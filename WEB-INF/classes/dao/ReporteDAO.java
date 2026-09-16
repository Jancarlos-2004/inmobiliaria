package dao;

import conexion.ConexionBD;

import javax.servlet.ServletContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * ReporteDAO
 * ----------
 * Implementa exactamente las 5 consultas obligatorias descritas en el
 * plan del proyecto (INNER JOIN x2, N:M, LEFT JOIN, GROUP BY/HAVING).
 * Cada metodo retorna una lista de mapas (columna -> valor) para poder
 * renderizarlas de forma generica en el panel de administracion/agente
 * sin crear un modelo especifico para cada reporte.
 */
public class ReporteDAO {

    public List<Map<String, Object>> propiedadesDetalladas(ServletContext context) throws Exception {
        String sql =
            "SELECT p.id, p.titulo, p.precio, c.nombre AS ciudad, t.nombre AS tipo, u.correo AS agente_correo " +
            "FROM propiedades p " +
            "INNER JOIN ciudades c ON p.id_ciudad = c.id " +
            "INNER JOIN tipos_propiedades t ON p.id_tipo = t.id " +
            "INNER JOIN usuarios u ON p.id_agente = u.id " +
            "ORDER BY p.id DESC";
        return ejecutarConsulta(context, sql);
    }

    public List<Map<String, Object>> detalleCitas(ServletContext context) throws Exception {
        String sql =
            "SELECT ci.id, ci.fecha_hora, ci.estado, p.titulo AS propiedad_titulo, " +
            "CONCAT(per_cli.nombres, ' ', per_cli.apellidos) AS cliente_nombre, " +
            "CONCAT(per_age.nombres, ' ', per_age.apellidos) AS agente_nombre " +
            "FROM citas ci " +
            "INNER JOIN propiedades p ON ci.id_propiedad = p.id " +
            "INNER JOIN perfiles per_cli ON ci.id_cliente = per_cli.id_usuario " +
            "INNER JOIN perfiles per_age ON p.id_agente = per_age.id_usuario " +
            "ORDER BY ci.fecha_hora DESC";
        return ejecutarConsulta(context, sql);
    }

    public List<Map<String, Object>> caracteristicasPorPropiedad(ServletContext context, int idPropiedad) throws Exception {
        String sql =
            "SELECT p.titulo, c.nombre AS caracteristica " +
            "FROM propiedades p " +
            "INNER JOIN propiedades_caracteristicas pc ON p.id = pc.id_propiedad " +
            "INNER JOIN caracteristicas c ON pc.id_caracteristica = c.id " +
            "WHERE p.id = ?";
        return ejecutarConsultaConParametro(context, sql, idPropiedad);
    }

    public List<Map<String, Object>> propiedadesSinCitas(ServletContext context) throws Exception {
        String sql =
            "SELECT p.id, p.titulo, p.precio, p.matricula_inmobiliaria " +
            "FROM propiedades p " +
            "LEFT JOIN citas c ON p.id = c.id_propiedad " +
            "WHERE c.id IS NULL AND p.estado = 'disponible'";
        return ejecutarConsulta(context, sql);
    }

    public List<Map<String, Object>> inmueblesPorCiudad(ServletContext context) throws Exception {
        String sql =
            "SELECT c.nombre AS ciudad, COUNT(p.id) AS total_propiedades, SUM(p.precio) AS valor_acumulado " +
            "FROM ciudades c " +
            "INNER JOIN propiedades p ON c.id = p.id_ciudad " +
            "WHERE p.estado = 'disponible' " +
            "GROUP BY c.nombre " +
            "HAVING COUNT(p.id) > 2";
        return ejecutarConsulta(context, sql);
    }

    // ------------------------------------------------------------------
    private List<Map<String, Object>> ejecutarConsulta(ServletContext context, String sql) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            return mapearResultado(rs);
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
    }

    private List<Map<String, Object>> ejecutarConsultaConParametro(ServletContext context, String sql, int parametro) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setInt(1, parametro);
            rs = ps.executeQuery();
            return mapearResultado(rs);
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
    }

    private List<Map<String, Object>> mapearResultado(ResultSet rs) throws SQLException {
        List<Map<String, Object>> filas = new ArrayList<>();
        ResultSetMetaData meta = rs.getMetaData();
        int columnas = meta.getColumnCount();
        while (rs.next()) {
            Map<String, Object> fila = new LinkedHashMap<>();
            for (int i = 1; i <= columnas; i++) {
                fila.put(meta.getColumnLabel(i), rs.getObject(i));
            }
            filas.add(fila);
        }
        return filas;
    }

    private void cerrarRecursos(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) {}
        try { if (ps != null) ps.close(); } catch (SQLException e) {}
        try { if (conn != null) conn.close(); } catch (SQLException e) {}
    }
}

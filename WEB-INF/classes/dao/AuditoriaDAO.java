package dao;

import conexion.ConexionBD;
import modelo.Auditoria;

import javax.servlet.ServletContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AuditoriaDAO
 * ------------
 * Registra y consulta la tabla `auditoria`. Se usa para dejar rastro de:
 *   - inicios de sesion (exitosos y fallidos)
 *   - creacion/edicion/baja de propiedades
 *   - cambios de estado en citas y solicitudes
 *
 * Las escrituras de auditoria NUNCA deben interrumpir la operacion principal:
 * si falla el registro de auditoria, se captura el error silenciosamente
 * (se podria loguear a consola) para no bloquear al usuario.
 */
public class AuditoriaDAO {

    public void registrarAccion(ServletContext context, Integer idUsuario, String accion,
                                 String tablaAfectada, Integer registroId, String detalles) {
        String sql = "INSERT INTO auditoria (id_usuario, accion, tabla_afectada, registro_id, detalles) " +
                     "VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            if (idUsuario != null) {
                ps.setInt(1, idUsuario);
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, accion);
            ps.setString(3, tablaAfectada);
            if (registroId != null) {
                ps.setInt(4, registroId);
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, detalles);
            ps.executeUpdate();
        } catch (Exception e) {
            // La auditoria no debe romper el flujo principal de la aplicacion.
            System.err.println("No se pudo registrar la auditoria: " + e.getMessage());
        } finally {
            cerrarRecursos(conn, ps, null);
        }
    }

    public List<Auditoria> listarUltimos(ServletContext context, int limite) throws Exception {
        List<Auditoria> lista = new ArrayList<>();
        String sql = "SELECT a.id, a.id_usuario, u.correo AS usuario_correo, a.accion, " +
                     "a.tabla_afectada, a.registro_id, a.fecha_hora, a.detalles " +
                     "FROM auditoria a " +
                     "LEFT JOIN usuarios u ON a.id_usuario = u.id " +
                     "ORDER BY a.fecha_hora DESC " +
                     "LIMIT ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limite);
            rs = ps.executeQuery();
            while (rs.next()) {
                Auditoria a = new Auditoria();
                a.setId(rs.getInt("id"));
                int idUsuario = rs.getInt("id_usuario");
                a.setIdUsuario(rs.wasNull() ? null : idUsuario);
                a.setUsuarioCorreo(rs.getString("usuario_correo"));
                a.setAccion(rs.getString("accion"));
                a.setTablaAfectada(rs.getString("tabla_afectada"));
                int registroId = rs.getInt("registro_id");
                a.setRegistroId(rs.wasNull() ? null : registroId);
                a.setFechaHora(rs.getTimestamp("fecha_hora"));
                a.setDetalles(rs.getString("detalles"));
                lista.add(a);
            }
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
        return lista;
    }

    private void cerrarRecursos(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) {}
        try { if (ps != null) ps.close(); } catch (SQLException e) {}
        try { if (conn != null) conn.close(); } catch (SQLException e) {}
    }
}

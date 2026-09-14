package dao;

import conexion.ConexionBD;
import modelo.Solicitud;

import javax.servlet.ServletContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * SolicitudDAO
 * ------------
 * Radicacion de solicitudes de compra/arriendo por parte de un Cliente,
 * con documentos adjuntos (1:N), y su aprobacion/rechazo por parte del
 * Agente dueño de la propiedad (o el Administrador).
 */
public class SolicitudDAO {

    public int radicarSolicitud(ServletContext context, Solicitud s) throws Exception {
        String sql = "INSERT INTO solicitudes (id_propiedad, id_cliente, tipo_solicitud, estado) " +
                     "VALUES (?, ?, ?, 'pendiente')";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rsKeys = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, s.getIdPropiedad());
            ps.setInt(2, s.getIdCliente());
            ps.setString(3, s.getTipoSolicitud());
            ps.executeUpdate();

            rsKeys = ps.getGeneratedKeys();
            int idSolicitud = 0;
            if (rsKeys.next()) {
                idSolicitud = rsKeys.getInt(1);
            }

            if (s.getDocumentos() != null && !s.getDocumentos().isEmpty()) {
                agregarDocumentos(conn, idSolicitud, s.getDocumentos());
            }

            return idSolicitud;
        } finally {
            cerrarRecursos(conn, ps, rsKeys);
        }
    }

    private void agregarDocumentos(Connection conn, int idSolicitud, List<Solicitud.Documento> documentos) throws SQLException {
        String sql = "INSERT INTO documentos_solicitudes (id_solicitud, nombre_archivo, ruta_archivo, tipo_documento) " +
                     "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Solicitud.Documento doc : documentos) {
                ps.setInt(1, idSolicitud);
                ps.setString(2, doc.getNombreArchivo());
                ps.setString(3, doc.getRutaArchivo());
                ps.setString(4, doc.getTipoDocumento());
                ps.executeUpdate();
            }
        }
    }

    public List<Solicitud> listarPorCliente(ServletContext context, int idCliente) throws Exception {
        String sql = "SELECT s.id, s.id_propiedad, p.titulo AS propiedad_titulo, p.precio AS propiedad_precio, " +
                     "s.id_cliente, s.tipo_solicitud, s.estado, s.fecha_solicitud " +
                     "FROM solicitudes s " +
                     "INNER JOIN propiedades p ON s.id_propiedad = p.id " +
                     "WHERE s.id_cliente = ? " +
                     "ORDER BY s.fecha_solicitud DESC";
        return listarConQuery(context, sql, idCliente);
    }

    public List<Solicitud> listarPorAgente(ServletContext context, int idAgente) throws Exception {
        String sql = "SELECT s.id, s.id_propiedad, p.titulo AS propiedad_titulo, p.precio AS propiedad_precio, " +
                     "s.id_cliente, CONCAT(per.nombres, ' ', per.apellidos) AS cliente_nombre, " +
                     "s.tipo_solicitud, s.estado, s.fecha_solicitud " +
                     "FROM solicitudes s " +
                     "INNER JOIN propiedades p ON s.id_propiedad = p.id " +
                     "INNER JOIN usuarios u ON s.id_cliente = u.id " +
                     "INNER JOIN perfiles per ON u.id = per.id_usuario " +
                     "WHERE p.id_agente = ? " +
                     "ORDER BY s.fecha_solicitud DESC";

        List<Solicitud> lista = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idAgente);
            rs = ps.executeQuery();
            while (rs.next()) {
                Solicitud s = mapearFila(rs);
                s.setClienteNombre(rs.getString("cliente_nombre"));
                cargarDocumentos(conn, s);
                lista.add(s);
            }
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
        return lista;
    }

    /**
     * Lista todas las solicitudes del sistema, de cualquier agente/propiedad.
     * Usada por el rol Administrador, que no esta limitado a un unico agente.
     */
    public List<Solicitud> listarTodas(ServletContext context) throws Exception {
        String sql = "SELECT s.id, s.id_propiedad, p.titulo AS propiedad_titulo, p.precio AS propiedad_precio, " +
                     "s.id_cliente, CONCAT(per.nombres, ' ', per.apellidos) AS cliente_nombre, " +
                     "s.tipo_solicitud, s.estado, s.fecha_solicitud " +
                     "FROM solicitudes s " +
                     "INNER JOIN propiedades p ON s.id_propiedad = p.id " +
                     "INNER JOIN usuarios u ON s.id_cliente = u.id " +
                     "INNER JOIN perfiles per ON u.id = per.id_usuario " +
                     "ORDER BY s.fecha_solicitud DESC";

        List<Solicitud> lista = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Solicitud s = mapearFila(rs);
                s.setClienteNombre(rs.getString("cliente_nombre"));
                cargarDocumentos(conn, s);
                lista.add(s);
            }
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
        return lista;
    }

    private List<Solicitud> listarConQuery(ServletContext context, String sql, int parametro) throws Exception {
        List<Solicitud> lista = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setInt(1, parametro);
            rs = ps.executeQuery();
            while (rs.next()) {
                Solicitud s = mapearFila(rs);
                cargarDocumentos(conn, s);
                lista.add(s);
            }
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
        return lista;
    }

    private Solicitud mapearFila(ResultSet rs) throws SQLException {
        Solicitud s = new Solicitud();
        s.setId(rs.getInt("id"));
        s.setIdPropiedad(rs.getInt("id_propiedad"));
        s.setPropiedadTitulo(rs.getString("propiedad_titulo"));
        s.setPropiedadPrecio(rs.getDouble("propiedad_precio"));
        s.setIdCliente(rs.getInt("id_cliente"));
        s.setTipoSolicitud(rs.getString("tipo_solicitud"));
        s.setEstado(rs.getString("estado"));
        s.setFechaSolicitud(rs.getTimestamp("fecha_solicitud"));
        return s;
    }

    public Solicitud obtenerPorId(ServletContext context, int id) throws Exception {
        String sql = "SELECT s.id, s.id_propiedad, p.titulo AS propiedad_titulo, p.precio AS propiedad_precio, " +
                     "p.id_agente, s.id_cliente, s.tipo_solicitud, s.estado, s.fecha_solicitud " +
                     "FROM solicitudes s " +
                     "INNER JOIN propiedades p ON s.id_propiedad = p.id " +
                     "WHERE s.id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                Solicitud s = mapearFila(rs);
                s.setIdAgentePropiedad(rs.getInt("id_agente"));
                cargarDocumentos(conn, s);
                return s;
            }
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
        return null;
    }

    private void cargarDocumentos(Connection conn, Solicitud s) throws SQLException {
        String sql = "SELECT id, id_solicitud, nombre_archivo, ruta_archivo, tipo_documento " +
                     "FROM documentos_solicitudes WHERE id_solicitud = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, s.getId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Solicitud.Documento doc = new Solicitud.Documento();
                    doc.setId(rs.getInt("id"));
                    doc.setIdSolicitud(rs.getInt("id_solicitud"));
                    doc.setNombreArchivo(rs.getString("nombre_archivo"));
                    doc.setRutaArchivo(rs.getString("ruta_archivo"));
                    doc.setTipoDocumento(rs.getString("tipo_documento"));
                    s.addDocumento(doc);
                }
            }
        }
    }

    public void actualizarEstado(ServletContext context, int idSolicitud, String nuevoEstado) throws Exception {
        String sql = "UPDATE solicitudes SET estado = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idSolicitud);
            ps.executeUpdate();
        } finally {
            cerrarRecursos(conn, ps, null);
        }
    }

    private void cerrarRecursos(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) {}
        try { if (ps != null) ps.close(); } catch (SQLException e) {}
        try { if (conn != null) conn.close(); } catch (SQLException e) {}
    }
}

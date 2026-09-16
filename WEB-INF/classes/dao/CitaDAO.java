package dao;

import conexion.ConexionBD;
import modelo.Cita;

import javax.servlet.ServletContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CitaDAO {

    public void agendarCita(ServletContext context, Cita c) throws Exception {
        String sql = "INSERT INTO citas (id_propiedad, id_cliente, fecha_hora, estado, notas) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            
            // Validacion manual previa (opcional, pero buena practica)
            String checkSql = "SELECT id FROM citas WHERE id_propiedad = ? AND fecha_hora = ? AND estado != 'cancelada'";
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, c.getIdPropiedad());
                psCheck.setTimestamp(2, new java.sql.Timestamp(c.getFechaHora().getTime()));
                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    if (rsCheck.next()) {
                        throw new Exception("Ya existe una cita activa programada para esta propiedad en el horario seleccionado (" + c.getFechaHora() + ").");
                    }
                }
            }

            ps = conn.prepareStatement(sql);
            ps.setInt(1, c.getIdPropiedad());
            ps.setInt(2, c.getIdCliente());
            ps.setTimestamp(3, new java.sql.Timestamp(c.getFechaHora().getTime()));
            ps.setString(4, c.getEstado() != null ? c.getEstado() : "pendiente");
            ps.setString(5, c.getNotas());
            ps.executeUpdate();
        } catch (SQLException e) {
            // Validacion por si salta la restriccion UNIQUE de base de datos directamente
            if (e.getErrorCode() == 1062 || (e.getMessage() != null && e.getMessage().contains("Duplicate entry"))) {
                throw new Exception("La propiedad ya tiene una visita agendada en la fecha y hora indicadas. Por favor, selecciona otro horario.");
            }
            throw e;
        } finally {
            cerrarRecursos(conn, ps, null);
        }
    }

    public List<Cita> listarCitasPorCliente(ServletContext context, int idCliente) throws Exception {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.id, c.id_propiedad, p.titulo AS propiedad_titulo, c.id_cliente, " +
                     "c.fecha_hora, c.estado, c.notas " +
                     "FROM citas c " +
                     "INNER JOIN propiedades p ON c.id_propiedad = p.id " +
                     "WHERE c.id_cliente = ? " +
                     "ORDER BY c.fecha_hora DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idCliente);
            rs = ps.executeQuery();
            while (rs.next()) {
                Cita c = new Cita();
                c.setId(rs.getInt("id"));
                c.setIdPropiedad(rs.getInt("id_propiedad"));
                c.setPropiedadTitulo(rs.getString("propiedad_titulo"));
                c.setIdCliente(rs.getInt("id_cliente"));
                c.setFechaHora(rs.getTimestamp("fecha_hora"));
                c.setEstado(rs.getString("estado"));
                c.setNotas(rs.getString("notas"));
                lista.add(c);
            }
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
        return lista;
    }

    public List<Cita> listarCitasPorAgente(ServletContext context, int idAgente) throws Exception {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.id, c.id_propiedad, p.titulo AS propiedad_titulo, c.id_cliente, " +
                     "CONCAT(per.nombres, ' ', per.apellidos) AS cliente_nombre, per.telefono AS cliente_telefono, " +
                     "c.fecha_hora, c.estado, c.notas " +
                     "FROM citas c " +
                     "INNER JOIN propiedades p ON c.id_propiedad = p.id " +
                     "INNER JOIN usuarios u ON c.id_cliente = u.id " +
                     "INNER JOIN perfiles per ON u.id = per.id_usuario " +
                     "WHERE p.id_agente = ? " +
                     "ORDER BY c.fecha_hora DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idAgente);
            rs = ps.executeQuery();
            while (rs.next()) {
                Cita c = new Cita();
                c.setId(rs.getInt("id"));
                c.setIdPropiedad(rs.getInt("id_propiedad"));
                c.setPropiedadTitulo(rs.getString("propiedad_titulo"));
                c.setIdCliente(rs.getInt("id_cliente"));
                c.setClienteNombre(rs.getString("cliente_nombre"));
                c.setClienteTelefono(rs.getString("cliente_telefono"));
                c.setFechaHora(rs.getTimestamp("fecha_hora"));
                c.setEstado(rs.getString("estado"));
                c.setNotas(rs.getString("notas"));
                lista.add(c);
            }
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
        return lista;
    }

    /**
     * Lista todas las citas del sistema, de cualquier agente/propiedad.
     * Usada por el rol Administrador, que no esta limitado a un unico agente.
     */
    public List<Cita> listarTodasLasCitas(ServletContext context) throws Exception {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.id, c.id_propiedad, p.titulo AS propiedad_titulo, c.id_cliente, " +
                     "CONCAT(per.nombres, ' ', per.apellidos) AS cliente_nombre, per.telefono AS cliente_telefono, " +
                     "c.fecha_hora, c.estado, c.notas " +
                     "FROM citas c " +
                     "INNER JOIN propiedades p ON c.id_propiedad = p.id " +
                     "INNER JOIN usuarios u ON c.id_cliente = u.id " +
                     "INNER JOIN perfiles per ON u.id = per.id_usuario " +
                     "ORDER BY c.fecha_hora DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Cita c = new Cita();
                c.setId(rs.getInt("id"));
                c.setIdPropiedad(rs.getInt("id_propiedad"));
                c.setPropiedadTitulo(rs.getString("propiedad_titulo"));
                c.setIdCliente(rs.getInt("id_cliente"));
                c.setClienteNombre(rs.getString("cliente_nombre"));
                c.setClienteTelefono(rs.getString("cliente_telefono"));
                c.setFechaHora(rs.getTimestamp("fecha_hora"));
                c.setEstado(rs.getString("estado"));
                c.setNotas(rs.getString("notas"));
                lista.add(c);
            }
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
        return lista;
    }

    public void actualizarEstadoCita(ServletContext context, int idCita, String nuevoEstado) throws Exception {
        String sql = "UPDATE citas SET estado = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idCita);
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

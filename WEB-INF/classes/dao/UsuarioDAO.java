package dao;

import conexion.ConexionBD;
import modelo.Usuario;
import modelo.Perfil;
import util.HashUtil;

import javax.servlet.ServletContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public Usuario validarCredenciales(ServletContext context, String correo, String password) throws Exception {
        Usuario usuario = obtenerUsuarioPorCorreo(context, correo);
        if (usuario == null) {
            return null;
        }
        
        // Verificar si la cuenta esta inactiva
        if ("inactivo".equalsIgnoreCase(usuario.getEstado())) {
            throw new Exception("Esta cuenta se encuentra inactiva. Contacte al administrador.");
        }

        String hashed = HashUtil.hashPassword(password, usuario.getPasswordSalt());
        if (hashed.equals(usuario.getPasswordHash())) {
            return usuario;
        }
        return null;
    }

    public Usuario obtenerUsuarioPorCorreo(ServletContext context, String correo) throws Exception {
        String sql = "SELECT u.id, u.correo, u.password_hash, u.password_salt, u.estado, " +
                     "p.nombres, p.apellidos, p.documento, p.telefono, p.direccion, p.foto " +
                     "FROM usuarios u " +
                     "LEFT JOIN perfiles p ON u.id = p.id_usuario " +
                     "WHERE u.correo = ?";
                     
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setString(1, correo);
            rs = ps.executeQuery();

            if (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setCorreo(rs.getString("correo"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setPasswordSalt(rs.getString("password_salt"));
                u.setEstado(rs.getString("estado"));

                String nombres = rs.getString("nombres");
                if (nombres != null) {
                    Perfil p = new Perfil();
                    p.setIdUsuario(u.getId());
                    p.setNombres(nombres);
                    p.setApellidos(rs.getString("apellidos"));
                    p.setDocumento(rs.getString("documento"));
                    p.setTelefono(rs.getString("telefono"));
                    p.setDireccion(rs.getString("direccion"));
                    p.setFoto(rs.getString("foto"));
                    u.setPerfil(p);
                }

                // Cargar roles
                cargarRoles(conn, u);
                return u;
            }
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
        return null;
    }

    public Usuario obtenerUsuarioPorId(ServletContext context, int id) throws Exception {
        String sql = "SELECT u.id, u.correo, u.password_hash, u.password_salt, u.estado, " +
                     "p.nombres, p.apellidos, p.documento, p.telefono, p.direccion, p.foto " +
                     "FROM usuarios u " +
                     "LEFT JOIN perfiles p ON u.id = p.id_usuario " +
                     "WHERE u.id = ?";
                     
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setCorreo(rs.getString("correo"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setPasswordSalt(rs.getString("password_salt"));
                u.setEstado(rs.getString("estado"));

                String nombres = rs.getString("nombres");
                Perfil p = new Perfil();
                p.setIdUsuario(u.getId());
                if (nombres != null) {
                    p.setNombres(nombres);
                    p.setApellidos(rs.getString("apellidos"));
                    p.setDocumento(rs.getString("documento"));
                    p.setTelefono(rs.getString("telefono"));
                    p.setDireccion(rs.getString("direccion"));
                    p.setFoto(rs.getString("foto"));
                } else {
                    p.setNombres("");
                    p.setApellidos("");
                    p.setDocumento("");
                }
                u.setPerfil(p);

                cargarRoles(conn, u);
                return u;
            }
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
        return null;
    }

    private void cargarRoles(Connection conn, Usuario u) throws SQLException {
        String sql = "SELECT r.nombre FROM usuarios_roles ur " +
                     "INNER JOIN roles r ON ur.id_rol = r.id " +
                     "WHERE ur.id_usuario = ?";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, u.getId());
            rs = ps.executeQuery();
            while (rs.next()) {
                u.addRol(rs.getString("nombre"));
            }
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
        }
    }

    public boolean registrarCliente(ServletContext context, String correo, String password, Perfil perfil) throws Exception {
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psProfile = null;
        PreparedStatement psRol = null;
        ResultSet rsUser = null;

        try {
            conn = ConexionBD.obtenerConexion(context);
            conn.setAutoCommit(false); // Iniciar transaccion

            // 1. Verificar si el correo ya existe
            String checkSql = "SELECT id FROM usuarios WHERE correo = ?";
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setString(1, correo);
                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    if (rsCheck.next()) {
                        throw new Exception("El correo '" + correo + "' ya se encuentra registrado.");
                    }
                }
            }
            
            // Verificar si el documento ya existe
            String checkDocSql = "SELECT id_usuario FROM perfiles WHERE documento = ?";
            try (PreparedStatement psCheckDoc = conn.prepareStatement(checkDocSql)) {
                psCheckDoc.setString(1, perfil.getDocumento());
                try (ResultSet rsCheckDoc = psCheckDoc.executeQuery()) {
                    if (rsCheckDoc.next()) {
                        throw new Exception("El documento '" + perfil.getDocumento() + "' ya se encuentra registrado.");
                    }
                }
            }

            // 2. Insertar Usuario
            String salt = HashUtil.generarSalt();
            String hash = HashUtil.hashPassword(password, salt);

            String userSql = "INSERT INTO usuarios (correo, password_hash, password_salt, estado) VALUES (?, ?, ?, 'activo')";
            psUser = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, correo);
            psUser.setString(2, hash);
            psUser.setString(3, salt);
            psUser.executeUpdate();

            rsUser = psUser.getGeneratedKeys();
            int idUsuario = 0;
            if (rsUser.next()) {
                idUsuario = rsUser.getInt(1);
            } else {
                throw new SQLException("No se pudo obtener el ID autogenerado del usuario.");
            }

            // 3. Insertar Perfil
            String profileSql = "INSERT INTO perfiles (id_usuario, nombres, apellidos, documento, telefono, direccion, foto) VALUES (?, ?, ?, ?, ?, ?, ?)";
            psProfile = conn.prepareStatement(profileSql);
            psProfile.setInt(1, idUsuario);
            psProfile.setString(2, perfil.getNombres());
            psProfile.setString(3, perfil.getApellidos());
            psProfile.setString(4, perfil.getDocumento());
            psProfile.setString(5, perfil.getTelefono());
            psProfile.setString(6, perfil.getDireccion());
            psProfile.setString(7, perfil.getFoto());
            psProfile.executeUpdate();

            // 4. Asignar Rol Cliente (id = 2)
            String rolSql = "INSERT INTO usuarios_roles (id_usuario, id_rol) VALUES (?, 2)";
            psRol = conn.prepareStatement(rolSql);
            psRol.setInt(1, idUsuario);
            psRol.executeUpdate();

            conn.commit(); // Confirmar transaccion
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psRol != null) psRol.close();
            if (psProfile != null) psProfile.close();
            cerrarRecursos(conn, psUser, rsUser);
        }
    }

    public void actualizarPerfil(ServletContext context, Perfil perfil) throws Exception {
        String sql = "UPDATE perfiles SET nombres = ?, apellidos = ?, documento = ?, telefono = ?, direccion = ?, foto = ? WHERE id_usuario = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            // Verificar duplicados de documento
            String checkDocSql = "SELECT id_usuario FROM perfiles WHERE documento = ? AND id_usuario != ?";
            try (PreparedStatement psCheckDoc = conn.prepareStatement(checkDocSql)) {
                psCheckDoc.setString(1, perfil.getDocumento());
                psCheckDoc.setInt(2, perfil.getIdUsuario());
                try (ResultSet rsCheckDoc = psCheckDoc.executeQuery()) {
                    if (rsCheckDoc.next()) {
                        throw new Exception("El documento '" + perfil.getDocumento() + "' ya esta asignado a otro usuario.");
                    }
                }
            }

            ps = conn.prepareStatement(sql);
            ps.setString(1, perfil.getNombres());
            ps.setString(2, perfil.getApellidos());
            ps.setString(3, perfil.getDocumento());
            ps.setString(4, perfil.getTelefono());
            ps.setString(5, perfil.getDireccion());
            ps.setString(6, perfil.getFoto());
            ps.setInt(7, perfil.getIdUsuario());
            ps.executeUpdate();
        } finally {
            cerrarRecursos(conn, ps, null);
        }
    }

    public List<Usuario> listarUsuarios(ServletContext context) throws Exception {
        String sql = "SELECT u.id, u.correo, u.estado, p.nombres, p.apellidos, p.documento " +
                     "FROM usuarios u " +
                     "LEFT JOIN perfiles p ON u.id = p.id_usuario " +
                     "ORDER BY u.id DESC";
        List<Usuario> lista = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setCorreo(rs.getString("correo"));
                u.setEstado(rs.getString("estado"));

                Perfil p = new Perfil();
                p.setIdUsuario(u.getId());
                p.setNombres(rs.getString("nombres"));
                p.setApellidos(rs.getString("apellidos"));
                p.setDocumento(rs.getString("documento"));
                u.setPerfil(p);

                cargarRoles(conn, u);
                lista.add(u);
            }
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
        return lista;
    }

    public void cambiarEstadoUsuario(ServletContext context, int idUsuario, String nuevoEstado) throws Exception {
        String sql = "UPDATE usuarios SET estado = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idUsuario);
            ps.executeUpdate();
        } finally {
            cerrarRecursos(conn, ps, null);
        }
    }

    public void reasignarRoles(ServletContext context, int idUsuario, String[] idsRoles) throws Exception {
        Connection conn = null;
        PreparedStatement psDelete = null;
        PreparedStatement psInsert = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            conn.setAutoCommit(false);

            // Eliminar roles existentes
            psDelete = conn.prepareStatement("DELETE FROM usuarios_roles WHERE id_usuario = ?");
            psDelete.setInt(1, idUsuario);
            psDelete.executeUpdate();

            // Insertar nuevos
            if (idsRoles != null && idsRoles.length > 0) {
                psInsert = conn.prepareStatement("INSERT INTO usuarios_roles (id_usuario, id_rol) VALUES (?, ?)");
                for (String rIdStr : idsRoles) {
                    int idRol = Integer.parseInt(rIdStr);
                    psInsert.setInt(1, idUsuario);
                    psInsert.setInt(2, idRol);
                    psInsert.executeUpdate();
                }
            }

            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psDelete != null) psDelete.close();
            if (psInsert != null) psInsert.close();
            cerrarRecursos(conn, null, null);
        }
    }

    private void cerrarRecursos(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) {}
        try { if (ps != null) ps.close(); } catch (SQLException e) {}
        try { if (conn != null) conn.close(); } catch (SQLException e) {}
    }
}

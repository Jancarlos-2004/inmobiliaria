package dao;

import conexion.ConexionBD;
import modelo.Propiedad;

import javax.servlet.ServletContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PropiedadDAO {

    public List<Propiedad> listarPropiedades(ServletContext context, String ciudadId, String tipoId, Double minPrecio, Double maxPrecio, String buscar, String estado) throws Exception {
        List<Propiedad> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.id, p.titulo, p.descripcion, p.direccion, p.precio, p.matricula_inmobiliaria, " +
            "p.id_ciudad, c.nombre AS ciudad_nombre, p.id_tipo, t.nombre AS tipo_nombre, " +
            "p.id_agente, per.nombres AS agente_nombres, per.apellidos AS agente_apellidos, p.estado, p.fecha_creacion " +
            "FROM propiedades p " +
            "INNER JOIN ciudades c ON p.id_ciudad = c.id " +
            "INNER JOIN tipos_propiedades t ON p.id_tipo = t.id " +
            "INNER JOIN usuarios u ON p.id_agente = u.id " +
            "INNER JOIN perfiles per ON u.id = per.id_usuario " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (ciudadId != null && !ciudadId.trim().isEmpty()) {
            sql.append("AND p.id_ciudad = ? ");
            params.add(Integer.parseInt(ciudadId));
        }
        if (tipoId != null && !tipoId.trim().isEmpty()) {
            sql.append("AND p.id_tipo = ? ");
            params.add(Integer.parseInt(tipoId));
        }
        if (minPrecio != null) {
            sql.append("AND p.precio >= ? ");
            params.add(minPrecio);
        }
        if (maxPrecio != null) {
            sql.append("AND p.precio <= ? ");
            params.add(maxPrecio);
        }
        if (buscar != null && !buscar.trim().isEmpty()) {
            sql.append("AND (p.titulo LIKE ? OR p.descripcion LIKE ? OR p.direccion LIKE ?) ");
            String seek = "%" + buscar.trim() + "%";
            params.add(seek);
            params.add(seek);
            params.add(seek);
        }
        if (estado != null && !estado.trim().isEmpty()) {
            sql.append("AND p.estado = ? ");
            params.add(estado);
        } else {
            // Por defecto no mostrar los inactivos (baja logica) en el catalogo publico
            sql.append("AND p.estado != 'inactivo' ");
        }

        sql.append("ORDER BY p.id DESC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            rs = ps.executeQuery();
            while (rs.next()) {
                Propiedad p = new Propiedad();
                p.setId(rs.getInt("id"));
                p.setTitulo(rs.getString("titulo"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setDireccion(rs.getString("direccion"));
                p.setPrecio(rs.getDouble("precio"));
                p.setMatriculaInmobiliaria(rs.getString("matricula_inmobiliaria"));
                p.setIdCiudad(rs.getInt("id_ciudad"));
                p.setCiudadNombre(rs.getString("ciudad_nombre"));
                p.setIdTipo(rs.getInt("id_tipo"));
                p.setTipoNombre(rs.getString("tipo_nombre"));
                p.setIdAgente(rs.getInt("id_agente"));
                p.setAgenteNombre(rs.getString("agente_nombres") + " " + rs.getString("agente_apellidos"));
                p.setEstado(rs.getString("estado"));
                p.setFechaCreacion(rs.getTimestamp("fecha_creacion"));

                // Cargar las imagenes correspondientes a la propiedad
                cargarImagenes(conn, p);
                lista.add(p);
            }
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
        return lista;
    }

    private void cargarPrimeraImagen(Connection conn, Propiedad p) throws SQLException {
        String sql = "SELECT url_imagen FROM imagenes_propiedades WHERE id_propiedad = ? LIMIT 1";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, p.getId());
            rs = ps.executeQuery();
            if (rs.next()) {
                p.addImagen(rs.getString("url_imagen"));
            }
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
        }
    }

    public Propiedad obtenerPropiedadPorId(ServletContext context, int id) throws Exception {
        String sql = "SELECT p.id, p.titulo, p.descripcion, p.direccion, p.precio, p.matricula_inmobiliaria, " +
                     "p.id_ciudad, c.nombre AS ciudad_nombre, p.id_tipo, t.nombre AS tipo_nombre, " +
                     "p.id_agente, per.nombres AS agente_nombres, per.apellidos AS agente_apellidos, p.estado, p.fecha_creacion " +
                     "FROM propiedades p " +
                     "INNER JOIN ciudades c ON p.id_ciudad = c.id " +
                     "INNER JOIN tipos_propiedades t ON p.id_tipo = t.id " +
                     "INNER JOIN usuarios u ON p.id_agente = u.id " +
                     "INNER JOIN perfiles per ON u.id = per.id_usuario " +
                     "WHERE p.id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                Propiedad p = new Propiedad();
                p.setId(rs.getInt("id"));
                p.setTitulo(rs.getString("titulo"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setDireccion(rs.getString("direccion"));
                p.setPrecio(rs.getDouble("precio"));
                p.setMatriculaInmobiliaria(rs.getString("matricula_inmobiliaria"));
                p.setIdCiudad(rs.getInt("id_ciudad"));
                p.setCiudadNombre(rs.getString("ciudad_nombre"));
                p.setIdTipo(rs.getInt("id_tipo"));
                p.setTipoNombre(rs.getString("tipo_nombre"));
                p.setIdAgente(rs.getInt("id_agente"));
                p.setAgenteNombre(rs.getString("agente_nombres") + " " + rs.getString("agente_apellidos"));
                p.setEstado(rs.getString("estado"));
                p.setFechaCreacion(rs.getTimestamp("fecha_creacion"));

                // Cargar todas las imagenes
                cargarImagenes(conn, p);
                // Cargar todas las caracteristicas
                cargarCaracteristicas(conn, p);

                return p;
            }
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
        return null;
    }

    private void cargarImagenes(Connection conn, Propiedad p) throws SQLException {
        String sql = "SELECT url_imagen FROM imagenes_propiedades WHERE id_propiedad = ?";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, p.getId());
            rs = ps.executeQuery();
            List<String> list = new ArrayList<>();
            while (rs.next()) {
                list.add(rs.getString("url_imagen"));
            }
            p.setImagenes(list);
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
        }
    }

    private void cargarCaracteristicas(Connection conn, Propiedad p) throws SQLException {
        String sql = "SELECT c.nombre FROM propiedades_caracteristicas pc " +
                     "INNER JOIN caracteristicas c ON pc.id_caracteristica = c.id " +
                     "WHERE pc.id_propiedad = ?";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, p.getId());
            rs = ps.executeQuery();
            List<String> list = new ArrayList<>();
            while (rs.next()) {
                list.add(rs.getString("nombre"));
            }
            p.setCaracteristicas(list);
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
        }
    }

    public void crearPropiedad(ServletContext context, Propiedad p, List<String> imagenes, String[] caracteristicasIds) throws Exception {
        Connection conn = null;
        PreparedStatement psProp = null;
        PreparedStatement psImg = null;
        PreparedStatement psChar = null;
        ResultSet rsKeys = null;

        try {
            conn = ConexionBD.obtenerConexion(context);
            conn.setAutoCommit(false);

            // 1. Validar unicidad de matricula
            String checkSql = "SELECT id FROM propiedades WHERE matricula_inmobiliaria = ?";
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setString(1, p.getMatriculaInmobiliaria());
                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    if (rsCheck.next()) {
                        throw new Exception("La matricula inmobiliaria '" + p.getMatriculaInmobiliaria() + "' ya se encuentra registrada por otra propiedad.");
                    }
                }
            }

            // 2. Insertar propiedad
            String propSql = "INSERT INTO propiedades (titulo, descripcion, direccion, precio, matricula_inmobiliaria, id_ciudad, id_tipo, id_agente, estado) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'disponible')";
            psProp = conn.prepareStatement(propSql, Statement.RETURN_GENERATED_KEYS);
            psProp.setString(1, p.getTitulo());
            psProp.setString(2, p.getDescripcion());
            psProp.setString(3, p.getDireccion());
            psProp.setDouble(4, p.getPrecio());
            psProp.setString(5, p.getMatriculaInmobiliaria());
            psProp.setInt(6, p.getIdCiudad());
            psProp.setInt(7, p.getIdTipo());
            psProp.setInt(8, p.getIdAgente());
            psProp.executeUpdate();

            rsKeys = psProp.getGeneratedKeys();
            int idPropiedad = 0;
            if (rsKeys.next()) {
                idPropiedad = rsKeys.getInt(1);
            } else {
                throw new SQLException("No se pudo obtener el ID autogenerado de la propiedad.");
            }

            // 3. Insertar imagenes (1:N)
            if (imagenes != null && !imagenes.isEmpty()) {
                psImg = conn.prepareStatement("INSERT INTO imagenes_propiedades (id_propiedad, url_imagen) VALUES (?, ?)");
                for (String url : imagenes) {
                    psImg.setInt(1, idPropiedad);
                    psImg.setString(2, url);
                    psImg.executeUpdate();
                }
            } else {
                // Al menos una por defecto
                psImg = conn.prepareStatement("INSERT INTO imagenes_propiedades (id_propiedad, url_imagen) VALUES (?, ?)");
                psImg.setInt(1, idPropiedad);
                psImg.setString(2, "assets/img/propiedades/placeholder.jpg");
                psImg.executeUpdate();
            }

            // 4. Insertar caracteristicas (N:M)
            if (caracteristicasIds != null && caracteristicasIds.length > 0) {
                psChar = conn.prepareStatement("INSERT INTO propiedades_caracteristicas (id_propiedad, id_caracteristica) VALUES (?, ?)");
                for (String charIdStr : caracteristicasIds) {
                    int idChar = Integer.parseInt(charIdStr);
                    psChar.setInt(1, idPropiedad);
                    psChar.setInt(2, idChar);
                    psChar.executeUpdate();
                }
            }

            conn.commit();
            p.setId(idPropiedad);
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            throw new Exception(util.ValidadorUtil.traducirExcepcionSQL(e));
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psImg != null) psImg.close();
            if (psChar != null) psChar.close();
            cerrarRecursos(conn, psProp, rsKeys);
        }
    }

    public void actualizarPropiedad(ServletContext context, Propiedad p, List<String> imagenes, String[] caracteristicasIds) throws Exception {
        Connection conn = null;
        PreparedStatement psProp = null;
        PreparedStatement psDelImg = null;
        PreparedStatement psImg = null;
        PreparedStatement psDelChar = null;
        PreparedStatement psChar = null;

        try {
            conn = ConexionBD.obtenerConexion(context);
            conn.setAutoCommit(false);

            // 1. Validar matricula duplicada
            String checkSql = "SELECT id FROM propiedades WHERE matricula_inmobiliaria = ? AND id != ?";
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setString(1, p.getMatriculaInmobiliaria());
                psCheck.setInt(2, p.getId());
                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    if (rsCheck.next()) {
                        throw new Exception("La matricula inmobiliaria '" + p.getMatriculaInmobiliaria() + "' ya esta asignada a otra propiedad.");
                    }
                }
            }

            // 2. Actualizar propiedad
            String propSql = "UPDATE propiedades SET titulo = ?, descripcion = ?, direccion = ?, precio = ?, " +
                             "matricula_inmobiliaria = ?, id_ciudad = ?, id_tipo = ?, estado = ? WHERE id = ?";
            psProp = conn.prepareStatement(propSql);
            psProp.setString(1, p.getTitulo());
            psProp.setString(2, p.getDescripcion());
            psProp.setString(3, p.getDireccion());
            psProp.setDouble(4, p.getPrecio());
            psProp.setString(5, p.getMatriculaInmobiliaria());
            psProp.setInt(6, p.getIdCiudad());
            psProp.setInt(7, p.getIdTipo());
            psProp.setString(8, p.getEstado());
            psProp.setInt(9, p.getId());
            psProp.executeUpdate();

            // 3. Reemplazar imagenes
            if (imagenes != null && !imagenes.isEmpty()) {
                psDelImg = conn.prepareStatement("DELETE FROM imagenes_propiedades WHERE id_propiedad = ?");
                psDelImg.setInt(1, p.getId());
                psDelImg.executeUpdate();

                psImg = conn.prepareStatement("INSERT INTO imagenes_propiedades (id_propiedad, url_imagen) VALUES (?, ?)");
                for (String url : imagenes) {
                    psImg.setInt(1, p.getId());
                    psImg.setString(2, url);
                    psImg.executeUpdate();
                }
            }

            // 4. Reemplazar caracteristicas
            psDelChar = conn.prepareStatement("DELETE FROM propiedades_caracteristicas WHERE id_propiedad = ?");
            psDelChar.setInt(1, p.getId());
            psDelChar.executeUpdate();

            if (caracteristicasIds != null && caracteristicasIds.length > 0) {
                psChar = conn.prepareStatement("INSERT INTO propiedades_caracteristicas (id_propiedad, id_caracteristica) VALUES (?, ?)");
                for (String charIdStr : caracteristicasIds) {
                    int idChar = Integer.parseInt(charIdStr);
                    psChar.setInt(1, p.getId());
                    psChar.setInt(2, idChar);
                    psChar.executeUpdate();
                }
            }

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            throw new Exception(util.ValidadorUtil.traducirExcepcionSQL(e));
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psDelImg != null) psDelImg.close();
            if (psImg != null) psImg.close();
            if (psDelChar != null) psDelChar.close();
            if (psChar != null) psChar.close();
            cerrarRecursos(conn, psProp, null);
        }
    }

    public void darBajaLogica(ServletContext context, int idPropiedad) throws Exception {
        String sql = "UPDATE propiedades SET estado = 'inactivo' WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idPropiedad);
            ps.executeUpdate();
        } finally {
            cerrarRecursos(conn, ps, null);
        }
    }

    /**
     * Actualiza unicamente el estado de una propiedad (disponible, arrendado,
     * vendido, inactivo). Se usa, por ejemplo, cuando se aprueba una solicitud
     * de compra o arriendo, para reflejar el cambio de inmediato sin pasar
     * por el formulario completo de edicion.
     */
    public void actualizarEstado(ServletContext context, int idPropiedad, String nuevoEstado) throws Exception {
        String sql = "UPDATE propiedades SET estado = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idPropiedad);
            ps.executeUpdate();
        } finally {
            cerrarRecursos(conn, ps, null);
        }
    }

    public List<Map<String, Object>> listarCiudades(ServletContext context) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT id, nombre FROM ciudades ORDER BY nombre ASC");
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("nombre", rs.getString("nombre"));
                list.add(map);
            }
        } finally {
            cerrarRecursos(conn, null, rs);
            if (stmt != null) stmt.close();
        }
        return list;
    }

    public List<Map<String, Object>> listarTipos(ServletContext context) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT id, nombre FROM tipos_propiedades ORDER BY nombre ASC");
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("nombre", rs.getString("nombre"));
                list.add(map);
            }
        } finally {
            cerrarRecursos(conn, null, rs);
            if (stmt != null) stmt.close();
        }
        return list;
    }

    public List<Map<String, Object>> listarCaracteristicas(ServletContext context) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT id, nombre FROM caracteristicas ORDER BY nombre ASC");
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("nombre", rs.getString("nombre"));
                list.add(map);
            }
        } finally {
            cerrarRecursos(conn, null, rs);
            if (stmt != null) stmt.close();
        }
        return list;
    }

    public void marcarFavorito(ServletContext context, int idUsuario, int idPropiedad, boolean favorito) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            if (favorito) {
                ps = conn.prepareStatement("INSERT IGNORE INTO favoritos (id_usuario, id_propiedad) VALUES (?, ?)");
            } else {
                ps = conn.prepareStatement("DELETE FROM favoritos WHERE id_usuario = ? AND id_propiedad = ?");
            }
            ps.setInt(1, idUsuario);
            ps.setInt(2, idPropiedad);
            ps.executeUpdate();
        } finally {
            cerrarRecursos(conn, ps, null);
        }
    }

    public boolean esFavorito(ServletContext context, int idUsuario, int idPropiedad) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement("SELECT 1 FROM favoritos WHERE id_usuario = ? AND id_propiedad = ?");
            ps.setInt(1, idUsuario);
            ps.setInt(2, idPropiedad);
            rs = ps.executeQuery();
            return rs.next();
        } finally {
            cerrarRecursos(conn, ps, rs);
        }
    }

    public List<Propiedad> listarFavoritos(ServletContext context, int idUsuario) throws Exception {
        List<Propiedad> lista = new ArrayList<>();
        String sql = "SELECT p.id, p.titulo, p.precio, c.nombre AS ciudad_nombre, t.nombre AS tipo_nombre, p.estado " +
                     "FROM favoritos f " +
                     "INNER JOIN propiedades p ON f.id_propiedad = p.id " +
                     "INNER JOIN ciudades c ON p.id_ciudad = c.id " +
                     "INNER JOIN tipos_propiedades t ON p.id_tipo = t.id " +
                     "WHERE f.id_usuario = ? AND p.estado != 'inactivo' " +
                     "ORDER BY p.id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.obtenerConexion(context);
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            while (rs.next()) {
                Propiedad p = new Propiedad();
                p.setId(rs.getInt("id"));
                p.setTitulo(rs.getString("titulo"));
                p.setPrecio(rs.getDouble("precio"));
                p.setCiudadNombre(rs.getString("ciudad_nombre"));
                p.setTipoNombre(rs.getString("tipo_nombre"));
                p.setEstado(rs.getString("estado"));
                
                cargarPrimeraImagen(conn, p);
                lista.add(p);
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

package conexion;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;
import javax.servlet.ServletContext;

public class ConexionBD {

    private static final String RUTA_PROPERTIES = "/WEB-INF/db.properties";

    public static Connection obtenerConexion(ServletContext contexto) throws Exception {
        Properties prop = new Properties();
        InputStream entrada = null;
        String modo = "local";

        try {
            entrada = contexto.getResourceAsStream(RUTA_PROPERTIES);
            if (entrada == null) {
                throw new Exception("No se encontro el archivo db.properties en " + RUTA_PROPERTIES);
            }
            prop.load(entrada);

            modo = prop.getProperty("modo", "local").trim().toLowerCase();

            String driver;
            String url;
            String usuario;
            String password;

            if ("remota".equals(modo)) {
                driver   = prop.getProperty("remota.driver");
                url      = prop.getProperty("remota.url");
                usuario  = prop.getProperty("remota.usuario");
                password = prop.getProperty("remota.password");
            } else {
                driver   = prop.getProperty("local.driver");
                url      = prop.getProperty("local.url");
                usuario  = prop.getProperty("local.usuario");
                password = prop.getProperty("local.password");
            }

            if (driver == null || url == null) {
                throw new Exception("Faltan propiedades de conexion para el modo '" + modo + "' en db.properties");
            }

            Class.forName(driver);
            return DriverManager.getConnection(url, usuario, password);

        } catch (ClassNotFoundException e) {
            throw new Exception("No se pudo cargar el driver JDBC para el modo '" + modo + "': " + e.getMessage(), e);
        } catch (Exception e) {
            throw new Exception("Error al conectar a la base de datos (modo=" + modo + "): " + e.getMessage(), e);
        } finally {
            if (entrada != null) {
                try {
                    entrada.close();
                } catch (Exception ignorado) {}
            }
        }
    }

    public static String obtenerModoActual(ServletContext contexto) {
        Properties prop = new Properties();
        InputStream entrada = null;
        try {
            entrada = contexto.getResourceAsStream(RUTA_PROPERTIES);
            if (entrada == null) {
                return "local";
            }
            prop.load(entrada);
            String modo = prop.getProperty("modo", "local").trim().toLowerCase();
            return "remota".equals(modo) ? "remota" : "local";
        } catch (Exception e) {
            return "local";
        } finally {
            if (entrada != null) {
                try { entrada.close(); } catch (Exception ignorado) {}
            }
        }
    }

    public static void cambiarModo(ServletContext contexto, String nuevoModo) throws Exception {
        if (nuevoModo == null) {
            throw new Exception("Debes indicar un modo.");
        }
        nuevoModo = nuevoModo.trim().toLowerCase();
        if (!"local".equals(nuevoModo) && !"remota".equals(nuevoModo)) {
            throw new Exception("Modo invalido: " + nuevoModo + " (usa 'local' o 'remota').");
        }

        String rutaReal = contexto.getRealPath(RUTA_PROPERTIES);
        if (rutaReal == null) {
            throw new Exception("No se pudo ubicar db.properties en el sistema de archivos "
                    + "(la app puede estar corriendo empaquetada como .war).");
        }

        Properties prop = new Properties();
        InputStream entrada = null;
        try {
            entrada = new FileInputStream(rutaReal);
            prop.load(entrada);
        } finally {
            if (entrada != null) {
                try { entrada.close(); } catch (Exception ignorado) {}
            }
        }

        prop.setProperty("modo", nuevoModo);

        OutputStream salida = null;
        try {
            salida = new FileOutputStream(rutaReal);
            prop.store(salida, "db.properties - modo actualizado desde el interruptor web");
        } finally {
            if (salida != null) {
                try { salida.close(); } catch (Exception ignorado) {}
            }
        }
    }
}

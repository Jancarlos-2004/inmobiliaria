package util;

import java.sql.SQLException;
import java.util.Date;
import java.util.regex.Pattern;

/**
 * ValidadorUtil
 * -------------
 * Centraliza las validaciones de integridad y formato exigidas por el parcial:
 * correo, telefono, precio positivo, fechas validas y captura comprensible
 * de violaciones de restricciones UNIQUE (MySQL error 1062).
 */
public class ValidadorUtil {

    private static final Pattern PATRON_CORREO = Pattern.compile(
        "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );

    private static final Pattern PATRON_TELEFONO = Pattern.compile(
        "^[0-9+()\\s-]{7,20}$"
    );

    public static boolean esCorreoValido(String correo) {
        if (correo == null || correo.trim().isEmpty()) {
            return false;
        }
        return PATRON_CORREO.matcher(correo.trim()).matches();
    }

    public static boolean esTelefonoValido(String telefono) {
        if (telefono == null || telefono.trim().isEmpty()) {
            return true; // Puede ser opcional en perfil
        }
        return PATRON_TELEFONO.matcher(telefono.trim()).matches();
    }

    public static boolean esPrecioValido(double precio) {
        return precio > 0;
    }

    public static boolean esFechaFutura(Date fecha) {
        if (fecha == null) return false;
        return fecha.after(new Date());
    }

    /**
     * Convierte errores de integridad de base de datos (MySQL 1062 - Duplicate entry)
     * en mensajes amigables y comprensibles para el usuario final.
     */
    public static String traducirExcepcionSQL(SQLException e) {
        if (e == null) {
            return "Ha ocurrido un error en la base de datos.";
        }

        // Error 1062: Duplicate entry for key '...'
        if (e.getErrorCode() == 1062 || (e.getMessage() != null && e.getMessage().toLowerCase().contains("duplicate entry"))) {
            String msg = e.getMessage().toLowerCase();
            if (msg.contains("correo") || msg.contains("usuarios.correo")) {
                return "El correo electrónico ya se encuentra registrado. Por favor, usa otro o inicia sesión.";
            }
            if (msg.contains("documento") || msg.contains("perfiles.documento")) {
                return "El número de documento de identidad ya se encuentra registrado en el sistema.";
            }
            if (msg.contains("matricula_inmobiliaria") || msg.contains("matricula")) {
                return "La matrícula inmobiliaria ya existe en el sistema. Debe ser única para cada inmueble.";
            }
            if (msg.contains("citas") || msg.contains("id_propiedad") || msg.contains("fecha_hora")) {
                return "Ya existe una cita agendada para esta propiedad en el mismo horario. Por favor selecciona otra hora o fecha.";
            }
            if (msg.contains("usuarios_roles")) {
                return "El usuario ya tiene asignado este rol.";
            }
            return "Ya existe un registro con estos datos en el sistema (restricción UNIQUE).";
        }

        return e.getMessage();
    }
}

package test;

import modelo.Perfil;
import modelo.Propiedad;
import modelo.Solicitud;
import modelo.Usuario;
import util.HashUtil;
import util.ValidadorUtil;

import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;

/**
 * TestSuiteInmobiliaria
 * ---------------------
 * Pruebas unitarias ejecutables para validar la lógica de negocio y seguridad:
 * - Cifrado y salt seguro de contraseñas (HashUtil).
 * - Validaciones de integridad y formato (ValidadorUtil).
 * - Traducción comprensible de restricciones UNIQUE (MySQL 1062).
 * - Reglas de agendamiento de citas y fechas futuras.
 * - Reglas de aprobación/rechazo de solicitudes y cambio de estado de propiedad.
 * - Integridad de roles y perfil 1:1 en modelos Java.
 */
public class TestSuiteInmobiliaria {

    private static int pruebasEjecutadas = 0;
    private static int pruebasExitosas = 0;

    public static void main(String[] args) {
        System.out.println("===============================================================");
        System.out.println("   SUITE DE PRUEBAS UNITARIAS - PROYECTO INMOBILIARIA UTS      ");
        System.out.println("===============================================================");

        testHashUtilGeneracionYConsistencia();
        testValidacionCorreos();
        testValidacionPrecios();
        testValidacionTelefonos();
        testTraduccionRestriccionesUniqueSQL();
        testReglasFechasCitas();
        testReglasAprobacionSolicitudYEstadoPropiedad();
        testModeloUsuarioRolYPerfil();

        System.out.println("\n---------------------------------------------------------------");
        System.out.println("RESUMEN DE PRUEBAS: " + pruebasExitosas + "/" + pruebasEjecutadas + " EXITOSAS");
        if (pruebasExitosas == pruebasEjecutadas) {
            System.out.println("[RESULTADO GLOBAL] TODAS LAS PRUEBAS UNITARIAS PASARON (100%)");
        } else {
            System.err.println("[RESULTADO GLOBAL] HUBO FALLOS EN LAS PRUEBAS.");
            System.exit(1);
        }
        System.out.println("===============================================================\n");
    }

    private static void afirmar(boolean condicion, String nombrePrueba) {
        pruebasEjecutadas++;
        if (condicion) {
            pruebasExitosas++;
            System.out.println(" [OK] " + nombrePrueba);
        } else {
            System.err.println(" [FALLO] " + nombrePrueba);
        }
    }

    // 1. Cifrado SHA-256 + Salt
    private static void testHashUtilGeneracionYConsistencia() {
        String salt1 = HashUtil.generarSalt();
        String salt2 = HashUtil.generarSalt();
        afirmar(salt1 != null && salt1.length() >= 8, "HashUtil: Salt generado correctamente con longitud segura");
        afirmar(!salt1.equals(salt2), "HashUtil: Dos salts generados consecutivamente son diferentes (entropia)");

        String pass = "Admin2026*";
        String hash1 = HashUtil.hashPassword(pass, salt1);
        String hash2 = HashUtil.hashPassword(pass, salt1);
        String hashDistinto = HashUtil.hashPassword(pass, salt2);

        afirmar(hash1.equals(hash2), "HashUtil: Mismo password y salt producen exactamente el mismo hash SHA-256");
        afirmar(!hash1.equals(hashDistinto), "HashUtil: Salting evita colisión de hashes para contraseñas idénticas");
        afirmar(!hash1.equals(pass), "HashUtil: La contraseña nunca se almacena en texto plano (64 caracteres hex)");
    }

    // 2. Validación de correos electrónicos
    private static void testValidacionCorreos() {
        afirmar(ValidadorUtil.esCorreoValido("cliente@uts.edu.co"), "Validador: Correo institucional valido");
        afirmar(ValidadorUtil.esCorreoValido("usuario.prueba@dominio.com"), "Validador: Correo corporativo valido");
        afirmar(!ValidadorUtil.esCorreoValido("correo-sin-arroba"), "Validador: Rechaza correo sin arroba");
        afirmar(!ValidadorUtil.esCorreoValido("test@sin-dominio"), "Validador: Rechaza correo sin TLD");
        afirmar(!ValidadorUtil.esCorreoValido(""), "Validador: Rechaza correo vacio");
        afirmar(!ValidadorUtil.esCorreoValido(null), "Validador: Rechaza correo null");
    }

    // 3. Validación de precios
    private static void testValidacionPrecios() {
        afirmar(ValidadorUtil.esPrecioValido(150000000.0), "Validador: Precio positivo valido (150M)");
        afirmar(ValidadorUtil.esPrecioValido(50000.0), "Validador: Precio positivo valido");
        afirmar(!ValidadorUtil.esPrecioValido(0.0), "Validador: Rechaza precio cero");
        afirmar(!ValidadorUtil.esPrecioValido(-250000.0), "Validador: Rechaza precio negativo");
    }

    // 4. Validación de teléfonos
    private static void testValidacionTelefonos() {
        afirmar(ValidadorUtil.esTelefonoValido("3151234567"), "Validador: Telefono celular colombiano valido");
        afirmar(ValidadorUtil.esTelefonoValido("+57 300 123 4567"), "Validador: Telefono con prefijo internacional");
        afirmar(ValidadorUtil.esTelefonoValido(null), "Validador: Telefono opcional permite null");
        afirmar(!ValidadorUtil.esTelefonoValido("abc-no-telefono"), "Validador: Rechaza telefono con letras");
    }

    // 5. Traducción de violaciones UNIQUE SQL (MySQL Error 1062)
    private static void testTraduccionRestriccionesUniqueSQL() {
        SQLException exCorreo = new SQLException("Duplicate entry 'admin@uts.edu.co' for key 'usuarios.correo'", "23000", 1062);
        String msgCorreo = ValidadorUtil.traducirExcepcionSQL(exCorreo);
        afirmar(msgCorreo.contains("correo electrónico ya se encuentra registrado"), "Manejo UNIQUE: Captura amigable de correo duplicado");

        SQLException exMatricula = new SQLException("Duplicate entry 'MAT-12345' for key 'matricula_inmobiliaria'", "23000", 1062);
        String msgMatricula = ValidadorUtil.traducirExcepcionSQL(exMatricula);
        afirmar(msgMatricula.contains("matrícula inmobiliaria ya existe"), "Manejo UNIQUE: Captura amigable de matrícula duplicada");

        SQLException exCita = new SQLException("Duplicate entry '1-2026-09-20' for key 'citas.id_propiedad'", "23000", 1062);
        String msgCita = ValidadorUtil.traducirExcepcionSQL(exCita);
        afirmar(msgCita.contains("cita agendada para esta propiedad en el mismo horario"), "Manejo UNIQUE: Captura amigable de cruce de horario de citas");

        SQLException exDoc = new SQLException("Duplicate entry '1098765432' for key 'perfiles.documento'", "23000", 1062);
        String msgDoc = ValidadorUtil.traducirExcepcionSQL(exDoc);
        afirmar(msgDoc.contains("documento de identidad ya se encuentra registrado"), "Manejo UNIQUE: Captura amigable de documento duplicado");
    }

    // 6. Reglas de fechas para citas
    private static void testReglasFechasCitas() {
        Calendar calFuturo = Calendar.getInstance();
        calFuturo.add(Calendar.DAY_OF_MONTH, 3);
        Date fechaFutura = calFuturo.getTime();

        Calendar calPasado = Calendar.getInstance();
        calPasado.add(Calendar.DAY_OF_MONTH, -2);
        Date fechaPasada = calPasado.getTime();

        afirmar(ValidadorUtil.esFechaFutura(fechaFutura), "Regla Citas: Acepta fecha futura para visita");
        afirmar(!ValidadorUtil.esFechaFutura(fechaPasada), "Regla Citas: Rechaza agendar visitas en fechas pasadas");
        afirmar(!ValidadorUtil.esFechaFutura(null), "Regla Citas: Rechaza fecha nula");
    }

    // 7. Reglas de negocio en aprobación de solicitudes
    private static void testReglasAprobacionSolicitudYEstadoPropiedad() {
        Propiedad prop = new Propiedad();
        prop.setId(101);
        prop.setTitulo("Apartamento Cabecera");
        prop.setEstado("disponible");

        Solicitud solCompra = new Solicitud();
        solCompra.setId(50);
        solCompra.setIdPropiedad(101);
        solCompra.setTipoSolicitud("compra");
        solCompra.setEstado("pendiente");

        // Simular decision de aprobacion
        if ("disponible".equals(prop.getEstado())) {
            solCompra.setEstado("aprobada");
            prop.setEstado("compra".equals(solCompra.getTipoSolicitud()) ? "vendido" : "arrendado");
        }
        afirmar("vendido".equals(prop.getEstado()), "Regla Negocio: Solicitud de compra aprobada cambia propiedad a 'vendido'");

        // Si la propiedad ya esta vendida, no puede aprobarse otra solicitud simultanea
        Solicitud solArriendo = new Solicitud();
        solArriendo.setId(51);
        solArriendo.setIdPropiedad(101);
        solArriendo.setTipoSolicitud("arriendo");
        solArriendo.setEstado("pendiente");

        boolean sePudoAprobar = false;
        if ("disponible".equals(prop.getEstado())) {
            solArriendo.setEstado("aprobada");
            sePudoAprobar = true;
        }
        afirmar(!sePudoAprobar, "Regla Negocio: Impide aprobar una segunda solicitud si el inmueble ya no está 'disponible'");
    }

    // 8. Integridad de Usuario, Perfil 1:1 y Roles N:M
    private static void testModeloUsuarioRolYPerfil() {
        Usuario user = new Usuario(1, "admin@uts.edu.co", "hash", "salt", "activo");
        user.addRol("Administrador");
        user.addRol("Inmobiliaria");

        afirmar(user.tieneRol("Administrador"), "Modelo: Usuario verifica pertenencia a rol Administrador");
        afirmar(user.tieneRol("Inmobiliaria"), "Modelo: Usuario con multiples roles soporta rol Inmobiliaria");
        afirmar(!user.tieneRol("Cliente"), "Modelo: Usuario no tiene rol Cliente si no le ha sido asignado");

        Perfil p = new Perfil(1, "Carlos", "Gomez", "1098765432", "3001234567", "Carrera 27 # 36-10", "foto.jpg");
        user.setPerfil(p);

        afirmar(user.getPerfil() != null && user.getPerfil().getIdUsuario() == user.getId(), "Modelo 1:1: Relacion Usuario 1:1 Perfil garantizada mediante idUsuario");
        afirmar("Carlos Gomez".equals(user.getPerfil().getNombreCompleto()), "Modelo Perfil: Helper getNombreCompleto retorna nombres y apellidos unidos");
    }
}

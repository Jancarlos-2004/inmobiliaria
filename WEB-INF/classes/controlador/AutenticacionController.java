package controlador;

import dao.AuditoriaDAO;
import dao.UsuarioDAO;
import modelo.Perfil;
import modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * AutenticacionController
 * ------------------------
 * Un solo Servlet que atiende tres rutas (ver web.xml):
 *   /login    -> GET muestra login.jsp, POST valida credenciales
 *   /registro -> GET muestra registro.jsp, POST crea el usuario Cliente
 *   /logout   -> invalida la sesion y redirige al index
 *
 * Las contraseñas nunca se manejan en texto plano fuera de este flujo:
 * UsuarioDAO + HashUtil se encargan del salteo/hash SHA-256.
 */
public class AutenticacionController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ruta = request.getServletPath();

        if ("/logout".equals(ruta)) {
            cerrarSesion(request, response);
            return;
        }

        // /login y /registro simplemente muestran su formulario (GET)
        if ("/login".equals(ruta)) {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else if ("/registro".equals(ruta)) {
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
        } else if ("/perfil".equals(ruta)) {
            mostrarPerfil(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ruta = request.getServletPath();

        if ("/login".equals(ruta)) {
            procesarLogin(request, response);
        } else if ("/registro".equals(ruta)) {
            procesarRegistro(request, response);
        } else if ("/perfil".equals(ruta)) {
            procesarActualizarPerfil(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    // ------------------------------------------------------------------
    // LOGIN
    // ------------------------------------------------------------------
    private void procesarLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String correo = trim(request.getParameter("correo"));
        String password = request.getParameter("password");

        if (correo.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("mensajeError", "Debes ingresar correo y contraseña.");
            request.setAttribute("correo", correo);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            Usuario usuario = usuarioDAO.validarCredenciales(getServletContext(), correo, password);

            if (usuario == null) {
                auditoriaDAO.registrarAccion(getServletContext(), null, "LOGIN_FALLIDO",
                        "usuarios", null, "Intento de acceso con correo: " + correo);
                request.setAttribute("mensajeError", "Correo o contraseña incorrectos.");
                request.setAttribute("correo", correo);
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // Credenciales validas: crear sesion
            HttpSession session = request.getSession(true);
            session.setAttribute("usuario", usuario);
            session.setAttribute("correo", usuario.getCorreo());
            session.setAttribute("roles", usuario.getRoles());

            // Registrar el inicio de sesion exitoso en la auditoria
            auditoriaDAO.registrarAccion(getServletContext(), usuario.getId(), "LOGIN_EXITOSO",
                    "usuarios", usuario.getId(), "Inicio de sesion desde correo " + usuario.getCorreo());

            String destino = (String) session.getAttribute("rutaDestino");
            session.removeAttribute("rutaDestino");

            if (destino != null && !destino.isEmpty()) {
                response.sendRedirect(request.getContextPath() + destino);
                return;
            }

            response.sendRedirect(request.getContextPath() + rutaDashboardSegunRol(usuario));

        } catch (Exception e) {
            request.setAttribute("mensajeError", "No se pudo iniciar sesion: " + e.getMessage());
            request.setAttribute("correo", correo);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private String rutaDashboardSegunRol(Usuario usuario) {
        if (usuario.tieneRol("Administrador")) {
            return "/dashboard_admin.jsp";
        } else if (usuario.tieneRol("Inmobiliaria")) {
            return "/dashboard_agente.jsp";
        } else {
            return "/dashboard_cliente.jsp";
        }
    }

    // ------------------------------------------------------------------
    // REGISTRO (siempre crea un usuario con rol Cliente)
    // ------------------------------------------------------------------
    private void procesarRegistro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String correo = trim(request.getParameter("correo"));
        String password = request.getParameter("password");
        String confirmarPassword = request.getParameter("confirmarPassword");
        String nombres = trim(request.getParameter("nombres"));
        String apellidos = trim(request.getParameter("apellidos"));
        String documento = trim(request.getParameter("documento"));
        String telefono = trim(request.getParameter("telefono"));
        String direccion = trim(request.getParameter("direccion"));

        // Repoblar el formulario en caso de error, sin reenviar la contraseña
        request.setAttribute("correo", correo);
        request.setAttribute("nombres", nombres);
        request.setAttribute("apellidos", apellidos);
        request.setAttribute("documento", documento);
        request.setAttribute("telefono", telefono);
        request.setAttribute("direccion", direccion);

        String errorValidacion = validarCamposRegistro(
                correo, password, confirmarPassword, nombres, apellidos, documento);

        if (errorValidacion != null) {
            request.setAttribute("mensajeError", errorValidacion);
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }

        try {
            Perfil perfil = new Perfil();
            perfil.setNombres(nombres);
            perfil.setApellidos(apellidos);
            perfil.setDocumento(documento);
            perfil.setTelefono(telefono);
            perfil.setDireccion(direccion);
            perfil.setFoto(null);

            usuarioDAO.registrarCliente(getServletContext(), correo, password, perfil);

            auditoriaDAO.registrarAccion(getServletContext(), null, "REGISTRO_CLIENTE",
                    "usuarios", null, "Nuevo cliente registrado con correo: " + correo);

            request.setAttribute("mensajeExito",
                    "¡Registro exitoso! Ya puedes iniciar sesion con tu correo y contraseña.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } catch (Exception e) {
            // Captura errores de negocio (correo/documento duplicado) y de SQL
            request.setAttribute("mensajeError", e.getMessage());
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
        }
    }

    private String validarCamposRegistro(String correo, String password, String confirmarPassword,
                                          String nombres, String apellidos, String documento) {
        if (correo.isEmpty() || password == null || password.isEmpty()
                || nombres.isEmpty() || apellidos.isEmpty() || documento.isEmpty()) {
            return "Todos los campos obligatorios deben ser diligenciados.";
        }
        if (!correo.matches("^[\\w.+-]+@[\\w-]+\\.[a-zA-Z]{2,}$")) {
            return "El correo ingresado no tiene un formato valido.";
        }
        if (password.length() < 6) {
            return "La contraseña debe tener al menos 6 caracteres.";
        }
        if (confirmarPassword == null || !password.equals(confirmarPassword)) {
            return "Las contraseñas no coinciden.";
        }
        return null;
    }

    // ------------------------------------------------------------------
    // PERFIL (cualquier usuario autenticado edita SOLO su propio perfil)
    // ------------------------------------------------------------------
    private void mostrarPerfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/perfil.jsp").forward(request, response);
    }

    private void procesarActualizarPerfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuarioSesion = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuarioSesion == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String nombres = trim(request.getParameter("nombres"));
        String apellidos = trim(request.getParameter("apellidos"));
        String documento = trim(request.getParameter("documento"));
        String telefono = trim(request.getParameter("telefono"));
        String direccion = trim(request.getParameter("direccion"));

        if (nombres.isEmpty() || apellidos.isEmpty() || documento.isEmpty()) {
            request.setAttribute("mensajeError", "Nombres, apellidos y documento son obligatorios.");
            request.getRequestDispatcher("/perfil.jsp").forward(request, response);
            return;
        }

        Perfil perfil = new Perfil();
        perfil.setIdUsuario(usuarioSesion.getId());
        perfil.setNombres(nombres);
        perfil.setApellidos(apellidos);
        perfil.setDocumento(documento);
        perfil.setTelefono(telefono);
        perfil.setDireccion(direccion);
        perfil.setFoto(usuarioSesion.getPerfil() != null ? usuarioSesion.getPerfil().getFoto() : null);

        try {
            usuarioDAO.actualizarPerfil(getServletContext(), perfil);

            // Refrescar el usuario en sesion para reflejar los cambios de inmediato
            Usuario usuarioActualizado = usuarioDAO.obtenerUsuarioPorId(getServletContext(), usuarioSesion.getId());
            session.setAttribute("usuario", usuarioActualizado);

            request.setAttribute("mensajeExito", "Perfil actualizado correctamente.");
        } catch (Exception e) {
            request.setAttribute("mensajeError", e.getMessage());
        }

        request.getRequestDispatcher("/perfil.jsp").forward(request, response);
    }

    // ------------------------------------------------------------------
    // LOGOUT
    // ------------------------------------------------------------------
    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Usuario usuario = (Usuario) session.getAttribute("usuario");
            if (usuario != null) {
                auditoriaDAO.registrarAccion(getServletContext(), usuario.getId(), "LOGOUT",
                        "usuarios", usuario.getId(), "Cierre de sesion");
            }
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    private String trim(String valor) {
        return valor == null ? "" : valor.trim();
    }
}

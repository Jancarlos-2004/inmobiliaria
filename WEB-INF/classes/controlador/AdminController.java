package controlador;

import dao.AuditoriaDAO;
import dao.ReporteDAO;
import dao.UsuarioDAO;
import modelo.Auditoria;
import modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * AdminController
 * ----------------
 * Todas las rutas quedan bajo /admin/* y por lo tanto ya estan protegidas
 * por AutorizacionFilter (exige rol Administrador); aqui se vuelve a
 * validar por defensa en profundidad.
 *
 *   /admin/usuarios              (GET)  -> listado de usuarios
 *   /admin/usuarios/estado       (POST) -> activar/inactivar (?id=&estado=)
 *   /admin/usuarios/roles        (POST) -> reasignar roles (?id=&roles=2,3)
 *   /admin/auditoria             (GET)  -> ultimos eventos registrados
 *   /admin/reportes              (GET)  -> las 5 consultas obligatorias
 */
public class AdminController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final AuditoriaDAO auditoriaDAO = new AuditoriaDAO();
    private final ReporteDAO reporteDAO = new ReporteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ruta = request.getServletPath();

        // /agente/reportes reutiliza el mismo reporte, visible tambien para el rol Inmobiliaria.
        // El resto de rutas de este controlador son exclusivas de Administrador.
        boolean esRutaReportesAgente = "/agente/reportes".equals(ruta);
        Usuario usuarioSesion = usuarioDeSesion(request);

        boolean autorizado = esRutaReportesAgente
                ? (usuarioSesion != null && (usuarioSesion.tieneRol("Administrador") || usuarioSesion.tieneRol("Inmobiliaria")))
                : esAdministrador(request);

        if (!autorizado) {
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }

        try {
            switch (ruta) {
                case "/admin/usuarios":
                    listarUsuarios(request, response);
                    break;
                case "/admin/auditoria":
                    listarAuditoria(request, response);
                    break;
                case "/admin/reportes":
                case "/agente/reportes":
                    mostrarReportes(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/dashboard_admin.jsp");
            }
        } catch (Exception e) {
            request.setAttribute("mensajeError", "Ocurrio un error: " + e.getMessage());
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!esAdministrador(request)) {
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }

        String ruta = request.getServletPath();
        try {
            switch (ruta) {
                case "/admin/usuarios/estado":
                    procesarCambioEstado(request, response);
                    break;
                case "/admin/usuarios/roles":
                    procesarReasignarRoles(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/dashboard_admin.jsp");
            }
        } catch (Exception e) {
            request.setAttribute("mensajeError", "Ocurrio un error: " + e.getMessage());
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
        }
    }

    // ------------------------------------------------------------------
    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        List<Usuario> usuarios = usuarioDAO.listarUsuarios(getServletContext());
        request.setAttribute("usuarios", usuarios);
        request.setAttribute("tituloPagina", "Gestion de usuarios");
        request.getRequestDispatcher("/admin_usuarios.jsp").forward(request, response);
    }

    private void procesarCambioEstado(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int idUsuario = parseIntOrCero(request.getParameter("id"));
        String nuevoEstado = request.getParameter("estado");

        if (!"activo".equals(nuevoEstado) && !"inactivo".equals(nuevoEstado)) {
            response.sendRedirect(request.getContextPath() + "/denegado.jsp");
            return;
        }

        Usuario admin = usuarioDeSesion(request);
        usuarioDAO.cambiarEstadoUsuario(getServletContext(), idUsuario, nuevoEstado);
        auditoriaDAO.registrarAccion(getServletContext(), admin.getId(), "CAMBIAR_ESTADO_USUARIO",
                "usuarios", idUsuario, "Nuevo estado: " + nuevoEstado);

        response.sendRedirect(request.getContextPath() + "/admin/usuarios");
    }

    private void procesarReasignarRoles(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int idUsuario = parseIntOrCero(request.getParameter("id"));
        String[] idsRoles = request.getParameterValues("roles");

        Usuario admin = usuarioDeSesion(request);
        usuarioDAO.reasignarRoles(getServletContext(), idUsuario, idsRoles);
        auditoriaDAO.registrarAccion(getServletContext(), admin.getId(), "REASIGNAR_ROLES",
                "usuarios_roles", idUsuario, "Roles asignados: " +
                        (idsRoles == null ? "(ninguno)" : String.join(",", idsRoles)));

        response.sendRedirect(request.getContextPath() + "/admin/usuarios");
    }

    // ------------------------------------------------------------------
    private void listarAuditoria(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        List<Auditoria> eventos = auditoriaDAO.listarUltimos(getServletContext(), 100);
        request.setAttribute("eventos", eventos);
        request.setAttribute("tituloPagina", "Auditoria del sistema");
        request.getRequestDispatcher("/admin_auditoria.jsp").forward(request, response);
    }

    // ------------------------------------------------------------------
    private void mostrarReportes(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {

        List<Map<String, Object>> propiedadesDetalladas = reporteDAO.propiedadesDetalladas(getServletContext());
        List<Map<String, Object>> detalleCitas = reporteDAO.detalleCitas(getServletContext());
        List<Map<String, Object>> propiedadesSinCitas = reporteDAO.propiedadesSinCitas(getServletContext());
        List<Map<String, Object>> inmueblesPorCiudad = reporteDAO.inmueblesPorCiudad(getServletContext());

        request.setAttribute("propiedadesDetalladas", propiedadesDetalladas);
        request.setAttribute("detalleCitas", detalleCitas);
        request.setAttribute("propiedadesSinCitas", propiedadesSinCitas);
        request.setAttribute("inmueblesPorCiudad", inmueblesPorCiudad);

        // El reporte de caracteristicas por propiedad requiere un id especifico (?idPropiedad=)
        int idPropiedad = parseIntOrCero(request.getParameter("idPropiedad"));
        if (idPropiedad > 0) {
            request.setAttribute("caracteristicasPropiedad",
                    reporteDAO.caracteristicasPorPropiedad(getServletContext(), idPropiedad));
            request.setAttribute("idPropiedadConsultada", idPropiedad);
        }

        request.setAttribute("tituloPagina", "Reportes");
        request.getRequestDispatcher("/admin_reportes.jsp").forward(request, response);
    }

    // ------------------------------------------------------------------
    private boolean esAdministrador(HttpServletRequest request) {
        Usuario usuario = usuarioDeSesion(request);
        return usuario != null && usuario.tieneRol("Administrador");
    }

    private Usuario usuarioDeSesion(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (Usuario) session.getAttribute("usuario") : null;
    }

    private int parseIntOrCero(String valor) {
        if (valor == null || valor.trim().isEmpty()) return 0;
        try {
            return Integer.parseInt(valor.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}

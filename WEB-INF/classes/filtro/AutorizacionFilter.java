package filtro;

import modelo.Usuario;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * AutorizacionFilter
 * -------------------
 * Intercepta las solicitudes hacia rutas privadas (dashboards, cambio de
 * modo de base de datos, y cualquier recurso bajo /admin, /agente o
 * /cliente) y verifica:
 *   1) Que exista una sesion activa con un usuario autenticado.
 *   2) Que ese usuario tenga al menos uno de los roles permitidos
 *      para la ruta solicitada.
 *
 * Si cualquiera de las dos condiciones falla, redirige a login.jsp
 * (sin sesion) o a denegado.jsp (sesion valida pero rol incorrecto).
 *
 * IMPORTANTE: este filtro es una capa de UX / primera barrera.
 * Cada Servlet/Controller (PropiedadController, CitaController, etc.)
 * DEBE volver a validar el rol en el servidor antes de ejecutar
 * cualquier operacion CRUD, tal como lo exige el plan del proyecto.
 */
public class AutorizacionFilter implements Filter {

    // Mapa de ruta protegida -> roles permitidos para esa ruta
    private static final Map<String, String[]> RUTAS_PROTEGIDAS = new HashMap<>();

    static {
        RUTAS_PROTEGIDAS.put("/dashboard_cliente.jsp",    new String[]{"Cliente"});
        RUTAS_PROTEGIDAS.put("/citas_cliente.jsp",        new String[]{"Cliente"});
        RUTAS_PROTEGIDAS.put("/solicitudes_cliente.jsp",  new String[]{"Cliente"});
        RUTAS_PROTEGIDAS.put("/cita_form.jsp",            new String[]{"Cliente"});
        RUTAS_PROTEGIDAS.put("/solicitud_form.jsp",       new String[]{"Cliente"});

        RUTAS_PROTEGIDAS.put("/dashboard_agente.jsp",     new String[]{"Inmobiliaria", "Administrador"});
        RUTAS_PROTEGIDAS.put("/agente_propiedades.jsp",   new String[]{"Inmobiliaria", "Administrador"});
        RUTAS_PROTEGIDAS.put("/formulario_propiedad.jsp", new String[]{"Inmobiliaria", "Administrador"});
        RUTAS_PROTEGIDAS.put("/citas_agente.jsp",         new String[]{"Inmobiliaria", "Administrador"});
        RUTAS_PROTEGIDAS.put("/solicitudes_agente.jsp",   new String[]{"Inmobiliaria", "Administrador"});

        RUTAS_PROTEGIDAS.put("/dashboard_admin.jsp",      new String[]{"Administrador"});
        RUTAS_PROTEGIDAS.put("/admin_usuarios.jsp",       new String[]{"Administrador"});
        RUTAS_PROTEGIDAS.put("/admin_reportes.jsp",       new String[]{"Administrador", "Inmobiliaria"});
        RUTAS_PROTEGIDAS.put("/admin_auditoria.jsp",      new String[]{"Administrador"});
        RUTAS_PROTEGIDAS.put("/cambiarModo.jsp",          new String[]{"Administrador"});

        RUTAS_PROTEGIDAS.put("/perfil.jsp",               new String[]{"Cliente", "Inmobiliaria", "Administrador"});
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Sin inicializacion especial requerida
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String contextPath = request.getContextPath();
        String rutaSolicitada = request.getRequestURI().substring(contextPath.length());

        HttpSession session = request.getSession(false);
        Usuario usuarioSesion = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        // 1) Sin sesion activa -> a login, guardando a donde queria ir
        if (usuarioSesion == null) {
            request.setAttribute("mensajeError", "Debes iniciar sesion para acceder a esta seccion.");
            request.getSession(true).setAttribute("rutaDestino", rutaSolicitada);
            response.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        // 2) Determinar los roles permitidos para la ruta (exacta o por prefijo /admin,/agente,/cliente)
        String[] rolesPermitidos = resolverRolesPermitidos(rutaSolicitada);

        // 3) Verificar que el usuario tenga alguno de los roles permitidos
        if (rolesPermitidos != null && !tieneAlgunRol(usuarioSesion, rolesPermitidos)) {
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }

        // Todo correcto: continuar con la cadena de filtros / recurso solicitado
        chain.doFilter(req, res);
    }

    private String[] resolverRolesPermitidos(String ruta) {
        if (RUTAS_PROTEGIDAS.containsKey(ruta)) {
            return RUTAS_PROTEGIDAS.get(ruta);
        }
        if (ruta.startsWith("/admin/")) {
            return new String[]{"Administrador"};
        }
        if (ruta.startsWith("/agente/")) {
            // Las rutas /agente/* incluyen tanto funciones exclusivas de Inmobiliaria
            // (crear/editar/dar de baja SUS propiedades, SUS citas, SUS solicitudes)
            // como funciones que el Administrador tambien debe poder ejecutar
            // (gestionar propiedades/citas/solicitudes de cualquier agente).
            // La restriccion fina "solo mis propios registros" para Inmobiliaria
            // se aplica despues, a nivel de Controller/DAO (ver PropiedadController,
            // CitaController y SolicitudController), no aqui.
            return new String[]{"Administrador", "Inmobiliaria"};
        }
        if (ruta.startsWith("/cliente/")) {
            return new String[]{"Cliente"};
        }
        // Ruta no mapeada explicitamente: solo exige sesion activa (ya validada arriba)
        return null;
    }

    private boolean tieneAlgunRol(Usuario usuario, String[] roles) {
        for (String rol : roles) {
            if (usuario.tieneRol(rol)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void destroy() {
        // Sin recursos que liberar
    }
}

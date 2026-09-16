package controlador;

import dao.AuditoriaDAO;
import dao.PropiedadDAO;
import dao.SolicitudDAO;
import modelo.Propiedad;
import modelo.Solicitud;
import modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * SolicitudController
 * --------------------
 * /cliente/solicitudes                (GET, Cliente)      -> "Mis solicitudes"
 * /cliente/solicitudes/nueva          (GET/POST, Cliente) -> radicar (?idPropiedad=)
 * /agente/solicitudes                 (GET, Inmobiliaria o Administrador) -> solicitudes recibidas (Administrador ve todas)
 * /agente/solicitudes/resolver        (POST, Inmobiliaria o Administrador)-> aprobar/rechazar (?id=&decision=)
 *
 * Nota sobre documentos: por ahora se registran como URL/ruta de texto
 * (una por linea), igual que las imagenes de propiedades. La carga de
 * archivos binarios reales se puede incorporar despues con
 * Apache Commons FileUpload sin cambiar el modelo de datos.
 */
public class SolicitudController extends HttpServlet {

    private final SolicitudDAO solicitudDAO = new SolicitudDAO();
    private final PropiedadDAO propiedadDAO = new PropiedadDAO();
    private final AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ruta = request.getServletPath();
        try {
            switch (ruta) {
                case "/cliente/solicitudes":
                    listarSolicitudesCliente(request, response);
                    break;
                case "/cliente/solicitudes/nueva":
                    mostrarFormularioSolicitud(request, response);
                    break;
                case "/agente/solicitudes":
                    listarSolicitudesAgente(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } catch (Exception e) {
            request.setAttribute("mensajeError", "Ocurrio un error: " + e.getMessage());
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ruta = request.getServletPath();
        try {
            switch (ruta) {
                case "/cliente/solicitudes/nueva":
                    procesarRadicarSolicitud(request, response);
                    break;
                case "/agente/solicitudes/resolver":
                    procesarResolverSolicitud(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } catch (Exception e) {
            request.setAttribute("mensajeError", "Ocurrio un error: " + e.getMessage());
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
        }
    }

    private void listarSolicitudesCliente(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        Usuario usuario = usuarioDeSesion(request);
        List<Solicitud> solicitudes = solicitudDAO.listarPorCliente(getServletContext(), usuario.getId());
        request.setAttribute("solicitudes", solicitudes);
        request.setAttribute("tituloPagina", "Mis solicitudes");
        request.getRequestDispatcher("/solicitudes_cliente.jsp").forward(request, response);
    }

    private void mostrarFormularioSolicitud(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        int idPropiedad = parseIntOrCero(request.getParameter("idPropiedad"));
        Propiedad propiedad = propiedadDAO.obtenerPropiedadPorId(getServletContext(), idPropiedad);

        if (propiedad == null) {
            request.setAttribute("mensajeError", "La propiedad indicada no existe.");
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }

        request.setAttribute("propiedad", propiedad);
        request.setAttribute("tituloPagina", "Radicar solicitud");
        request.getRequestDispatcher("/solicitud_form.jsp").forward(request, response);
    }

    private void procesarRadicarSolicitud(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        Usuario usuario = usuarioDeSesion(request);
        int idPropiedad = parseIntOrCero(request.getParameter("idPropiedad"));
        String tipoSolicitud = request.getParameter("tipoSolicitud");

        Propiedad propiedad = propiedadDAO.obtenerPropiedadPorId(getServletContext(), idPropiedad);
        if (propiedad == null) {
            request.setAttribute("mensajeError", "La propiedad indicada no existe.");
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }

        if (!"compra".equals(tipoSolicitud) && !"arriendo".equals(tipoSolicitud)) {
            request.setAttribute("mensajeError", "Debes indicar si la solicitud es de compra o arriendo.");
            request.setAttribute("propiedad", propiedad);
            request.getRequestDispatcher("/solicitud_form.jsp").forward(request, response);
            return;
        }

        Solicitud s = new Solicitud();
        s.setIdPropiedad(idPropiedad);
        s.setIdCliente(usuario.getId());
        s.setTipoSolicitud(tipoSolicitud);

        agregarDocumentosDelFormulario(request, s);

        try {
            int idSolicitud = solicitudDAO.radicarSolicitud(getServletContext(), s);
            auditoriaDAO.registrarAccion(getServletContext(), usuario.getId(), "RADICAR_SOLICITUD",
                    "solicitudes", idSolicitud, "Solicitud de " + tipoSolicitud + " para la propiedad #" + idPropiedad);
            response.sendRedirect(request.getContextPath() + "/cliente/solicitudes");
        } catch (Exception e) {
            request.setAttribute("mensajeError", e.getMessage());
            request.setAttribute("propiedad", propiedad);
            request.getRequestDispatcher("/solicitud_form.jsp").forward(request, response);
        }
    }

    private void agregarDocumentosDelFormulario(HttpServletRequest request, Solicitud s) {
        String[] tipos = {"identificacion", "ingresos", "contrato", "otro"};
        for (String tipo : tipos) {
            String url = request.getParameter("doc_" + tipo);
            if (url != null && !url.trim().isEmpty()) {
                String nombreArchivo = url.trim().substring(url.trim().lastIndexOf('/') + 1);
                s.addDocumento(new Solicitud.Documento(0, 0, nombreArchivo, url.trim(), tipo));
            }
        }
    }

    private void listarSolicitudesAgente(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        Usuario usuario = usuarioDeSesion(request);
        if (usuario == null || !(usuario.tieneRol("Inmobiliaria") || usuario.tieneRol("Administrador"))) {
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }

        // El Administrador no esta limitado a un agente: ve todas las solicitudes del sistema.
        List<Solicitud> solicitudes = usuario.tieneRol("Administrador")
                ? solicitudDAO.listarTodas(getServletContext())
                : solicitudDAO.listarPorAgente(getServletContext(), usuario.getId());

        request.setAttribute("solicitudes", solicitudes);
        request.setAttribute("tituloPagina", "Solicitudes recibidas");
        request.getRequestDispatcher("/solicitudes_agente.jsp").forward(request, response);
    }

    private void procesarResolverSolicitud(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        Usuario usuario = usuarioDeSesion(request);
        int idSolicitud = parseIntOrCero(request.getParameter("id"));
        String decision = request.getParameter("decision"); // aprobada | rechazada

        if (!"aprobada".equals(decision) && !"rechazada".equals(decision)) {
            response.sendRedirect(request.getContextPath() + "/denegado.jsp");
            return;
        }

        Solicitud s = solicitudDAO.obtenerPorId(getServletContext(), idSolicitud);
        if (s == null) {
            response.sendRedirect(request.getContextPath() + "/denegado.jsp");
            return;
        }

        boolean autorizado = usuario != null && (usuario.tieneRol("Administrador")
                || (usuario.tieneRol("Inmobiliaria") && usuario.getId() == s.getIdAgentePropiedad()));
        if (!autorizado) {
            response.sendRedirect(request.getContextPath() + "/denegado.jsp");
            return;
        }

        // Si se va a aprobar, la propiedad debe seguir disponible: evita que dos
        // solicitudes distintas (p. ej. una de compra y otra de arriendo) queden
        // ambas aprobadas sobre el mismo inmueble.
        if ("aprobada".equals(decision)) {
            Propiedad propiedad = propiedadDAO.obtenerPropiedadPorId(getServletContext(), s.getIdPropiedad());
            if (propiedad == null) {
                request.setAttribute("mensajeError", "La propiedad asociada ya no existe.");
                mostrarSolicitudesAgenteConMensaje(request, response, usuario);
                return;
            }
            if (!"disponible".equals(propiedad.getEstado())) {
                request.setAttribute("mensajeError",
                        "No se puede aprobar: la propiedad ya no esta disponible (estado actual: "
                                + propiedad.getEstado() + ").");
                mostrarSolicitudesAgenteConMensaje(request, response, usuario);
                return;
            }
        }

        solicitudDAO.actualizarEstado(getServletContext(), idSolicitud, decision);
        auditoriaDAO.registrarAccion(getServletContext(), usuario.getId(), "RESOLVER_SOLICITUD",
                "solicitudes", idSolicitud, "Decision: " + decision);

        // Si se aprueba la solicitud, el estado de la propiedad cambia de inmediato
        // (compra -> vendido, arriendo -> arrendado), sin pasar por el formulario de edicion.
        if ("aprobada".equals(decision)) {
            String nuevoEstadoPropiedad = "compra".equals(s.getTipoSolicitud()) ? "vendido" : "arrendado";
            propiedadDAO.actualizarEstado(getServletContext(), s.getIdPropiedad(), nuevoEstadoPropiedad);
            auditoriaDAO.registrarAccion(getServletContext(), usuario.getId(), "CAMBIO_ESTADO_PROPIEDAD",
                    "propiedades", s.getIdPropiedad(),
                    "Propiedad marcada como " + nuevoEstadoPropiedad + " tras aprobar solicitud #" + idSolicitud);
        }

        response.sendRedirect(request.getContextPath() + "/agente/solicitudes");
    }

    /** Recarga la lista de "solicitudes recibidas" del agente, conservando el mensajeError/Exito ya seteado. */
    private void mostrarSolicitudesAgenteConMensaje(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws Exception, ServletException, IOException {
        List<Solicitud> solicitudes = usuario.tieneRol("Administrador")
                ? solicitudDAO.listarTodas(getServletContext())
                : solicitudDAO.listarPorAgente(getServletContext(), usuario.getId());
        request.setAttribute("solicitudes", solicitudes);
        request.setAttribute("tituloPagina", "Solicitudes recibidas");
        request.getRequestDispatcher("/solicitudes_agente.jsp").forward(request, response);
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

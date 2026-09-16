package controlador;

import dao.AuditoriaDAO;
import dao.CitaDAO;
import dao.PropiedadDAO;
import modelo.Cita;
import modelo.Propiedad;
import modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * CitaController
 * ---------------
 * /cliente/citas               (GET, Cliente)      -> "Mis citas"
 * /cliente/citas/nueva         (GET/POST, Cliente) -> agendar cita (?idPropiedad=)
 * /agente/citas                (GET, Inmobiliaria o Administrador) -> citas sobre mis inmuebles (Administrador ve todas)
 * /agente/citas/estado         (POST, Inmobiliaria o Administrador)-> aceptar/cancelar/completar (?id=&estado=)
 */
public class CitaController extends HttpServlet {

    private final CitaDAO citaDAO = new CitaDAO();
    private final PropiedadDAO propiedadDAO = new PropiedadDAO();
    private final AuditoriaDAO auditoriaDAO = new AuditoriaDAO();
    private static final SimpleDateFormat FORMATO_FECHA_HORA = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ruta = request.getServletPath();
        try {
            switch (ruta) {
                case "/cliente/citas":
                    listarCitasCliente(request, response);
                    break;
                case "/cliente/citas/nueva":
                    mostrarFormularioCita(request, response);
                    break;
                case "/agente/citas":
                    listarCitasAgente(request, response);
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
                case "/cliente/citas/nueva":
                    procesarAgendarCita(request, response);
                    break;
                case "/agente/citas/estado":
                    procesarCambioEstado(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } catch (Exception e) {
            request.setAttribute("mensajeError", "Ocurrio un error: " + e.getMessage());
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
        }
    }

    private void listarCitasCliente(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        Usuario usuario = usuarioDeSesion(request);
        List<Cita> citas = citaDAO.listarCitasPorCliente(getServletContext(), usuario.getId());
        request.setAttribute("citas", citas);
        request.setAttribute("tituloPagina", "Mis citas");
        request.getRequestDispatcher("/citas_cliente.jsp").forward(request, response);
    }

    private void mostrarFormularioCita(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        int idPropiedad = parseIntOrCero(request.getParameter("idPropiedad"));
        Propiedad propiedad = propiedadDAO.obtenerPropiedadPorId(getServletContext(), idPropiedad);

        if (propiedad == null) {
            request.setAttribute("mensajeError", "La propiedad indicada no existe.");
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }

        request.setAttribute("propiedad", propiedad);
        request.setAttribute("tituloPagina", "Agendar cita");
        request.getRequestDispatcher("/cita_form.jsp").forward(request, response);
    }

    private void procesarAgendarCita(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        Usuario usuario = usuarioDeSesion(request);
        int idPropiedad = parseIntOrCero(request.getParameter("idPropiedad"));
        String fechaHoraStr = request.getParameter("fechaHora");
        String notas = request.getParameter("notas");

        Propiedad propiedad = propiedadDAO.obtenerPropiedadPorId(getServletContext(), idPropiedad);
        if (propiedad == null) {
            request.setAttribute("mensajeError", "La propiedad indicada no existe.");
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }

        Date fechaHora;
        try {
            fechaHora = FORMATO_FECHA_HORA.parse(fechaHoraStr);
        } catch (Exception e) {
            request.setAttribute("mensajeError", "La fecha y hora ingresadas no son validas.");
            request.setAttribute("propiedad", propiedad);
            request.getRequestDispatcher("/cita_form.jsp").forward(request, response);
            return;
        }

        if (fechaHora.before(new Date())) {
            request.setAttribute("mensajeError", "No puedes agendar una cita en una fecha pasada.");
            request.setAttribute("propiedad", propiedad);
            request.getRequestDispatcher("/cita_form.jsp").forward(request, response);
            return;
        }

        Cita cita = new Cita();
        cita.setIdPropiedad(idPropiedad);
        cita.setIdCliente(usuario.getId());
        cita.setFechaHora(fechaHora);
        cita.setEstado("pendiente");
        cita.setNotas(notas);

        try {
            citaDAO.agendarCita(getServletContext(), cita);
            auditoriaDAO.registrarAccion(getServletContext(), usuario.getId(), "AGENDAR_CITA",
                    "citas", null, "Cita solicitada para la propiedad #" + idPropiedad);
            response.sendRedirect(request.getContextPath() + "/cliente/citas");
        } catch (Exception e) {
            request.setAttribute("mensajeError", e.getMessage());
            request.setAttribute("propiedad", propiedad);
            request.getRequestDispatcher("/cita_form.jsp").forward(request, response);
        }
    }

    private void listarCitasAgente(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        Usuario usuario = usuarioDeSesion(request);
        if (usuario == null || !(usuario.tieneRol("Inmobiliaria") || usuario.tieneRol("Administrador"))) {
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }

        // El Administrador no esta limitado a un agente: ve todas las citas del sistema.
        List<Cita> citas = usuario.tieneRol("Administrador")
                ? citaDAO.listarTodasLasCitas(getServletContext())
                : citaDAO.listarCitasPorAgente(getServletContext(), usuario.getId());

        request.setAttribute("citas", citas);
        request.setAttribute("tituloPagina", "Citas agendadas");
        request.getRequestDispatcher("/citas_agente.jsp").forward(request, response);
    }

    private void procesarCambioEstado(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Usuario usuario = usuarioDeSesion(request);
        if (usuario == null || !(usuario.tieneRol("Inmobiliaria") || usuario.tieneRol("Administrador"))) {
            response.sendRedirect(request.getContextPath() + "/denegado.jsp");
            return;
        }

        int idCita = parseIntOrCero(request.getParameter("id"));
        String nuevoEstado = request.getParameter("estado");

        if (!esEstadoValido(nuevoEstado)) {
            response.sendRedirect(request.getContextPath() + "/denegado.jsp");
            return;
        }

        citaDAO.actualizarEstadoCita(getServletContext(), idCita, nuevoEstado);
        auditoriaDAO.registrarAccion(getServletContext(), usuario.getId(), "CAMBIAR_ESTADO_CITA",
                "citas", idCita, "Nuevo estado: " + nuevoEstado);

        response.sendRedirect(request.getContextPath() + "/agente/citas");
    }

    private boolean esEstadoValido(String estado) {
        return "pendiente".equals(estado) || "aceptada".equals(estado)
                || "cancelada".equals(estado) || "completada".equals(estado);
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

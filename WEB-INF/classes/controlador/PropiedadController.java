package controlador;

import dao.AuditoriaDAO;
import dao.PropiedadDAO;
import modelo.Propiedad;
import modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * PropiedadController
 * --------------------
 * Atiende:
 *   /buscar                     (GET, publico)  -> lista con filtros
 *   /propiedad                  (GET, publico)  -> detalle de una propiedad (?id=)
 *   /favoritos/toggle           (POST, Cliente) -> agrega/quita de favoritos
 *   /agente/propiedades         (GET, Inmobiliaria o Administrador) -> "Mis propiedades" (Administrador ve todas)
 *   /agente/propiedades/nueva   (GET/POST, Inmobiliaria o Administrador) -> crear
 *   /agente/propiedades/editar  (GET/POST, Inmobiliaria o Administrador) -> editar (?id=)
 *   /agente/propiedades/baja    (POST, Inmobiliaria o Administrador) -> baja logica (?id=)
 *
 * Las rutas bajo /agente/* ya estan protegidas por AutorizacionFilter
 * (exige rol "Inmobiliaria" o "Administrador"), pero este controlador
 * vuelve a validar el rol y, ademas, que el agente sea dueño de la
 * propiedad que edita o da de baja (salvo que el usuario tenga rol
 * Administrador, que no queda limitado por el propietario/agente).
 */
public class PropiedadController extends HttpServlet {

    private final PropiedadDAO propiedadDAO = new PropiedadDAO();
    private final AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ruta = request.getServletPath();

        try {
            switch (ruta) {
                case "/buscar":
                    mostrarBusqueda(request, response);
                    break;
                case "/propiedad":
                    mostrarDetalle(request, response);
                    break;
                case "/agente/propiedades":
                    listarPropiedadesAgente(request, response);
                    break;
                case "/agente/propiedades/nueva":
                    mostrarFormularioNuevo(request, response);
                    break;
                case "/agente/propiedades/editar":
                    mostrarFormularioEditar(request, response);
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
                case "/favoritos/toggle":
                    procesarToggleFavorito(request, response);
                    break;
                case "/agente/propiedades/nueva":
                    procesarCrear(request, response);
                    break;
                case "/agente/propiedades/editar":
                    procesarEditar(request, response);
                    break;
                case "/agente/propiedades/baja":
                    procesarBaja(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } catch (Exception e) {
            request.setAttribute("mensajeError", "Ocurrio un error: " + e.getMessage());
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
        }
    }

    // ------------------------------------------------------------------
    // BUSQUEDA PUBLICA
    // ------------------------------------------------------------------
    private void mostrarBusqueda(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {

        String q = request.getParameter("q");
        String ciudadId = request.getParameter("ciudad");
        String tipoId = request.getParameter("tipo");
        String minPrecioStr = request.getParameter("minPrecio");
        String maxPrecioStr = request.getParameter("maxPrecio");

        Double minPrecio = parseDoubleOrNull(minPrecioStr);
        Double maxPrecio = parseDoubleOrNull(maxPrecioStr);

        List<Propiedad> resultados = propiedadDAO.listarPropiedades(
                getServletContext(), ciudadId, tipoId, minPrecio, maxPrecio, q, null);

        request.setAttribute("resultados", resultados);
        request.setAttribute("q", q);
        request.setAttribute("ciudades", propiedadDAO.listarCiudades(getServletContext()));
        request.setAttribute("tipos", propiedadDAO.listarTipos(getServletContext()));
        request.setAttribute("tituloPagina", "Buscar propiedades");

        request.getRequestDispatcher("/buscar.jsp").forward(request, response);
    }

    // ------------------------------------------------------------------
    // DETALLE PUBLICO
    // ------------------------------------------------------------------
    private void mostrarDetalle(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {

        int id = parseIntOrCero(request.getParameter("id"));
        Propiedad propiedad = propiedadDAO.obtenerPropiedadPorId(getServletContext(), id);

        if (propiedad == null) {
            request.setAttribute("mensajeError", "La propiedad solicitada no existe.");
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        Usuario usuarioSesion = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
        if (usuarioSesion != null && usuarioSesion.tieneRol("Cliente")) {
            boolean esFavorito = propiedadDAO.esFavorito(getServletContext(), usuarioSesion.getId(), id);
            request.setAttribute("esFavorito", esFavorito);
        }

        request.setAttribute("propiedad", propiedad);
        request.setAttribute("tituloPagina", propiedad.getTitulo());
        request.getRequestDispatcher("/detalle_propiedad.jsp").forward(request, response);
    }

    // ------------------------------------------------------------------
    // FAVORITOS (Cliente)
    // ------------------------------------------------------------------
    private void procesarToggleFavorito(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        Usuario usuarioSesion = usuarioDeSesion(request);
        int idPropiedad = parseIntOrCero(request.getParameter("idPropiedad"));

        if (usuarioSesion == null || !usuarioSesion.tieneRol("Cliente")) {
            response.sendRedirect(request.getContextPath() + "/denegado.jsp");
            return;
        }

        boolean marcarComoFavorito = "agregar".equals(request.getParameter("accion"));
        propiedadDAO.marcarFavorito(getServletContext(), usuarioSesion.getId(), idPropiedad, marcarComoFavorito);

        String volverA = request.getParameter("volverA");
        if (volverA == null || volverA.isEmpty()) {
            volverA = "/propiedad?id=" + idPropiedad;
        }
        response.sendRedirect(request.getContextPath() + volverA);
    }

    // ------------------------------------------------------------------
    // "MIS PROPIEDADES" (Agente)
    // ------------------------------------------------------------------
    private void listarPropiedadesAgente(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {

        Usuario usuarioSesion = usuarioDeSesion(request);
        if (usuarioSesion == null || !(usuarioSesion.tieneRol("Inmobiliaria") || usuarioSesion.tieneRol("Administrador"))) {
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }

        // El DAO no expone filtro por agente todavia, asi que filtramos en memoria.
        // Se combinan las propiedades visibles por defecto (no inactivas) con las
        // inactivas (dadas de baja), para que el agente vea el estado real de todo su catalogo.
        List<Propiedad> visibles = propiedadDAO.listarPropiedades(
                getServletContext(), null, null, null, null, null, null);
        List<Propiedad> inactivas = propiedadDAO.listarPropiedades(
                getServletContext(), null, null, null, null, null, "inactivo");

        // El Administrador no esta limitado al propietario/agente: ve y gestiona
        // el catalogo completo. La Inmobiliaria solo ve (y por lo tanto gestiona)
        // sus propias propiedades, tal como antes.
        boolean esAdministrador = usuarioSesion.tieneRol("Administrador");
        List<Propiedad> propias = new ArrayList<>();
        for (Propiedad p : visibles) {
            if (esAdministrador || p.getIdAgente() == usuarioSesion.getId()) {
                propias.add(p);
            }
        }
        for (Propiedad p : inactivas) {
            if (esAdministrador || p.getIdAgente() == usuarioSesion.getId()) {
                propias.add(p);
            }
        }

        request.setAttribute("propiedades", propias);
        request.setAttribute("tituloPagina", esAdministrador ? "Todas las propiedades" : "Mis propiedades");
        request.getRequestDispatcher("/agente_propiedades.jsp").forward(request, response);
    }

    // ------------------------------------------------------------------
    // CREAR
    // ------------------------------------------------------------------
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {

        cargarCatalogosFormulario(request);
        request.setAttribute("modoFormulario", "crear");
        request.setAttribute("tituloPagina", "Publicar propiedad");
        request.getRequestDispatcher("/formulario_propiedad.jsp").forward(request, response);
    }

    private void procesarCrear(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {

        Usuario usuarioSesion = usuarioDeSesion(request);
        if (usuarioSesion == null || !(usuarioSesion.tieneRol("Inmobiliaria") || usuarioSesion.tieneRol("Administrador"))) {
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }

        Propiedad p = leerPropiedadDelFormulario(request);
        p.setIdAgente(usuarioSesion.getId());

        String errorValidacion = validarPropiedad(p);
        if (errorValidacion != null) {
            request.setAttribute("mensajeError", errorValidacion);
            request.setAttribute("propiedad", p);
            cargarCatalogosFormulario(request);
            request.setAttribute("modoFormulario", "crear");
            request.getRequestDispatcher("/formulario_propiedad.jsp").forward(request, response);
            return;
        }

        List<String> imagenes = leerImagenesDelFormulario(request);
        String[] caracteristicasIds = request.getParameterValues("caracteristicas");

        try {
            propiedadDAO.crearPropiedad(getServletContext(), p, imagenes, caracteristicasIds);
            auditoriaDAO.registrarAccion(getServletContext(), usuarioSesion.getId(), "CREAR_PROPIEDAD",
                    "propiedades", p.getId(), "Propiedad creada: " + p.getTitulo());
            response.sendRedirect(request.getContextPath() + "/propiedad?id=" + p.getId());
        } catch (Exception e) {
            request.setAttribute("mensajeError", e.getMessage());
            request.setAttribute("propiedad", p);
            cargarCatalogosFormulario(request);
            request.setAttribute("modoFormulario", "crear");
            request.getRequestDispatcher("/formulario_propiedad.jsp").forward(request, response);
        }
    }

    // ------------------------------------------------------------------
    // EDITAR
    // ------------------------------------------------------------------
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {

        Usuario usuarioSesion = usuarioDeSesion(request);
        int id = parseIntOrCero(request.getParameter("id"));
        Propiedad p = propiedadDAO.obtenerPropiedadPorId(getServletContext(), id);

        if (p == null) {
            request.setAttribute("mensajeError", "La propiedad no existe.");
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }
        if (!puedeGestionar(usuarioSesion, p)) {
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }

        request.setAttribute("propiedad", p);
        cargarCatalogosFormulario(request);
        request.setAttribute("modoFormulario", "editar");
        request.setAttribute("tituloPagina", "Editar propiedad");
        request.getRequestDispatcher("/formulario_propiedad.jsp").forward(request, response);
    }

    private void procesarEditar(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {

        Usuario usuarioSesion = usuarioDeSesion(request);
        int id = parseIntOrCero(request.getParameter("id"));
        Propiedad existente = propiedadDAO.obtenerPropiedadPorId(getServletContext(), id);

        if (existente == null) {
            request.setAttribute("mensajeError", "La propiedad no existe.");
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }
        if (!puedeGestionar(usuarioSesion, existente)) {
            request.getRequestDispatcher("/denegado.jsp").forward(request, response);
            return;
        }

        Propiedad p = leerPropiedadDelFormulario(request);
        p.setId(id);
        p.setIdAgente(existente.getIdAgente());
        if (p.getEstado() == null || p.getEstado().trim().isEmpty()) {
            p.setEstado(existente.getEstado());
        }

        String errorValidacion = validarPropiedad(p);
        if (errorValidacion != null) {
            request.setAttribute("mensajeError", errorValidacion);
            request.setAttribute("propiedad", p);
            cargarCatalogosFormulario(request);
            request.setAttribute("modoFormulario", "editar");
            request.getRequestDispatcher("/formulario_propiedad.jsp").forward(request, response);
            return;
        }

        List<String> imagenes = leerImagenesDelFormulario(request);
        String[] caracteristicasIds = request.getParameterValues("caracteristicas");

        try {
            propiedadDAO.actualizarPropiedad(getServletContext(), p, imagenes, caracteristicasIds);
            auditoriaDAO.registrarAccion(getServletContext(), usuarioSesion.getId(), "EDITAR_PROPIEDAD",
                    "propiedades", id, "Propiedad actualizada: " + p.getTitulo());
            response.sendRedirect(request.getContextPath() + "/propiedad?id=" + id);
        } catch (Exception e) {
            request.setAttribute("mensajeError", e.getMessage());
            request.setAttribute("propiedad", p);
            cargarCatalogosFormulario(request);
            request.setAttribute("modoFormulario", "editar");
            request.getRequestDispatcher("/formulario_propiedad.jsp").forward(request, response);
        }
    }

    // ------------------------------------------------------------------
    // BAJA LOGICA
    // ------------------------------------------------------------------
    private void procesarBaja(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Usuario usuarioSesion = usuarioDeSesion(request);
        int id = parseIntOrCero(request.getParameter("id"));
        Propiedad existente = propiedadDAO.obtenerPropiedadPorId(getServletContext(), id);

        if (existente == null || !puedeGestionar(usuarioSesion, existente)) {
            response.sendRedirect(request.getContextPath() + "/denegado.jsp");
            return;
        }

        propiedadDAO.darBajaLogica(getServletContext(), id);
        auditoriaDAO.registrarAccion(getServletContext(), usuarioSesion.getId(), "BAJA_PROPIEDAD",
                "propiedades", id, "Propiedad dada de baja: " + existente.getTitulo());
        response.sendRedirect(request.getContextPath() + "/agente/propiedades");
    }

    // ------------------------------------------------------------------
    // Utilidades comunes
    // ------------------------------------------------------------------

    /** Un agente solo gestiona sus propias propiedades; el Administrador puede gestionar todas. */
    private boolean puedeGestionar(Usuario usuario, Propiedad propiedad) {
        if (usuario == null) return false;
        if (usuario.tieneRol("Administrador")) return true;
        return usuario.tieneRol("Inmobiliaria") && usuario.getId() == propiedad.getIdAgente();
    }

    private Usuario usuarioDeSesion(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (Usuario) session.getAttribute("usuario") : null;
    }

    private void cargarCatalogosFormulario(HttpServletRequest request) throws Exception {
        request.setAttribute("ciudades", propiedadDAO.listarCiudades(getServletContext()));
        request.setAttribute("tipos", propiedadDAO.listarTipos(getServletContext()));
        request.setAttribute("caracteristicasDisponibles", propiedadDAO.listarCaracteristicas(getServletContext()));
    }

    private Propiedad leerPropiedadDelFormulario(HttpServletRequest request) {
        Propiedad p = new Propiedad();
        p.setTitulo(trim(request.getParameter("titulo")));
        p.setDescripcion(trim(request.getParameter("descripcion")));
        p.setDireccion(trim(request.getParameter("direccion")));
        p.setMatriculaInmobiliaria(trim(request.getParameter("matriculaInmobiliaria")));
        p.setIdCiudad(parseIntOrCero(request.getParameter("idCiudad")));
        p.setIdTipo(parseIntOrCero(request.getParameter("idTipo")));
        p.setEstado(trim(request.getParameter("estado")));

        String precioStr = request.getParameter("precio");
        try {
            p.setPrecio(precioStr == null || precioStr.trim().isEmpty() ? -1 : Double.parseDouble(precioStr.trim()));
        } catch (NumberFormatException e) {
            p.setPrecio(-1);
        }
        return p;
    }

    private List<String> leerImagenesDelFormulario(HttpServletRequest request) {
        // Sprint 2: se reciben como URLs separadas por salto de linea (una por campo).
        // La carga de archivos binarios se puede incorporar despues con Apache Commons FileUpload.
        List<String> imagenes = new ArrayList<>();
        String bloque = request.getParameter("imagenesUrls");
        if (bloque != null && !bloque.trim().isEmpty()) {
            for (String linea : bloque.split("\\r?\\n")) {
                String limpia = linea.trim();
                if (!limpia.isEmpty()) {
                    imagenes.add(limpia);
                }
            }
        }
        return imagenes;
    }

    private String validarPropiedad(Propiedad p) {
        if (p.getTitulo() == null || p.getTitulo().isEmpty()) {
            return "El titulo es obligatorio.";
        }
        if (p.getDireccion() == null || p.getDireccion().isEmpty()) {
            return "La direccion es obligatoria.";
        }
        if (p.getMatriculaInmobiliaria() == null || p.getMatriculaInmobiliaria().isEmpty()) {
            return "La matricula inmobiliaria es obligatoria.";
        }
        if (p.getIdCiudad() <= 0) {
            return "Debes seleccionar una ciudad valida.";
        }
        if (p.getIdTipo() <= 0) {
            return "Debes seleccionar un tipo de inmueble valido.";
        }
        if (p.getPrecio() <= 0) {
            return "El precio debe ser un numero positivo mayor a cero.";
        }
        return null;
    }

    private Double parseDoubleOrNull(String valor) {
        if (valor == null || valor.trim().isEmpty()) return null;
        try {
            return Double.parseDouble(valor.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private int parseIntOrCero(String valor) {
        if (valor == null || valor.trim().isEmpty()) return 0;
        try {
            return Integer.parseInt(valor.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private String trim(String valor) {
        return valor == null ? "" : valor.trim();
    }
}

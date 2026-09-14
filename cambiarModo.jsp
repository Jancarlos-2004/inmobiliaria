<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="conexion.ConexionBD" %>
<%
    String mensajeError = null;
    String mensajeExito = null;

    String accion = request.getParameter("modo");
    if (accion != null) {
        try {
            ConexionBD.cambiarModo(application, accion);
            mensajeExito = "Modo de base de datos cambiado a '" + accion + "' correctamente.";
        } catch (Exception e) {
            mensajeError = "No se pudo cambiar el modo: " + e.getMessage();
        }
    }

    String modoActual = ConexionBD.obtenerModoActual(application);
    request.setAttribute("modoActual", modoActual);
    request.setAttribute("mensajeError", mensajeError);
    request.setAttribute("mensajeExito", mensajeExito);
    request.setAttribute("tituloPagina", "Cambiar base de datos");
%>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-centrada">
    <h1>Interruptor de base de datos</h1>
    <p class="subtitulo">
        Modo actual: <strong>${modoActual}</strong>
    </p>

    <%@ include file="views/mensajes.jspf" %>

    <div class="fila-botones">
        <form action="${pageContext.request.contextPath}/cambiarModo.jsp" method="get">
            <input type="hidden" name="modo" value="local">
            <button type="submit" class="boton-primario" ${modoActual == 'local' ? 'disabled' : ''}>
                Usar base de datos LOCAL
            </button>
        </form>
        <form action="${pageContext.request.contextPath}/cambiarModo.jsp" method="get">
            <input type="hidden" name="modo" value="remota">
            <button type="submit" class="boton-primario" ${modoActual == 'remota' ? 'disabled' : ''}>
                Usar base de datos REMOTA
            </button>
        </form>
    </div>
</section>

<%@ include file="views/footer.jspf" %>

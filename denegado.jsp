<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("tituloPagina", "Acceso denegado"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-centrada">
    <h1>Acceso denegado</h1>
    <p class="subtitulo">
        No tienes permisos para ver esta seccion, o tu sesion no es valida para este rol.
    </p>
    <a href="${pageContext.request.contextPath}/index.jsp" class="boton-primario">Volver al inicio</a>
</section>

<%@ include file="views/footer.jspf" %>

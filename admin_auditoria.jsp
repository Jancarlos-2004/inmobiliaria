<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% request.setAttribute("tituloPagina", "Auditoria del sistema"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-ancha">
    <h1>Auditoria del sistema</h1>
    <p class="subtitulo">Ultimos 100 eventos registrados &middot; mostrando ${fn:length(eventos)}.</p>

    <div class="tabla-responsive">
    <table class="tabla-simple tabla-auditoria">
        <thead>
        <tr><th>Fecha</th><th>Usuario</th><th>Accion</th><th>Tabla</th><th>Registro</th><th>Detalles</th></tr>
        </thead>
        <tbody>
        <c:forEach var="e" items="${eventos}">
            <tr>
                <td class="celda-fecha-tecnica"><fmt:formatDate value="${e.fechaHora}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                <td class="celda-usuario-auditoria">
                    <c:choose>
                        <c:when test="${empty e.usuarioCorreo}"><span class="etiqueta-visitante">(visitante)</span></c:when>
                        <c:otherwise>${e.usuarioCorreo}</c:otherwise>
                    </c:choose>
                </td>
                <td><span class="etiqueta-accion">${e.accion}</span></td>
                <td class="celda-fecha-tecnica">${e.tablaAfectada}</td>
                <td class="celda-fecha-tecnica">${e.registroId}</td>
                <td class="celda-detalle-auditoria">${e.detalles}</td>
            </tr>
        </c:forEach>
        <c:if test="${empty eventos}">
            <tr><td colspan="6" class="sin-resultados">No hay eventos de auditoria registrados todavia.</td></tr>
        </c:if>
        </tbody>
    </table>
    </div>
</section>

<%@ include file="views/footer.jspf" %>

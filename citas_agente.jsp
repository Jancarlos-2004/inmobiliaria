<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% request.setAttribute("tituloPagina", "Citas agendadas"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-ancha">
    <h1>Citas sobre mis propiedades</h1>

    <%@ include file="views/mensajes.jspf" %>

    <c:choose>
        <c:when test="${empty citas}">
            <p class="sin-resultados">No tienes citas agendadas todavia.</p>
        </c:when>
        <c:otherwise>
            <div class="tabla-responsive">
            <table class="tabla-simple">
                <thead>
                <tr><th>Propiedad</th><th>Cliente</th><th>Telefono</th><th>Fecha y hora</th><th>Estado</th><th>Acciones</th></tr>
                </thead>
                <tbody>
                <c:forEach var="c" items="${citas}">
                    <tr>
                        <td><a href="${pageContext.request.contextPath}/propiedad?id=${c.idPropiedad}">${c.propiedadTitulo}</a></td>
                        <td>${c.clienteNombre}</td>
                        <td>${c.clienteTelefono}</td>
                        <td><fmt:formatDate value="${c.fechaHora}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td><span class="etiqueta-estado etiqueta-${c.estado}">${c.estado}</span></td>
                        <td class="acciones-tabla">
                            <c:if test="${c.estado == 'pendiente'}">
                                <form action="${pageContext.request.contextPath}/agente/citas/estado" method="post" class="form-inline">
                                    <input type="hidden" name="id" value="${c.id}">
                                    <input type="hidden" name="estado" value="aceptada">
                                    <button type="submit" class="enlace-accion">Aceptar</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/agente/citas/estado" method="post" class="form-inline">
                                    <input type="hidden" name="id" value="${c.id}">
                                    <input type="hidden" name="estado" value="cancelada">
                                    <button type="submit" class="enlace-peligro">Cancelar</button>
                                </form>
                            </c:if>
                            <c:if test="${c.estado == 'aceptada'}">
                                <form action="${pageContext.request.contextPath}/agente/citas/estado" method="post" class="form-inline">
                                    <input type="hidden" name="id" value="${c.id}">
                                    <input type="hidden" name="estado" value="completada">
                                    <button type="submit" class="enlace-accion">Marcar completada</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<%@ include file="views/footer.jspf" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% request.setAttribute("tituloPagina", "Solicitudes recibidas"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-ancha">
    <h1>Solicitudes recibidas</h1>

    <%@ include file="views/mensajes.jspf" %>

    <c:choose>
        <c:when test="${empty solicitudes}">
            <p class="sin-resultados">No has recibido solicitudes todavia.</p>
        </c:when>
        <c:otherwise>
            <div class="tabla-responsive">
            <table class="tabla-simple">
                <thead>
                <tr><th>Propiedad</th><th>Cliente</th><th>Tipo</th><th>Documentos</th><th>Estado</th><th>Fecha</th><th>Acciones</th></tr>
                </thead>
                <tbody>
                <c:forEach var="s" items="${solicitudes}">
                    <tr>
                        <td><a href="${pageContext.request.contextPath}/propiedad?id=${s.idPropiedad}">${s.propiedadTitulo}</a></td>
                        <td>${s.clienteNombre}</td>
                        <td><span class="badge bg-light text-dark text-capitalize">${s.tipoSolicitud}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty s.documentos}">
                                    <div style="display:flex; flex-direction:column; gap:4px;">
                                    <c:forEach var="doc" items="${s.documentos}">
                                        <a href="${doc.rutaArchivo}" target="_blank" class="etiqueta-estado etiqueta-disponible" style="font-size:0.75rem; text-decoration:none; display:inline-block;" title="${doc.nombreArchivo}">
                                            📄 ${doc.tipoDocumento} (${doc.nombreArchivo})
                                        </a>
                                    </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <span style="font-size:0.8rem; color:#888;">Sin adjuntos</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><span class="etiqueta-estado etiqueta-${s.estado}">${s.estado}</span></td>
                        <td><fmt:formatDate value="${s.fechaSolicitud}" pattern="dd/MM/yyyy"/></td>
                        <td class="acciones-tabla">
                            <c:if test="${s.estado == 'pendiente'}">
                                <form action="${pageContext.request.contextPath}/agente/solicitudes/resolver" method="post" class="form-inline">
                                    <input type="hidden" name="id" value="${s.id}">
                                    <input type="hidden" name="decision" value="aprobada">
                                    <button type="submit" class="enlace-accion">Aprobar</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/agente/solicitudes/resolver" method="post" class="form-inline">
                                    <input type="hidden" name="id" value="${s.id}">
                                    <input type="hidden" name="decision" value="rechazada">
                                    <button type="submit" class="enlace-peligro">Rechazar</button>
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

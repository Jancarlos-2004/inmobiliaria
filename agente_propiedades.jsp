<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% request.setAttribute("tituloPagina", "Mis propiedades"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-ancha">
    <div class="cabecera-seccion">
        <h1>Mis propiedades</h1>
        <a class="boton-primario" href="${pageContext.request.contextPath}/agente/propiedades/nueva">+ Publicar nueva</a>
    </div>

    <c:choose>
        <c:when test="${empty propiedades}">
            <p class="sin-resultados">Aun no has publicado ninguna propiedad.</p>
        </c:when>
        <c:otherwise>
            <table class="tabla-simple">
                <thead>
                <tr>
                    <th>Titulo</th>
                    <th>Ciudad</th>
                    <th>Precio</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${propiedades}">
                    <tr>
                        <td><a href="${pageContext.request.contextPath}/propiedad?id=${p.id}">${p.titulo}</a></td>
                        <td>${p.ciudadNombre}</td>
                        <td><fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$"/></td>
                        <td><span class="etiqueta-estado etiqueta-${p.estado}">${p.estado}</span></td>
                        <td class="acciones-tabla">
                            <a href="${pageContext.request.contextPath}/agente/propiedades/editar?id=${p.id}">Editar</a>
                            <c:if test="${p.estado != 'inactivo'}">
                                <form action="${pageContext.request.contextPath}/agente/propiedades/baja" method="post"
                                      onsubmit="return confirm('¿Dar de baja esta propiedad?');" class="form-inline">
                                    <input type="hidden" name="id" value="${p.id}">
                                    <button type="submit" class="enlace-peligro">Dar de baja</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</section>

<%@ include file="views/footer.jspf" %>

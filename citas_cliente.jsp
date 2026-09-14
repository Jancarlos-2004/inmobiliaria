<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% request.setAttribute("tituloPagina", "Mis citas"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-ancha">
    <h1>Mis citas</h1>

    <%@ include file="views/mensajes.jspf" %>

    <c:choose>
        <c:when test="${empty citas}">
            <p class="sin-resultados">Aun no has agendado ninguna cita. Busca una propiedad y agenda una visita.</p>
        </c:when>
        <c:otherwise>
            <div class="grilla-registros">
                <c:forEach var="c" items="${citas}">
                    <div class="tarjeta-registro">
                        <div class="tarjeta-registro-cabecera">
                            <p class="tarjeta-registro-titulo">
                                <a href="${pageContext.request.contextPath}/propiedad?id=${c.idPropiedad}">${c.propiedadTitulo}</a>
                            </p>
                            <span class="etiqueta-estado etiqueta-${c.estado}">${c.estado}</span>
                        </div>

                        <div class="tarjeta-registro-datos">
                            <span class="tarjeta-registro-dato">
                                <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4"/><path d="M8 2v4"/><path d="M3 10h18"/></svg>
                                <fmt:formatDate value="${c.fechaHora}" pattern="dd/MM/yyyy"/>
                            </span>
                            <span class="tarjeta-registro-dato">
                                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 3"/></svg>
                                <fmt:formatDate value="${c.fechaHora}" pattern="HH:mm"/>
                            </span>
                        </div>

                        <c:if test="${not empty c.notas}">
                            <p class="tarjeta-registro-notas">"${c.notas}"</p>
                        </c:if>

                        <div class="tarjeta-registro-accion">
                            <a class="boton-secundario boton-pequeno" href="${pageContext.request.contextPath}/propiedad?id=${c.idPropiedad}">Ver propiedad</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<%@ include file="views/footer.jspf" %>

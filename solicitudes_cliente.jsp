<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% request.setAttribute("tituloPagina", "Mis solicitudes"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-ancha">
    <h1>Mis solicitudes</h1>

    <%@ include file="views/mensajes.jspf" %>

    <c:choose>
        <c:when test="${empty solicitudes}">
            <p class="sin-resultados">Aun no has radicado ninguna solicitud de compra o arriendo.</p>
        </c:when>
        <c:otherwise>
            <div class="grilla-registros">
                <c:forEach var="s" items="${solicitudes}">
                    <div class="tarjeta-registro">
                        <div class="tarjeta-registro-cabecera">
                            <p class="tarjeta-registro-titulo">
                                <a href="${pageContext.request.contextPath}/propiedad?id=${s.idPropiedad}">${s.propiedadTitulo}</a>
                            </p>
                            <span class="etiqueta-estado etiqueta-${s.estado}">${s.estado}</span>
                        </div>

                        <div class="tarjeta-registro-datos">
                            <span class="tarjeta-registro-dato">
                                <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4"/><path d="M8 2v4"/><path d="M3 10h18"/></svg>
                                <fmt:formatDate value="${s.fechaSolicitud}" pattern="dd/MM/yyyy"/>
                            </span>
                        </div>

                        <div class="tarjeta-registro-detalle">
                            <span>Tipo: <strong>${s.tipoSolicitud}</strong></span>
                            <span>Precio: <strong><fmt:formatNumber value="${s.propiedadPrecio}" type="currency" currencySymbol="$"/></strong></span>
                        </div>

                        <c:if test="${not empty s.documentos}">
                            <div style="margin-top:8px; padding-top:8px; border-top:1px dashed #e1e5ea; font-size:0.8rem;">
                                <span style="font-weight:600; color:#5b6675; display:block; margin-bottom:4px;">Documentos radicados:</span>
                                <div style="display:flex; flex-wrap:wrap; gap:4px;">
                                    <c:forEach var="doc" items="${s.documentos}">
                                        <a href="${doc.rutaArchivo}" target="_blank" class="etiqueta-estado etiqueta-disponible" style="font-size:0.75rem; text-decoration:none;" title="${doc.nombreArchivo}">
                                            📄 ${doc.tipoDocumento}
                                        </a>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <div class="tarjeta-registro-accion" style="margin-top:12px;">
                            <a class="boton-secundario boton-pequeno" href="${pageContext.request.contextPath}/propiedad?id=${s.idPropiedad}">Ver propiedad</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<%@ include file="views/footer.jspf" %>

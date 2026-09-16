<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% request.setAttribute("tituloPagina", ((modelo.Propiedad) request.getAttribute("propiedad")).getTitulo()); %>
<%@ include file="views/header.jspf" %>

<%-- Bandera puramente visual: ¿la propiedad tiene "Parqueadero" entre sus
     caracteristicas ya cargadas? No se agrega ninguna consulta nueva ni
     campo nuevo; solo se recorre la lista que el DAO ya entrega. --%>
<c:set var="tieneParqueadero" value="false"/>
<c:forEach var="carac" items="${propiedad.caracteristicas}">
    <c:if test="${carac eq 'Parqueadero'}"><c:set var="tieneParqueadero" value="true"/></c:if>
</c:forEach>

<section class="detalle-propiedad">
    <div class="detalle-contenido">

        <div class="galeria">
            <c:choose>
                <c:when test="${empty propiedad.imagenes}">
                    <div class="sin-imagen">
                        <svg viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="9" cy="10" r="1.6"/><path d="M21 16l-5.5-5.5L9 17"/></svg>
                        Imagen no disponible
                    </div>
                </c:when>
                <c:otherwise>
                    <c:set var="primeraImg" value="${propiedad.imagenes[0]}"/>
                    <div class="galeria-principal">
                        <c:choose>
                            <c:when test="${primeraImg.startsWith('http')}">
                                <img src="${primeraImg}" alt="${propiedad.titulo}" class="galeria-imagen-principal">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/${primeraImg}" alt="${propiedad.titulo}" class="galeria-imagen-principal">
                            </c:otherwise>
                        </c:choose>

                        <button type="button" class="galeria-ampliar" aria-label="Ver imagen en grande">
                            <svg viewBox="0 0 24 24"><path d="M9 3H5a2 2 0 00-2 2v4M15 3h4a2 2 0 012 2v4M9 21H5a2 2 0 01-2-2v-4M15 21h4a2 2 0 002-2v-4"/></svg>
                        </button>

                        <c:if test="${fn:length(propiedad.imagenes) > 1}">
                            <span class="galeria-contador">
                                <span class="galeria-contador-actual">1</span> / <span class="galeria-contador-total">${fn:length(propiedad.imagenes)}</span>
                            </span>
                        </c:if>
                    </div>

                    <c:if test="${fn:length(propiedad.imagenes) > 1}">
                        <div class="galeria-miniaturas">
                            <c:forEach var="img" items="${propiedad.imagenes}" varStatus="st">
                                <button type="button" class="galeria-miniatura ${st.first ? 'activa' : ''}" aria-label="Ver foto ${st.count}">
                                    <c:choose>
                                        <c:when test="${img.startsWith('http')}">
                                            <img src="${img}" alt="${propiedad.titulo} - foto ${st.count}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/${img}" alt="${propiedad.titulo} - foto ${st.count}">
                                        </c:otherwise>
                                    </c:choose>
                                </button>
                            </c:forEach>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="detalle-info">
            <div class="detalle-info-badges">
                <span class="etiqueta-estado etiqueta-${propiedad.estado}">${propiedad.estado}</span>
                <span class="etiqueta-tipo-destacada etiqueta-tipo-detalle">${propiedad.tipoNombre}</span>
            </div>

            <h1>${propiedad.titulo}</h1>
            <p class="ubicacion">
                <svg viewBox="0 0 24 24"><path d="M12 21s7-6.2 7-12a7 7 0 10-14 0c0 5.8 7 12 7 12z"/><circle cx="12" cy="9" r="2.4"/></svg>
                ${propiedad.direccion}, ${propiedad.ciudadNombre}
            </p>

            <p class="precio-grande"><fmt:formatNumber value="${propiedad.precio}" type="currency" currencySymbol="$"/></p>

            <div class="detalle-stats">
                <div class="detalle-stat">
                    <svg viewBox="0 0 24 24"><path d="M3 11l9-7 9 7"/><path d="M5 10v10h14V10"/></svg>
                    <div>
                        <span class="detalle-stat-valor">${propiedad.tipoNombre}</span>
                        <span class="detalle-stat-etiqueta">Tipo</span>
                    </div>
                </div>
                <c:if test="${tieneParqueadero}">
                    <div class="detalle-stat">
                        <svg viewBox="0 0 24 24"><path d="M5 17V8a2 2 0 012-2h7.5a4.5 4.5 0 010 9H8"/><circle cx="8" cy="17" r="1.6"/><circle cx="16" cy="17" r="1.6"/></svg>
                        <div>
                            <span class="detalle-stat-valor">Sí</span>
                            <span class="detalle-stat-etiqueta">Parqueadero</span>
                        </div>
                    </div>
                </c:if>
                <div class="detalle-stat">
                    <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                    <div>
                        <span class="detalle-stat-valor">${propiedad.estado}</span>
                        <span class="detalle-stat-etiqueta">Estado</span>
                    </div>
                </div>
            </div>

            <h3>Descripción</h3>
            <p>${propiedad.descripcion}</p>

            <h3>Características</h3>
            <c:choose>
                <c:when test="${empty propiedad.caracteristicas}">
                    <p class="texto-muted">Sin caracteristicas registradas.</p>
                </c:when>
                <c:otherwise>
                    <ul class="lista-caracteristicas">
                        <c:forEach var="c" items="${propiedad.caracteristicas}">
                            <li>${c}</li>
                        </c:forEach>
                    </ul>
                </c:otherwise>
            </c:choose>

            <h3>Ubicación</h3>
            <p class="detalle-ubicacion-texto">
                <svg viewBox="0 0 24 24"><path d="M12 21s7-6.2 7-12a7 7 0 10-14 0c0 5.8 7 12 7 12z"/><circle cx="12" cy="9" r="2.4"/></svg>
                ${propiedad.direccion}, ${propiedad.ciudadNombre}
            </p>
        </div>
    </div>

    <aside class="detalle-lateral">
        <div class="tarjeta-contacto">
            <p class="tarjeta-contacto-precio"><fmt:formatNumber value="${propiedad.precio}" type="currency" currencySymbol="$"/></p>
            <span class="etiqueta-estado etiqueta-${propiedad.estado}">${propiedad.estado}</span>

            <h3>Datos de contacto</h3>
            <p class="tarjeta-contacto-agente">
                <svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="3.6"/><path d="M4.5 20a7.5 7.5 0 0115 0"/></svg>
                Agente: ${propiedad.agenteNombre}
                <c:if test="${not empty sessionScope.usuario}"> — ${sessionScope.usuario.correo}</c:if>
                <c:if test="${empty sessionScope.usuario}">
                    (inicia sesion para ver el correo de contacto)
                </c:if>
            </p>
            <p class="texto-muted">Matricula inmobiliaria: ${propiedad.matriculaInmobiliaria}</p>

            <div class="acciones-detalle">
                <c:if test="${not empty sessionScope.usuario and sessionScope.usuario.tieneRol('Cliente')}">
                    <form action="${pageContext.request.contextPath}/favoritos/toggle" method="post">
                        <input type="hidden" name="idPropiedad" value="${propiedad.id}">
                        <input type="hidden" name="volverA" value="/propiedad?id=${propiedad.id}">
                        <c:choose>
                            <c:when test="${esFavorito}">
                                <input type="hidden" name="accion" value="quitar">
                                <button type="submit" class="boton-secundario">Quitar de favoritos</button>
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="accion" value="agregar">
                                <button type="submit" class="boton-secundario">Agregar a favoritos</button>
                            </c:otherwise>
                        </c:choose>
                    </form>
                    <a class="boton-primario" href="${pageContext.request.contextPath}/cliente/citas/nueva?idPropiedad=${propiedad.id}">Agendar cita</a>
                    <a class="boton-secundario" href="${pageContext.request.contextPath}/cliente/solicitudes/nueva?idPropiedad=${propiedad.id}">Radicar solicitud</a>
                </c:if>

                <c:if test="${not empty sessionScope.usuario and
                              (sessionScope.usuario.tieneRol('Administrador') or
                               (sessionScope.usuario.tieneRol('Inmobiliaria') and sessionScope.usuario.id == propiedad.idAgente))}">
                    <a class="boton-primario" href="${pageContext.request.contextPath}/agente/propiedades/editar?id=${propiedad.id}">Editar</a>
                    <form action="${pageContext.request.contextPath}/agente/propiedades/baja" method="post"
                          onsubmit="return confirm('¿Dar de baja esta propiedad? No se eliminara, solo pasara a estado inactivo.');">
                        <input type="hidden" name="id" value="${propiedad.id}">
                        <button type="submit" class="boton-peligro">Dar de baja</button>
                    </form>
                </c:if>

                <c:if test="${empty sessionScope.usuario}">
                    <p class="texto-muted">
                        <a href="${pageContext.request.contextPath}/login.jsp">Inicia sesión</a> para agendar una cita o guardar esta propiedad.
                    </p>
                </c:if>
            </div>
        </div>
    </aside>
</section>

<%@ include file="views/footer.jspf" %>

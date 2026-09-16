<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% request.setAttribute("tituloPagina", "Buscar propiedades"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-ancha tarjeta-filtros">
    <div class="panel-filtros-encabezado">
        <svg viewBox="0 0 24 24"><path d="M4 6h16M7 12h10M10 18h4"/></svg>
        <h1>Buscar propiedades</h1>
    </div>
    <p class="subtitulo">Filtra el catálogo por ciudad, tipo de propiedad, precio o palabra clave.</p>

    <form action="${pageContext.request.contextPath}/buscar" method="get" class="formulario-filtros">
        <div class="campo-filtro campo-filtro-ancha">
            <label for="f-q">Palabra clave</label>
            <div class="input-con-icono">
                <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="M21 21l-4.3-4.3"/></svg>
                <input type="text" id="f-q" name="q" placeholder="Título, dirección, descripción..." value="${q}">
            </div>
        </div>

        <div class="campo-filtro">
            <label for="f-ciudad">Ciudad / sector</label>
            <select id="f-ciudad" name="ciudad">
                <option value="">Todas las ciudades</option>
                <c:forEach var="c" items="${ciudades}">
                    <option value="${c.id}" ${param.ciudad == c.id ? 'selected' : ''}>${c.nombre}</option>
                </c:forEach>
            </select>
        </div>

        <div class="campo-filtro">
            <label for="f-tipo">Tipo de propiedad</label>
            <select id="f-tipo" name="tipo">
                <option value="">Todos los tipos</option>
                <c:forEach var="t" items="${tipos}">
                    <option value="${t.id}" ${param.tipo == t.id ? 'selected' : ''}>${t.nombre}</option>
                </c:forEach>
            </select>
        </div>

        <div class="campo-filtro">
            <label for="f-min">Precio mínimo</label>
            <input type="number" id="f-min" name="minPrecio" placeholder="$ Mínimo" value="${param.minPrecio}">
        </div>

        <div class="campo-filtro">
            <label for="f-max">Precio máximo</label>
            <input type="number" id="f-max" name="maxPrecio" placeholder="$ Máximo" value="${param.maxPrecio}">
        </div>

        <div class="campo-filtro campo-filtro-ancha campo-filtro-acciones">
            <button type="submit" class="boton-primario">Filtrar</button>
            <a href="${pageContext.request.contextPath}/buscar" class="enlace-limpiar-filtros">
                <svg viewBox="0 0 24 24"><path d="M6 6l12 12M18 6L6 18"/></svg>
                Limpiar filtros
            </a>
        </div>
    </form>
</section>

<div class="resultados-encabezado">
    <h2>Propiedades disponibles</h2>
    <p class="resultados-contador">
        <c:choose>
            <c:when test="${fn:length(resultados) == 1}">1 propiedad encontrada</c:when>
            <c:otherwise>${fn:length(resultados)} propiedades encontradas</c:otherwise>
        </c:choose>
    </p>
</div>

<section class="grilla-propiedades">
    <c:choose>
        <c:when test="${empty resultados}">
            <p class="sin-resultados">No se encontraron propiedades con esos criterios.</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="p" items="${resultados}">
                <a class="tarjeta-propiedad" href="${pageContext.request.contextPath}/propiedad?id=${p.id}">
                    <div class="tarjeta-propiedad-galeria">
                        <c:choose>
                            <c:when test="${empty p.imagenes}">
                                <div class="sin-imagen">
                                    <svg viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="9" cy="10" r="1.6"/><path d="M21 16l-5.5-5.5L9 17"/></svg>
                                    Imagen no disponible
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:set var="img" value="${p.imagenes[0]}"/>
                                <c:choose><c:when test="${img.startsWith('http')}"><img src="${img}" alt="${p.titulo}"></c:when><c:otherwise><img src="${pageContext.request.contextPath}/${img}" alt="${p.titulo}"></c:otherwise></c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="tarjeta-propiedad-info">
                        <span class="etiqueta-estado etiqueta-${p.estado}">${p.estado}</span>
                        <span class="etiqueta-tipo-destacada">${p.tipoNombre}</span>

                        <p class="precio"><fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$"/></p>
                        <p class="subtitulo-tarjeta">${p.tipoNombre} · ${p.estado}</p>

                        <h3>${p.titulo}</h3>
                        <p class="ubicacion">
                            <svg viewBox="0 0 24 24"><path d="M12 21s7-6.2 7-12a7 7 0 10-14 0c0 5.8 7 12 7 12z"/><circle cx="12" cy="9" r="2.4"/></svg>
                            ${p.ciudadNombre} · ${p.direccion}
                        </p>

                        <span class="tarjeta-propiedad-cta">
                            Ver propiedad
                            <svg viewBox="0 0 24 24"><path d="M9 6l6 6-6 6"/></svg>
                        </span>
                    </div>
                </a>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</section>

<%@ include file="views/footer.jspf" %>

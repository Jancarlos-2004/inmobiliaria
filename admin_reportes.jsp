<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% request.setAttribute("tituloPagina", "Reportes"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-ancha">
    <h1>Reportes</h1>
    <p class="subtitulo">Las 5 consultas SQL obligatorias del proyecto, en formato visual.</p>

    <c:set var="valorTotalCiudades" value="${0}"/>
    <c:forEach var="fila" items="${inmueblesPorCiudad}">
        <c:set var="valorTotalCiudades" value="${valorTotalCiudades + fila.valor_acumulado}"/>
    </c:forEach>

    <div class="tarjetas-estadisticas">
        <div class="tarjeta-estadistica">
            <span class="tarjeta-estadistica-icono">
                <svg viewBox="0 0 24 24"><path d="M3 21h18"/><path d="M5 21V7l7-4 7 4v14"/><path d="M9 21v-6h6v6"/></svg>
            </span>
            <div>
                <p class="tarjeta-estadistica-valor">${fn:length(propiedadesDetalladas)}</p>
                <p class="tarjeta-estadistica-etiqueta">Propiedades detalladas</p>
            </div>
        </div>
        <div class="tarjeta-estadistica">
            <span class="tarjeta-estadistica-icono">
                <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4"/><path d="M8 2v4"/><path d="M3 10h18"/></svg>
            </span>
            <div>
                <p class="tarjeta-estadistica-valor">${fn:length(detalleCitas)}</p>
                <p class="tarjeta-estadistica-etiqueta">Citas registradas</p>
            </div>
        </div>
        <div class="tarjeta-estadistica">
            <span class="tarjeta-estadistica-icono">
                <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
            </span>
            <div>
                <p class="tarjeta-estadistica-valor">${fn:length(propiedadesSinCitas)}</p>
                <p class="tarjeta-estadistica-etiqueta">Propiedades sin citas</p>
            </div>
        </div>
        <div class="tarjeta-estadistica">
            <span class="tarjeta-estadistica-icono">
                <svg viewBox="0 0 24 24"><path d="M12 21s-7-4.5-9.5-9A5.5 5.5 0 0 1 12 6a5.5 5.5 0 0 1 9.5 6c-2.5 4.5-9.5 9-9.5 9z"/></svg>
            </span>
            <div>
                <p class="tarjeta-estadistica-valor">${fn:length(inmueblesPorCiudad)}</p>
                <p class="tarjeta-estadistica-etiqueta">Ciudades con inventario relevante</p>
            </div>
        </div>
        <div class="tarjeta-estadistica">
            <span class="tarjeta-estadistica-icono">
                <svg viewBox="0 0 24 24"><path d="M12 1v22"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
            </span>
            <div>
                <p class="tarjeta-estadistica-valor"><fmt:formatNumber value="${valorTotalCiudades}" type="currency" currencySymbol="$"/></p>
                <p class="tarjeta-estadistica-etiqueta">Valor acumulado (ciudades listadas)</p>
            </div>
        </div>
    </div>

    <h2>1. Propiedades detalladas (INNER JOIN x3)</h2>
    <div class="tabla-responsive">
    <table class="tabla-simple">
        <thead><tr><th>ID</th><th>Titulo</th><th>Precio</th><th>Ciudad</th><th>Tipo</th><th>Agente</th></tr></thead>
        <tbody>
        <c:forEach var="fila" items="${propiedadesDetalladas}">
            <tr>
                <td>${fila.id}</td>
                <td>${fila.titulo}</td>
                <td class="celda-numerica"><fmt:formatNumber value="${fila.precio}" type="currency" currencySymbol="$"/></td>
                <td>${fila.ciudad}</td>
                <td>${fila.tipo}</td>
                <td>${fila.agente_correo}</td>
            </tr>
        </c:forEach>
        <c:if test="${empty propiedadesDetalladas}">
            <tr><td colspan="6" class="sin-resultados">Sin propiedades para mostrar.</td></tr>
        </c:if>
        </tbody>
    </table>
    </div>

    <h2>2. Detalle de citas (INNER JOIN x3)</h2>
    <div class="tabla-responsive">
    <table class="tabla-simple">
        <thead><tr><th>ID</th><th>Fecha</th><th>Estado</th><th>Propiedad</th><th>Cliente</th><th>Agente</th></tr></thead>
        <tbody>
        <c:forEach var="fila" items="${detalleCitas}">
            <tr>
                <td>${fila.id}</td>
                <td class="celda-fecha-tecnica"><fmt:formatDate value="${fila.fecha_hora}" pattern="dd/MM/yyyy HH:mm"/></td>
                <td><span class="etiqueta-estado etiqueta-${fila.estado}">${fila.estado}</span></td>
                <td>${fila.propiedad_titulo}</td>
                <td>${fila.cliente_nombre}</td>
                <td>${fila.agente_nombre}</td>
            </tr>
        </c:forEach>
        <c:if test="${empty detalleCitas}">
            <tr><td colspan="6" class="sin-resultados">Sin citas para mostrar.</td></tr>
        </c:if>
        </tbody>
    </table>
    </div>

    <h2>3. Caracteristicas por propiedad (Muchos a Muchos)</h2>
    <form action="${pageContext.request.contextPath}/${sessionScope.usuario.tieneRol('Administrador') ? 'admin' : 'agente'}/reportes"
          method="get" class="formulario-filtros">
        <input type="number" name="idPropiedad" placeholder="ID de la propiedad" value="${idPropiedadConsultada}" min="1" required>
        <button type="submit" class="boton-primario">Consultar</button>
    </form>
    <c:if test="${not empty idPropiedadConsultada}">
        <div class="tabla-responsive">
        <table class="tabla-simple">
            <thead><tr><th>Propiedad</th><th>Caracteristica</th></tr></thead>
            <tbody>
            <c:forEach var="fila" items="${caracteristicasPropiedad}">
                <tr><td>${fila.titulo}</td><td>${fila.caracteristica}</td></tr>
            </c:forEach>
            <c:if test="${empty caracteristicasPropiedad}">
                <tr><td colspan="2" class="sin-resultados">Sin caracteristicas para esa propiedad.</td></tr>
            </c:if>
            </tbody>
        </table>
        </div>
    </c:if>

    <h2>4. Propiedades sin citas agendadas (LEFT JOIN)</h2>
    <div class="tabla-responsive">
    <table class="tabla-simple">
        <thead><tr><th>ID</th><th>Titulo</th><th>Precio</th><th>Matricula</th></tr></thead>
        <tbody>
        <c:forEach var="fila" items="${propiedadesSinCitas}">
            <tr>
                <td>${fila.id}</td>
                <td>${fila.titulo}</td>
                <td class="celda-numerica"><fmt:formatNumber value="${fila.precio}" type="currency" currencySymbol="$"/></td>
                <td>${fila.matricula_inmobiliaria}</td>
            </tr>
        </c:forEach>
        <c:if test="${empty propiedadesSinCitas}">
            <tr><td colspan="4" class="sin-resultados">Todas las propiedades tienen al menos una cita.</td></tr>
        </c:if>
        </tbody>
    </table>
    </div>

    <h2>5. Inmuebles por ciudad (GROUP BY / HAVING)</h2>
    <div class="tabla-responsive">
    <table class="tabla-simple">
        <thead><tr><th>Ciudad</th><th>Total propiedades</th><th>Valor acumulado</th></tr></thead>
        <tbody>
        <c:forEach var="fila" items="${inmueblesPorCiudad}">
            <tr>
                <td>${fila.ciudad}</td>
                <td class="celda-numerica">${fila.total_propiedades}</td>
                <td class="celda-numerica"><fmt:formatNumber value="${fila.valor_acumulado}" type="currency" currencySymbol="$"/></td>
            </tr>
        </c:forEach>
        <c:if test="${empty inmueblesPorCiudad}">
            <tr><td colspan="3" class="sin-resultados">Ninguna ciudad supera 2 propiedades disponibles todavia.</td></tr>
        </c:if>
        </tbody>
    </table>
    </div>
</section>

<%@ include file="views/footer.jspf" %>

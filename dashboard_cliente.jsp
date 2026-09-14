<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("tituloPagina", "Panel del cliente"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-ancha tarjeta-ancha-panel">
    <div class="panel-encabezado">
        <h1>Bienvenido, ${sessionScope.usuario.perfil.nombres}</h1>
        <p class="subtitulo">Este es tu panel de Cliente.</p>
    </div>

    <div class="panel-accesos">
        <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/buscar">
            <span class="tarjeta-acceso-icono">
                <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
            </span>
            <span class="tarjeta-acceso-texto">
                <p class="tarjeta-acceso-titulo">Buscar propiedades</p>
                <p class="tarjeta-acceso-desc">Explora el catalogo de inmuebles disponibles.</p>
            </span>
            <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
        </a>

        <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/cliente/solicitudes">
            <span class="tarjeta-acceso-icono">
                <svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
            </span>
            <span class="tarjeta-acceso-texto">
                <p class="tarjeta-acceso-titulo">Mis solicitudes</p>
                <p class="tarjeta-acceso-desc">Seguimiento de tus solicitudes de compra o arriendo.</p>
            </span>
            <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
        </a>

        <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/cliente/citas">
            <span class="tarjeta-acceso-icono">
                <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4"/><path d="M8 2v4"/><path d="M3 10h18"/></svg>
            </span>
            <span class="tarjeta-acceso-texto">
                <p class="tarjeta-acceso-titulo">Mis citas</p>
                <p class="tarjeta-acceso-desc">Consulta tus visitas agendadas a propiedades.</p>
            </span>
            <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
        </a>

        <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/perfil">
            <span class="tarjeta-acceso-icono">
                <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            </span>
            <span class="tarjeta-acceso-texto">
                <p class="tarjeta-acceso-titulo">Mi perfil</p>
                <p class="tarjeta-acceso-desc">Edita tus datos personales de contacto.</p>
            </span>
            <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
        </a>

        <div class="tarjeta-acceso tarjeta-acceso-pendiente">
            <span class="tarjeta-acceso-icono">
                <svg viewBox="0 0 24 24"><path d="M20.8 4.6a5.5 5.5 0 0 0-7.8 0L12 5.6l-1-1a5.5 5.5 0 0 0-7.8 7.8l1 1L12 21l7.8-7.6 1-1a5.5 5.5 0 0 0 0-7.8z"/></svg>
            </span>
            <span class="tarjeta-acceso-texto">
                <p class="tarjeta-acceso-titulo">Mis favoritos</p>
                <p class="tarjeta-acceso-desc">Guarda las propiedades que mas te interesan.</p>
                <span class="etiqueta-pronto">Proximamente</span>
            </span>
        </div>
    </div>
</section>

<%@ include file="views/footer.jspf" %>

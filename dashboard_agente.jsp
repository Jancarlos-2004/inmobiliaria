<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("tituloPagina", "Panel del agente"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-ancha tarjeta-ancha-panel">
    <div class="panel-encabezado">
        <h1>Bienvenido, ${sessionScope.usuario.perfil.nombres}</h1>
        <p class="subtitulo">Este es tu panel de Agente Inmobiliario.</p>
    </div>

    <div class="panel-grupo">
        <h2 class="panel-grupo-titulo">Propiedades</h2>
        <div class="panel-accesos">
            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/agente/propiedades/nueva">
                <span class="tarjeta-acceso-icono">
                    <svg viewBox="0 0 24 24"><path d="M3 10.5 12 3l9 7.5"/><path d="M5 9.5V21h14V9.5"/><path d="M12 12v6"/><path d="M9 15h6"/></svg>
                </span>
                <span class="tarjeta-acceso-texto">
                    <p class="tarjeta-acceso-titulo">Nueva propiedad</p>
                    <p class="tarjeta-acceso-desc">Publica un nuevo inmueble en el catalogo.</p>
                </span>
                <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
            </a>

            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/agente/propiedades">
                <span class="tarjeta-acceso-icono">
                    <svg viewBox="0 0 24 24"><path d="M3 21h18"/><path d="M5 21V7l7-4 7 4v14"/><path d="M9 21v-6h6v6"/><path d="M9 11h.01"/><path d="M14 11h.01"/></svg>
                </span>
                <span class="tarjeta-acceso-texto">
                    <p class="tarjeta-acceso-titulo">Mis propiedades</p>
                    <p class="tarjeta-acceso-desc">Consulta y administra tus propiedades publicadas.</p>
                </span>
                <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
            </a>
        </div>
    </div>

    <div class="panel-grupo">
        <h2 class="panel-grupo-titulo">Actividad</h2>
        <div class="panel-accesos">
            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/agente/citas">
                <span class="tarjeta-acceso-icono">
                    <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4"/><path d="M8 2v4"/><path d="M3 10h18"/></svg>
                </span>
                <span class="tarjeta-acceso-texto">
                    <p class="tarjeta-acceso-titulo">Citas</p>
                    <p class="tarjeta-acceso-desc">Citas agendadas sobre tus inmuebles.</p>
                </span>
                <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
            </a>

            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/agente/solicitudes">
                <span class="tarjeta-acceso-icono">
                    <svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                </span>
                <span class="tarjeta-acceso-texto">
                    <p class="tarjeta-acceso-titulo">Solicitudes</p>
                    <p class="tarjeta-acceso-desc">Recibidas para aprobar o rechazar.</p>
                </span>
                <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
            </a>

            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/agente/reportes">
                <span class="tarjeta-acceso-icono">
                    <svg viewBox="0 0 24 24"><path d="M3 3v18h18"/><path d="M7 15v3"/><path d="M12 10v8"/><path d="M17 6v12"/></svg>
                </span>
                <span class="tarjeta-acceso-texto">
                    <p class="tarjeta-acceso-titulo">Reportes</p>
                    <p class="tarjeta-acceso-desc">Indicadores sobre tu actividad como agente.</p>
                </span>
                <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
            </a>
        </div>
    </div>

    <div class="panel-grupo">
        <h2 class="panel-grupo-titulo">Cuenta</h2>
        <div class="panel-accesos">
            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/perfil">
                <span class="tarjeta-acceso-icono">
                    <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/><path d="M16.5 3.5 19 6l-4.5 4.5-2-2z"/></svg>
                </span>
                <span class="tarjeta-acceso-texto">
                    <p class="tarjeta-acceso-titulo">Mi perfil</p>
                    <p class="tarjeta-acceso-desc">Edita tus datos personales de agente.</p>
                </span>
                <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
            </a>
        </div>
    </div>
</section>

<%@ include file="views/footer.jspf" %>

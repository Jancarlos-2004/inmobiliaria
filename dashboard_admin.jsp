<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("tituloPagina", "Panel del administrador"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-ancha tarjeta-ancha-panel">
    <div class="panel-encabezado">
        <h1>Bienvenido, ${sessionScope.usuario.perfil.nombres}</h1>
        <p class="subtitulo">Este es tu panel de Administrador.</p>
    </div>

    <div class="panel-grupo">
        <h2 class="panel-grupo-titulo">Gestion</h2>
        <div class="panel-accesos">
            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/admin/usuarios">
                <span class="tarjeta-acceso-icono">
                    <svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H7a4 4 0 0 0-4 4v2"/><circle cx="10" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                </span>
                <span class="tarjeta-acceso-texto">
                    <p class="tarjeta-acceso-titulo">Usuarios</p>
                    <p class="tarjeta-acceso-desc">Gestion de usuarios y roles del sistema.</p>
                </span>
                <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
            </a>

            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/agente/propiedades">
                <span class="tarjeta-acceso-icono">
                    <svg viewBox="0 0 24 24"><path d="M3 10.5 12 3l9 7.5"/><path d="M5 9.5V21h14V9.5"/><path d="M9 21v-6h6v6"/></svg>
                </span>
                <span class="tarjeta-acceso-texto">
                    <p class="tarjeta-acceso-titulo">Propiedades</p>
                    <p class="tarjeta-acceso-desc">Ver y gestionar el catalogo completo de propiedades, de cualquier inmobiliaria.</p>
                </span>
                <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
            </a>

            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/agente/citas">
                <span class="tarjeta-acceso-icono">
                    <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4"/><path d="M8 2v4"/><path d="M3 10h18"/></svg>
                </span>
                <span class="tarjeta-acceso-texto">
                    <p class="tarjeta-acceso-titulo">Citas</p>
                    <p class="tarjeta-acceso-desc">Gestiona las citas agendadas sobre cualquier propiedad.</p>
                </span>
                <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
            </a>

            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/agente/solicitudes">
                <span class="tarjeta-acceso-icono">
                    <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6"/></svg>
                </span>
                <span class="tarjeta-acceso-texto">
                    <p class="tarjeta-acceso-titulo">Solicitudes</p>
                    <p class="tarjeta-acceso-desc">Aprueba o rechaza solicitudes de compra/arriendo de cualquier agente.</p>
                </span>
                <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
            </a>
        </div>
    </div>

    <div class="panel-grupo">
        <h2 class="panel-grupo-titulo">Supervision</h2>
        <div class="panel-accesos">
            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/admin/auditoria">
                <span class="tarjeta-acceso-icono">
                    <svg viewBox="0 0 24 24"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                </span>
                <span class="tarjeta-acceso-texto">
                    <p class="tarjeta-acceso-titulo">Auditoria</p>
                    <p class="tarjeta-acceso-desc">Revisa el historial de actividad del sistema.</p>
                </span>
                <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
            </a>

            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/admin/reportes">
                <span class="tarjeta-acceso-icono">
                    <svg viewBox="0 0 24 24"><path d="M3 3v18h18"/><path d="M7 15v3"/><path d="M12 10v8"/><path d="M17 6v12"/></svg>
                </span>
                <span class="tarjeta-acceso-texto">
                    <p class="tarjeta-acceso-titulo">Reportes</p>
                    <p class="tarjeta-acceso-desc">Consulta las 5 consultas de reporte del proyecto.</p>
                </span>
                <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
            </a>
        </div>
    </div>

    <div class="panel-grupo">
        <h2 class="panel-grupo-titulo">Sistema</h2>
        <div class="panel-accesos">
            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/cambiarModo.jsp">
                <span class="tarjeta-acceso-icono">
                    <svg viewBox="0 0 24 24"><ellipse cx="12" cy="5" rx="8" ry="3"/><path d="M4 5v14c0 1.66 3.58 3 8 3s8-1.34 8-3V5"/><path d="M4 12c0 1.66 3.58 3 8 3s8-1.34 8-3"/></svg>
                </span>
                <span class="tarjeta-acceso-texto">
                    <p class="tarjeta-acceso-titulo">Base de datos</p>
                    <p class="tarjeta-acceso-desc">Cambiar el modo de conexion (local/remota).</p>
                </span>
                <span class="tarjeta-acceso-cta">Entrar <svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg></span>
            </a>
        </div>
    </div>
</section>

<%@ include file="views/footer.jspf" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Propiedad" %>
<%@ page import="dao.PropiedadDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% request.setAttribute("tituloPagina", "Inicio"); %>
<%
    // Propiedades destacadas: reutiliza PropiedadDAO (misma clase que usa /buscar)
    // sin tocar controladores ni rutas. Se muestran las mas recientes que
    // estan "disponible". Si algo falla, la seccion simplemente no se muestra.
    List<Propiedad> propiedadesDestacadas = new ArrayList<Propiedad>();
    try {
        PropiedadDAO propiedadDAO = new PropiedadDAO();
        List<Propiedad> listado = propiedadDAO.listarPropiedades(
                getServletContext(), null, null, null, null, null, "disponible");
        int limite = Math.min(listado.size(), 6);
        for (int i = 0; i < limite; i++) {
            Propiedad completa = propiedadDAO.obtenerPropiedadPorId(getServletContext(), listado.get(i).getId());
            if (completa != null) {
                propiedadesDestacadas.add(completa);
            }
        }
    } catch (Exception ex) {
        propiedadesDestacadas = new ArrayList<Propiedad>();
    }
    request.setAttribute("propiedadesDestacadas", propiedadesDestacadas);
%>
<%@ include file="views/header.jspf" %>

<%-- ===================================================
     HERO PRINCIPAL
     =================================================== --%>
<section class="hero" aria-label="Portada principal">
    <div class="hero-skyline" aria-hidden="true">
        <svg viewBox="0 0 1200 140" preserveAspectRatio="xMidYMax slice" xmlns="http://www.w3.org/2000/svg">
            <rect class="edificio" x="0"    y="55" width="90"  height="85"/>
            <rect class="edificio" x="70"   y="30" width="70"  height="110"/>
            <rect class="edificio" x="150"  y="70" width="110" height="70"/>
            <rect class="edificio-frente" x="250" y="20" width="90" height="120"/>
            <rect class="ventana" x="266" y="36" width="10" height="12" style="animation-delay:0.1s"/>
            <rect class="ventana" x="286" y="36" width="10" height="12" style="animation-delay:0.6s"/>
            <rect class="ventana" x="306" y="36" width="10" height="12" style="animation-delay:1.1s"/>
            <rect class="ventana" x="266" y="60" width="10" height="12" style="animation-delay:0.9s"/>
            <rect class="ventana" x="286" y="60" width="10" height="12" style="animation-delay:0.3s"/>
            <rect class="ventana" x="306" y="60" width="10" height="12" style="animation-delay:1.4s"/>
            <rect class="ventana" x="266" y="84" width="10" height="12" style="animation-delay:0.5s"/>
            <rect class="ventana" x="286" y="84" width="10" height="12" style="animation-delay:1.2s"/>
            <rect class="ventana" x="306" y="84" width="10" height="12" style="animation-delay:0.2s"/>
            <rect class="edificio" x="345" y="45" width="60"  height="95"/>
            <rect class="edificio" x="410" y="65" width="130" height="75"/>
            <rect class="edificio-frente" x="555" y="10" width="80" height="130" style="animation-delay:1.5s"/>
            <rect class="ventana" x="570" y="26" width="9" height="11" style="animation-delay:0.4s"/>
            <rect class="ventana" x="588" y="26" width="9" height="11" style="animation-delay:1.3s"/>
            <rect class="ventana" x="606" y="26" width="9" height="11" style="animation-delay:0.7s"/>
            <rect class="ventana" x="570" y="48" width="9" height="11" style="animation-delay:1.0s"/>
            <rect class="ventana" x="588" y="48" width="9" height="11" style="animation-delay:0.2s"/>
            <rect class="ventana" x="606" y="48" width="9" height="11" style="animation-delay:1.6s"/>
            <rect class="ventana" x="570" y="70" width="9" height="11" style="animation-delay:0.6s"/>
            <rect class="ventana" x="588" y="70" width="9" height="11" style="animation-delay:1.4s"/>
            <rect class="ventana" x="606" y="70" width="9" height="11" style="animation-delay:0.3s"/>
            <rect class="edificio" x="645" y="50" width="75"  height="90"/>
            <rect class="edificio" x="715" y="75" width="120" height="65"/>
            <rect class="edificio-frente" x="850" y="25" width="95" height="115" style="animation-delay:0.8s"/>
            <rect class="ventana" x="867" y="42" width="10" height="12" style="animation-delay:0.2s"/>
            <rect class="ventana" x="888" y="42" width="10" height="12" style="animation-delay:0.9s"/>
            <rect class="ventana" x="909" y="42" width="10" height="12" style="animation-delay:1.5s"/>
            <rect class="ventana" x="867" y="66" width="10" height="12" style="animation-delay:1.1s"/>
            <rect class="ventana" x="888" y="66" width="10" height="12" style="animation-delay:0.5s"/>
            <rect class="ventana" x="909" y="66" width="10" height="12" style="animation-delay:0.1s"/>
            <rect class="edificio" x="960"  y="55" width="70"  height="85"/>
            <rect class="edificio" x="1030" y="35" width="85"  height="105"/>
            <rect class="edificio" x="1110" y="70" width="90"  height="70"/>
        </svg>
    </div>

    <%-- Tabs Comprar / Arrendar --%>
    <div class="hero-tabs" role="tablist" aria-label="Tipo de operación">
        <button type="button" class="hero-tab activo" role="tab" aria-selected="true" data-tipo="Comprar">
            🏠 Comprar
        </button>
        <button type="button" class="hero-tab" role="tab" aria-selected="false" data-tipo="Arrendar">
            🔑 Arrendar
        </button>
    </div>

    <h1>Encuentra tu próximo inmueble</h1>
    <p class="subtitulo">Compra, venta y arriendo de propiedades en Santander con asesoría experta.</p>

    <form action="${pageContext.request.contextPath}/buscar" method="get" class="formulario-busqueda" role="search">
        <input type="text" name="q" id="hero-busqueda" placeholder="Ciudad, barrio o palabra clave..." autocomplete="off" aria-label="Buscar propiedades">
        <button type="submit" class="boton-primario">
            <svg viewBox="0 0 24 24" style="width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2.5;margin-right:6px;vertical-align:-2px;"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
            Buscar
        </button>
    </form>
    <p class="texto-muted">¿Buscas por ciudad, tipo o rango de precio? <a href="${pageContext.request.contextPath}/buscar">Usa el buscador avanzado</a>.</p>

    <%-- Estadísticas del hero --%>
    <div class="hero-stats" aria-label="Estadísticas de la plataforma">
        <div class="hero-stat">
            <span class="hero-stat-valor">${propiedadesDestacadas.size() > 0 ? propiedadesDestacadas.size().toString().concat('+') : '0'}</span>
            <span class="hero-stat-label">Propiedades activas</span>
        </div>
        <div class="hero-stat">
            <span class="hero-stat-valor">100%</span>
            <span class="hero-stat-label">Verificadas</span>
        </div>
        <div class="hero-stat">
            <span class="hero-stat-valor">24/7</span>
            <span class="hero-stat-label">Disponibilidad</span>
        </div>
        <div class="hero-stat">
            <span class="hero-stat-valor">★ 5.0</span>
            <span class="hero-stat-label">Calificación</span>
        </div>
    </div>
</section>

<%-- ===================================================
     PROPIEDADES DESTACADAS (lógica existente intacta)
     =================================================== --%>
<section class="seccion-destacadas">
    <div class="titulo-seccion">
        <h2>Propiedades destacadas</h2>
        <p class="subtitulo">Una selección de los inmuebles disponibles publicados más recientemente.</p>
    </div>

    <c:choose>
        <c:when test="${empty propiedadesDestacadas}">
            <p class="sin-resultados">Por ahora no hay propiedades destacadas para mostrar.</p>
        </c:when>
        <c:otherwise>
            <div class="grilla-destacadas">
                <c:forEach var="p" items="${propiedadesDestacadas}">
                    <article class="tarjeta-propiedad tarjeta-destacada">
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
                                    <c:choose><c:when test="${img.startsWith('http')}"><img src="${img}" alt="${p.titulo}" loading="lazy"></c:when><c:otherwise><img src="${pageContext.request.contextPath}/${img}" alt="${p.titulo}" loading="lazy"></c:otherwise></c:choose>
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

                            <c:if test="${not empty p.caracteristicas}">
                                <ul class="tarjeta-destacada-caracteristicas">
                                    <c:forEach var="carac" items="${p.caracteristicas}" begin="0" end="2">
                                        <li><svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>${carac}</li>
                                    </c:forEach>
                                </ul>
                            </c:if>

                            <a class="boton-primario boton-ver-propiedad" href="${pageContext.request.contextPath}/propiedad?id=${p.id}">
                                Ver propiedad
                                <svg viewBox="0 0 24 24" style="width:14px;height:14px;margin-left:4px;vertical-align:-2px;stroke:currentColor;fill:none;stroke-width:2.4"><path d="M9 6l6 6-6 6"/></svg>
                            </a>
                        </div>
                    </article>
                </c:forEach>
            </div>
            <p class="ver-todas-destacadas">
                <a href="${pageContext.request.contextPath}/buscar">Ver todas las propiedades →</a>
            </p>
        </c:otherwise>
    </c:choose>
</section>

<%-- ===================================================
     TIPOS DE INMUEBLE
     =================================================== --%>
<section class="seccion-tipos-inmueble" aria-label="Tipos de inmueble">
    <div class="seccion-header">
        <h2>Busca por tipo de inmueble</h2>
        <p>Encuentra exactamente lo que necesitas en nuestro amplio catálogo de propiedades.</p>
    </div>
    <div class="tipos-grid">
        <a href="${pageContext.request.contextPath}/buscar?q=casa" class="tipo-card">
            <div class="tipo-card-icono">
                <svg viewBox="0 0 24 24"><path d="M3 10.5 12 3l9 7.5"/><path d="M5 9.5V21h14V9.5"/><path d="M9 21v-6h6v6"/></svg>
            </div>
            <span class="tipo-card-nombre">Casas</span>
        </a>
        <a href="${pageContext.request.contextPath}/buscar?q=apartamento" class="tipo-card">
            <div class="tipo-card-icono">
                <svg viewBox="0 0 24 24"><rect x="4" y="2" width="16" height="20" rx="2"/><path d="M9 22v-4h6v4"/><path d="M8 6h.01"/><path d="M16 6h.01"/><path d="M12 6h.01"/><path d="M12 10h.01"/><path d="M8 10h.01"/><path d="M16 10h.01"/><path d="M8 14h.01"/><path d="M16 14h.01"/><path d="M12 14h.01"/></svg>
            </div>
            <span class="tipo-card-nombre">Apartamentos</span>
        </a>
        <a href="${pageContext.request.contextPath}/buscar?q=local" class="tipo-card">
            <div class="tipo-card-icono">
                <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><path d="M9 22V12h6v10"/><path d="M16 3h4v4"/></svg>
            </div>
            <span class="tipo-card-nombre">Locales</span>
        </a>
        <a href="${pageContext.request.contextPath}/buscar?q=lote" class="tipo-card">
            <div class="tipo-card-icono">
                <svg viewBox="0 0 24 24"><polygon points="3 11 12 2 21 11 21 21 3 21"/><line x1="3" y1="21" x2="21" y2="21"/></svg>
            </div>
            <span class="tipo-card-nombre">Lotes</span>
        </a>
        <a href="${pageContext.request.contextPath}/buscar?q=oficina" class="tipo-card">
            <div class="tipo-card-icono">
                <svg viewBox="0 0 24 24"><rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
            </div>
            <span class="tipo-card-nombre">Oficinas</span>
        </a>
    </div>
</section>

<%-- ===================================================
     ZONAS POPULARES
     =================================================== --%>
<section class="seccion-zonas" aria-label="Zonas populares">
    <div class="seccion-header">
        <h2>Zonas populares en Santander</h2>
        <p>Descubre las mejores ubicaciones para vivir o invertir en la región.</p>
    </div>
    <div class="zonas-grid">
        <a href="${pageContext.request.contextPath}/buscar?q=bucaramanga" class="zona-card">
            <div class="zona-card-fondo" style="background: linear-gradient(135deg,#0f4c5c,#0a2f3a);"></div>
            <div class="zona-card-overlay"></div>
            <div class="zona-card-icono-top">
                <svg viewBox="0 0 24 24"><path d="M12 21s7-6.2 7-12a7 7 0 10-14 0c0 5.8 7 12 7 12z"/></svg>
            </div>
            <div class="zona-card-info">
                <span class="zona-card-nombre">Bucaramanga</span>
                <span class="zona-card-sub">Ciudad capital · Centro histórico</span>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/buscar?q=cabecera" class="zona-card">
            <div class="zona-card-fondo" style="background: linear-gradient(135deg,#1a5c40,#0e3025);"></div>
            <div class="zona-card-overlay"></div>
            <div class="zona-card-icono-top">
                <svg viewBox="0 0 24 24"><path d="M12 21s7-6.2 7-12a7 7 0 10-14 0c0 5.8 7 12 7 12z"/></svg>
            </div>
            <div class="zona-card-info">
                <span class="zona-card-nombre">Cabecera</span>
                <span class="zona-card-sub">Zona norte exclusiva</span>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/buscar?q=cañaveral" class="zona-card">
            <div class="zona-card-fondo" style="background: linear-gradient(135deg,#5c3a0f,#3a200a);"></div>
            <div class="zona-card-overlay"></div>
            <div class="zona-card-icono-top">
                <svg viewBox="0 0 24 24"><path d="M12 21s7-6.2 7-12a7 7 0 10-14 0c0 5.8 7 12 7 12z"/></svg>
            </div>
            <div class="zona-card-info">
                <span class="zona-card-nombre">Cañaveral</span>
                <span class="zona-card-sub">Conjuntos residenciales</span>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/buscar?q=lagos" class="zona-card">
            <div class="zona-card-fondo" style="background: linear-gradient(135deg,#1a3a5c,#0e2035);"></div>
            <div class="zona-card-overlay"></div>
            <div class="zona-card-icono-top">
                <svg viewBox="0 0 24 24"><path d="M12 21s7-6.2 7-12a7 7 0 10-14 0c0 5.8 7 12 7 12z"/></svg>
            </div>
            <div class="zona-card-info">
                <span class="zona-card-nombre">Lagos</span>
                <span class="zona-card-sub">Urbanizaciones modernas</span>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/buscar?q=floridablanca" class="zona-card">
            <div class="zona-card-fondo" style="background: linear-gradient(135deg,#3a0f5c,#200935);"></div>
            <div class="zona-card-overlay"></div>
            <div class="zona-card-icono-top">
                <svg viewBox="0 0 24 24"><path d="M12 21s7-6.2 7-12a7 7 0 10-14 0c0 5.8 7 12 7 12z"/></svg>
            </div>
            <div class="zona-card-info">
                <span class="zona-card-nombre">Floridablanca</span>
                <span class="zona-card-sub">Área metropolitana</span>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/buscar?q=giron" class="zona-card">
            <div class="zona-card-fondo" style="background: linear-gradient(135deg,#0f5c3a,#0a3020);"></div>
            <div class="zona-card-overlay"></div>
            <div class="zona-card-icono-top">
                <svg viewBox="0 0 24 24"><path d="M12 21s7-6.2 7-12a7 7 0 10-14 0c0 5.8 7 12 7 12z"/></svg>
            </div>
            <div class="zona-card-info">
                <span class="zona-card-nombre">Girón</span>
                <span class="zona-card-sub">Ciudad patrimonio</span>
            </div>
        </a>
    </div>
</section>

<%-- ===================================================
     ¿POR QUÉ ELEGIRNOS?
     =================================================== --%>
<section class="seccion-beneficios" aria-label="Por qué elegirnos">
    <div class="seccion-header">
        <h2>¿Por qué elegir Nexus Living Co?</h2>
        <p>Te ofrecemos un proceso seguro, transparente y completamente personalizado.</p>
    </div>
    <div class="beneficios-grid">
        <div class="beneficio-card">
            <div class="beneficio-icono">
                <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="M9 12l2 2 4-4"/></svg>
            </div>
            <h3 class="beneficio-titulo">Propiedades verificadas</h3>
            <p class="beneficio-desc">Cada inmueble pasa por un proceso de verificación para garantizar información real, precisa y confiable.</p>
        </div>
        <div class="beneficio-card">
            <div class="beneficio-icono">
                <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            </div>
            <h3 class="beneficio-titulo">Atención personalizada</h3>
            <p class="beneficio-desc">Nuestros asesores te acompañan en cada paso del proceso, desde la búsqueda hasta el cierre.</p>
        </div>
        <div class="beneficio-card">
            <div class="beneficio-icono">
                <svg viewBox="0 0 24 24"><path d="M3 21h18"/><path d="M5 21V7l7-4 7 4v14"/><path d="M9 21v-6h6v6"/><path d="M9 11h.01"/><path d="M14 11h.01"/></svg>
            </div>
            <h3 class="beneficio-titulo">Agentes especializados</h3>
            <p class="beneficio-desc">Contamos con agentes inmobiliarios expertos en el mercado local de Santander con años de experiencia.</p>
        </div>
        <div class="beneficio-card">
            <div class="beneficio-icono">
                <svg viewBox="0 0 24 24"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
            </div>
            <h3 class="beneficio-titulo">Proceso 100% digital</h3>
            <p class="beneficio-desc">Agenda citas, envía solicitudes y gestiona todo tu proceso inmobiliario desde cualquier dispositivo.</p>
        </div>
    </div>
</section>

<%-- ===================================================
     CTA FINAL
     =================================================== --%>
<section class="seccion-cta-final" aria-label="Llamado a la acción">
    <div class="cta-final-contenido">
        <h2>Encuentra el lugar que quieres llamar hogar</h2>
        <p>Más de cientos de propiedades disponibles en Santander esperan por ti. Comienza tu búsqueda hoy.</p>
        <a href="${pageContext.request.contextPath}/buscar" class="boton-cta-final">
            Explorar propiedades
            <svg viewBox="0 0 24 24"><path d="M9 6l6 6-6 6"/></svg>
        </a>
    </div>
</section>

<%@ include file="views/footer.jspf" %>

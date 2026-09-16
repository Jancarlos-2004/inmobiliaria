<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("tituloPagina", "Radicar solicitud"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario">
    <h1>Radicar solicitud</h1>

    <div class="resumen-propiedad-form">
        <span class="resumen-propiedad-form-icono">
            <svg viewBox="0 0 24 24"><path d="M3 10.5 12 3l9 7.5"/><path d="M5 9.5V21h14V9.5"/><path d="M9 21v-6h6v6"/></svg>
        </span>
        <div>
            <p class="resumen-propiedad-form-titulo">${propiedad.titulo}</p>
            <p class="resumen-propiedad-form-direccion">${propiedad.direccion}</p>
        </div>
    </div>

    <%@ include file="views/mensajes.jspf" %>

    <form action="${pageContext.request.contextPath}/cliente/solicitudes/nueva" method="post" class="formulario">
        <input type="hidden" name="idPropiedad" value="${propiedad.id}">

        <label for="tipoSolicitud">Tipo de solicitud</label>
        <select id="tipoSolicitud" name="tipoSolicitud" required>
            <option value="">Selecciona...</option>
            <option value="compra">Compra</option>
            <option value="arriendo">Arriendo</option>
        </select>

        <fieldset>
            <legend>Documentos</legend>
            <p class="texto-ayuda">
                Por ahora se registran como enlace/ruta de archivo (URL). Deja vacio lo que no apliquе.
            </p>

            <label for="doc_identificacion">Identificacion</label>
            <input type="text" id="doc_identificacion" name="doc_identificacion" placeholder="URL o ruta del documento">

            <label for="doc_ingresos">Certificado de ingresos</label>
            <input type="text" id="doc_ingresos" name="doc_ingresos" placeholder="URL o ruta del documento">

            <label for="doc_contrato">Contrato / referencia</label>
            <input type="text" id="doc_contrato" name="doc_contrato" placeholder="URL o ruta del documento">

            <label for="doc_otro">Otro</label>
            <input type="text" id="doc_otro" name="doc_otro" placeholder="URL o ruta del documento">
        </fieldset>

        <button type="submit" class="boton-primario">Radicar solicitud</button>
    </form>
    <p class="texto-ayuda texto-ayuda-centrado">
        Tu solicitud quedara en estado <span class="etiqueta-estado etiqueta-pendiente">pendiente</span> hasta que el agente la revise.
    </p>
</section>

<%@ include file="views/footer.jspf" %>

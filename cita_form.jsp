<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("tituloPagina", "Agendar cita"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario">
    <h1>Agendar visita</h1>

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

    <form action="${pageContext.request.contextPath}/cliente/citas/nueva" method="post" class="formulario">
        <input type="hidden" name="idPropiedad" value="${propiedad.id}">

        <label for="fechaHora">Fecha y hora deseada</label>
        <input type="datetime-local" id="fechaHora" name="fechaHora" required>
        <p class="texto-ayuda">Elige el dia y la hora en que te gustaria visitar la propiedad.</p>

        <label for="notas">Notas (opcional)</label>
        <textarea id="notas" name="notas" rows="3" placeholder="Ej: prefiero horario en la tarde"></textarea>

        <button type="submit" class="boton-primario">Solicitar cita</button>
    </form>
    <p class="texto-ayuda texto-ayuda-centrado">
        La cita queda en estado <span class="etiqueta-estado etiqueta-pendiente">pendiente</span> hasta que el agente la confirme.
    </p>
</section>

<%@ include file="views/footer.jspf" %>

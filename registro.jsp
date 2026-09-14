<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("tituloPagina", "Crear cuenta"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario">
    <h1>Crear cuenta de Cliente</h1>
    <p class="subtitulo">Regístrate para agendar citas, guardar favoritos y radicar solicitudes.</p>

    <%@ include file="views/mensajes.jspf" %>

    <form action="${pageContext.request.contextPath}/registro" method="post" class="formulario">
        <div class="fila-doble">
            <div>
                <label for="nombres">Nombres</label>
                <input type="text" id="nombres" name="nombres" value="${nombres}" required>
            </div>
            <div>
                <label for="apellidos">Apellidos</label>
                <input type="text" id="apellidos" name="apellidos" value="${apellidos}" required>
            </div>
        </div>

        <div class="fila-doble">
            <div>
                <label for="documento">Documento de identidad</label>
                <input type="text" id="documento" name="documento" value="${documento}" required>
            </div>
            <div>
                <label for="telefono">Telefono</label>
                <input type="text" id="telefono" name="telefono" value="${telefono}">
            </div>
        </div>

        <label for="direccion">Direccion</label>
        <input type="text" id="direccion" name="direccion" value="${direccion}">

        <label for="correo">Correo electronico</label>
        <input type="email" id="correo" name="correo" value="${correo}" required>

        <div class="fila-doble">
            <div>
                <label for="password">Contraseña</label>
                <input type="password" id="password" name="password" minlength="6" required>
            </div>
            <div>
                <label for="confirmarPassword">Confirmar contraseña</label>
                <input type="password" id="confirmarPassword" name="confirmarPassword" minlength="6" required>
            </div>
        </div>

        <button type="submit" class="boton-primario">Registrarme</button>
    </form>

    <p class="enlace-secundario">
        ¿Ya tienes cuenta?
        <a href="${pageContext.request.contextPath}/login.jsp">Inicia sesion aqui</a>
    </p>
</section>

<%@ include file="views/footer.jspf" %>

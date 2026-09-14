<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("tituloPagina", "Iniciar sesion"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario">
    <h1>Iniciar sesion</h1>
    <p class="subtitulo">Ingresa con tu correo y contraseña registrados.</p>

    <%@ include file="views/mensajes.jspf" %>

    <form action="${pageContext.request.contextPath}/login" method="post" class="formulario">
        <label for="correo">Correo electronico</label>
        <input type="email" id="correo" name="correo" value="${correo}" required autofocus>

        <label for="password">Contraseña</label>
        <input type="password" id="password" name="password" required>

        <button type="submit" class="boton-primario">Ingresar</button>
    </form>

    <p class="enlace-secundario">
        ¿Aun no tienes cuenta?
        <a href="${pageContext.request.contextPath}/registro.jsp">Registrate aqui</a>
    </p>
</section>

<%@ include file="views/footer.jspf" %>

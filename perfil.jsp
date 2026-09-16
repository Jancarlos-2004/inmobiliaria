<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("tituloPagina", "Mi perfil"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario">
    <h1>Mi perfil</h1>
    <p class="subtitulo">Correo: ${sessionScope.usuario.correo}</p>

    <%@ include file="views/mensajes.jspf" %>

    <form action="${pageContext.request.contextPath}/perfil" method="post" class="formulario">
        <label for="nombres">Nombres</label>
        <input type="text" id="nombres" name="nombres" value="${sessionScope.usuario.perfil.nombres}" required>

        <label for="apellidos">Apellidos</label>
        <input type="text" id="apellidos" name="apellidos" value="${sessionScope.usuario.perfil.apellidos}" required>

        <label for="documento">Documento de identidad</label>
        <input type="text" id="documento" name="documento" value="${sessionScope.usuario.perfil.documento}" required>

        <label for="telefono">Telefono</label>
        <input type="text" id="telefono" name="telefono" value="${sessionScope.usuario.perfil.telefono}">

        <label for="direccion">Direccion</label>
        <input type="text" id="direccion" name="direccion" value="${sessionScope.usuario.perfil.direccion}">

        <button type="submit" class="boton-primario">Guardar cambios</button>
    </form>
</section>

<%@ include file="views/footer.jspf" %>

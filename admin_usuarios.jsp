<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% request.setAttribute("tituloPagina", "Gestion de usuarios"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-ancha">
    <h1>Usuarios registrados</h1>
    <p class="subtitulo">${fn:length(usuarios)} usuario(s) en el sistema.</p>

    <%@ include file="views/mensajes.jspf" %>

    <div class="tabla-responsive">
    <table class="tabla-simple">
        <thead>
        <tr><th>Nombre</th><th>Correo</th><th>Documento</th><th>Estado</th><th>Roles</th><th>Acciones</th></tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${usuarios}">
            <tr>
                <td class="celda-nombre">${u.perfil.nombres} ${u.perfil.apellidos}</td>
                <td>${u.correo}</td>
                <td>${u.perfil.documento}</td>
                <td><span class="etiqueta-estado etiqueta-${u.estado}">${u.estado}</span></td>
                <td>
                    <div class="chips-roles">
                        <c:if test="${u.tieneRol('Cliente')}"><span class="etiqueta-rol etiqueta-rol-cliente">Cliente</span></c:if>
                        <c:if test="${u.tieneRol('Inmobiliaria')}"><span class="etiqueta-rol etiqueta-rol-agente">Agente</span></c:if>
                        <c:if test="${u.tieneRol('Administrador')}"><span class="etiqueta-rol etiqueta-rol-admin">Admin</span></c:if>
                        <c:if test="${!u.tieneRol('Cliente') && !u.tieneRol('Inmobiliaria') && !u.tieneRol('Administrador')}">
                            <span class="etiqueta-rol etiqueta-rol-ninguno">Sin rol</span>
                        </c:if>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/usuarios/roles" method="post" class="form-roles">
                        <input type="hidden" name="id" value="${u.id}">
                        <label class="checkbox-inline">
                            <input type="checkbox" name="roles" value="2" ${u.tieneRol('Cliente') ? 'checked' : ''}> Cliente
                        </label>
                        <label class="checkbox-inline">
                            <input type="checkbox" name="roles" value="3" ${u.tieneRol('Inmobiliaria') ? 'checked' : ''}> Inmobiliaria
                        </label>
                        <label class="checkbox-inline">
                            <input type="checkbox" name="roles" value="4" ${u.tieneRol('Administrador') ? 'checked' : ''}> Administrador
                        </label>
                        <button type="submit" class="enlace-accion">Guardar roles</button>
                    </form>
                </td>
                <td class="acciones-tabla">
                    <form action="${pageContext.request.contextPath}/admin/usuarios/estado" method="post" class="form-inline">
                        <input type="hidden" name="id" value="${u.id}">
                        <c:choose>
                            <c:when test="${u.estado == 'activo'}">
                                <input type="hidden" name="estado" value="inactivo">
                                <button type="submit" class="enlace-peligro">Inactivar</button>
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="estado" value="activo">
                                <button type="submit" class="enlace-accion">Activar</button>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    </div>
</section>

<%@ include file="views/footer.jspf" %>

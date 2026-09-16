<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% request.setAttribute("tituloPagina", "crear".equals(request.getAttribute("modoFormulario")) ? "Publicar propiedad" : "Editar propiedad"); %>
<%@ include file="views/header.jspf" %>

<section class="tarjeta-formulario tarjeta-ancha">
    <h1>${"crear".equals(modoFormulario) ? "Publicar nueva propiedad" : "Editar propiedad"}</h1>

    <%@ include file="views/mensajes.jspf" %>

    <form action="${pageContext.request.contextPath}/agente/propiedades/${modoFormulario == 'crear' ? 'nueva' : 'editar'}"
          method="post" class="formulario">

        <c:if test="${modoFormulario == 'editar'}">
            <input type="hidden" name="id" value="${propiedad.id}">
        </c:if>

        <label for="titulo">Titulo</label>
        <input type="text" id="titulo" name="titulo" value="${propiedad.titulo}" required>

        <label for="descripcion">Descripcion</label>
        <textarea id="descripcion" name="descripcion" rows="4">${propiedad.descripcion}</textarea>

        <label for="direccion">Direccion</label>
        <input type="text" id="direccion" name="direccion" value="${propiedad.direccion}" required>

        <label for="matriculaInmobiliaria">Matricula inmobiliaria (unica)</label>
        <input type="text" id="matriculaInmobiliaria" name="matriculaInmobiliaria" value="${propiedad.matriculaInmobiliaria}" required>

        <div class="fila-doble">
            <div>
                <label for="idCiudad">Ciudad</label>
                <select id="idCiudad" name="idCiudad" required>
                    <option value="">Selecciona...</option>
                    <c:forEach var="c" items="${ciudades}">
                        <option value="${c.id}" ${propiedad.idCiudad == c.id ? 'selected' : ''}>${c.nombre}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label for="idTipo">Tipo de inmueble</label>
                <select id="idTipo" name="idTipo" required>
                    <option value="">Selecciona...</option>
                    <c:forEach var="t" items="${tipos}">
                        <option value="${t.id}" ${propiedad.idTipo == t.id ? 'selected' : ''}>${t.nombre}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="fila-doble">
            <div>
                <label for="precio">Precio (COP)</label>
                <input type="number" id="precio" name="precio" min="1" step="1"
                       value="${propiedad.precio > 0 ? propiedad.precio : ''}" required>
            </div>
            <c:if test="${modoFormulario == 'editar'}">
                <div>
                    <label for="estado">Estado</label>
                    <select id="estado" name="estado">
                        <option value="disponible" ${propiedad.estado == 'disponible' ? 'selected' : ''}>Disponible</option>
                        <option value="arrendado" ${propiedad.estado == 'arrendado' ? 'selected' : ''}>Arrendado</option>
                        <option value="vendido" ${propiedad.estado == 'vendido' ? 'selected' : ''}>Vendido</option>
                        <option value="inactivo" ${propiedad.estado == 'inactivo' ? 'selected' : ''}>Inactivo</option>
                    </select>
                </div>
            </c:if>
        </div>

        <label for="imagenesUrls">Imagenes (una URL por linea)</label>
        <textarea id="imagenesUrls" name="imagenesUrls" rows="3"
                  placeholder="assets/img/propiedades/casa1.jpg"><c:forEach var="img" items="${propiedad.imagenes}">${img}
</c:forEach></textarea>
        <p class="texto-ayuda">Deja vacio para conservar las imagenes actuales al editar.</p>

        <label>Caracteristicas</label>
        <div class="grupo-checkboxes">
            <c:forEach var="car" items="${caracteristicasDisponibles}">
                <label class="checkbox-inline">
                    <input type="checkbox" name="caracteristicas" value="${car.id}"
                           ${propiedad.caracteristicas.contains(car.nombre) ? 'checked' : ''}>
                    ${car.nombre}
                </label>
            </c:forEach>
        </div>

        <button type="submit" class="boton-primario">
            ${modoFormulario == 'crear' ? 'Publicar propiedad' : 'Guardar cambios'}
        </button>
    </form>
</section>

<%@ include file="views/footer.jspf" %>

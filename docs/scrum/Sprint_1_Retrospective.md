# Sprint 1 — Retrospective (Retrospectiva del Equipo)

**Sprint:** 1 de 3  
**Objetivo:** Evaluar el proceso de trabajo, identificar aciertos, dificultades técnicas y compromisos de mejora para el Sprint 2.

---

## 1. ¿Qué funcionó bien? (Aspectos Positivos)
- La centralización de la conexión JDBC en `ConexionBD.java` permitió cambiar entre base de datos local y remota sin tocar los DAOs ni los controladores.
- La función de salting antes del hash SHA-256 en `HashUtil.java` funcionó perfectamente y cumplió las exigencias del parcial.
- El diseño modular de los fragmentos `header.jspf` y `footer.jspf` evitó duplicar código en las vistas.

## 2. ¿Qué dificultades surgieron? (Puntos de Dolor)
- Se detectó que si se mapeaban únicamente los servlets en el filtro, un usuario malicioso podía invocar los nombres de archivo `.jsp` directamente en la barra de direcciones. Se procedió a blindar la lista completa de JSPs en `AutorizacionFilter` y `web.xml`.
- Inicialmente los errores de clave duplicada arrojaban trazas feas de MySQL al usuario final.

## 3. Plan de Acción y Mejoras para el Sprint 2
1. **Acción 1:** Implementar clases auxiliares de validación previa (`ValidadorUtil`) para capturar errores de tipo y formato antes de enviar las sentencias a la base de datos.
2. **Acción 2:** Adoptar estándares estrictos para el CRUD de propiedades, garantizando que el agente solo pueda modificar las publicaciones que le pertenecen.
3. **Acción 3:** Preparar la galería de imágenes 1:N y las características N:M con formularios dinámicos limpios.

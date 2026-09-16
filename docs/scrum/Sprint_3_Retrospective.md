# Sprint 3 — Retrospective (Retrospectiva de Cierre del Proyecto)

**Sprint:** 3 de 3  
**Objetivo:** Evaluar el desempeño global del equipo Scrum a lo largo de los tres sprints, lecciones aprendidas y preparación para la sustentación individual ante el docente.

---

## 1. ¿Qué funcionó excelentemente a lo largo del proyecto?
- **Disciplina Iterativa:** Dividir el desarrollo en 3 sprints de 7 días permitió abordar primero los cimientos de seguridad y base de datos, luego el catálogo y finalmente las transacciones y reportes, sin atascos de última hora.
- **Arquitectura Limpia MVC:** Separar estrictamente la presentación (JSP/JSPF con Bootstrap 5), el control (Servlets) y el acceso a datos (DAOs con JDBC) hizo que agregar nuevas funcionalidades fuera natural y ordenado.
- **Manejo de Errores y Seguridad:** El blindaje del filtro `AutorizacionFilter` y la captura de errores UNIQUE evitaron fallas de seguridad y mejoraron la experiencia de usuario.
- **Automatización de Pruebas y Documentación:** La suite de pruebas unitarias y los scripts generadores de PDF aseguraron entregables de nivel profesional.

## 2. Lecciones Aprendidas para Futuros Proyectos
- Las restricciones de integridad en base de datos (`UNIQUE`, `FOREIGN KEY`, `ON DELETE`) deben definirse desde el día 1; es mucho más costoso parchar la integridad referencial al final del desarrollo.
- Proteger únicamente las URLs de los controladores no basta en aplicaciones Java EE; se deben proteger también las vistas JSP contra accesos directos por GET.
- Mantener las credenciales privadas fuera del control de versiones mediante `.gitignore` y plantillas de configuración (`db.properties.example`) es un estándar indispensable de seguridad.

## 3. Preparación para la Sustentación Individual
- Cada miembro del equipo domina la explicación de los 3 tipos de relaciones (1:1 en perfiles, 1:N en imágenes/citas/solicitudes, N:M en roles/características/favoritos).
- Se tiene claridad total sobre la justificación de la normalización 3FN y la sintaxis de las 5 consultas SQL complejas de los reportes.
- El proyecto se encuentra 100% operativo en Tomcat y MySQL local.

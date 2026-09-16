# Sprint 2 — Retrospective (Retrospectiva del Equipo)

**Sprint:** 2 de 3  
**Objetivo:** Analizar la velocidad del equipo, identificar mejoras en la interacción con la base de datos y preparar el Sprint final de operación, reportes y pruebas.

---

## 1. ¿Qué funcionó bien? (Aspectos Positivos)
- El manejo de transacciones con rollback en `PropiedadDAO.java` garantizó que si fallaba la inserción de imágenes o características, la propiedad no quedaba huérfana en la base de datos.
- El buscador dinámico con parámetros opcionales en SQL evitó tener que escribir múltiples consultas repetitivas.
- Los dashboards por rol otorgaron una experiencia de usuario clara y adaptada a cada tipo de actor.

## 2. ¿Qué dificultades surgieron? (Puntos de Dolor)
- Al manejar múltiples imágenes por URL en el formulario, fue necesario validar que no se enviaran líneas vacías o espacios en blanco.
- La protección de edición de propiedades requirió doble comprobación: a nivel de filtro general y a nivel de controlador para impedir que un agente modifique los inmuebles de otro agente.

## 3. Plan de Acción y Mejoras para el Sprint 3
1. **Acción 1:** Implementar el módulo transaccional de citas y solicitudes, cuidando la restricción UNIQUE para evitar cruce de visitas.
2. **Acción 2:** Integrar el visor de documentos radicados para que el agente examine los comprobantes antes de aprobar una solicitud.
3. **Acción 3:** Construir las 5 consultas de reportes consolidados (INNER JOIN x2, N:M, LEFT JOIN, GROUP BY + HAVING).
4. **Acción 4:** Desarrollar la suite de pruebas unitarias automáticas y la documentación completa para la sustentación.

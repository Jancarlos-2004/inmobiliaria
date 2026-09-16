# Sprint 3 — Planning (Planificación)

**Sprint:** 3 de 3  
**Duración:** 7 días calendario  
**Meta del Sprint (Sprint Goal):** Completar la operación y cierre del sistema inmobiliario: agendamiento de citas con control de cruce de horarios, radicación de solicitudes de compra/arriendo con documentos adjuntos (1:N), flujo de aprobación/rechazo por agentes con transición de estado de propiedad, favoritos N:M, reportes SQL analíticos con 5 consultas complejas, suite de pruebas unitarias, documentación técnica final (MER, Relacional, 3FN, Diccionario en PDF) y preparación para la sustentación.

---

## 1. Historias de Usuario Seleccionadas (Sprint Backlog)
1. **HU-08:** Favoritos de clientes en relación N:M (3 SP).
2. **HU-09:** Agendamiento de citas con restricción UNIQUE de horario (5 SP).
3. **HU-10:** Radicación de solicitudes y documentos adjuntos 1:N (5 SP).
4. **HU-11:** Aprobación/Rechazo de solicitudes y cambio de estado del inmueble (5 SP).
5. **HU-12:** Reportes consolidados con 5 consultas SQL avanzadas (5 SP).
- **Total estimado:** 23 Story Points.

---

## 2. Tareas Técnicas Desglosadas
- **Módulo de Citas:**
  - Crear `CitaDAO.java` y `CitaController.java`.
  - Implementar validación de fecha futura y captura de restricción `UNIQUE (id_propiedad, fecha_hora)`.
  - Crear vistas `citas_cliente.jsp`, `citas_agente.jsp` y `cita_form.jsp`.
- **Módulo de Solicitudes y Documentos:**
  - Crear `SolicitudDAO.java` con carga eagerly de documentos asociados (`cargarDocumentos`).
  - Crear `SolicitudController.java` mapeando `/cliente/solicitudes`, `/nueva`, `/agente/solicitudes` y `/resolver`.
  - Implementar regla de negocio: si se aprueba compra -> propiedad pasa a `'vendido'`; si es arriendo -> propiedad pasa a `'arrendado'`.
  - Visualizar los documentos adjuntos tanto en la vista del agente como del cliente.
- **Módulo de Reportes SQL:**
  - Crear `ReporteDAO.java` con las 5 consultas requeridas por la rúbrica UTS.
  - Diseñar interfaz gráfica de métricas y tablas en `admin_reportes.jsp`.
- **Calidad y Entrega:**
  - Desarrollar suite de pruebas unitarias `TestSuiteInmobiliaria.java`.
  - Redactar matriz de pruebas funcionales `TEST-01` a `TEST-15`.
  - Generar los 5 documentos PDF oficiales (`MER.pdf`, `Modelo_Relacional.pdf`, `Diccionario_Datos.pdf`, `Normalizacion_3FN.pdf`, `Consultas_SQL.pdf`).
  - Configurar `.gitignore` y scripts de inicialización de repositorio Git.

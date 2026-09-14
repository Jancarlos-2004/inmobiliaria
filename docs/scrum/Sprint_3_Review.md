# Sprint 3 — Review (Revisión Final del Producto)

**Sprint:** 3 de 3  
**Participantes:** Product Owner (Docente Julián Barney Jaimes Rincón), Scrum Master y Development Team.  
**Resultado:** Producto Aceptado en su totalidad para Entrega y Sustentación Final.

---

## 1. Demostración del Incremento Final
Se realizó la demostración del flujo operativo de punta a punta:
1. **Flujo de Citas:** Un cliente agendó una visita para el viernes siguiente; el agente la visualizó en su bandeja `/agente/citas` y la marcó como aceptada. Se demostró que al intentar agendar otra cita en el mismo horario sobre la misma propiedad, el sistema lo rechazó limpiamente.
2. **Flujo de Solicitudes y Documentación:** El cliente radicó una solicitud de compra adjuntando su cédula y extractos bancarios. El agente abrió `/agente/solicitudes`, revisó los documentos adjuntos en la columna de la tabla y procedió a presionar "Aprobar". Inmediatamente se comprobó en la base de datos que el estado de la propiedad cambió de `'disponible'` a `'vendido'`.
3. **Favoritos (N:M):** El cliente guardó y desmarcó inmuebles con el corazón interactivo, visualizándolos en su dashboard.
4. **Reportes SQL Avanzados:** Se ingresó a `/admin/reportes` y se sustentaron las 5 consultas requeridas por el parcial:
   - Consulta 1: INNER JOIN entre 4 tablas (propiedades, ciudades, tipos, usuarios).
   - Consulta 2: INNER JOIN entre 4 tablas (citas, propiedades, perfiles cliente, perfiles agente).
   - Consulta 3: Resolución N:M de propiedades y características.
   - Consulta 4: LEFT JOIN para inmuebles sin citas agendadas.
   - Consulta 5: GROUP BY y HAVING para análisis patrimonial por ciudad.
5. **Pruebas Unitarias:** Se ejecutó `TestSuiteInmobiliaria.java`, obteniendo 33/33 pruebas aprobadas (100%).
6. **Entrega Documental:** Presentación de los 5 archivos PDF oficiales en la carpeta `docs/`.

---

## 2. Métricas del Sprint y Producto Final
- **Story Points Comprometidos Sprint 3:** 23 SP | **Completados:** 23 SP.
- **Story Points Totales del Producto:** 67 / 67 Story Points (100% de cumplimiento).
- **Historias de Usuario Aceptadas:** HU-08, HU-09, HU-10, HU-11, HU-12.
- **Definición de Hecho (DoD):** Cumplida al 100% en todas las historias del Product Backlog.

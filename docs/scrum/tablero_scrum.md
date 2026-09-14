# Tablero de Seguimiento Scrum (Kanban Board)

**Herramienta de Referencia:** GitHub Projects / Trello / Jira / Padlet  
**Proyecto:** Nexus Living Co — Inmobiliaria UTS  
**Marco de Trabajo:** Scrum (Sprints 1, 2 y 3)

---

## 1. Estructura de Columnas y Distribución de Tarjetas

```text
+----------------+----------------+----------------+----------------+----------------+
|    BACKLOG     |     TO DO      |  IN PROGRESS   |    TESTING     |      DONE      |
+----------------+----------------+----------------+----------------+----------------+
```

A continuación se detalla el estado final del tablero al cierre del proyecto (Sprint 3 finalizado):

### [COLUMNA: BACKLOG (Futuras Iteraciones / Mejoras Opcionales)]
- [ ] **[MEJORA-01] Integración de Mapas Interactivos:** Ubicación georreferenciada con Google Maps o Leaflet para visualizar propiedades en el mapa.
- [ ] **[MEJORA-02] Pasarela de Pagos en Línea:** Pago de canon de arriendo o reserva de compra mediante PSE / Tarjeta.
- [ ] **[MEJORA-03] Notificaciones por Correo:** Envío de correos automáticos (JavaMail) al aprobar citas o solicitudes.
- [ ] **[MEJORA-04] Chat en Tiempo Real:** Canal de mensajería directa entre cliente y agente asignado.

---

### [COLUMNA: TO DO (Por Hacer)]
*(Todas las tareas de los Sprints 1, 2 y 3 fueron abordadas y completadas).*

---

### [COLUMNA: IN PROGRESS (En Curso)]
*(Ninguna tarea en curso; ciclo de desarrollo del parcial concluido).*

---

### [COLUMNA: TESTING (En Pruebas y Validación)]
*(Todas las pruebas de la matriz TEST-01 a TEST-15 y pruebas unitarias de TestSuiteInmobiliaria pasaron satisfactoriamente).*

---

### [COLUMNA: DONE (Terminadas y Aprobadas por el Product Owner)]

#### Sprint 1 — Cimientos y Acceso
- [x] **HU-01 [5 SP]: Landing Page pública y responsiva**
  - *Criterio:* Presentación de Nexus Living Co, buscador rápido, propiedades destacadas dinámicas, navbar y footer institucional.
- [x] **HU-02 [5 SP]: Registro de Usuarios con Correo Único**
  - *Criterio:* Cifrado con SHA-256 + salt criptográfico (`HashUtil`), asignación de rol `Cliente`, creación de perfil 1:1 y captura de error UNIQUE.
- [x] **HU-03 [5 SP]: Inicio y Cierre de Sesión Seguro**
  - *Criterio:* Autenticación contra BD, manejo de `HttpSession`, redirección automática por rol e invalidación de sesión al salir.
- [x] **HU-04 [8 SP]: Control de Acceso por Roles (Filter)**
  - *Criterio:* `AutorizacionFilter` blindando rutas `/admin/*`, `/agente/*`, `/cliente/*` y JSPs directos contra accesos no autorizados.
- [x] **TECH-01: Arquitectura de Base de Datos y JDBC**
  - *Criterio:* Creación de `schema.sql` (DDL), `data.sql` (DML), diagramas MER y clase de conexión dinámica local/remota (`ConexionBD`).

#### Sprint 2 — Núcleo del Negocio
- [x] **HU-05 [3 SP]: Gestión de Perfil de Usuario (1:1)**
  - *Criterio:* Visualización y actualización de documento, teléfono y dirección personal por parte del usuario autenticado en `/perfil`.
- [x] **HU-06 [8 SP]: CRUD de Propiedades, Imágenes 1:N y Amenidades N:M**
  - *Criterio:* Publicación y edición atómica con transacciones JDBC, galería de fotos, amenidades y baja lógica (`estado='inactivo'`).
- [x] **HU-07 [5 SP]: Buscador y Filtros Avanzados**
  - *Criterio:* Búsqueda combinada por ciudad, tipo, rango de precios y palabra clave en `/buscar`.
- [x] **HU-13 [3 SP]: Auditoría de Operaciones del Sistema**
  - *Criterio:* Registro persistente de inicios de sesión, cambios de estado y publicaciones en tabla `auditoria`.
- [x] **TECH-02: Integración de Bootstrap 5**
  - *Criterio:* Inclusión de Bootstrap 5 CSS y JS sin alterar la estética personalizada ni el modo oscuro del sistema.

#### Sprint 3 — Operación y Cierre
- [x] **HU-08 [3 SP]: Propiedades Favoritas (N:M)**
  - *Criterio:* Marcado de favoritos con icono de corazón y visualización en dashboard de cliente mediante tabla `favoritos`.
- [x] **HU-09 [5 SP]: Agendamiento de Citas con Control de Cruce de Horario**
  - *Criterio:* Agendamiento con validación de fecha futura y restricción `UNIQUE (id_propiedad, fecha_hora)` para evitar colisiones.
- [x] **HU-10 [5 SP]: Radicación de Solicitudes y Documentos Adjuntos (1:N)**
  - *Criterio:* Formulario de solicitud de compra/arriendo con carga y registro de documentos en `documentos_solicitudes`.
- [x] **HU-11 [5 SP]: Aprobación y Rechazo de Solicitudes**
  - *Criterio:* Bandeja de agente con visualización de documentos radicados y cambio automático de estado del inmueble a `'vendido'` o `'arrendado'`.
- [x] **HU-12 [5 SP]: Reportes SQL Multi-tabla**
  - *Criterio:* Pantalla `/admin/reportes` con las 5 consultas requeridas (INNER JOIN x2, N:M, LEFT JOIN, GROUP BY + HAVING).
- [x] **TECH-03: Suite de Pruebas Unitarias y Funcionales**
  - *Criterio:* 33 pruebas unitarias automáticas en `TestSuiteInmobiliaria.java` y matriz `TEST-01` a `TEST-15`.
- [x] **TECH-04: Documentación Técnica Oficial en PDF**
  - *Criterio:* `MER.pdf`, `Modelo_Relacional.pdf`, `Diccionario_Datos.pdf`, `Normalizacion_3FN.pdf`, `Consultas_SQL.pdf`.

---

## 2. Instrucciones para Replicar en Herramientas Externas (Trello / Jira / Padlet)
1. Crear un tablero con las 5 columnas: `BACKLOG`, `TO DO`, `IN PROGRESS`, `TESTING`, `DONE`.
2. Crear una tarjeta por cada una de las 13 Historias de Usuario descritas en la sección `DONE`.
3. Asignar las etiquetas por Sprint (Sprint 1: Azul, Sprint 2: Verde, Sprint 3: Naranja).
4. Agregar los criterios de aceptación en la lista de chequeo de cada tarjeta.

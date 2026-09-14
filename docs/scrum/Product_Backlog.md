# Product Backlog Oficial — Proyecto Inmobiliaria UTS

**Institución:** Unidades Tecnológicas de Santander (UTS)  
**Asignatura:** Programación Java  
**Docente (Product Owner):** Julián Barney Jaimes Rincón  
**Equipo de Desarrollo:** Scrum Team UTS  
**Marco de Trabajo:** Scrum (3 Sprints de 7 días cada uno)

---

## 1. Definición de Hecho Global (Definition of Done - DoD)
Una Historia de Usuario se considera **DONE (Terminada)** cuando cumple los siguientes criterios:
1. **Código Fuente:** Implementado en Java EE, JSP, Servlets y JDBC sin dependencias de frameworks no autorizados.
2. **Base de Datos:** Integrado con MySQL mediante consultas preparadas (`PreparedStatement`) respetando integridad referencial y restricciones UNIQUE.
3. **Seguridad:** Validación de roles tanto en vistas como en el servidor (`AutorizacionFilter` y controladores).
4. **Diseño Frontend:** Responsivo y compatible con Bootstrap 5 en desktop, tablet y smartphone.
5. **Pruebas:** Verificado funcionalmente y con pruebas unitarias aprobadas.
6. **Auditoría:** Registro de eventos críticos en la tabla `auditoria`.

---

## 2. Tabla del Product Backlog Priorizado

| ID | Historia de Usuario | Prioridad | Estimación (Story Points) | Sprint Asignado | Criterios de Aceptación (DoD Específico) | Estado |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **HU-01** | **Landing Page:** Como visitante, quiero una página de aterrizaje atractiva para conocer la inmobiliaria y buscar propiedades rápidamente. | Alta | 5 SP | Sprint 1 | • Vista pública responsiva con navbar, buscador rápido (tipo, ciudad, precio) y propiedades destacadas dinámicas.<br>• Acceso directo a login y registro.<br>• Integración de testimonios y pie de página institucional. | **DONE** |
| **HU-02** | **Registro de Usuarios:** Como visitante, quiero registrarme con un correo único y validado para crear mi cuenta sin duplicados en el sistema. | Alta | 5 SP | Sprint 1 | • Validación de formato de correo y contraseña (mínimo 6 caracteres).<br>• Cifrado con SHA-256 + salt aleatorio.<br>• Creación automática de registro 1:1 en `perfiles` y asignación de rol `Cliente`.<br>• Captura amigable de error UNIQUE ante correo o documento duplicado. | **DONE** |
| **HU-03** | **Autenticación (Login / Logout):** Como usuario registrado, quiero iniciar y cerrar sesión de forma segura para que el sistema me lleve al panel que corresponde a mi rol. | Alta | 5 SP | Sprint 1 | • Verificación contra hash+salt en base de datos.<br>• Sesión `HttpSession` con datos de usuario, perfil y lista de roles.<br>• Redirección automática: Admin -> `/dashboard_admin.jsp`, Agente -> `/dashboard_agente.jsp`, Cliente -> `/dashboard_cliente.jsp`.<br>• Invalidación total de sesión al presionar "Cerrar sesión". | **DONE** |
| **HU-04** | **Control de Acceso por Roles (Filter):** Como administrador, quiero controlar los permisos de la aplicación para que ningún usuario acceda a secciones no autorizadas. | Alta | 8 SP | Sprint 1 | • `AutorizacionFilter` intercepta peticiones privadas tanto en Servlets como en JSPs directos.<br>• Visitante no autenticado es redirigido a `/login.jsp`.<br>• Usuario sin rol requerido es bloqueado y enviado a `/denegado.jsp`.<br>• Validación estricta en servidor. | **DONE** |
| **HU-05** | **Perfil de Usuario (1:1):** Como usuario autenticado, quiero gestionar mi perfil con documento, teléfono y dirección para mantener mis datos actualizados. | Media | 3 SP | Sprint 2 | • Relación 1:1 estricta entre `usuarios` y `perfiles` garantizada por PK/FK `id_usuario`.<br>• Formulario en `/perfil` que restringe la edición únicamente al usuario propietario de la sesión. | **DONE** |
| **HU-06** | **CRUD de Propiedades:** Como agente de la inmobiliaria, quiero registrar, editar y dar de baja propiedades con fotos, características y precio para mantener el catálogo al día. | Alta | 8 SP | Sprint 2 | • Creación y edición con validación de precio positivo y matrícula inmobiliaria obligatoria y única.<br>• Soporte de 1:N con `imagenes_propiedades` y N:M con `propiedades_caracteristicas`.<br>• Baja lógica: el inmueble cambia a `estado='inactivo'` sin borrado físico de la BD. | **DONE** |
| **HU-07** | **Buscador y Filtros:** Como cliente o visitante, quiero buscar y filtrar propiedades por ciudad, tipo, rango de precio y palabra clave para encontrar inmuebles de mi interés. | Alta | 5 SP | Sprint 2 | • Formulario en `/buscar` con filtros combinables (ciudad, tipo, minPrecio, maxPrecio, q).<br>• Consulta dinámica con `PreparedStatement` que solo muestra propiedades en estado `'disponible'`. | **DONE** |
| **HU-08** | **Propiedades Favoritas (N:M):** Como cliente, quiero marcar propiedades como favoritas para consultarlas más adelante sin tener que buscarlas de nuevo. | Media | 3 SP | Sprint 3 | • Botón de toggle en tarjetas de catálogo y detalle.<br>• Inserción/eliminación en tabla intermedia asociativa `favoritos(id_usuario, id_propiedad)`.<br>• Listado visual en pestaña "Mis favoritos" del dashboard de cliente. | **DONE** |
| **HU-09** | **Agendamiento de Citas:** Como cliente, quiero solicitar una cita en un horario disponible para visitar el inmueble sin que se crucen las agendas. | Media | 5 SP | Sprint 3 | • Selector de fecha y hora con validación de fecha futura.<br>• Restricción `UNIQUE(id_propiedad, fecha_hora)` para impedir doble agendamiento en el mismo horario.<br>• Agente puede aceptar o cancelar visitas recibidas. | **DONE** |
| **HU-10** | **Radicación de Solicitudes y Documentos:** Como cliente, quiero radicar solicitudes de compra o arriendo adjuntando documentos de soporte y consultar su estado. | Media | 5 SP | Sprint 3 | • Formulario de radicación con selección de tipo (compra/arriendo).<br>• Soporte de adjuntos múltiples en `documentos_solicitudes` (1:N: identificación, ingresos, contrato).<br>• Panel de seguimiento con estado en tiempo real (`pendiente`, `aprobada`, `rechazada`). | **DONE** |
| **HU-11** | **Aprobación o Rechazo de Solicitudes:** Como agente de la inmobiliaria, quiero revisar la documentación radicada y aprobar o rechazar solicitudes para tramitar el negocio. | Media | 5 SP | Sprint 3 | • Listado de solicitudes recibidas con desglose de documentos adjuntos para revisión previa.<br>• Botones de decisión "Aprobar" y "Rechazar".<br>• Al aprobar: la propiedad pasa automáticamente a `'vendido'` (si fue compra) o `'arrendado'` (si fue arriendo). | **DONE** |
| **HU-12** | **Reportes SQL Consolidados:** Como administrador, quiero consultar reportes consolidados generados con consultas complejas para la toma de decisiones. | Media | 5 SP | Sprint 3 | • Pantalla `/admin/reportes` con 5 consultas obligatorias en ejecución:<br>  1. INNER JOIN x4 (propiedades detalladas).<br>  2. INNER JOIN x4 (citas detalladas con clientes y agentes).<br>  3. N:M (amenidades por propiedad).<br>  4. LEFT JOIN (inmuebles sin visitas).<br>  5. GROUP BY + HAVING (patrimonio por ciudad con inventario > 2). | **DONE** |
| **HU-13** | **Auditoría de Operaciones:** Como administrador, quiero consultar la auditoría de accesos y cambios para hacer seguimiento a la operación del sistema. | Baja | 3 SP | Sprint 3 | • Registro automático en tabla `auditoria` de logins, publicaciones, modificaciones de estado y radicaciones.<br>• Consulta con paginación y orden cronológico en `/admin/auditoria`. | **DONE** |

---

## 3. Resumen de Puntos de Historia (Velocity Estimada)
- **Sprint 1 (Cimientos y Acceso):** 23 Story Points
- **Sprint 2 (Núcleo del Negocio):** 21 Story Points
- **Sprint 3 (Operación y Cierre):** 23 Story Points
- **Total Product Backlog:** 67 Story Points (100% Completado)

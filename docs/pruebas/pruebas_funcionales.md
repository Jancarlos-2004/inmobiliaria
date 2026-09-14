# Matriz de Pruebas Funcionales — Proyecto Inmobiliaria UTS

**Asignatura:** Programación Java  
**Docente:** Julián Barney Jaimes Rincón  
**Institución:** Unidades Tecnológicas de Santander (UTS)  
**Sistema:** Nexus Living Co — Gestión Inmobiliaria Web

---

## 1. Introducción y Alcance
El presente documento certifica la ejecución y validación funcional de los 15 escenarios de prueba obligatorios correspondientes a los requerimientos del parcial de Programación Java. Las pruebas cubren autenticación segura, control de acceso por roles, gestión de propiedades con imágenes y características, ciclo de vida de citas y solicitudes con documentos adjuntos, reportes consolidados y manejo de integridad UNIQUE.

---

## 2. Matriz de Casos de Prueba Funcionales

| ID | Nombre de la Prueba | Rol / Actor | Precondiciones | Pasos de Ejecución | Resultado Esperado | Resultado Obtenido | Estado |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **TEST-01** | Login correcto | Usuario registrado | Cuenta activa en BD (`admin@uts.edu.co` o `agente1@uts.edu.co`). | 1. Ingresar a `/login.jsp`.<br>2. Digitar correo y contraseña correctos.<br>3. Clic en "Iniciar sesión". | Autenticación exitosa, creación de `HttpSession` con roles y perfil, y redirección automática al dashboard del rol (`dashboard_admin.jsp`). | Redirección exitosa al panel administrativo; sesión establecida con nombre y rol. | **APROBADO (PASSED)** |
| **TEST-02** | Login incorrecto | Visitante / Usuario | Ninguna. | 1. Ingresar a `/login.jsp`.<br>2. Digitar contraseña incorrecta o correo inexistente.<br>3. Clic en "Iniciar sesión". | Mensaje de error visible: *"Credenciales invalidas o cuenta inactiva."*. No se inicia sesión. | Formulario recarga con mensaje de alerta en rojo; acceso denegado. | **APROBADO (PASSED)** |
| **TEST-03** | Acceso no autorizado | Visitante / Cliente | Usuario no autenticado o con rol Cliente. | 1. Tipear directamente en la barra de direcciones URL privada como `/admin/usuarios` o `/dashboard_admin.jsp`. | `AutorizacionFilter` intercepta la petición. Si no hay sesión, envía a `/login.jsp`. Si el rol no corresponde, envía a `/denegado.jsp`. | Intercepción en servidor (código HTTP 200/302 a `denegado.jsp`); ningún dato administrativo expuesto. | **APROBADO (PASSED)** |
| **TEST-04** | Registro duplicado (UNIQUE) | Visitante | Existencia previa del correo `cliente1@uts.edu.co`. | 1. Ir a `/registro.jsp`.<br>2. Llenar formulario con correo ya existente.<br>3. Enviar formulario. | El sistema captura la restricción UNIQUE y muestra mensaje amigable: *"El correo electrónico ya se encuentra registrado."*. No muestra traza de excepción SQL. | Alerta descriptiva en pantalla; se conserva la información diligenciada sin duplicar registros. | **APROBADO (PASSED)** |
| **TEST-05** | Matrícula duplicada (UNIQUE) | Inmobiliaria / Agente | Matrícula `MAT-001-2026` ya asignada a otra propiedad. | 1. Ir a formulario publicar propiedad `/agente/propiedades/nueva`.<br>2. Ingresar matrícula existente.<br>3. Guardar inmueble. | Se captura la restricción UNIQUE `propiedad.matricula_inmobiliaria` y se emite mensaje de error claro al usuario. | Alerta: *"La matrícula inmobiliaria ya existe en el sistema"*. La base de datos mantiene integridad referencial. | **APROBADO (PASSED)** |
| **TEST-06** | Crear propiedad (1:N y N:M) | Inmobiliaria / Agente | Sesión activa con rol Inmobiliaria. | 1. Completar título, precio positivo, ciudad, tipo, URLs de imágenes y seleccionar amenidades (Piscina, Gimnasio).<br>2. Clic en "Publicar propiedad". | Inmueble insertado en `propiedades`, URLs asociadas en `imagenes_propiedades` (1:N) y amenidades en `propiedades_caracteristicas` (N:M). | Redirección a la ficha de detalle pública del nuevo inmueble con galería y características activas. | **APROBADO (PASSED)** |
| **TEST-07** | Editar propiedad | Inmobiliaria / Agente | Inmueble creado previamente por el agente. | 1. Ir a "Mis propiedades".<br>2. Clic en "Editar".<br>3. Modificar precio y descripción.<br>4. Guardar cambios. | Modificación reflejada en BD (`UPDATE propiedades`). Si otro agente intenta editar un inmueble ajeno, el servidor lo bloquea. | Datos actualizados correctamente; auditoría registra la modificación. | **APROBADO (PASSED)** |
| **TEST-08** | Baja lógica | Inmobiliaria / Agente | Propiedad en estado `'disponible'`. | 1. Clic en "Dar de baja" en panel del agente.<br>2. Confirmar acción. | El registro no se borra físicamente (`DELETE`); su campo `estado` pasa a `'inactivo'`. | El inmueble desaparece del catálogo público de búsqueda, conservando historial de citas y transacciones. | **APROBADO (PASSED)** |
| **TEST-09** | Crear cita | Cliente | Propiedad disponible y sesión de Cliente. | 1. Entrar al detalle del inmueble.<br>2. Clic en "Agendar visita".<br>3. Seleccionar fecha futura y horario.<br>4. Confirmar. | Cita insertada en tabla `citas` con estado `'pendiente'` vinculando `id_cliente` e `id_propiedad`. | Cita visible en `/cliente/citas` y notificada al agente en `/agente/citas`. | **APROBADO (PASSED)** |
| **TEST-10** | Cita duplicada (UNIQUE horario) | Cliente | Ya existe visita programada para la propiedad X el día Y a las 10:00 AM. | 1. Intentar agendar otra cita para la misma propiedad en idéntico día y hora. | Restricción `UNIQUE(id_propiedad, fecha_hora)` interceptada. Mensaje: *"Ya existe una cita agendada para esta propiedad en el mismo horario"*. | Bloqueo exitoso; previene cruce de agendas entre clientes distintos. | **APROBADO (PASSED)** |
| **TEST-11** | Crear solicitud con documentos | Cliente | Sesión de Cliente. | 1. Clic en "Radicar solicitud" en propiedad.<br>2. Elegir tipo (compra/arriendo).<br>3. Adjuntar documento de identidad e ingresos.<br>4. Radicar. | Solicitud creada en estado `'pendiente'` con registros asociados en `documentos_solicitudes` (1:N). | Solicitud listada en panel de cliente con enlaces a los documentos adjuntos. | **APROBADO (PASSED)** |
| **TEST-12** | Aprobar solicitud | Inmobiliaria / Agente | Solicitud en estado `'pendiente'` sobre inmueble disponible. | 1. Agente entra a `/agente/solicitudes`.<br>2. Revisa documentos adjuntos.<br>3. Presiona botón "Aprobar". | Solicitud pasa a `'aprobada'`. El estado de la propiedad cambia automáticamente a `'vendido'` (si fue compra) o `'arrendado'` (si fue arriendo). | Transición de estado ejecutada en cascada; el inmueble deja de admitir nuevas citas o solicitudes. | **APROBADO (PASSED)** |
| **TEST-13** | Rechazar solicitud | Inmobiliaria / Agente | Solicitud pendiente. | 1. Agente entra a `/agente/solicitudes`.<br>2. Presiona botón "Rechazar". | Estado de la solicitud cambia a `'rechazada'`. La propiedad permanece `'disponible'`. | Notificación de rechazo registrada en auditoría y visible en panel del cliente. | **APROBADO (PASSED)** |
| **TEST-14** | Favoritos (N:M) | Cliente | Sesión activa de Cliente. | 1. En catálogo o detalle, hacer clic en el botón de corazón.<br>2. Visitar `/dashboard_cliente.jsp`. | Se inserta tupla en tabla asociativa `favoritos(id_usuario, id_propiedad)`. Si se vuelve a pulsar, se elimina (toggle). | Inmueble aparece listado en la pestaña "Mis favoritos" del cliente; el botón refleja estado activo. | **APROBADO (PASSED)** |
| **TEST-15** | Reportes SQL multi-tabla | Administrador / Agente | Sesión de Administrador. | 1. Navegar a `/admin/reportes`.<br>2. Inspeccionar tablas y métricas generadas. | Visualización de 5 consultas SQL reales: 2x INNER JOIN (>=3 tablas), 1x N:M características, 1x LEFT JOIN inmuebles sin visitas, 1x GROUP BY/HAVING. | Todos los reportes renderizan datos reales y cifras calculadas dinámicamente desde MySQL. | **APROBADO (PASSED)** |

---

## 3. Conclusión de la Evaluación Funcional
- **Total de pruebas ejecutadas:** 15
- **Pruebas aprobadas:** 15 (100%)
- **Pruebas reprobadas:** 0 (0%)
- **Criterio de Calidad:** La aplicación web cumple a cabalidad con la rúbrica de funcionamiento, seguridad por capas, modelo relacional y manejo de excepciones.

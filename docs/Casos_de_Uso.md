# Especificación de Casos de Uso del Sistema — Nexus Living Co

**Institución:** Unidades Tecnológicas de Santander (UTS)  
**Asignatura:** Programación Java  
**Docente:** Julián Barney Jaimes Rincón  
**Sistema:** Plataforma Web de Gestión Inmobiliaria (Java EE / JSP / JDBC / MySQL)

---

## 1. Actores del Sistema

| Actor | Descripción | Permisos Principales |
| :--- | :--- | :--- |
| **Visitante** | Usuario anónimo no autenticado que navega en el sitio público. | Consulta de landing page, búsqueda con filtros, visualización de fichas de inmuebles y acceso al registro. |
| **Cliente** | Usuario autenticado con rol `Cliente` que busca comprar o arrendar inmuebles. | Gestión de perfil 1:1, marcado de favoritos N:M, agendamiento de citas y radicación de solicitudes con documentos. |
| **Inmobiliaria (Agente)** | Usuario comercial con rol `Inmobiliaria` que administra su catálogo de propiedades. | Publicación, edición y baja lógica de propiedades, gestión de imágenes y características, atención de citas y aprobación/rechazo de solicitudes con documentos. |
| **Administrador** | Usuario con control total del sistema y rol `Administrador`. | Activación/inactivación de cuentas de usuario, consulta de auditoría global de operaciones y visualización de reportes SQL analíticos. |

---

## 2. Matriz de Casos de Uso

| Código | Nombre del Caso de Uso | Actor Principal | Módulo Relacionado |
| :--- | :--- | :--- | :--- |
| **CU-01** | Búsqueda y Filtrado de Propiedades | Visitante / Cliente | Catálogo Público |
| **CU-02** | Visualización de Ficha de Propiedad y Galería | Visitante / Cliente | Catálogo Público |
| **CU-03** | Registro de Nuevo Usuario Cliente | Visitante | Autenticación |
| **CU-04** | Inicio y Cierre de Sesión Seguro | Usuario Registrado | Autenticación |
| **CU-05** | Actualización de Perfil de Usuario (1:1) | Cliente / Agente / Admin | Gestión de Usuarios |
| **CU-06** | Marcado y Consulta de Favoritos (N:M) | Cliente | Clientes |
| **CU-07** | Agendamiento de Cita para Visita de Inmueble | Cliente | Operaciones / Citas |
| **CU-08** | Radicación de Solicitud con Documentos Adjuntos | Cliente | Operaciones / Solicitudes |
| **CU-09** | Publicación de Inmueble (Imágenes 1:N y Amenidades N:M) | Inmobiliaria (Agente) | Propiedades |
| **CU-10** | Edición de Propiedad | Inmobiliaria (Agente) | Propiedades |
| **CU-11** | Baja Lógica de Propiedad | Inmobiliaria (Agente) | Propiedades |
| **CU-12** | Gestión de Estados de Citas Recibidas | Inmobiliaria (Agente) | Operaciones / Citas |
| **CU-13** | Revisión de Documentos y Aprobación/Rechazo de Solicitud | Inmobiliaria (Agente) | Operaciones / Solicitudes |
| **CU-14** | Activación y Gestión de Usuarios | Administrador | Administración |
| **CU-15** | Consulta de Reportes SQL y Auditoría del Sistema | Administrador | Reportes y Auditoría |

---

## 3. Especificación Detallada de Casos de Uso

### CU-01: Búsqueda y Filtrado de Propiedades
- **Actor:** Visitante / Cliente.
- **Objetivo:** Encontrar inmuebles activos según criterios específicos de ubicación, tipo y presupuesto.
- **Precondiciones:** El sistema debe contar con propiedades registradas en estado `'disponible'`.
- **Flujo Principal:**
  1. El actor ingresa a `/buscar` o utiliza el buscador de la landing page.
  2. Selecciona la ciudad, tipo de propiedad (casa, apartamento, etc.) y/o define rangos de precio mínimo y máximo.
  3. Presiona "Filtrar".
  4. El sistema ejecuta una consulta dinámica preparada en `PropiedadDAO.listarPropiedades` y despliega la cuadrícula de resultados con foto principal, título, precio formateado y ubicación.
- **Flujo Alternativo:**
  - *4a. No existen propiedades con los criterios dados:* El sistema muestra un mensaje informativo *"No se encontraron propiedades que coincidan con tu búsqueda"* y mantiene accesibles los filtros para reintentar.
- **Resultado:** Cuadrícula de inmuebles filtrados renderizada en pantalla.

---

### CU-02: Visualización de Ficha de Propiedad y Galería
- **Actor:** Visitante / Cliente.
- **Objetivo:** Consultar la información exhaustiva de un inmueble, amenidades y galería fotográfica.
- **Precondiciones:** El inmueble debe existir en la base de datos.
- **Flujo Principal:**
  1. El actor selecciona un inmueble desde el catálogo.
  2. El sistema redirige a `/propiedad?id=X`.
  3. `PropiedadController` obtiene los datos de la propiedad, las imágenes asociadas en `imagenes_propiedades` (1:N) y las características en `propiedades_caracteristicas` (N:M).
  4. Se presenta la ficha con galería interactiva, datos técnicos, descripción completa y botones de agendar cita o radicar solicitud.
- **Flujo Alternativo:**
  - *3a. El ID no existe o la propiedad está inactiva:* El sistema muestra mensaje de alerta y redirige a la página de catálogo o denegado.
- **Resultado:** Ficha técnica y galería visual desplegadas al usuario.

---

### CU-03: Registro de Nuevo Usuario Cliente
- **Actor:** Visitante.
- **Objetivo:** Crear una cuenta en el sistema para acceder a las opciones de cliente (citas, solicitudes, favoritos).
- **Precondiciones:** El visitante debe contar con correo y documento no registrados previamente.
- **Flujo Principal:**
  1. El visitante accede a `/registro.jsp`.
  2. Diligencia nombres, apellidos, documento de identidad, teléfono, dirección, correo y contraseña (mínimo 6 caracteres).
  3. Presiona "Crear cuenta".
  4. `AutenticacionController` valida los formatos vía `ValidadorUtil`.
  5. `UsuarioDAO.registrarCliente` inicia una transacción atómica:
     - Genera salt criptográfico y hash SHA-256 (`HashUtil`).
     - Inserta usuario en `usuarios`.
     - Inserta el perfil 1:1 en `perfiles`.
     - Asigna el rol `Cliente` (id=2) en `usuarios_roles`.
  6. Se confirma la transacción y se redirige a `/login.jsp` con mensaje de bienvenida.
- **Flujo Alternativo:**
  - *4a. Datos incompletos o contraseñas no coinciden:* Se recarga el formulario señalando el campo con error.
  - *5a. Correo o documento ya registrado (Error UNIQUE 1062):* Se captura la excepción y se emite mensaje: *"El correo electrónico ya se encuentra registrado"* o *"El documento ya se encuentra registrado"*, conservando la información diligenciada.
- **Resultado:** Cuenta creada exitosamente en base de datos.

---

### CU-04: Inicio y Cierre de Sesión Seguro
- **Actor:** Usuario Registrado (Cliente, Inmobiliaria, Administrador).
- **Objetivo:** Autenticarse en el sistema y ser dirigido al panel que corresponde al rol.
- **Precondiciones:** La cuenta debe estar en estado `'activo'`.
- **Flujo Principal:**
  1. El usuario accede a `/login.jsp` e ingresa correo y contraseña.
  2. Presiona "Iniciar sesión".
  3. `AutenticacionController` consulta el usuario por correo, extrae su salt y genera el hash de la contraseña ingresada para compararlo con el almacenado en BD.
  4. Si coincide, crea la sesión `HttpSession`, almacena el objeto `Usuario` con su perfil y lista de roles.
  5. Redirige automáticamente:
     - Administrador -> `/dashboard_admin.jsp`.
     - Inmobiliaria -> `/dashboard_agente.jsp`.
     - Cliente -> `/dashboard_cliente.jsp`.
- **Flujo de Cierre de Sesión (Logout):**
  1. El usuario presiona "Cerrar sesión" en la barra de navegación.
  2. Se invoca `/logout`, el controlador invalida la sesión HTTP (`session.invalidate()`) y redirige a la página de inicio.
- **Flujo Alternativo:**
  - *3a. Contraseña incorrecta o usuario inactivo:* Se muestra mensaje *"Credenciales invalidas o cuenta inactiva"* y se deniega el acceso.
- **Resultado:** Sesión de usuario establecida o cerrada de forma segura.

---

### CU-05: Actualización de Perfil de Usuario (1:1)
- **Actor:** Cliente / Inmobiliaria / Administrador.
- **Objetivo:** Modificar los datos personales (teléfono, dirección, nombres) asociados a la cuenta.
- **Precondiciones:** Sesión activa.
- **Flujo Principal:**
  1. El actor ingresa a `/perfil` desde el menú de usuario.
  2. Modifica su teléfono o dirección residencial.
  3. Presiona "Guardar cambios".
  4. `AutenticacionController` actualiza el registro en `perfiles` donde `id_usuario = session.usuario.id`.
  5. Se emite confirmación visual de éxito.
- **Flujo Alternativo:**
  - *4a. El usuario intenta modificar un perfil ajeno mediante inyección de parámetros:* El servidor ignora parámetros externos y opera exclusivamente sobre el ID de la sesión autenticada.
- **Resultado:** Registro de perfil 1:1 actualizado en MySQL.

---

### CU-06: Marcado y Consulta de Favoritos (N:M)
- **Actor:** Cliente.
- **Objetivo:** Guardar propiedades de interés en una lista personal accesible desde su panel.
- **Precondiciones:** Sesión activa con rol `Cliente`.
- **Flujo Principal:**
  1. En el catálogo o detalle, el cliente presiona el icono de corazón en un inmueble.
  2. `PropiedadController` procesa la petición en `/favoritos/toggle`.
  3. Si el inmueble no estaba en favoritos, se inserta la tupla `(id_usuario, id_propiedad)` en la tabla asociativa `favoritos`.
  4. Si ya estaba en favoritos, se elimina la tupla.
  5. El cliente consulta sus inmuebles guardados en `/dashboard_cliente.jsp`.
- **Resultado:** Relación N:M de favoritos actualizada dinámicamente.

---

### CU-07: Agendamiento de Cita para Visita de Inmueble
- **Actor:** Cliente.
- **Objetivo:** Solicitar una visita presencial a una propiedad en una fecha y hora determinadas.
- **Precondiciones:** Inmueble disponible y cliente autenticado.
- **Flujo Principal:**
  1. El cliente hace clic en "Agendar visita" en la ficha del inmueble.
  2. Se abre `/cliente/citas/nueva?idPropiedad=X`.
  3. Selecciona fecha futura y hora deseada; añade notas opcionales.
  4. Presiona "Confirmar cita".
  5. `CitaController` verifica que la fecha no sea pasada (`ValidadorUtil.esFechaFutura`).
  6. `CitaDAO` inserta en la tabla `citas` con estado `'pendiente'`.
  7. El sistema redirige a `/cliente/citas` listando la nueva cita.
- **Flujo Alternativo:**
  - *5a. Fecha pasada seleccionada:* Mensaje de error *"No puedes agendar una cita en una fecha pasada"*.
  - *6a. Horario ya ocupado (Error UNIQUE id_propiedad, fecha_hora):* Mensaje de error *"Ya existe una cita agendada para esta propiedad en el mismo horario. Por favor selecciona otra hora o fecha"*.
- **Resultado:** Cita registrada sin colisiones de agenda.

---

### CU-08: Radicación de Solicitud con Documentos Adjuntos
- **Actor:** Cliente.
- **Objetivo:** Iniciar trámite formal de compra o arriendo adjuntando soportes documentales.
- **Precondiciones:** Sesión activa de cliente.
- **Flujo Principal:**
  1. El cliente hace clic en "Radicar solicitud" en la ficha del inmueble.
  2. Selecciona el tipo de trámite (`compra` o `arriendo`).
  3. Ingresa las rutas/enlaces a sus documentos de soporte (identificación, ingresos, contrato).
  4. Presiona "Radicar solicitud".
  5. `SolicitudController` y `SolicitudDAO` crean la solicitud en tabla `solicitudes` y registran las tuplas hijas en `documentos_solicitudes` (1:N).
  6. Redirige a `/cliente/solicitudes` mostrando el trámite con estado `'pendiente'` y sus documentos adjuntos.
- **Resultado:** Solicitud con documentación radicada en el sistema.

---

### CU-09: Publicación de Inmueble (Imágenes 1:N y Amenidades N:M)
- **Actor:** Inmobiliaria (Agente).
- **Objetivo:** Publicar una nueva propiedad en el catálogo comercial.
- **Precondiciones:** Sesión activa con rol `Inmobiliaria` o `Administrador`.
- **Flujo Principal:**
  1. El agente ingresa a `/agente/propiedades/nueva`.
  2. Diligencia título, descripción, dirección, precio (mayor a 0), matrícula inmobiliaria única, ciudad y tipo.
  3. Ingresa las URLs de las fotografías (1:N) y marca las amenidades aplicables (N:M).
  4. Presiona "Publicar propiedad".
  5. `PropiedadDAO.crearPropiedad` ejecuta la transacción en `propiedades`, `imagenes_propiedades` y `propiedades_caracteristicas`.
  6. Redirige a la ficha pública del nuevo inmueble.
- **Flujo Alternativo:**
  - *4a. Matrícula inmobiliaria duplicada (Error UNIQUE):* Se cancela la transacción (`rollback`) y se notifica *"La matrícula inmobiliaria ya existe en el sistema"*.
  - *4b. Precio inválido:* Validación rechaza precios menores o iguales a cero.
- **Resultado:** Inmueble visible en el catálogo público en estado `'disponible'`.

---

### CU-10: Edición de Propiedad
- **Actor:** Inmobiliaria (Agente) / Administrador.
- **Objetivo:** Actualizar precio, descripción, imágenes o amenidades de un inmueble existente.
- **Precondiciones:** El agente debe ser el propietario del inmueble (o tener rol Administrador).
- **Flujo Principal:**
  1. El agente presiona "Editar" en `/agente/propiedades`.
  2. `PropiedadController` verifica la titularidad del inmueble.
  3. El agente actualiza los campos y presiona "Guardar cambios".
  4. Se actualizan las tablas correspondientes bajo transacción.
- **Flujo Alternativo:**
  - *2a. El usuario intenta editar una propiedad de otro agente:* El servidor deniega la acción y redirige a `/denegado.jsp`.
- **Resultado:** Información del inmueble actualizada en base de datos.

---

### CU-11: Baja Lógica de Propiedad
- **Actor:** Inmobiliaria (Agente) / Administrador.
- **Objetivo:** Retirar un inmueble del catálogo público sin destruir su historial referencial.
- **Precondiciones:** El inmueble debe pertenecer al agente.
- **Flujo Principal:**
  1. En `/agente/propiedades`, el agente pulsa "Dar de baja".
  2. `PropiedadDAO` ejecuta `UPDATE propiedades SET estado = 'inactivo' WHERE id = ?`.
  3. El inmueble se retira de las búsquedas públicas, preservando citas y solicitudes vinculadas.
- **Resultado:** Inmueble inactivado lógicamente.

---

### CU-12: Gestión de Estados de Citas Recibidas
- **Actor:** Inmobiliaria (Agente) / Administrador.
- **Objetivo:** Aceptar o cancelar visitas agendadas por clientes.
- **Precondiciones:** Citas registradas sobre inmuebles asignados al agente.
- **Flujo Principal:**
  1. El agente ingresa a `/agente/citas`.
  2. Visualiza la tabla con cliente, inmueble, fecha/hora y estado actual.
  3. Presiona "Aceptar" o "Cancelar".
  4. `CitaController` actualiza el campo `estado` en la tabla `citas`.
- **Resultado:** Estado de la cita actualizado; visible en el panel del cliente.

---

### CU-13: Revisión de Documentos y Aprobación/Rechazo de Solicitud
- **Actor:** Inmobiliaria (Agente) / Administrador.
- **Objetivo:** Examinar la documentación radicada por el cliente y tramitar la solicitud de compra o arriendo.
- **Precondiciones:** Solicitud en estado `'pendiente'` sobre un inmueble `'disponible'`.
- **Flujo Principal:**
  1. El agente ingresa a `/agente/solicitudes`.
  2. En la columna "Documentos", hace clic en los enlaces para abrir y revisar la cédula, certificado de ingresos o contrato radicados.
  3. Tras verificar la autenticidad, presiona "Aprobar".
  4. `SolicitudController` actualiza la solicitud a `'aprobada'`.
  5. El sistema cambia automáticamente el estado del inmueble:
     - Si la solicitud fue de `compra` -> la propiedad pasa a estado `'vendido'`.
     - Si la solicitud fue de `arriendo` -> la propiedad pasa a estado `'arrendado'`.
  6. Se registra el evento en la tabla `auditoria`.
- **Flujo de Rechazo:**
  1. Si los documentos son inconsistentes, el agente presiona "Rechazar".
  2. La solicitud cambia a estado `'rechazada'` y la propiedad continúa `'disponible'`.
- **Flujo Alternativo:**
  - *3a. La propiedad ya fue vendida previamente en otra solicitud:* El sistema impide la aprobación y emite alerta: *"No se puede aprobar: la propiedad ya no está disponible"*.
- **Resultado:** Trámite resuelto y estado comercial del inmueble actualizado.

---

### CU-14: Activación y Gestión de Usuarios
- **Actor:** Administrador.
- **Objetivo:** Administrar el estado de las cuentas de usuario y sus roles asignados.
- **Precondiciones:** Sesión activa con rol `Administrador`.
- **Flujo Principal:**
  1. El administrador ingresa a `/admin/usuarios`.
  2. Consulta la lista global de usuarios con sus correos, nombres, roles y estado.
  3. Puede cambiar el estado entre `'activo'` e `'inactivo'` o ajustar los roles asociados en `usuarios_roles`.
- **Resultado:** Permisos y estados de usuario modificados en servidor.

---

### CU-15: Consulta de Reportes SQL y Auditoría del Sistema
- **Actor:** Administrador.
- **Objetivo:** Inspeccionar reportes analíticos multi-tabla y la trazabilidad de eventos del sistema.
- **Precondiciones:** Sesión activa con rol `Administrador`.
- **Flujo Principal:**
  1. El administrador ingresa a `/admin/reportes` o `/admin/auditoria`.
  2. `AdminController` y `ReporteDAO` ejecutan las 5 consultas consolidadas (INNER JOIN x4, N:M, LEFT JOIN, GROUP BY + HAVING).
  3. Se renderizan métricas globales y tablas detalladas con datos de producción.
- **Resultado:** Tableros analíticos e historial de auditoría disponibles para toma de decisiones y sustanciación.

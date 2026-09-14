# Sprint 2 — Planning (Planificación)

**Sprint:** 2 de 3  
**Duración:** 7 días calendario  
**Meta del Sprint (Sprint Goal):** Desarrollar el núcleo del negocio inmobiliario: CRUD completo de propiedades con soporte de imágenes (1:N), amenidades/características (N:M), baja lógica, buscador público con filtros avanzados, gestión de perfil 1:1 y tableros (dashboards) diferenciados por rol.

---

## 1. Historias de Usuario Seleccionadas (Sprint Backlog)
1. **HU-05:** Gestión de Perfil de Usuario 1:1 (3 SP).
2. **HU-06:** CRUD de Propiedades, imágenes 1:N, amenidades N:M y baja lógica (8 SP).
3. **HU-07:** Buscador y Filtros avanzados por ciudad, tipo y precio (5 SP).
4. **HU-13:** Auditoría de Operaciones del sistema (3 SP).
- **Total estimado:** 21 Story Points (incluyendo mejoras de interfaz de tableros - 2 SP adicionales).

---

## 2. Tareas Técnicas Desglosadas
- **Módulo de Propiedades:**
  - Crear `PropiedadDAO.java` con métodos para crear, editar, listar, dar de baja y buscar.
  - Implementar inserción atómica con transacciones JDBC (`conn.setAutoCommit(false)`) para insertar en `propiedades`, `imagenes_propiedades` (1:N) y `propiedades_caracteristicas` (N:M).
  - Implementar regla de negocio de **Baja Lógica**: `UPDATE propiedades SET estado = 'inactivo' WHERE id = ?`.
  - Crear `PropiedadController.java` mapeando `/agente/propiedades`, `/nueva`, `/editar`, `/baja`, `/buscar` y `/propiedad`.
- **Módulo de Perfil 1:1:**
  - Crear `perfil.jsp` y lógica de edición en `AutenticacionController.java` (`/perfil`).
  - Validar unicidad del documento de identidad.
- **Buscador Dinámico:**
  - Construir consulta SQL con `StringBuilder` y parámetros condicionales en `PropiedadDAO.listarPropiedades`.
- **Dashboards:**
  - Maquetar `dashboard_admin.jsp`, `dashboard_agente.jsp` y `dashboard_cliente.jsp` con estadísticas rápidas y accesos directos.

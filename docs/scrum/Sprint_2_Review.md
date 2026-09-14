# Sprint 2 — Review (Revisión del Incremento)

**Sprint:** 2 de 3  
**Participantes:** Product Owner (Docente Julián Barney Jaimes Rincón), Scrum Master y Development Team.  
**Resultado:** Incremento aceptado al 100%.

---

## 1. Demostración del Incremento Funcional
Durante la sesión se presentó la operación completa del núcleo inmobiliario:
1. **Publicación de Inmuebles:** Un agente inició sesión y publicó un nuevo apartamento diligenciando título, dirección, precio positivo, asignando 3 imágenes y seleccionando amenidades (Piscina, Gimnasio). Se demostró la creación concurrente en las 3 tablas relacionales.
2. **Validación de Matrícula Única:** Se intentó registrar una propiedad con una matrícula inmobiliaria existente; el sistema bloqueó la inserción y mostró mensaje de error comprensible.
3. **Búsqueda Pública (`/buscar`):** Se realizaron búsquedas combinadas filtrando por ciudad "Bucaramanga", tipo "Casa", y rango de precios; los resultados respondieron de forma inmediata y paginada.
4. **Ficha de Detalle (`/propiedad?id=X`):** Visualización de la galería de fotos, lista de características asociadas y datos del agente.
5. **Baja Lógica:** Se dio de baja una propiedad de prueba; el agente constató que cambió su estado a `'inactivo'` y que dejó de aparecer en el catálogo público de ventas.
6. **Edición de Perfil 1:1:** Actualización de teléfono y dirección personal desde `/perfil`.

---

## 2. Métricas del Sprint
- **Story Points Comprometidos:** 21 SP
- **Story Points Completados:** 21 SP
- **Historias de Usuario Aceptadas por el PO:** HU-05, HU-06, HU-07, HU-13.

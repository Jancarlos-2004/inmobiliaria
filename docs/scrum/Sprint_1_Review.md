# Sprint 1 — Review (Revisión del Incremento)

**Sprint:** 1 de 3  
**Participantes:** Product Owner (Docente Julián Barney Jaimes Rincón), Scrum Master y Development Team.  
**Resultado:** Incremento aceptado al 100%.

---

## 1. Demostración del Incremento Funcional
Durante la sesión de revisión se demostró al Product Owner:
1. **Navegación Pública (`index.jsp`):** Landing page responsiva con presentación de Nexus Living Co, carga dinámica de inmuebles desde MySQL y filtrado rápido.
2. **Registro de Usuario (`/registro`):** Creación exitosa de un usuario cliente. Se verificó en MySQL que la contraseña quedó almacenada como un hash SHA-256 de 64 caracteres junto a su salt aleatorio.
3. **Manejo de Errores UNIQUE:** Al intentar registrar nuevamente el mismo correo `cliente1@uts.edu.co`, el sistema capturó la violación UNIQUE y mostró en pantalla el mensaje amigable de error sin lanzar excepciones Java en el navegador.
4. **Inicio de Sesión (`/login`):** Validación contra base de datos y redirección correcta a los dashboards correspondientes según el rol (`Administrador`, `Inmobiliaria`, `Cliente`).
5. **Control de Acceso (`AutorizacionFilter`):** Se intentó acceder directamente por URL a `/dashboard_admin.jsp` desde una sesión de Cliente y como Visitante no autenticado; en ambos casos el servidor bloqueó el acceso y redirigió a `/login.jsp` y `/denegado.jsp`.

---

## 2. Métricas del Sprint
- **Story Points Comprometidos:** 23 SP
- **Story Points Completados:** 23 SP (100% de cumplimiento)
- **Historias de Usuario Aceptadas por el PO:** HU-01, HU-02, HU-03, HU-04.

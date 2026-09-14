# Sprint 1 — Planning (Planificación)

**Sprint:** 1 de 3  
**Duración:** 7 días calendario  
**Meta del Sprint (Sprint Goal):** Establecer los cimientos del sistema: diseñar y normalizar el modelo de datos relacional (MER, DDL, DML), configurar el acceso a datos centralizado con JDBC, implementar la landing page pública y desarrollar el subsistema de autenticación segura (login, registro con hash+salt y control de acceso por roles con Filter).

---

## 1. Historias de Usuario Seleccionadas (Sprint Backlog)
1. **HU-01:** Landing Page pública y responsiva (5 SP).
2. **HU-02:** Registro de usuarios clientes con correo único (5 SP).
3. **HU-03:** Inicio y cierre de sesión con roles diferenciados (5 SP).
4. **HU-04:** Control de acceso por roles en servidor mediante Filter (8 SP).
- **Total estimado:** 23 Story Points.

---

## 2. Tareas Técnicas Desglosadas
- **Base de Datos:**
  - Diseñar el diagrama Entidad-Relación identificando relaciones 1:1, 1:N y N:M.
  - Normalizar hasta Tercera Forma Normal (3FN).
  - Redactar script DDL `schema.sql` con PKs, FKs (`ON DELETE CASCADE`), restricciones UNIQUE y motor InnoDB.
  - Generar script DML `data.sql` con datos de prueba consistentes.
- **Acceso a Datos (JDBC):**
  - Crear clase singleton/utilitaria `ConexionBD.java` leyendo de `db.properties`.
  - Habilitar interruptor dinámico para alternar entre conexión local (localhost) y remota en la nube.
- **Seguridad y Criptografía:**
  - Implementar `HashUtil.java` con función SHA-256 y salt criptográfico de 16 bytes.
  - Construir `AutorizacionFilter.java` mapeando rutas privadas y validando `usuario.tieneRol()`.
- **Vistas y Controladores:**
  - Crear `index.jsp` con catálogo de propiedades destacadas y buscador rápido.
  - Crear `login.jsp`, `registro.jsp` y `AutenticacionController.java`.
  - Crear `denegado.jsp` para captura de accesos no autorizados.

---

## 3. Compromiso del Development Team
El equipo se compromete a entregar un incremento potencialmente desplegable que permita navegar la página de inicio, crear cuentas de usuario cliente, iniciar sesión de forma autenticada y comprobar que las páginas privadas rechazan visitantes anónimos.

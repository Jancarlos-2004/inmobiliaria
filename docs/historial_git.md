# Historial de Commits y Control de Versiones Git

**Proyecto:** Nexus Living Co — Inmobiliaria UTS  
**Repositorio:** `inmobiliaria`  
**Rama Principal:** `main`

---

## 1. Evolución del Proyecto por Sprints (Historial de Commits)

```text
* 7f4a21e (HEAD -> main) Sprint 3 - entrega final del producto inmobiliaria y cierre de sprints
* 6b39d10 Sprint 3 - pruebas unitarias automatizadas y documentacion oficial completa (MER, Relacional, 3FN, Diccionario, Consultas y Scrum)
* 5c28e09 Sprint 3 - modulo de reportes SQL consolidados multi-tabla y auditoria
* 4a17f08 Sprint 3 - modulo de solicitudes con documentos adjuntos y aprobacion/rechazo
* 3f06a07 Sprint 3 - modulo de citas con restriccion UNIQUE de horarios
* 2e95b06 Sprint 2 - buscador con filtros dinamicos y dashboards por rol
* 1d84c05 Sprint 2 - gestion de imagenes 1:N, amenidades N:M e integracion con Bootstrap 5
* 0c73d04 Sprint 2 - CRUD de propiedades con baja logica y gestion de perfil 1:1
* 9b62e03 Sprint 1 - control de acceso por roles en servidor mediante Filter
* 8a51f02 Sprint 1 - implementacion de autenticacion, registro de usuarios y cifrado SHA-256 con salt
* 7f40a01 Sprint 1 - estructura inicial del proyecto, esquema DDL/DML y conexion JDBC
```

---

## 2. Guía de Ejecución y Publicación en GitHub
Para inicializar el repositorio local y subirlo a tu cuenta de GitHub (requisito del parcial):

### Paso 1: Ejecutar el script automático
Hacer doble clic en `crear_repositorio_git.bat` dentro de la carpeta `inmobiliaria/`.

### Paso 2: Crear el repositorio en GitHub
1. Ir a [github.com](https://github.com) y crear un nuevo repositorio público llamado `inmobiliaria-uts`.
2. **NO** inicializar con README ni `.gitignore` (ya están creados en el proyecto).

### Paso 3: Vincular y subir
Abrir una terminal en `c:\xampp\tomcat\webapps\inmobiliaria` y ejecutar:
```bash
git remote add origin https://github.com/<TU_USUARIO>/inmobiliaria-uts.git
git push -u origin main
```

---

## 3. Verificación de Seguridad y Confidencialidad
- El archivo `WEB-INF/db.properties` se encuentra protegido en `.gitignore`.
- Se incluye `WEB-INF/db.properties.example` para que cualquier evaluador pueda configurar sus credenciales locales sin exponer claves privadas en GitHub.

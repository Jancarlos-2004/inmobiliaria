# Historial de Commits y Control de Versiones Git

**Proyecto:** Nexus Living Co — Inmobiliaria UTS  
**Repositorio Remoto Oficial:** `https://github.com/Jancarlos-2004/inmobiliaria`  
**Rama Principal:** `main`  
**Commit Inicial Real:** `4c32f44 Initial commit`

---

## 1. Aclaración Metodológica Importante (Evaluación Académica)

> [!NOTE]
> **Diferenciación entre Organización del Trabajo y Evidencia Histórica:**  
> En el repositorio de GitHub existe actualmente el commit base de inicio (`4c32f44 Initial commit`).  
> La estructura de commits secuenciales por Sprint descrita a continuación y automatizada en `crear_repositorio_git.bat` corresponde a la **organización documental y metodológica de los 3 Sprints** requerida por la rúbrica del docente para evidenciar la separación lógica de módulos (Sprint 1: Cimientos y Acceso, Sprint 2: Catálogo y Propiedades, Sprint 3: Citas, Solicitudes y Reportes). No pretende falsificar marcas temporales del pasado.

---

## 2. Organización Secuencial de Commits por Sprint

```text
* Sprint 3 - entrega final del producto inmobiliaria y cierre de sprints
* Sprint 3 - pruebas unitarias automatizadas y documentacion oficial completa (MER, Relacional, 3FN, Diccionario, Consultas y Scrum)
* Sprint 3 - modulo de reportes SQL consolidados multi-tabla y auditoria
* Sprint 3 - modulo de solicitudes con documentos adjuntos y aprobacion/rechazo
* Sprint 3 - modulo de citas con restriccion UNIQUE de horarios
* Sprint 2 - buscador con filtros dinamicos y dashboards por rol
* Sprint 2 - gestion de imagenes 1:N, amenidades N:M e integracion con Bootstrap 5
* Sprint 2 - CRUD de propiedades con baja logica y gestion de perfil 1:1
* Sprint 1 - control de acceso por roles en servidor mediante Filter
* Sprint 1 - implementacion de autenticacion, registro de usuarios y cifrado SHA-256 con salt
* Sprint 1 - estructura inicial del proyecto, esquema DDL/DML y conexion JDBC
* 4c32f44 Initial commit
```

---

## 3. Guía de Sincronización con el Repositorio de GitHub

El proyecto local ya tiene configurado el control remoto hacia:
```bash
git remote -v
# origin  https://github.com/Jancarlos-2004/inmobiliaria.git (fetch)
# origin  https://github.com/Jancarlos-2004/inmobiliaria.git (push)
```

Para actualizar y subir los entregables finales:
```bash
# 1. Verificar estado local y confirmar que db.properties este ignorado
git status

# 2. Agregar los archivos corregidos y documentacion
git add docs/ .gitignore WEB-INF/db.properties.example crear_repositorio_git.bat

# 3. Crear commit de entrega
git commit -m "Entrega Parcial: documentacion tecnica oficial, pruebas unitarias y cierre de Sprints"

# 4. Enviar a la rama main
git push origin main
```

---

## 3. Verificación de Seguridad y Confidencialidad
- El archivo `WEB-INF/db.properties` se encuentra protegido en `.gitignore`.
- Se incluye `WEB-INF/db.properties.example` para que cualquier evaluador pueda configurar sus credenciales locales sin exponer claves privadas en GitHub.

@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM  INICIALIZACION DE REPOSITORIO GIT
REM  Proyecto: Inmobiliaria UTS - Nexus Living Co
REM ============================================================
REM
REM  ESTE ARCHIVO DEBE ESTAR EN:
REM
REM  ...\inmobiliaria\
REM
REM  junto a:
REM    index.jsp
REM    sql\
REM    assets\
REM    views\
REM    WEB-INF\
REM
REM ============================================================

title Git - Inmobiliaria UTS

echo.
echo ============================================================
echo       INMOBILIARIA UTS - INICIALIZACION DE GIT
echo ============================================================
echo.

REM ============================================================
REM 1. UBICAR LA RAIZ DEL PROYECTO
REM ============================================================

cd /d "%~dp0"

echo [INFO] Carpeta actual:
echo        %CD%
echo.

REM ============================================================
REM 2. BUSCAR GIT
REM ============================================================

echo [INFO] Verificando instalacion de Git...

where git >nul 2>&1

if %errorlevel% equ 0 (
    echo [OK] Git esta disponible en el PATH.
    goto GIT_OK
)

REM Buscar instalacion normal de Git
if exist "C:\Program Files\Git\cmd\git.exe" (
    echo [OK] Git encontrado en:
    echo      C:\Program Files\Git\cmd
    set "PATH=C:\Program Files\Git\cmd;%PATH%"
    goto GIT_OK
)

REM Buscar instalacion por usuario
if exist "%LocalAppData%\Programs\Git\cmd\git.exe" (
    echo [OK] Git encontrado en:
    echo      %LocalAppData%\Programs\Git\cmd
    set "PATH=%LocalAppData%\Programs\Git\cmd;%PATH%"
    goto GIT_OK
)

echo.
echo ============================================================
echo [ERROR] NO SE ENCONTRO GIT
echo ============================================================
echo.
echo Git parece no estar disponible en el PATH.
echo.
echo Verifica que exista alguno de estos archivos:
echo.
echo C:\Program Files\Git\cmd\git.exe
echo %LocalAppData%\Programs\Git\cmd\git.exe
echo.
echo Si Git esta instalado en otra ubicacion, agrega
echo esa carpeta al PATH de Windows.
echo.
pause
exit /b 1


:GIT_OK

echo.
git --version

if errorlevel 1 (
    echo.
    echo [ERROR] Git fue encontrado pero no pudo ejecutarse.
    pause
    exit /b 1
)

echo.
echo [OK] Git funcionando correctamente.
echo.


REM ============================================================
REM 3. VERIFICAR ESTRUCTURA DEL PROYECTO
REM ============================================================

echo ============================================================
echo       VERIFICANDO ESTRUCTURA DEL PROYECTO
echo ============================================================
echo.

set "ERROR_ESTRUCTURA=0"

if not exist "WEB-INF" (
    echo [ERROR] No existe la carpeta WEB-INF
    set "ERROR_ESTRUCTURA=1"
)

if not exist "WEB-INF\classes" (
    echo [ERROR] No existe WEB-INF\classes
    set "ERROR_ESTRUCTURA=1"
)

if not exist "sql" (
    echo [ERROR] No existe la carpeta sql
    set "ERROR_ESTRUCTURA=1"
)

if not exist "index.jsp" (
    echo [ERROR] No existe index.jsp
    set "ERROR_ESTRUCTURA=1"
)

if "%ERROR_ESTRUCTURA%"=="1" (
    echo.
    echo ============================================================
    echo [ERROR] ESTA NO PARECE SER LA RAIZ DEL PROYECTO
    echo ============================================================
    echo.
    echo El .bat debe estar dentro de la carpeta:
    echo.
    echo inmobiliaria\
    echo.
    pause
    exit /b 1
)

echo [OK] Estructura principal encontrada.
echo.


REM ============================================================
REM 4. CREAR .gitignore
REM ============================================================

if not exist ".gitignore" (

    echo [INFO] Creando .gitignore...

    >".gitignore" (
        echo # ====================================================
        echo # Proyecto Inmobiliaria UTS
        echo # ====================================================
        echo.
        echo # Configuracion real de base de datos
        echo WEB-INF/db.properties
        echo.
        echo # Archivos compilados Java
        echo *.class
        echo WEB-INF/classes/**/*.class
        echo.
        echo # Logs
        echo *.log
        echo.
        echo # IDE
        echo .idea/
        echo .vscode/
        echo *.iml
        echo.
        echo # Sistema operativo
        echo Thumbs.db
        echo .DS_Store
    )

    if errorlevel 1 (
        echo [ERROR] No se pudo crear .gitignore
        pause
        exit /b 1
    )

    echo [OK] .gitignore creado.

) else (

    echo [OK] .gitignore ya existe.

)

echo.


REM ============================================================
REM 5. CREAR EJEMPLO DE DB.PROPERTIES
REM ============================================================

if not exist "WEB-INF\db.properties.example" (

    echo [INFO] Creando db.properties.example...

    >"WEB-INF\db.properties.example" (
        echo # Configuracion de ejemplo
        echo # NO colocar credenciales reales aqui.
        echo.
        echo modo=local
        echo.
        echo # Base de datos local
        echo local.url=jdbc:mysql://localhost:3306/inmobiliaria
        echo local.usuario=TU_USUARIO
        echo local.password=TU_PASSWORD
        echo.
        echo # Base de datos remota
        echo remota.url=jdbc:mysql://HOST:PUERTO/NOMBRE_BD
        echo remota.usuario=TU_USUARIO
        echo remota.password=TU_PASSWORD
    )

    echo [OK] db.properties.example creado.

) else (

    echo [OK] db.properties.example ya existe.

)

echo.


REM ============================================================
REM 6. INICIALIZAR GIT
REM ============================================================

if not exist ".git" (

    echo ============================================================
    echo       INICIALIZANDO REPOSITORIO GIT
    echo ============================================================
    echo.

    git init

    if errorlevel 1 (
        echo [ERROR] No se pudo ejecutar git init.
        pause
        exit /b 1
    )

    git branch -M main

    echo [OK] Repositorio creado.
    echo [OK] Rama principal: main

) else (

    echo [OK] Ya existe un repositorio Git.
    echo.

)

echo.


REM ============================================================
REM 7. CONFIGURAR IDENTIDAD DE GIT
REM ============================================================

echo ============================================================
echo       CONFIGURACION DE IDENTIDAD
echo ============================================================
echo.

git config user.name >nul 2>&1

if errorlevel 1 (

    echo [AVISO] No hay nombre configurado.

    set /p "GIT_NAME=Escribe tu nombre: "

    if not "!GIT_NAME!"=="" (
        git config user.name "!GIT_NAME!"
    )

)

git config user.email >nul 2>&1

if errorlevel 1 (

    echo [AVISO] No hay correo configurado.

    set /p "GIT_EMAIL=Escribe tu correo: "

    if not "!GIT_EMAIL!"=="" (
        git config user.email "!GIT_EMAIL!"
    )

)

echo.
echo [INFO] Usuario Git:
git config user.name

echo [INFO] Correo Git:
git config user.email

echo.


REM ============================================================
REM 8. PROTEGER DB.PROPERTIES
REM ============================================================

if exist "WEB-INF\db.properties" (

    git ls-files --error-unmatch "WEB-INF/db.properties" >nul 2>&1

    if not errorlevel 1 (

        echo [AVISO] db.properties estaba siendo versionado.
        echo [INFO] Quitandolo del indice de Git...

        git rm --cached -- "WEB-INF/db.properties"

        if errorlevel 1 (
            echo [AVISO] No se pudo quitar db.properties.
        ) else (
            echo [OK] db.properties eliminado del indice.
        )

    ) else (

        echo [OK] db.properties no esta siendo versionado.

    )

)

echo.


REM ============================================================
REM FUNCIONES AUXILIARES
REM ============================================================

goto SPRINT1


:ADD

if exist "%~1" (

    git add -- "%~1"

    if errorlevel 1 (

        echo [ERROR] No se pudo agregar:
        echo         %~1
        set "ADD_ERROR=1"

    ) else (

        echo [ADD] %~1

    )

) else (

    echo [SKIP] No existe:
    echo        %~1

)

exit /b


:COMMIT

git diff --cached --quiet

if errorlevel 1 (

    echo.
    echo [INFO] Creando commit:
    echo        %~1
    echo.

    git commit -m "%~1"

    if errorlevel 1 (

        echo [ERROR] El commit fallo.
        set "COMMIT_ERROR=1"

    ) else (

        echo [OK] Commit creado correctamente.

    )

) else (

    echo [SKIP] No hay cambios preparados para:
    echo        %~1

)

echo.
exit /b


REM ============================================================
REM SPRINT 1
REM FUNDAMENTOS - BD - CONEXION - AUTENTICACION
REM ============================================================

:SPRINT1

echo.
echo ============================================================
echo              SPRINT 1
echo       FUNDAMENTOS Y ACCESO
echo ============================================================
echo.

set "ADD_ERROR=0"

call :ADD ".gitignore"
call :ADD "WEB-INF\db.properties.example"
call :ADD "sql"
call :ADD "compilar.bat"
call :ADD "index.jsp"
call :ADD "WEB-INF\web.xml"

call :COMMIT "Sprint 1 - estructura inicial, base de datos y configuracion JDBC"


REM ------------------------------------------------------------
REM AUTENTICACION
REM ------------------------------------------------------------

set "ADD_ERROR=0"

call :ADD "WEB-INF\classes\util\HashUtil.java"
call :ADD "WEB-INF\classes\conexion\ConexionBD.java"
call :ADD "WEB-INF\classes\modelo\Usuario.java"
call :ADD "WEB-INF\classes\dao\UsuarioDAO.java"
call :ADD "login.jsp"
call :ADD "registro.jsp"

call :COMMIT "Sprint 1 - autenticacion, registro y hash de contrasenas"


REM ------------------------------------------------------------
REM AUTORIZACION
REM ------------------------------------------------------------

set "ADD_ERROR=0"

call :ADD "WEB-INF\classes\filtro\AutorizacionFilter.java"
call :ADD "denegado.jsp"

call :COMMIT "Sprint 1 - autorizacion por roles mediante Filter"


REM ============================================================
REM SPRINT 2
REM PROPIEDADES - PERFIL - BUSQUEDA - INTERFAZ
REM ============================================================

echo.
echo ============================================================
echo              SPRINT 2
echo       PROPIEDADES Y EXPERIENCIA WEB
echo ============================================================
echo.


REM ------------------------------------------------------------
REM PROPIEDADES
REM ------------------------------------------------------------

set "ADD_ERROR=0"

call :ADD "WEB-INF\classes\modelo\Propiedad.java"
call :ADD "WEB-INF\classes\modelo\Perfil.java"
call :ADD "WEB-INF\classes\dao\PropiedadDAO.java"
call :ADD "WEB-INF\classes\controlador\PropiedadController.java"

call :ADD "agente_propiedades.jsp"
call :ADD "formulario_propiedad.jsp"
call :ADD "detalle_propiedad.jsp"
call :ADD "perfil.jsp"

call :COMMIT "Sprint 2 - CRUD de propiedades, baja logica y perfil"


REM ------------------------------------------------------------
REM RECURSOS VISUALES
REM ------------------------------------------------------------

set "ADD_ERROR=0"

call :ADD "assets"
call :ADD "views\header.jspf"
call :ADD "views\footer.jspf"
call :ADD "views\mensajes.jspf"

call :COMMIT "Sprint 2 - recursos visuales y fragmentos JSPF"


REM ------------------------------------------------------------
REM BUSQUEDA Y DASHBOARDS
REM ------------------------------------------------------------

set "ADD_ERROR=0"

call :ADD "buscar.jsp"
call :ADD "dashboard_admin.jsp"
call :ADD "dashboard_agente.jsp"
call :ADD "dashboard_cliente.jsp"

call :COMMIT "Sprint 2 - buscador y dashboards por rol"


REM ============================================================
REM SPRINT 3
REM CITAS - SOLICITUDES - REPORTES - ADMINISTRACION
REM ============================================================

echo.
echo ============================================================
echo              SPRINT 3
echo       OPERACION Y CIERRE DEL PRODUCTO
echo ============================================================
echo.


REM ------------------------------------------------------------
REM CITAS
REM ------------------------------------------------------------

set "ADD_ERROR=0"

call :ADD "WEB-INF\classes\modelo\Cita.java"
call :ADD "WEB-INF\classes\dao\CitaDAO.java"
call :ADD "WEB-INF\classes\controlador\CitaController.java"

call :ADD "citas_cliente.jsp"
call :ADD "citas_agente.jsp"
call :ADD "cita_form.jsp"

call :COMMIT "Sprint 3 - modulo de citas y restriccion UNIQUE"


REM ------------------------------------------------------------
REM SOLICITUDES
REM ------------------------------------------------------------

set "ADD_ERROR=0"

call :ADD "WEB-INF\classes\modelo\Solicitud.java"
call :ADD "WEB-INF\classes\dao\SolicitudDAO.java"
call :ADD "WEB-INF\classes\controlador\SolicitudController.java"

call :ADD "solicitudes_cliente.jsp"
call :ADD "solicitudes_agente.jsp"
call :ADD "solicitud_form.jsp"

call :COMMIT "Sprint 3 - modulo de solicitudes y documentos"


REM ------------------------------------------------------------
REM REPORTES Y ADMINISTRACION
REM ------------------------------------------------------------

set "ADD_ERROR=0"

call :ADD "WEB-INF\classes\dao\ReporteDAO.java"
call :ADD "admin_reportes.jsp"
call :ADD "admin_usuarios.jsp"
call :ADD "admin_auditoria.jsp"

call :COMMIT "Sprint 3 - reportes, administracion y auditoria"


REM ============================================================
REM 9. ARCHIVOS RESTANTES
REM ============================================================

echo.
echo ============================================================
echo          REVISION FINAL DE ARCHIVOS
echo ============================================================
echo.

echo [INFO] Buscando archivos que hayan quedado pendientes...

git add .

REM Volver a retirar db.properties por seguridad
if exist "WEB-INF\db.properties" (
    git reset -- "WEB-INF/db.properties" >nul 2>&1
)

git diff --cached --quiet

if errorlevel 1 (

    echo.
    echo [INFO] Se encontraron archivos pendientes:
    echo.

    git status --short

    echo.
    echo [INFO] Creando commit de integracion final...

    git commit -m "Sprint 3 - integracion final del proyecto inmobiliaria"

    if errorlevel 1 (
        echo [ERROR] El commit final fallo.
    ) else (
        echo [OK] Commit final creado.
    )

) else (

    echo [OK] No quedaron archivos pendientes.

)


REM ============================================================
REM 10. ESTADO FINAL
REM ============================================================

echo.
echo ============================================================
echo              ESTADO FINAL
echo ============================================================
echo.

git status

echo.
echo ============================================================
echo              HISTORIAL DE COMMITS
echo ============================================================
echo.

git log --oneline -n 15

echo.
echo ============================================================
echo                    FIN
echo ============================================================
echo.

echo [IMPORTANTE]
echo.
echo 1. WEB-INF\db.properties NO debe subirse a GitHub.
echo.
echo 2. Revisa siempre:
echo       git status
echo.
echo 3. Para ver todos los commits:
echo       git log --oneline
echo.
echo 4. Este script organiza los archivos actuales en commits.
echo    No crea un historial historico real de trabajo.
echo.

pause
exit /b 0

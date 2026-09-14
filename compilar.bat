@echo off
REM ============================================================
REM  Script de compilacion - Proyecto Inmobiliaria (Java/JSP)
REM ============================================================
REM  Uso:
REM   1) Copia esta carpeta "inmobiliaria" dentro de:
REM      <TU_TOMCAT>\webapps\
REM   2) Edita la linea SET TOMCAT_HOME de abajo con la ruta real
REM      de tu instalacion de Tomcat (donde esta la carpeta "lib"
REM      con servlet-api.jar).
REM   3) Pon el conector de MySQL (mysql-connector-j-x.x.x.jar)
REM      dentro de WEB-INF\lib (ver WEB-INF\lib\LEEME.txt).
REM   4) Doble clic en este archivo, o ejecutalo desde cmd.
REM ============================================================

setlocal

REM ---- AJUSTA ESTA RUTA A TU INSTALACION DE TOMCAT ----
SET "TOMCAT_HOME=C:\xampp\tomcat"

if not exist "%TOMCAT_HOME%\lib\servlet-api.jar" (
    echo [ERROR] No se encontro servlet-api.jar en: %TOMCAT_HOME%\lib
    echo         Edita este archivo compilar.bat y corrige la linea TOMCAT_HOME
    echo         para que apunte a la carpeta donde instalaste Apache Tomcat.
    pause
    exit /b 1
)

echo Compilando clases Java...
echo.

cd /d "%~dp0WEB-INF\classes"

javac -encoding UTF-8 -cp "%TOMCAT_HOME%\lib\servlet-api.jar;." -d . ^
    util\*.java ^
    conexion\ConexionBD.java ^
    modelo\*.java ^
    dao\*.java ^
    filtro\AutorizacionFilter.java ^
    controlador\*.java

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Hubo errores de compilacion. Revisa los mensajes de arriba,
    echo         copialos y pideselos a Claude para corregirlos.
    pause
    exit /b 1
)

echo.
echo [OK] Compilacion exitosa. Se generaron los .class dentro de WEB-INF\classes
echo.

if not exist "%~dp0WEB-INF\lib\*.jar" (
    echo [AVISO] No hay ningun .jar en WEB-INF\lib
    echo         Falta el conector de MySQL - revisa WEB-INF\lib\LEEME.txt
    echo         La app compilo pero la conexion a la base de datos fallara.
)

echo Ahora reinicia Tomcat y entra a http://localhost:8080/inmobiliaria/
pause

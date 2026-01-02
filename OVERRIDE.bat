@echo off
setlocal enabledelayedexpansion
title OVERRIDE FINAL - STABLE
mode con: cols=90 lines=30

:boot
cls
color 0a
echo.
echo  [ INICIANDO SISTEMA OVERRIDE ]
echo.
set "bar="
for /l %%i in (1,1,20) do (
    set "bar=!bar!#"
    cls
    echo  CARGANDO NUCLEO: [!bar!]
    ping -n 1 127.0.0.1 >nul
)
echo.
echo  [ SISTEMA LISTO ]
ping -n 2 127.0.0.1 >nul

:menu
cls
color 0a
echo.
echo   =================================================
echo      O  V  E  R  R  I  D  E   -   S  H  E  L  L
echo   =================================================
echo.
echo    1. INYECCION ALEATORIA
echo    2. ATAQUE MULTI-VECTOR (5 VENTANAS VERDES)
echo    3. MATRIX DECODER (TECLA PARA VOLVER)
echo    4. AUTO-DESTRUCCION (COUNTDOWN)
echo.
set /p opt=">>> SELECCIONAR OPCION: "

if "%opt%"=="1" goto solo
if "%opt%"=="2" goto multi
if "%opt%"=="3" goto matrix
if "%opt%"=="4" goto self_destruct
goto menu

:solo
cls
set /a "num=(!random! %% 13) + 1"
if %num%==1 set "u=asciiquarium.live"
if %num%==2 set "u=ascii.live/donut"
if %num%==3 set "u=ascii.live/batman"
if %num%==4 set "u=ascii.live/can-you-hear-me"
if %num%==5 set "u=ascii.live/hes"
if %num%==6 set "u=ascii.live/knot"
if %num%==7 set "u=ascii.live/bnr"
if %num%==8 set "u=ascii.live/coin"
if %num%==9 set "u=ascii.live/parrot"
if %num%==10 set "u=ascii.live/dvd"
if %num%==11 set "u=ascii.live/playstation"
if %num%==12 set "u=ascii.live/nyan"
if %num%==13 set "u=ascii.live/torus-knot"

echo [!] LANZANDO: %u%
start cmd /k "color a && curl %u%"
goto menu

:multi
cls
echo [!] DESPLEGANDO 5 VECTORES...
for /l %%x in (1,1,5) do (
   set /a "r=(!random! %% 12) + 1"
   set "target="
   if !r!==1 set "target=asciiquarium.live"
   if !r!==2 set "target=ascii.live/nyan"
   if !r!==3 set "target=ascii.live/donut"
   if !r!==4 set "target=ascii.live/parrot"
   if !r!==5 set "target=ascii.live/batman"
   if !r!==6 set "target=ascii.live/dvd"
   if !r!==7 set "target=ascii.live/coin"
   if !r!==8 set "target=ascii.live/hes"
   if !r!==9 set "target=ascii.live/knot"
   if !r!==10 set "target=ascii.live/bnr"
   if !r!==11 set "target=ascii.live/playstation"
   if !r!==12 set "target=ascii.live/torus-knot"
   
   echo  ^> Abriendo vector %%x: !target!
   start cmd /k "color a && curl !target!"
   ping -n 1 127.0.0.1 >nul
)
pause
goto menu

:matrix
cls
color 02
echo [ MATRIX DECODER ACTIVO ]
echo [ PRESIONE CTRL+C PARA SALIR ]
echo.
:m_loop
echo !random!!random!!random!!random!!random!!random!!random!!random!
ping -n 1 127.0.0.1 >nul
:: Nota: Si PowerShell fallaba, aquí usamos un método simple. 
:: Para volver al menú en esta versión, mejor cerramos la ventana o usamos Ctrl+C.
goto m_loop

:self_destruct
:: Cambiamos a rojo para toda la animación
color 0c
for /l %%i in (5,-1,1) do (
    cls
    echo.
    echo  #################################################
    echo  #                                               #
    echo  #       ALERTA: AUTO-DESTRUCCION ACTIVA         #
    echo  #                                               #
    echo  #            SISTEMA CERRANDO EN: %%i           #
    echo  #                                               #
    echo  #################################################
    echo.
    echo  [!] BORRANDO LOGS...
    echo  [!] ELIMINANDO RASTROS DE IP...
    :: Retardo ultra-estable
    ping -n 2 127.0.0.1 >nul
)

:: Efecto final de parpadeo antes de cerrar
color 4f
cls
echo.
echo  [ SISTEMA PURGADO EXITOSAMENTE ]
ping -n 2 127.0.0.1 >nul
exit
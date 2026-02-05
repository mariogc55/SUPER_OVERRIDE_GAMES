@echo off
setlocal enabledelayedexpansion
title SuperOverrideAbyssUltimateCommander
mode con: cols=115 lines=45

:boot
cls & color 0b
echo.
echo  [ SISTEMA SuperOverrideAbyssUltimateCommander V.9.2 ]
echo.
set "bar="
for /l %%i in (1,1,20) do (
    set "bar=!bar!#"
    cls & echo. & echo  [ OPTIMIZANDO RENDERIZADO DE OBJETOS ACTIVOS ] & echo.
    echo  -- SINCRONIZANDO RADAR: [!bar!]
    ping -n 1 127.0.0.1 >nul
)

:menu
cls & color 0b
echo.
echo   ========================================================================================
echo      S U P E R   O V E R R I D E   A B Y S S   U L T I M A T E   C O M M A N D E R
echo   ========================================================================================
echo.
echo          [ PANEL DE CONTROL PRINCIPAL ]
echo.
echo          1. INICIAR OPERACION (DEEP SEA SONAR)
echo          2. SALIR DEL SISTEMA
echo.
echo   ========================================================================================
set /p opt="ID_COMMANDER >> "

if "%opt%"=="1" goto abyss_init
if "%opt%"=="2" exit
goto menu

:abyss_init
set /a sx=30, sy=10, score=0, lives=5, torpedos=5
call :respawn_items
goto game_loop

:game_loop
cls
color 0b
echo  ESTADO: ULTIMATE_COMMANDER ^| TESOROS: %score% ^| INTEGRIDAD: %lives%0%% ^| TORPEDOS: %torpedos%
echo  CONTROLES: [W,A,S,D] Navegar  [T] Torpedo  [M] Menu
echo  ------------------------------------------------------------------------------------------------------

:: DIBUJADO DEL BORDER SUPERIOR
set "top=#"
for /l %%i in (1,1,60) do set "top=!top!="
echo  !top!#

:: RENDERIZADO DEL MAPA
for /l %%y in (1,1,22) do (
    set /a "l_space=!random! %% 4"
    set "line="
    for /l %%i in (0,1,!l_space!) do set "line=!line! "
    set "line=!line!#"

    for /l %%x in (1,1,60) do (
        set "obj= "
        
        :: 1. Comprobar Submarino
        if %%x==%sx% if %%y==%sy% set "obj=S"
        
        :: 2. Comprobar Tesoro (solo si el espacio esta vacio)
        if "!obj!"==" " (
            if %%x==%tx% if %%y==%ty% set "obj=$"
        )
        
        :: 3. Comprobar 12 Minas (forzamos la lectura de variables)
        if "!obj!"==" " (
            for /l %%o in (1,1,12) do (
                if %%x==!ox%%o! if %%y==!oy%%o! set "obj=X"
            )
        )
        
        set "line=!line!!obj!"
    )
    echo !line!#
)
echo  !top!#

:: ALERTAS DE PROXIMIDAD
set "alert="
for /l %%o in (1,1,12) do (
    set /a "dx=sx-!ox%%o!", "dy=sy-!oy%%o!"
    if !dx! LSS 0 set /a dx*=-1
    if !dy! LSS 0 set /a dy*=-1
    if !dx! LEQ 3 if !dy! LEQ 3 set "alert=[!] CONTACTO CERCANO: MINA DETECTADA"
)
if defined alert (echo. & echo %alert% & color 0e)

:: ENTRADA DE COMANDO
echo.
set "in="
set /p "in=RUMBO_SONAR >> "

if /i "%in%"=="M" goto menu
if /i "%in%"=="T" goto shoot_torpedo
if /i "%in%"=="W" set /a sy-=1
if /i "%in%"=="S" set /a sy+=1
if /i "%in%"=="A" set /a sx-=1
if /i "%in%"=="D" set /a sx+=1

:: LIMITES FISICOS
if %sx% LSS 1 set /a sx=1
if %sx% GTR 60 set /a sx=60
if %sy% LSS 1 set /a sy=1
if %sy% GTR 22 set /a sy=22

:: DETECCION DE COLISION O TESORO
if %sx%==%tx% if %sy%==%ty% (
    set /a score+=1
    call :respawn_items
    goto game_loop
)

for /l %%o in (1,1,12) do (
    if %sx%==!ox%%o! if %sy%==!oy%%o! goto collision
)
goto game_loop

:shoot_torpedo
if %torpedos% LEQ 0 (echo [!] SIN MUNICION & ping -n 2 127.0.0.1 >nul & goto game_loop)
set /a torpedos-=1
echo [!] LANZANDO CARGA DE PROFUNDIDAD...
for /l %%o in (1,1,12) do (
    set /a "dx=sx-!ox%%o!", "dy=sy-!oy%%o!"
    if !dx! LSS 0 set /a dx*=-1
    if !dy! LSS 0 set /a dy*=-1
    if !dx! LEQ 6 if !dy! LEQ 6 (
        set /a ox%%o=0, oy%%o=0
        echo [!] MINA EN SECTOR %%o ELIMINADA.
    )
)
ping -n 2 127.0.0.1 >nul
goto game_loop

:collision
set /a lives-=1
color 0c
echo [!] COLISION DETECTADA - INTEGRIDAD AL %lives%0%%
ping -n 2 127.0.0.1 >nul
if %lives% LEQ 0 (
    cls & echo [!] MISION FALLIDA: SUBMARINO PERDIDO EN EL ABISMO
    pause & goto menu
)
set /a sx=30, sy=10
goto game_loop

:respawn_items
:: Coordenadas aleatorias seguras (lejos de los bordes)
set /a tx=%random% %% 50 + 5, ty=%random% %% 15 + 3
for /l %%i in (1,1,12) do (
    set /a ox%%i=%random% %% 50 + 5, oy%%i=%random% %% 15 + 3
    :: Evitar que la mina aparezca sobre el jugador al inicio
    if !ox%%i!==%sx% if !oy%%i!==%sy% set /a ox%%i+=3
)
goto :eof
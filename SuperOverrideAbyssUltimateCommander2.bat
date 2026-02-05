@echo off
setlocal enabledelayedexpansion
title SuperOverrideAbyssUltimateCommander
mode con: cols=115 lines=45

:boot
cls & color 0b
echo.
echo  [ SISTEMA SuperOverrideAbyssUltimateCommander V.10.1 ]
echo.
echo  -- CALIBRANDO SENSORES DE PROXIMIDAD...
:: Inicializar variables globales una sola vez
set /a score=0, lives=5, torpedos=10, sx=30, sy=10
call :respawn_items
ping -n 2 127.0.0.1 >nul

:menu
cls & color 0b
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
set /p "opt=ID_COMMANDER >> "
if "%opt%"=="1" goto game_loop
if "%opt%"=="2" exit
goto menu

:game_loop
:: Condicion de victoria
if %score% GEQ 3 goto victory

cls & color 0b
echo  ESTADO: OPERATIVO ^| TESOROS: %score%/3 ^| INTEGRIDAD: %lives%0%% ^| TORPEDOS: %torpedos%
echo  SISTEMA: [W,A,S,D] Motores  [T] Torpedo  [P] Pulso Sonar  [M] Menu
echo  ------------------------------------------------------------------------------------------------------

:: RENDERIZADO DEL MAPA
echo #============================================================#
for /l %%y in (1,1,22) do (
    set "line="
    set "line=#"
    for /l %%x in (1,1,60) do (
        set "char= "
        
        :: 1. Submarino
        if %%x==!sx! if %%y==!sy! (
            set "char=S"
        ) else (
            :: Calcular distancia para sonar
            set /a "dx=!sx!-%%x", "dy=!sy!-%%y"
            if !dx! LSS 0 set /a dx*=-1
            if !dy! LSS 0 set /a dy*=-1
            set /a "dist=dx+dy"
            
            :: 2. Tesoro
            if %%x==!tx! if %%y==!ty! (
                if !dist! LEQ 10 (set "char=$") else (if "!sonar_ping!"=="1" set "char=$")
            )
            
            :: 3. Minas (Chequeo de las 20 minas)
            for /l %%o in (1,1,20) do (
                if %%x==!ox%%o! if %%y==!oy%%o! (
                    if !dist! LEQ 6 (set "char=X") else (if "!sonar_ping!"=="1" set "char=X")
                )
            )
        )
        set "line=!line!!char!"
    )
    echo !line!#
)
echo #============================================================#
set "sonar_ping=0"
if defined msg (echo. & echo %msg% & set "msg=")

:: ENTRADA DE COMANDO
echo.
set "in="
set /p "in=RUMBO_SONAR >> "

if /i "%in%"=="M" goto menu
if /i "%in%"=="P" goto use_sonar
if /i "%in%"=="T" goto shoot_torpedo
if /i "%in%"=="W" set /a sy-=1
if /i "%in%"=="S" set /a sy+=1
if /i "%in%"=="A" set /a sx-=1
if /i "%in%"=="D" set /a sx+=1

:: --- LOGICA DE COLISIONES Y EVENTOS ---

:: Límites del mapa (Muros)
if %sx% LSS 1 goto collision
if %sx% GTR 60 goto collision
if %sy% LSS 1 goto collision
if %sy% GTR 22 goto collision

:: Detectar Tesoro
if %sx%==%tx% if %sy%==%ty% (
    set /a score+=1
    set "msg=[+] SISTEMA: TESORO RECUPERADO. ANALIZANDO NUEVAS COORDENADAS..."
    call :respawn_items
    goto game_loop
)

:: Detectar Minas
for /l %%o in (1,1,20) do (
    if %sx%==!ox%%o! if %sy%==!oy%%o! goto collision
)

goto game_loop

:use_sonar
set "dir_h=" & set "dir_v="
if %tx% GTR %sx% (set "dir_h=ESTE") else (set "dir_h=OESTE")
if %ty% GTR %sy% (set "dir_v=SUR") else (set "dir_v=NORTE")
set "msg=[SONAR] TESORO AL %dir_v%-%dir_h% ^| MINAS REVELADAS"
set "sonar_ping=1"
goto game_loop

:shoot_torpedo
if %torpedos% LEQ 0 (set "msg=[!] SIN MUNICION" & goto game_loop)
set /a torpedos-=1
for /l %%o in (1,1,20) do (
    set /a "dx=sx-!ox%%o!", "dy=sy-!oy%%o!"
    if !dx! LSS 0 set /a dx*=-1
    if !dy! LSS 0 set /a dy*=-1
    if !dx! LEQ 6 if !dy! LEQ 6 (set /a ox%%o=99, oy%%o=99)
)
set "msg=[!] CARGA LANZADA - SECTOR DESPEJADO"
goto game_loop

:collision
set /a lives-=1
color 0c
echo [!] ALERTA: COLISION DETECTADA - DAÑO EN EL CASCO
ping -n 2 127.0.0.1 >nul
if %lives% LEQ 0 (
    cls & echo [!] SISTEMA CRITICO: SUBMARINO DESTRUIDO
    pause & set /a score=0, lives=5 & goto menu
)
set /a sx=30, sy=10
goto game_loop

:respawn_items
:: Generar nuevo tesoro
set /a tx=%random% %% 50 + 5, ty=%random% %% 18 + 2
:: Generar 20 minas
for /l %%i in (1,1,20) do (
    set /a ox%%i=%random% %% 58 + 1, oy%%i=%random% %% 20 + 1
    :: Evitar que aparezcan sobre el submarino (spawn seguro)
    if !ox%%i! GEQ 25 if !ox%%i! LEQ 35 (
        if !oy%%i! GEQ 8 if !oy%%i! LEQ 12 (
            set /a ox%%i=1, oy%%i=1
        )
    )
)
goto :eof

:victory
cls & color 0a
echo.
echo   ========================================================================================
echo      ¡ M I S I O N   C U M P L I D A ! - OPERACION ABYSS FINALIZADA
echo   ========================================================================================
echo.
echo          COMANDANTE, HA RECUPERADO LOS 3 TESOROS.
echo          EL SISTEMA HA SIDO TOTALMENTE DESBLOQUEADO.
echo.
pause
set /a score=0, lives=5
goto menu
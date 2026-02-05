@echo off
setlocal enabledelayedexpansion
title SuperOverrideAbyssUltimateCommander
mode con: cols=115 lines=45

:boot
cls & color 0b
echo.
echo  [ SISTEMA SuperOverrideAbyssUltimateCommander V.10.0 ]
echo.
echo  -- ACTIVANDO SONAR PASIVO...
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
if %score% GEQ 3 goto victory
cls & color 0b
echo  ESTADO: OPERATIVO ^| TESOROS: %score%/3 ^| INTEGRIDAD: %lives%0%% ^| TORPEDOS: %torpedos%
echo  SISTEMA: [W,A,S,D] Motores  [T] Torpedo  [P] Pulso Sonar  [M] Menu
echo  ------------------------------------------------------------------------------------------------------

:: RENDERIZADO CON VISIBILIDAD DINAMICA
echo #============================================================#
for /l %%y in (1,1,22) do (
    set /a "l_space=!random! %% 4"
    set "line="
    for /l %%i in (0,1,!l_space!) do set "line=!line! "
    set "line=!line!#"

    for /l %%x in (1,1,60) do (
        set "char= "
        
        :: 1. Submarino (Siempre visible)
        if %%x==!sx! if %%y==!sy! (
            set "char=S"
        ) else (
            :: Calcular distancia para visibilidad por proximidad
            set /a "dx=sx-%%x", "dy=sy-%%y"
            if !dx! LSS 0 set /a dx*=-1
            if !dy! LSS 0 set /a dy*=-1
            set /a "dist=dx+dy"
            
            :: 2. Tesoro (Visible si esta cerca o si se activo el sonar)
            if %%x==!tx! if %%y==!ty! (
                if !dist! LEQ 8 (set "char=$") else (if "%sonar_ping%"=="1" set "char=$")
            )
            
            :: 3. Minas (20 unidades)
            for /l %%o in (1,1,20) do (
                if %%x==!ox%%o! if %%y==!oy%%o! (
                    if !dist! LEQ 5 (set "char=X") else (if "%sonar_ping%"=="1" set "char=X")
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

:: INPUT
echo.
set /p "in=RUMBO_SONAR >> "

if /i "%in%"=="M" goto menu
if /i "%in%"=="P" goto use_sonar
if /i "%in%"=="T" goto shoot_torpedo
if /i "%in%"=="W" set /a sy-=1
if /i "%in%"=="S" set /a sy+=1
if /i "%in%"=="A" set /a sx-=1
if /i "%in%"=="D" set /a sx+=1

:: --- FISICAS ---
if %sx% LSS 1 goto collision
if %sx% GTR 60 goto collision
if %sy% LSS 1 goto collision
if %sy% GTR 22 goto collision

if %sx%==%tx% if %sy%==%ty% (
    set /a score+=1
    set "msg=[+] TESORO RECUPERADO. REUBICANDO..."
    call :respawn_items
    goto game_loop
)

for /l %%o in (1,1,20) do (
    if %sx%==!ox%%o! if %sy%==!oy%%o! goto collision
)
goto game_loop

:use_sonar
:: Indica la direccion del tesoro
set "dir_h=" & set "dir_v="
if %tx% GTR %sx% (set "dir_h=ESTE") else (set "dir_h=OESTE")
if %ty% GTR %sy% (set "dir_v=SUR") else (set "dir_v=NORTE")
set "msg=[SONAR] SEÑAL DETECTADA AL %dir_v%-%dir_h% ^| PULSO REVELADOR ACTIVADO"
set "sonar_ping=1"
goto game_loop

:shoot_torpedo
if %torpedos% LEQ 0 (set "msg=[!] SIN MUNICION" & goto game_loop)
set /a torpedos-=1
for /l %%o in (1,1,20) do (
    set /a "dx=sx-!ox%%o!", "dy=sy-!oy%%o!"
    if !dx! LSS 0 set /a dx*=-1
    if !dy! LSS 0 set /a dy*=-1
    if !dx! LEQ 7 if !dy! LEQ 7 (set /a ox%%o=99, oy%%o=99)
)
set "msg=[!] TORPEDO LANZADO - AREA DESPEJADA"
goto game_loop

:collision
set /a lives-=1
color 0c
echo [!] IMPACTO DETECTADO
ping -n 1 127.0.0.1 >nul
if %lives% LEQ 0 (pause & goto menu)
set /a sx=30, sy=10
goto game_loop

:respawn_items
set /a score=0, lives=5, torpedos=10, sx=30, sy=10
set /a tx=%random% %% 50 + 5, ty=%random% %% 18 + 2
for /l %%i in (1,1,20) do (
    set /a ox%%i=%random% %% 58 + 1, oy%%i=%random% %% 20 + 1
    if !ox%%i! GEQ 25 if !ox%%i! LEQ 35 (set /a ox%%i=2)
)
goto :eof

:victory
cls & color 0a
echo.
echo   ========================================================================================
echo      ¡M I S I O N   C U M P L I D A! - SUPER OVERRIDE ABYSS ULTIMATE COMMANDER
echo   ========================================================================================
pause & goto menu
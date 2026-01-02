@echo off
setlocal enabledelayedexpansion
title SUPER OVERRIDE ABYSS
mode con: cols=95 lines=38

:boot
cls
color 0b
echo.
echo  [ SISTEMA SUPER OVERRIDE ABYSS V.6.0 INICIADO ]
echo.
echo  ESTADO DEL SISTEMA: NUCLEO OPERATIVO
echo.
set "bar="
for /l %%i in (1,1,20) do (
    set "bar=!bar!#"
    cls
    echo.
    echo  [ SISTEMA SUPER OVERRIDE ABYSS V.6.0 INICIADO ]
    echo.
    echo  -- CARGANDO MODULOS TACTICOS: [!bar!]
    ping -n 1 127.0.0.1 >nul
)

:menu
cls
color 0b
echo.
echo   =========================================================================
echo      S  U  P  E  R      O  V  E  R  R  I  D  E      A  B  Y  S  S
echo   =========================================================================
echo.
echo    [ MINIJUEGOS ]
echo    1. TRES EN RAYA (SISTEMA DE TURNOS)
echo    2. CODIGO DE ACCESO (10 INTENTOS O BLOQUEO)
echo    3. DEEP SEA SONAR (EXPLORACION DE CAVERNAS)
echo.
echo    [ HERRAMIENTAS DE SISTEMA ]
echo    4. MATRIX DECODER (FLUJO DE DATOS)
echo    5. ESCANER DE PUERTOS (RASTREO)
echo    6. AUTO-DESTRUCCION (CIERRE DE EMERGENCIA)
echo.
set /p opt="NAV_OPERATOR >> "

if "%opt%"=="1" goto tictactoe
if "%opt%"=="2" goto guessnum
if "%opt%"=="3" goto sonar
if "%opt%"=="4" goto matrix
if "%opt%"=="5" goto scanner
if "%opt%"=="6" goto self_destruct
goto menu

:sonar
cls
color 0b
set /a sx=15, sy=6, score=0
call :respawn_items
:sonar_loop
cls
echo  DEEP SEA SONAR - MAPA TACTICO
echo  ------------------------------------------------------------
echo  TESOROS: %score% ^| PROFUNDIDAD: %sy%00m ^| [X] = MINA SÓNICA
echo.
echo    _______________________________________
for /l %%y in (1,1,12) do (
    set /a "l_space=!random! %% 4"
    set "line="
    for /l %%i in (0,1,!l_space!) do set "line=!line! "
    set "line=!line!#"
    for /l %%x in (1,1,30) do (
        set "char= "
        if %%x==%sx% if %%y==%sy% set "char=S"
        if %%x==%tx% if %%y==%ty% set "char=$"
        for /l %%o in (1,1,5) do (
            if %%x==!ox%%o! if %%y==!oy%%o! set "char=X"
        )
        set "line=!line!!char!"
    )
    set "line=!line!# "
    echo !line!
)
echo    ---------------------------------------
echo.
echo  [ W,A,S,D + ENTER ] [ M = MENU ]
echo.
if %sx%==%tx% if %sy%==%ty% (set /a score+=1 & call :respawn_items & goto sonar_loop)
for /l %%o in (1,1,5) do (if %sx%==!ox%%o! if %sy%==!oy%%o! goto sonar_dead)
set "move="
set /p "move=RUMBO >> "
if /i "%move%"=="M" goto menu
if /i "%move%"=="W" set /a sy-=1
if /i "%move%"=="S" set /a sy+=1
if /i "%move%"=="A" set /a sx-=1
if /i "%move%"=="D" set /a sx+=1
if %sx% LSS 1 goto sonar_dead
if %sx% GTR 30 goto sonar_dead
if %sy% LSS 1 goto sonar_dead
if %sy% GTR 12 goto sonar_dead
goto sonar_loop

:respawn_items
set /a tx=%random% %% 26 + 2, ty=%random% %% 10 + 1
for /l %%i in (1,1,5) do (set /a ox%%i=!random! %% 26 + 2, oy%%i=!random! %% 10 + 1)
goto :eof

:sonar_dead
color 0c & cls
echo.
echo   [!] ALERTA: CASCO COMPROMETIDO
echo   ==============================
echo    Has colisionado en el abismo. Tesoros: %score%
echo.
pause & goto menu

:tictactoe
set "p1=1" & set "p2=2" & set "p3=3" & set "p4=4" & set "p5=5" & set "p6=6" & set "p7=7" & set "p8=8" & set "p9=9"
set "turno=X" & set "ganador=NADA"
:tt_loop
cls & color 0e
echo.
echo       TRES EN RAYA - SUPER OVERRIDE
echo    ===================================
echo.
echo        [ !p1! ] ^| [ !p2! ] ^| [ !p3! ]
echo       -----------------------
echo        [ !p4! ] ^| [ !p5! ] ^| [ !p6! ]
echo       -----------------------
echo        [ !p7! ] ^| [ !p8! ] ^| [ !p9! ]
echo.
if not "!ganador!"=="NADA" (echo JUGADOR !ganador! GANA & pause & goto menu)
echo    TURNO DE: !turno!
set /p move="Posicion (M para salir): "
if /i "%move%"=="M" goto menu
set "valido=0"
for /l %%i in (1,1,9) do (if "%move%"=="%%i" if "!p%%i!"=="%%i" (set "p%%i=!turno!" & set "valido=1"))
if "!valido!"=="0" goto tt_loop
if "!p1!"=="!p2!" if "!p2!"=="!p3!" set "ganador=!p1!"
if "!p4!"=="!p5!" if "!p5!"=="!p6!" set "ganador=!p4!"
if "!p7!"=="!p8!" if "!p8!"=="!p9!" set "ganador=!p7!"
if "!p1!"=="!p4!" if "!p4!"=="!p7!" set "ganador=!p1!"
if "!p2!"=="!p5!" if "!p5!"=="!p8!" set "ganador=!p2!"
if "!p3!"=="!p6!" if "!p6!"=="!p9!" set "ganador=!p3!"
if "!p1!"=="!p5!" if "!p5!"=="!p9!" set "ganador=!p1!"
if "!p3!"=="!p5!" if "!p5!"=="!p7!" set "ganador=!p3!"
if not "!ganador!"=="NADA" goto tt_loop
if "!turno!"=="X" (set "turno=O") else (set "turno=X")
goto tt_loop

:guessnum
cls & color 0e
set /a "target=(%random% %% 100) + 1", "intentos=10"
echo   [ ADIVINA EL CODIGO (1-100) ]
:gn_loop
echo.
echo   Intentos: %intentos%
set /p "user_num=Codigo: "
set /a "intentos-=1"
if "%user_num%"=="" goto gn_loop
if %user_num% EQU %target% (echo [!] ACCESO CONCEDIDO. & pause & goto menu)
if %intentos% LEQ 0 (goto self_destruct)
if %user_num% LSS %target% (echo -- MAS ALTO...) else (echo -- MAS BAJO...)
goto gn_loop

:matrix
cls & color 02
echo [ MATRIX DECODER - PRESIONE CTRL+C PARA SALIR ]
:m_loop
echo %random%%random%%random%%random%%random%
ping -n 1 127.0.0.1 >nul
goto m_loop

:scanner
cls & color 0b
echo [!] INICIANDO ESCANEO DE NODOS...
for /l %%i in (1,1,15) do (
    set /a "p=%random% %% 65000"
    echo  ANALIZANDO IP: 10.0.5.%%i ... PUERTO: !p! ... [ OK ]
    ping -n 1 127.0.0.1 >nul
)
pause & goto menu

:self_destruct
color 0c
for /l %%i in (5,-1,1) do (cls & echo ALERTA: AUTO-DESTRUCCION EN %%i & ping -n 2 127.0.0.1 >nul)
exit
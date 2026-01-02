@echo off
setlocal enabledelayedexpansion
title SUPER OVERRIDE - DEEP SEA EDITION
mode con: cols=95 lines=35

:boot
cls
color 0b
echo.
echo  [ SISTEMA SUPER OVERRIDE V.5.5 INICIADO ]
echo.
echo  ESTADO DEL SISTEMA: CALIBRANDO SONAR...
echo.
set "bar="
for /l %%i in (1,1,20) do (
    set "bar=!bar!#"
    cls
    echo.
    echo  [ SISTEMA SUPER OVERRIDE V.5.5 INICIADO ]
    echo.
    echo  -- INUNDANDO COMPARTIMENTOS: [!bar!]
    ping -n 1 127.0.0.1 >nul
)
ping -n 1 127.0.0.1 >nul

:menu
cls
color 0b
echo.
echo   =========================================================================
echo      S  U  P  E  R      O  V  E  R  R  I  D  E      D  E  E  P      S  E  A
echo   =========================================================================
echo.
echo    1. INYECCION ALEATORIA
echo    2. ATAQUE MULTI-VECTOR
echo    3. MATRIX DECODER (FLUJO)
echo    4. MINIJUEGO: TRES EN RAYA
echo    5. MINIJUEGO: CODIGO DE ACCESO (10 INTENTOS)
echo    6. MINIJUEGO: DEEP SEA SONAR (SUBMARINO)
echo    7. ESCANER DE PUERTOS
echo    8. AUTO-DESTRUCCION
echo.
set /p opt="NAV_OPERATOR >> "

if "%opt%"=="1" goto solo
if "%opt%"=="2" goto multi
if "%opt%"=="3" goto matrix
if "%opt%"=="4" goto tictactoe
if "%opt%"=="5" goto guessnum
if "%opt%"=="6" goto sonar
if "%opt%"=="7" goto scanner
if "%opt%"=="8" goto self_destruct
goto menu

:sonar
cls
color 0b
set /a sx=10, sy=5, tx=%random% %% 18 + 1, ty=%random% %% 8 + 1, score=0
:sonar_loop
cls
echo  DEEP SEA SONAR - BUSQUEDA DE TESOROS
echo  --------------------------------------------------------
echo  TESOROS RECOLECTADOS: %score% ^| PROFUNDIDAD: %sy%00m
echo.
:: Renderizado del Mapa Táctico
echo  ######################
for /l %%y in (1,1,10) do (
    set "line=#"
    for /l %%x in (1,1,20) do (
        set "char= "
        if %%x==%sx% if %%y==%sy% set "char=S"
        if %%x==%tx% if %%y==%ty% set "char=$"
        set "line=!line!!char!"
    )
    echo !line!#
)
echo  ######################
echo.
echo  [ W,A,S,D + ENTER para navegar ] [ M para emerger ]
echo.

:: Detección de Tesoro
if %sx%==%tx% if %sy%==%ty% (
    set /a score+=1
    set /a tx=%random% %% 18 + 1
    set /a ty=%random% %% 8 + 1
    goto sonar_loop
)

:: Control de Movimiento
set "move="
set /p "move=RUMBO >> "
if /i "%move%"=="M" goto menu
if /i "%move%"=="W" set /a sy-=1
if /i "%move%"=="S" set /a sy+=1
if /i "%move%"=="A" set /a sx-=1
if /i "%move%"=="D" set /a sx+=1

:: Lógica de Colisión (Paredes)
if %sx% LSS 1 goto sonar_dead
if %sx% GTR 20 goto sonar_dead
if %sy% LSS 1 goto sonar_dead
if %sy% GTR 10 goto sonar_dead
goto sonar_loop

:sonar_dead
color 0c
cls
echo.
echo   [!] COLLISION DETECTED - HULL BREACH
echo   ====================================
echo    El submarino no ha soportado la presion.
echo    Tesoros perdidos: %score%
echo.
pause
goto menu

:guessnum
cls
color 0e
set /a "target=(%random% %% 100) + 1", "intentos=10"
echo.
echo   [ ADIVINA EL CODIGO DE ACCESO (1-100) ]
echo   [ ALERTA: SI FALLAS 10 VECES, EL SISTEMA SE DESTRUIRA ]
echo   ======================================================
:gn_loop
echo.
echo   Intentos restantes: %intentos%
set /p "user_num=Introduce codigo: "
set /a "intentos-=1"
if "%user_num%"=="" goto gn_loop
if %user_num% EQU %target% (
    echo.
    echo   [!] ACCESO CONCEDIDO. SISTEMA DESBLOQUEADO.
    pause
    goto menu
)
if %intentos% LEQ 0 (
    echo.
    echo   [!] DEMASIADOS INTENTOS FALLIDOS. ACTIVANDO AUTO-DESTRUCCION...
    ping -n 3 127.0.0.1 >nul
    goto self_destruct
)
if %user_num% LSS %target% (echo   -- EL CODIGO ES MAS ALTO...)
if %user_num% GTR %target% (echo   -- EL CODIGO ES MAS BAJO...)
goto gn_loop

:solo
cls
start cmd /k "color a && curl asciiquarium.live"
goto menu

:multi
cls
for /l %%x in (1,1,5) do (start cmd /k "color a && curl ascii.live/nyan" & ping -n 1 127.0.0.1 >nul)
goto menu

:matrix
cls
color 02
echo [ MATRIX DECODER - CTRL+C PARA SALIR ]
:m_loop
echo %random%%random%%random%%random%
ping -n 1 127.0.0.1 >nul
goto m_loop

:scanner
cls
color 0b
for /l %%i in (1,1,10) do (echo  BUSCANDO IP 10.0.0.%%i ... [ OK ] & ping -n 1 127.0.0.1 >nul)
pause
goto menu

:tictactoe
set "p1=1" & set "p2=2" & set "p3=3" & set "p4=4" & set "p5=5" & set "p6=6" & set "p7=7" & set "p8=8" & set "p9=9"
set "turno=X" & set "ganador=NADA"
:tt_loop
cls
color 0e
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
if not "!ganador!"=="NADA" (echo ¡EL JUGADOR !ganador! HA GANADO! & pause & goto menu)
echo    Turno de: !turno! (M para salir)
set /p move="Posicion: "
if /i "!move!"=="M" goto menu
set "valido=0"
if "!move!"=="1" if "!p1!"=="1" (set "p1=!turno!" & set "valido=1")
if "!move!"=="2" if "!p2!"=="2" (set "p2=!turno!" & set "valido=1")
if "!move!"=="3" if "!p3!"=="3" (set "p3=!turno!" & set "valido=1")
if "!move!"=="4" if "!p4!"=="4" (set "p4=!turno!" & set "valido=1")
if "!move!"=="5" if "!p5!"=="5" (set "p5=!turno!" & set "valido=1")
if "!move!"=="6" if "!p6!"=="6" (set "p6=!turno!" & set "valido=1")
if "!move!"=="7" if "!p7!"=="7" (set "p7=!turno!" & set "valido=1")
if "!move!"=="8" if "!p8!"=="8" (set "p8=!turno!" & set "valido=1")
if "!move!"=="9" if "!p9!"=="9" (set "p9=!turno!" & set "valido=1")
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

:self_destruct
color 0c
for /l %%i in (5,-1,1) do (
    cls
    echo  ADVERTENCIA: AUTO-DESTRUCCION EN %%i
    ping -n 2 127.0.0.1 >nul
)
exit
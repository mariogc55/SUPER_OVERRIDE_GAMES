@echo off
setlocal enabledelayedexpansion
title Micro-Space Batch v4


set "nave= ^ "
set "vacio=   "
set "pos_nave=2"
set "distancia=0"
set "meta=50"
set "obs_pos=0"
set "obs_linea=0"

:game_loop
cls
set "o1=%vacio%" & set "o2=%vacio%" & set "o3=%vacio%"
set "n1=%vacio%" & set "n2=%vacio%" & set "n3=%vacio%"

if %obs_linea% GEQ 2 (
    set /a "obs_linea=0"
    set /a "obs_pos=(%random% %% 3) + 1"
) else (
    set /a "obs_linea+=1"
)

if %obs_linea%==1 (
    if %obs_pos%==1 set "o1= X "
    if %obs_pos%==2 set "o2= X "
    if %obs_pos%==3 set "o3= X "
)

if %pos_nave%==1 set "n1=%nave%"
if %pos_nave%==2 set "n2=%nave%"
if %pos_nave%==3 set "n3=%nave%"

echo.
echo    DISTANCIA: %distancia% / %meta%
echo   =========================
echo      [1]     [2]     [3]
echo   _________________________
echo   I  %o1%  I  %o2%  I  %o3%  I  ^<-- RADAR (PELIGRO)
echo   I-------I-------I-------I
echo   I  %n1%  I  %n2%  I  %n3%  I  ^<-- TU NAVE (^)
echo   =========================
echo.
echo Instrucciones:
echo Escribe 1, 2 o 3 y pulsa ENTER para moverte.
echo Solo pulsa ENTER para seguir recto.

if %obs_linea%==0 if %distancia% GTR 0 (
    if %obs_pos%==%pos_nave% (
        echo.
        echo       ¡¡¡ BOOOOOOM !!!
        echo   Chocaste en el carril %pos_nave%.
        echo.
        pause
        exit
    )
)

if %distancia% GEQ %meta% (
    echo.
    echo   ¡¡ ENHORABUENA, PILOTO !!
    echo   Has completado la mision.
    pause
    exit
)

set "input="
set /p "input=>>> "

if "%input%"=="1" set "pos_nave=1"
if "%input%"=="2" set "pos_nave=2"
if "%input%"=="3" set "pos_nave=3"

set /a "distancia+=1"
goto game_loop
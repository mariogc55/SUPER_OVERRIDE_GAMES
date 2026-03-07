@echo off
setlocal enabledelayedexpansion
title Micro-Space Batch v5

set "nave= A "
set "vacio=   "
set "pos_nave=2"
set "distancia=0"
set "meta=50"
set "obs_pos=0"
set "obs_linea=0"

:game_loop
cls

set /a "distancia+=1"

set /a "obs_linea+=1"

if %obs_linea% GTR 2 (
    set /a "obs_linea=1"
    set /a "obs_pos=(%random% %% 3) + 1"
)

set "o1=%vacio%" & set "o2=%vacio%" & set "o3=%vacio%"
set "n1=%vacio%" & set "n2=%vacio%" & set "n3=%vacio%"

if %obs_linea%==1 (
    if %obs_pos%==1 set "o1=[X]"
    if %obs_pos%==2 set "o2=[X]"
    if %obs_pos%==3 set "o3=[X]"
)

if %pos_nave%==1 set "n1=%nave%"
if %pos_nave%==2 set "n2=%nave%"
if %pos_nave%==3 set "n3=%nave%"

echo.
echo    PROGRESO: %distancia% / %meta%
echo   =========================
echo      [1]     [2]     [3]
echo   _________________________
echo   I  %o1%  I  %o2%  I  %o3%  I  ^<-- RADAR (DISTANTE)
echo   I-------I-------I-------I
echo   I  %n1%  I  %n2%  I  %n3%  I  ^<-- TU NAVE (%nave%)
echo   =========================
echo.

if %obs_linea%==2 (
    if %obs_pos%==%pos_nave% (
        echo.
        echo   ¡¡¡ BOOOOOOM !!! 
        echo   El impacto en el carril %pos_nave% fue inevitable.
        echo.
        pause
        exit
    )
)

if %distancia% GEQ %meta% (
    echo.
    echo   ¡MISION COMPLETADA! Has llegado al destino.
    pause
    exit
)

echo Escribe 1, 2 o 3 para moverte y pulsa ENTER.
set "input="
set /p "input=>>> "

if "%input%"=="1" set "pos_nave=1"
if "%input%"=="2" set "pos_nave=2"
if "%input%"=="3" set "pos_nave=3"

goto game_loop
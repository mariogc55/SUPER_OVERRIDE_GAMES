@echo off
setlocal enabledelayedexpansion
title Micro-Space Batch

set "nave=^"
set "pos_nave=2"
set "distancia=0"
set "meta=50"
set "obs_pos=0"
set "obs_linea=5"

:game_loop
cls
set "l1= " & set "l2= " & set "l3= "
set "o1= " & set "o2= " & set "o3= "

if %pos_nave%==1 set "l1=%nave%"
if %pos_nave%==2 set "l2=%nave%"
if %pos_nave%==3 set "l3=%nave%"


if %obs_linea% GEQ 5 (
    set /a "obs_linea=0"
    set /a "obs_pos=(%random% %% 3) + 1"
)


if %obs_linea%==4 (
    if %obs_pos%==1 set "o1=X"
    if %obs_pos%==2 set "o2=X"
    if %obs_pos%==3 set "o3=X"
)

echo.
echo    DISTANCIA: %distancia% / %meta%
echo   -----------------
echo      [1] [2] [3]
echo   I   %o1%   %o2%   %o3%   I  ^<-- OBSTACULO
echo   I   %l1%   %l2%   %l3%   I  ^<-- TU NAVE
echo   -----------------
echo.
echo [1-2-3] Moverse + Enter para avanzar.

if %obs_linea%==4 (
    if %obs_pos%==%pos_nave% (
        echo.
        echo ¡BOOM! Chocaste con un asteroide.
        pause
        exit
    )
)

if %distancia% GEQ %meta% (
    echo.
    echo ¡FELICIDADES! Has cruzado el cinturon de asteroides.
    pause
    exit
)

set /p "input=>>> "
if "%input%"=="1" set "pos_nave=1"
if "%input%"=="2" set "pos_nave=2"
if "%input%"=="3" set "pos_nave=3"

set /a "distancia+=1"
set /a "obs_linea+=1"

goto game_loop
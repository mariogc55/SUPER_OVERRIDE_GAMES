@echo off
setlocal enabledelayedexpansion
title Micro-Space Batch v2


set "nave=^"
set "pos_nave=2"
set "distancia=0"
set "meta=50"
set "obs_pos=0"
set "obs_linea=0"

:game_loop
cls

set "o1= " & set "o2= " & set "o3= "
set "n1= " & set "n2= " & set "n3= "


if %obs_linea% GEQ 3 (
    set /a "obs_linea=1"
    set /a "obs_pos=(%random% %% 3) + 1"
) else (
    set /a "obs_linea+=1"
)


if %obs_linea%==1 (
    if %obs_pos%==1 set "o1=X"
    if %obs_pos%==2 set "o2=X"
    if %obs_pos%==3 set "o3=X"
)


if %pos_nave%==1 set "n1=%nave%"
if %pos_nave%==2 set "n2=%nave%"
if %pos_nave%==3 set "n3=%nave%"


echo.
echo    DISTANCIA: %distancia% / %meta%
echo   -------------------------
echo      [1]     [2]     [3]
echo.
echo   I   %o1%   I   %o2%   I   %o3%   I  ^<-- RADAR (PELIGRO)
echo   I-------I-------I-------I
echo   I   %n1%   I   %n2%   I   %n3%   I  ^<-- TU NAVE
echo   -------------------------
echo.
echo Escribe 1, 2 o 3 y pulsa ENTER para moverte y avanzar.
echo (Si solo pulsas ENTER, te mantienes en el sitio)

if %obs_linea%==2 (
    if %obs_pos%==%pos_nave% (
        echo.
        echo ¡BOOM! El asteroide destruyó tu nave en el carril %pos_nave%.
        pause
        exit
    )
)


if %distancia% GEQ %meta% (
    echo.
    echo ¡MISION CUMPLIDA! Has llegado a salvo.
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

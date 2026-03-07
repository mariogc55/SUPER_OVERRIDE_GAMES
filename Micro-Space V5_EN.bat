@echo off
setlocal enabledelayedexpansion
title Micro-Space Batch v5

set "ship= A "
set "empty=   "
set "ship_pos=2"
set "distance=0"
set "goal=50"
set "obs_pos=0"
set "obs_step=0"

:game_loop
cls

set /a "distance+=1"
set /a "obs_step+=1"

if %obs_step% GTR 2 (
    set /a "obs_step=1"
    set /a "obs_pos=(%random% %% 3) + 1"
)

set "o1=%empty%" & set "o2=%empty%" & set "o3=%empty%"
set "n1=%empty%" & set "n2=%empty%" & set "n3=%empty%"

if %obs_step%==1 (
    if %obs_pos%==1 set "o1=[X]"
    if %obs_pos%==2 set "o2=[X]"
    if %obs_pos%==3 set "o3=[X]"
)

if %ship_pos%==1 set "n1=%ship%"
if %ship_pos%==2 set "n2=%ship%"
if %ship_pos%==3 set "n3=%ship%"

echo.
echo    PROGRESS: %distance% / %goal%
echo   =========================
echo      [1]     [2]     [3]
echo   _________________________
echo   I  %o1%  I  %o2%  I  %o3%  I  ^<-- RADAR (DISTANT)
echo   I-------I-------I-------I
echo   I  %n1%  I  %n2%  I  %n3%  I  ^<-- YOUR SHIP (%ship%)
echo   =========================
echo.

if %obs_step%==2 (
    if %obs_pos%==%ship_pos% (
        echo.
        echo   !!! BOOOOOOM !!! 
        echo   Collision in lane %ship_pos%.
        echo.
        pause
        exit
    )
)

if %distance% GEQ %goal% (
    echo.
    echo   !! MISSION ACCOMPLISHED !!
    echo   You reached the destination.
    pause
    exit
)

echo Type 1, 2, or 3 to move and press ENTER.
echo Press ENTER alone to stay in lane.
set "input="
set /p "input=>>> "

if "%input%"=="1" set "ship_pos=1"
if "%input%"=="2" set "ship_pos=2"
if "%input%"=="3" set "ship_pos=3"

goto game_loop
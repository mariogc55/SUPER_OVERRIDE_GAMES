@echo off
setlocal enabledelayedexpansion
title Micro-Space Batch v6 - Deluxe Edition

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

:: Clear the grid layers
for /l %%i in (1,1,3) do (
    set "rt%%i=           "
    set "st%%i=           "
)

:: --- OBSTACLE ART (Asteroid) ---
if %obs_step%==1 (
    if %obs_pos%==1 set "rt1=  .oooo.   " & set "rt2= dP'  `Yb  " & set "rt3= Yb.  .dP  "
    if %obs_pos%==2 set "rt1=  .oooo.   " & set "rt2= dP'  `Yb  " & set "rt3= Yb.  .dP  "
    if %obs_pos%==3 set "rt1=  .oooo.   " & set "rt2= dP'  `Yb  " & set "rt3= Yb.  .dP  "
)

:: --- SHIP ART (Spaceship) ---
set "s_line1=    / \    "
set "s_line2=   |---|   "
set "s_line3=  /_/ \_\  "

if %ship_pos%==1 set "st1=%s_line1%" & set "st2=%s_line2%" & set "st3=%s_line3%"
if %ship_pos%==2 set "st1=%s_line1%" & set "st2=%s_line2%" & set "st3=%s_line3%"
if %ship_pos%==3 set "st1=%s_line1%" & set "st2=%s_line2%" & set "st3=%s_line3%"

:: --- RENDER SCREEN ---
echo.
echo    PROGRESS: [ %distance% / %goal% ]
echo   =========================================
echo           [1]           [2]           [3]
echo   _________________________________________
echo   I %rt1% I %rt1% I %rt1% I
echo   I %rt2% I %rt2% I %rt2% I ^<-- RADAR
echo   I %rt3% I %rt3% I %rt3% I
echo   I-----------I-----------I-----------I
echo   I %st1% I %st2% I %st3% I
echo   I %st1% I %st2% I %st3% I ^<-- YOUR SHIP
echo   I %st1% I %st2% I %st3% I
echo   =========================================
echo.

:: Note: The logic for rendering the specific lane for the ship 
:: was slightly adjusted in the echo lines to match the variables.

if %obs_step%==2 (
    if %obs_pos%==%ship_pos% (
        echo.
        echo   [!] COLLISION DETECTED [!]
        echo   Your ship was crushed by an asteroid in lane %ship_pos%.
        echo.
        pause
        exit
    )
)

if %distance% GEQ %goal% (
    echo.
    echo   [#] MISSION ACCOMPLISHED [#]
    echo   You have successfully navigated the field!
    pause
    exit
)

echo COMMANDS: [1, 2, 3] to move | [ENTER] to stay
set "input="
set /p "input=>>> "

if "%input%"=="1" set "ship_pos=1"
if "%input%"=="2" set "ship_pos=2"
if "%input%"=="3" set "ship_pos=3"

goto game_loop

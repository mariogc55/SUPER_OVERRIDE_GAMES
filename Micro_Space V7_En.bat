@echo off
setlocal enabledelayedexpansion
title Micro-Space v7 - Deep Space

set "ship_pos=2"
set "distance=0"
set "goal=50"
set "obs_pos=0"
set "obs_step=0"

:: Art definitions
set "s1=    / \    "
set "s2=   [---]   "
set "s3=  /_/_\_\  "
set "a1=  .oooo.   "
set "a2= dP'  `Yb  "
set "a3= Yb.  .dP  "
set "blank=           "

:game_loop
cls
set /a "distance+=1"
set /a "obs_step+=1"

:: Cycle: 1(Far), 2(Mid), 3(Near), 4(Collision Check/Reset)
if %obs_step% GTR 4 (
    set /a "obs_step=1"
    set /a "obs_pos=(%random% %% 3) + 1"
)

:: Clear all radar rows
for /l %%i in (1,1,3) do (
    for /l %%j in (1,1,3) do (
        set "r%%i_%%j=%blank%"
    )
)

:: Assign Asteroid based on its current step
if %obs_step%==1 (
    if %obs_pos%==1 (set "r1_1=%a1%" & set "r1_2=%a2%" & set "r1_3=%a3%")
    if %obs_pos%==2 (set "r2_1=%a1%" & set "r2_2=%a2%" & set "r2_3=%a3%")
    if %obs_pos%==3 (set "r3_1=%a1%" & set "r3_2=%a2%" & set "r3_3=%a3%")
)
if %obs_step%==2 (
    set "m1_1=%blank%" & set "m2_1=%blank%" & set "m3_1=%blank%"
    if %obs_pos%==1 (set "m1_1=%a1%" & set "m1_2=%a2%" & set "m1_3=%a3%")
    if %obs_pos%==2 (set "m2_1=%a1%" & set "m2_2=%a2%" & set "m2_3=%a3%")
    if %obs_pos%==3 (set "m3_1=%a1%" & set "m3_2=%a2%" & set "m3_3=%a3%")
) else (
    set "m1_1=%blank%" & set "m1_2=%blank%" & set "m1_3=%blank%"
    set "m2_1=%blank%" & set "m2_2=%blank%" & set "m2_3=%blank%"
    set "m3_1=%blank%" & set "m3_2=%blank%" & set "m3_3=%blank%"
)
if %obs_step%==3 (
    if %obs_pos%==1 (set "n1_1=%a1%" & set "n1_2=%a2%" & set "n1_3=%a3%")
    if %obs_pos%==2 (set "n2_1=%a1%" & set "n2_2=%a2%" & set "n2_3=%a3%")
    if %obs_pos%==3 (set "n3_1=%a1%" & set "n3_2=%a2%" & set "n3_3=%a3%")
) else (
    set "n1_1=%blank%" & set "n1_2=%blank%" & set "n1_3=%blank%"
    set "n2_1=%blank%" & set "n2_2=%blank%" & set "n2_3=%blank%"
    set "n3_1=%blank%" & set "n3_2=%blank%" & set "n3_3=%blank%"
)

:: Ship Setup
set "s1_1=%blank%" & set "s1_2=%blank%" & set "s1_3=%blank%"
set "s2_1=%blank%" & set "s2_2=%blank%" & set "s2_3=%blank%"
set "s3_1=%blank%" & set "s3_2=%blank%" & set "s3_3=%blank%"
if %ship_pos%==1 (set "s1_1=%s1%" & set "s1_2=%s2%" & set "s1_3=%s3%")
if %ship_pos%==2 (set "s2_1=%s1%" & set "s2_2=%s2%" & set "s2_3=%s3%")
if %ship_pos%==3 (set "s3_1=%s1%" & set "s3_2=%s2%" & set "s3_3=%s3%")

:: --- RENDER ---
echo.
echo    PROGRESS: [ %distance% / %goal% ]
echo   =========================================
echo           [1]           [2]           [3]
echo   _________________________________________
echo   : %r1_1% : %r2_1% : %r3_1% :
echo   : %r1_2% : %r2_2% : %r3_2% :  FAR
echo   : %r1_3% : %r2_3% : %r3_3% :
echo   :...........:...........:...........:
echo   : %m1_1% : %m2_1% : %m3_1% :
echo   : %m1_2% : %m2_2% : %m3_2% :  MID
echo   : %m1_3% : %m2_3% : %m3_3% :
echo   :...........:...........:...........:
echo   : %n1_1% : %n2_1% : %n3_1% :
echo   : %n1_2% : %n2_2% : %n3_2% :  NEAR
echo   : %n1_3% : %n2_3% : %n3_3% :
echo   :===========:===========:===========:
echo   : %s1_1% : %s2_1% : %s3_1% :
echo   : %s1_2% : %s2_2% : %s3_2% :  SHIP
echo   : %s1_3% : %s2_3% : %s3_3% :
echo   =========================================
echo.

:: Collision check (at step 4, the asteroid hits the ship's position)
if %obs_step%==4 (
    if %obs_pos%==%ship_pos% (
        echo.
        echo   [!] COLLISION DETECTED [!]
        pause
        exit
    )
)

if %distance% GEQ %goal% (
    echo.
    echo   [#] MISSION ACCOMPLISHED [#]
    pause
    exit
)

echo COMMANDS: [1, 2, 3] to move - [ENTER] to fly
set "input="
set /p "input=>>> "

if "%input%"=="1" set "ship_pos=1"
if "%input%"=="2" set "ship_pos=2"
if "%input%"=="3" set "ship_pos=3"

goto game_loop
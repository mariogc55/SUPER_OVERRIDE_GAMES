@echo off
setlocal enabledelayedexpansion
title Batch Knight - Dungeon Crawler

:: --- initial Stats ---
set /a "hp=20"
set /a "max_hp=20"
set /a "gold=0"
set /a "floor=1"
set "status=You enter the dark dungeon..."
set "event_art=          "

:game_loop
cls
echo.
echo   HP: [ %hp% / %max_hp% ]   GOLD: %gold%   FLOOR: %floor%
echo  -------------------------------------------------
echo.

:: --- Render Event Art ---
echo         %event_art%
echo.
echo   [P]  -- %status%
echo.
echo  -------------------------------------------------
echo   [ENTER] Advance   [1] Drink Potion (5 Gold)   [Q] Quit
echo.

set "input="
set /p "input=>>> "

:: --- Actions ---
if "%input%"=="q" exit
if "%input%"=="1" (
    if %gold% GEQ 5 (
        set /a "gold-=5"
        set /a "hp=%max_hp%"
        set "status=You drank a potion! HP restored."
        set "event_art=  (Potion)  "
    ) else (
        set "status=Not enough gold for a potion!"
    )
    goto game_loop
)

:: --- Random Event Logic (On Enter) ---
set /a "floor+=1"
set /a "event=%random% %% 10"

if %event% LEQ 4 (
    :: Empty Floor
    set "status=The corridor is quiet. You keep walking."
    set "event_art= . . . . . "
) else if %event% LEQ 7 (
    :: Found Gold
    set /a "found=%random% %% 5 + 1"
    set /a "gold+=%found%"
    set "status=You found %found% gold coins on the floor!"
    set "event_art=  $$ $ $$  "
) else (
    :: Enemy Encounter
    set /a "damage=%random% %% 6 + 1"
    set /a "hp-=%damage%"
    set "status=A Goblin attacks! You lose %damage% HP but slay it."
    set "event_art=  p(`o')q  "
)

:: --- Death Check ---
if %hp% LEQ 0 (
    cls
    echo.
    echo   =========================================
    echo             G A M E   O V E R
    echo   =========================================
    echo    Floor reached: %floor%
    echo    Gold collected: %gold%
    echo.
    pause
    exit
)

goto game_loop
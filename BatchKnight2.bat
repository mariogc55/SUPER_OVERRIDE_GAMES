@echo off
setlocal enabledelayedexpansion
title Batch Knight II: The Shadow Realm

:: --- Inicializacion de Variables (Valores Base) ---
set hp=30
set max_hp=30
set gold=10
set floor=1
set xp=0
set lvl=1
set atk=5
set enemy_hp=0
set "status=Welcome to the Dungeon"
set "e_name=None"

:game_loop
cls
:: Calculo de costos de forma aislada
set /a h_cost=lvl+5
set /a a_cost=lvl+10

echo =====================================================
echo  NAME: Sir Batch (Lvl %lvl%)      FLOOR: %floor%
echo  HP: [%hp% / %max_hp%]   XP: %xp%/10   GOLD: %gold%
echo  ATK: %atk%
echo =====================================================
echo.

if %enemy_hp% GTR 0 (
    echo          [ %e_name% ]
    echo           { o . o }
    echo            --m-- 
    echo        HP: %enemy_hp%
    echo.
    echo    [1] ATTACK   [2] FLEE
) else (
    echo           ._____.
    echo           I [?] I
    echo           !_____!
    echo.
    echo    [1] ADVANCE  [2] POTION (%h_cost%G) 
    echo    [3] UPGRADE (%a_cost%G)  [4] QUIT
)
echo.
echo  LOG: "%status%"
echo -----------------------------------------------------
set "opt="
set /p "opt=COMMAND >>> "

:: Filtro de seguridad para evitar saltos vacios
if "%opt%"=="" (
    set "status=Please enter a number"
    goto game_loop
)

if "%opt%"=="1" goto :action_1
if "%opt%"=="2" goto :action_2
if "%opt%"=="3" goto :action_3
if "%opt%"=="4" exit
goto game_loop

:action_1
if %enemy_hp% GTR 0 (
    :: ATAQUE
    set /a dmg=%random% %% atk
    set /a dmg=dmg+1
    set /a enemy_hp=enemy_hp-dmg
    set "status=You hit for !dmg!"
    
    if !enemy_hp! LEQ 0 (
        set /a g_drop=%random% %% 5
        set /a g_drop=g_drop+lvl
        set /a x_drop=lvl*2
        set /a gold=gold+g_drop
        set /a xp=xp+x_drop
        set "status=Victory! +!g_drop! Gold"
        set enemy_hp=0
        goto :check_lvl
    )
    
    set /a e_dmg=%random% %% 4
    set /a e_dmg=e_dmg+lvl
    set /a hp=hp-e_dmg
    set "status=You hit !dmg! / Enemy hits !e_dmg!"
    goto :check_dead
) else (
    :: AVANZAR
    set /a floor=floor+1
    
    if %floor%==50 (
        set "e_name=SHADOW LORD"
        set enemy_hp=100
        set "status=FINAL BOSS APPEARS"
        goto game_loop
    )

    set /a chance=%random% %% 10
    if !chance! LEQ 5 (
        set "status=The floor is empty..."
    ) else if !chance! LEQ 8 (
        set /a enemy_hp=%random% %% 10
        set /a enemy_hp=enemy_hp+floor
        set "e_name=Shadow Beast"
        set "status=An enemy appeared!"
    ) else (
        set /a found=%random% %% 10
        set /a found=found+1
        set /a gold=gold+found
        set "status=Found !found! gold!"
    )
    goto game_loop
)

:action_2
if %enemy_hp% GTR 0 (
    set /a hp=hp-2
    set enemy_hp=0
    set "status=You fled (Took 2 damage)"
    goto :check_dead
) else (
    if %gold% GEQ %h_cost% (
        set /a gold=gold-h_cost
        set hp=%max_hp%
        set "status=Healed!"
    ) else (
        set "status=No gold"
    )
    goto game_loop
)

:action_3
if %gold% GEQ %a_cost% (
    set /a gold=gold-a_cost
    set /a atk=atk+2
    set "status=Weapon Upgraded"
) else (
    set "status=No gold"
)
goto game_loop

:check_lvl
if %xp% GEQ 10 (
    set /a lvl=lvl+1
    set xp=0
    set /a max_hp=max_hp+5
    set hp=max_hp
    set /a atk=atk+1
    set "status=LEVEL UP to !lvl!"
)
goto game_loop

:check_dead
if %hp% LEQ 0 (
    echo GAME OVER.
    pause
    exit
)
if %floor% GTR 50 (
    echo YOU WON!
    pause
    exit
)
goto game_loop
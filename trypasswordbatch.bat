@echo off
setlocal enabledelayedexpansion

set RAR_FILE=example.rar
set CHAR_SET=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
set MAX_LENGTH=4

:: Iterate through all possible combinations
for /l %%L in (1, 1, %MAX_LENGTH%) do (
    call :bruteforce %%L
)

pause
exit

:bruteforce
set LENGTH=%1
set TRY_PASS=
call :gen_pass %LENGTH% 0
goto :eof

:gen_pass
set LENGTH=%1
set INDEX=%2

:: If the generated password length is equal to desired length, try to extract the RAR file
if !INDEX! geq !LENGTH! (
    echo Trying password: !TRY_PASS!
    unrar x -p!TRY_PASS! %RAR_FILE% >nul 2>&1
    if %errorlevel%==0 (
        echo Password found: !TRY_PASS!
        exit /b
    )
    goto :eof
)

:: Iterate through the character set
for %%C in (%CHAR_SET%) do (
    set TRY_PASS=!TRY_PASS!%%C
    call :gen_pass %LENGTH% !INDEX! + 1
    set TRY_PASS=!TRY_PASS:~0,-1!
)

goto :eof

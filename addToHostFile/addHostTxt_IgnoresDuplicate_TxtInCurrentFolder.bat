@echo off
TITLE Modifying your HOSTS file
ECHO.

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %&:"=" 
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

:LOOP
SET Choice=
SET /P Choice="Do you want to modify HOSTS file ? (Y/N)"

IF NOT '%Choice%'=='' SET Choice=%Choice:~0,1%

ECHO.
IF /I '%Choice%'=='Y' GOTO ACCEPTED
IF /I '%Choice%'=='N' GOTO REJECTED
ECHO Please type Y (for Yes) or N (for No) to proceed!
ECHO.
GOTO Loop


:REJECTED
ECHO Your HOSTS file was left unchanged.
ECHO Finished.
GOTO END


:ACCEPTED
setlocal enabledelayedexpansion
::Create your list of host domains
for /F "tokens=1,2 delims=  " %%A in (storedhosts.txt) do (
    
    SET _ip=%%A
    SET _host=%%B
    SET NEWLINE=^& echo.
    ECHO Adding !_ip!       !_host!
    REM REM ::strip out this specific line and store in tmp file
    type %WINDIR%\System32\drivers\etc\hosts > tmp.txt
    ECHO !_host! and !_ip!
    REM REM ::re-add the line to it
    ECHO %NEWLINE%^!_ip!        !_host! >> tmp.txt
    REM ::overwrite host file
    copy /b/v/y tmp.txt %WINDIR%\System32\drivers\etc\hosts
    pause
    del tmp.txt 
)

ipconfig /flushdns
ECHO.
ECHO.
ECHO Finished, you may close this window now.
GOTO END

:END
ECHO.
PAUSE
EXIT
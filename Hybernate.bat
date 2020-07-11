::::::::::::::::::::::::::::::::::::::::::::::::
:: Hybernate V1.0
:: Welpdx
:: Hybernate computer after input time
:: Usage: Place .bat file in C:\Windows\System32
::        for easy run from command line
::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
echo Hours and Minutes until Hybernation?
echo.
set /p hour=Hours:
set /a Hr=%hour%*3600
echo.
set /p min=Minutes:
set /a sec=%min%*60+%Hr%
if %ERRORLEVEL% neq 0 goto ProcessError
echo.
echo Waiting time...
TIMEOUT /T %sec% /NOBREAK
echo.
shutdown /h /f
echo.
pause >nul

echo. done
pause
exit /b 0

:ProcessError
echo Error
pause
exit /b 1

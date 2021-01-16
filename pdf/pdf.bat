@echo off

::echo %~dp0
::set mypath=%cd%
::echo %mypath%

:init
echo ::::::::::::::::::::::::::::::::::::::::::::::::
echo :: pdf.bat V1.0
echo :: Welpdx
echo :: Menu for stuff
echo ::::::::::::::::::::::::::::::::::::::::::::::::
set batdir=%~dp0
set curdir="%cd%\ "
echo %batdir%
echo %curdir%
set txt=".txt"
set pdf=".pdf"
::start %curdir%\flush.bat

:menu
REM --------------------------------------------------------------------------------
REM Menu selection
REM --------------------------------------------------------------------------------
set exitoption=
echo   Available Options:
echo     1) ocrmypdf
echo     2) pdftk get bkmk text file
echo     3) pdftk add bookmarks
echo     4) pdfWriteBookmarks add bookmarks
echo     5) pdftk extract pdf 
echo.
REM echo     5) n^+^+: start notepad^+^+ ^<file^>
echo.
set /p option=.  Enter a number: 
echo.
echo  ----------------------------------------------------
echo.
if "%option%"=="1" goto ocrmp
if "%option%"=="2" goto pdftkg
if "%option%"=="3" goto pdftks
if "%option%"=="4" goto pdfwbg
if "%option%"=="5" goto pdftk_export
REM if "%option%"=="5" goto n
if "%option%"=="q" goto exit
cls
echo Please Try Again
goto init  

REM :n
REM set /p fn=file name:
REM start notepad++ %fn%
REM timeout 2 >nul
REM exit

:ocrmp
set /p pdffni=input pdf file name (input.pdf):
set /p pdffno=output pdf file name (output.pdf):
start /B ocrmypdf --output-type pdf %pdffni% %pdffno% --redo-ocr 
echo ocrmypdf --output-type pdf %pdffni% %pdffno% --redo-ocr
pause >nul
goto exit

:pdftkg
robocopy  %batdir%\pdftk  %curdir% /E
echo pdftk files copied
timeout 2 >nul
cls
set /p pdffn=pdf file name (input.pdf):
set /p txtfn=output text file name (textfile.txt):
start pdftk %pdffn% dump_data output %txtfn%
echo Press Enter to Delete Copied Files and Exit...
pause >nul
del pdftk.exe
del libiconv2.dll

goto exit 


:pdftks
robocopy  %batdir%\pdftk  %curdir% /E
echo pdftk files copied
echo add bookmarks to pdf file
timeout 2 >nul
cls
set /p pdffni=pdf file name (input.pdf):
set /p txtfn=text file name (textfile.txt):
set /p pdffno=output pdf file name (output.pdf):
start pdftk %pdffni% update_info %txtfn% output	%pdffno%
echo Press Enter to Delete Copied Files and Exit...
pause >nul
del pdftk.exe
del libiconv2.dll

goto exit


:pdfwbg
robocopy  %batdir%\pdfwb  %curdir% /E
echo pdfwb files copied
echo add bookmarks to pdf file
timeout 2 >nul
cls
set /p pdffni=pdf file name (input.pdf):
set /p txtfn=text file name (textfile.txt):
set /p pdffno=output pdf file name (output.pdf):


start /B java -jar pdfWriteBookmarks.jar %pdffni% %txtfn% %pdffno%
for /l %%a in (1,1,20) do (
	cls
	call set "bar=%%bar%%#"
	call echo %%bar%%
	ping localhost -n 1 >nul
)
echo Done...
echo Press any key to start deleting stuff...
pause >nul
del pdfWriteBookmarks.jar
:: https://stackoverflow.com/a/7331075/14451841
@RD /S /Q lib REM delete lib folder

if NOT %pdffni% == %pdffno% del %pdffni%
del %txtfn%
goto exit


:pdftk_export
robocopy  %batdir%\pdftk_export  %curdir% /E
echo pdftk files copied
echo add bookmarks to pdf file
timeout 2 >nul
cls
set /p pdffni=pdf file name (input.pdf):

start pdftk_Export.py %pdffni% 
echo Press Enter to Delete Copied Files and Exit...
pause >nul
del pdftk.exe
del PdftkXp.exe
del pdftk_Export.py


:exit
exit


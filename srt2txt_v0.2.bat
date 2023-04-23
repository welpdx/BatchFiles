@echo off
Title SRT2TXT V1.0
Mode con cols=70 lines=20
SETLOCAL ENABLEDELAYEDEXPANSION

:init
cls
REM see colorInTerminal
call :printerInit
call :printer ":::::::::::::::::::::::::::::::::::::::::::::::"
call :printer  ":: SRT2TXT V1.0"
call :printer  ":: Welpdx"
call :printer  :: 
call :printer  :::::::::::::::::::::::::::::::::::::::::::::::
echo [0m
set batdir=%~dp0
set curdir="%cd%\"

set "subdir=SRT2TXT\"



::set "txt=.txt"
::set "i=0"
::set option=


echo START
::create python script
timeout 1 >nul
goto create_py


:run
echo select SRT
pause >nul && timeout 1 >nul
call :fileSelector
echo select SRT && pause >nul && timeout 1 >nul
python "%batdir%%subdir%\SRT2TXT.py" %FileName%
echo python script ran
pause >nul 

timeout 2 >nul && echo deleting py
del "%batdir%%subdir%\SRT2TXT.py"
timeout 2 >nul && echo done!
goto exit


:: ------------ functions -------------------



:: printer begin
:printerInit
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set /a z=0
set colors=[31m [32m [33m [34m [35m [36m [37m 
for %%i in (%colors%) do (
  set colorlist[!z!]=%%i
  set /a z=z+1
  )
goto :eof

:printer
set mytext=%~1
set i=1
set j=0

:NextChar
	set "mytext=!mytext:~0,%i%!%ESC%!colorlist[%j%]!!mytext:~%i%!"
    set /a i=i+1+5
	set /a j=j+1
	if %j% gtr 6 set j=0
    if "!mytext:~%i%,1!" NEQ "" goto NextChar
	echo %mytext%
goto :eof

:: printer end



:create_py
echo creating py start
pause >nul && timeout 1 >nul

if not exist "%batdir%%subdir%\" mkdir %batdir%%subdir% && echo created %batdir%%subdir%

if exist "%batdir%%subdir%\SRT2TXT.py" del "%batdir%%subdir%\SRT2TXT.py" && echo deleted  "%batdir%%subdir%\SRT2TXT.py"



(
echo """
echo Creates readable text file from SRT file.
echo """
echo import re, sys
echo ^#pause to see sys args
echo import time
echo ^#to check sys.argv got the right things that make it main^(^) work
echo ^#print^("sys.argv: ",  sys.argv^)
echo ^#time.sleep^(5^)
echo:
echo:
echo def is_time_stamp^(l^):
echo   if l[:2].isnumeric^(^) and l[2] == ':':
echo     return True
echo   return False
echo:
echo def has_letters^(line^):
echo   if re.search^('[a-zA-Z]', line^):
echo     return True
echo   return False
echo:
echo def has_no_text^(line^):
echo   l = line.strip^(^)
echo   if not len^(l^):
echo     return True
echo   if l.isnumeric^(^):
echo     return True
echo   if is_time_stamp^(l^):
echo     return True
echo   if l[0] == '^(' and l[-1] == '^)':
echo     return True
echo   if not has_letters^(line^):
echo     return True
echo   return False
echo:
echo def is_lowercase_letter_or_comma^(letter^):
echo   if letter.isalpha^(^) and letter.lower^(^) == letter:
echo     return True
echo   if letter == ',':
echo     return True
echo   return False
echo:
echo def clean_up^(lines^):
echo   """
echo   Get rid of all non-text lines and
echo   try to combine text broken into multiple lines
echo   """
echo   new_lines = []
echo   for line in lines[1:]:
echo     if has_no_text^(line^):
echo       continue
echo     elif len^(new_lines^) and is_lowercase_letter_or_comma^(line[0]^):
echo       #combine with previous line
echo       new_lines[-1] = new_lines[-1].strip^(^) + ' ' + line
echo     else:
echo       #append line
echo       new_lines.append^(line^)
echo   return new_lines
echo:
echo def main^(args^):
echo   """
echo     args[1]: file name
echo     args[2]: encoding. Default: utf-8.
echo       - If you get a lot of [?]s replacing characters,
echo       - you probably need to change file_encoding to 'cp1252'
echo   """
echo   file_name = args[1]
echo   file_encoding = ^'utf-8^' if len^(args^) ^< 3 else args[2]
echo   with open^(file_name, encoding=file_encoding, errors='replace'^) as f:
echo     lines = f.readlines^(^)
echo     new_lines = clean_up^(lines^)
echo   new_file_name = file_name[:-4] + '.txt'
echo   with open^(new_file_name, 'w'^) as f:
echo     for line in new_lines:
echo       f.write^(line^)
echo:
echo if __name__ == '__main__':
echo   main^(sys.argv^)
) > "%batdir%%subdir%\SRT2TXT.py"

echo py script created 
goto run

:fileSelector
:: see fileSelector4.bat
:: Filter set to select all first then text second
set cmd=Add-Type -AssemblyName System.Windows.Forms;$f=new-object                 Windows.Forms.OpenFileDialog;$f.InitialDirectory='%curdir%';$f.Filter='All  Files(*.*)^|*.*^|Text Files(*.txt)^|*.txt';$f.Multiselect=$true;[void]$f.ShowDialog();if($f.Multiselect)        {$f.FileNames}else{$f.FileName}
::echo "%cmd%" 
echo Opening file select dialogue...
set pwshcmd=powershell -noprofile -command "&{%cmd%}"
for /f "tokens=* delims=" %%I in ('%pwshcmd%') do call :sum "%%I" ret-
timeout /t 1 >nul
::cls
exit /B
:sum [mud] [ret]
echo "%~1"
set FileName=%FileName% "%~1"
set ret=%FileName%
goto :eof



:exit
echo exiting
timeout /t 1 >nul
exit

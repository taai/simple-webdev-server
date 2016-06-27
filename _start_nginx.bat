@echo off

set CurrentDir=%cd%

tasklist /FI "IMAGENAME eq nginx.exe" 2>NUL | find /I /N "nginx.exe">NUL
if %ERRORLEVEL% == 0 (
	echo NginX is running already.
) else if exist "bin\nginx" (
	echo Starting NginX . . .
	start "" %CurrentDir%\bin\nginx\nginx.exe -p %CurrentDir%\bin\nginx\ -c %CurrentDir%\config\nginx\nginx.conf
) else (
	color 0C
	echo NginX is not installed.
)

echo. & echo. & echo.
pause

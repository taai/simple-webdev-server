@echo off

tasklist /FI "IMAGENAME eq nginx.exe" 2>NUL | find /I /N "nginx.exe">NUL
if %ERRORLEVEL% == 0 if exist "bin\nginx" (
	echo Stopping NginX . . .
	cd .\bin\nginx
	nginx.exe -s stop
	cd ..\..\
)

echo. & echo. & echo.
pause

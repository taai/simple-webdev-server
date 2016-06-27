@echo off

tasklist /FI "IMAGENAME eq php-cgi.exe" 2>NUL | find /I /N "php-cgi.exe">NUL
if %ERRORLEVEL% == 0 if exist "bin\php" (
	echo Stopping PHP FastCGI...
	taskkill /IM php-cgi.exe
)

echo. & echo. & echo.
pause

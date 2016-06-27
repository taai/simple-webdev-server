@echo off

tasklist /FI "IMAGENAME eq php-cgi.exe" 2>NUL | find /I /N "php-cgi.exe">NUL
if %ERRORLEVEL% == 0 (
	echo PHP is running already.
) else if exist "bin\php" (
	echo Starting PHP FastCGI . . .
	.\bin\RunHiddenConsole.exe .\bin\php\php-cgi.exe -b 127.0.0.1:9000 -c .\config\php\php.ini
) else (
	color 0C
	echo PHP is not installed.
)

echo. & echo. & echo.
pause

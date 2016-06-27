@echo off

set CurrentDir=%cd%

tasklist /FI "IMAGENAME eq nginx.exe" 2>NUL | find /I /N "nginx.exe">NUL
if %ERRORLEVEL% == 0 (
	echo NginX is running already.
) else if exist "bin\nginx" (
	echo Starting NginX . . .
	start "" %CurrentDir%\bin\nginx\nginx.exe -p %CurrentDir%\bin\nginx\ -c %CurrentDir%\config\nginx\nginx.conf
)

tasklist /FI "IMAGENAME eq php-cgi.exe" 2>NUL | find /I /N "php-cgi.exe">NUL
if %ERRORLEVEL% == 0 (
	echo PHP FastCGI is running already.
) else if exist "bin\php" (
	echo Starting PHP FastCGI . . .
	.\bin\RunHiddenConsole.exe .\bin\php\php-cgi.exe -b 127.0.0.1:9000 -c .\config\php\php.ini
)

tasklist /FI "IMAGENAME eq postgres.exe" 2>NUL | find /I /N "postgres.exe">NUL
if %ERRORLEVEL% == 0 (
	echo PostgreSQL is running already.
) else if exist "bin\pgsql" (
	echo Starting PostgreSQL . . .
	.\bin\RunHiddenConsole.exe .\bin\pgsql\bin\pg_ctl.exe -D .\data\pgsql -l .\logs\pgsql\logfile start
)

echo. & echo. & echo.
pause

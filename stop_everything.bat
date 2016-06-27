@echo off

tasklist /FI "IMAGENAME eq nginx.exe" 2>NUL | find /I /N "nginx.exe">NUL
if %ERRORLEVEL% == 0 if exist "bin\nginx" (
	echo Stopping NginX . . .
	cd .\bin\nginx
	nginx.exe -s stop
	cd ..\..\
)

tasklist /FI "IMAGENAME eq php-cgi.exe" 2>NUL | find /I /N "php-cgi.exe">NUL
if %ERRORLEVEL% == 0 if exist "bin\php" (
	echo Stopping PHP FastCGI...
	taskkill /IM php-cgi.exe
)

tasklist /FI "IMAGENAME eq postgres.exe" 2>NUL | find /I /N "postgres.exe">NUL
if %ERRORLEVEL% == 0 if exist "bin\pgsql" (
	echo Stopping PostgreSQL . . .
	.\bin\pgsql\bin\pg_ctl.exe -D .\data\pgsql stop
)

echo. & echo. & echo.
pause

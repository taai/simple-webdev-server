@echo off

tasklist /FI "IMAGENAME eq postgres.exe" 2>NUL | find /I /N "postgres.exe">NUL
if %ERRORLEVEL% == 0 if exist "bin\pgsql" (
	echo Stopping PostgreSQL . . .
	.\bin\pgsql\bin\pg_ctl.exe -D .\data\pgsql stop
)

echo. & echo. & echo.
pause

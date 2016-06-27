@echo off

tasklist /FI "IMAGENAME eq postgres.exe" 2>NUL | find /I /N "postgres.exe">NUL
if %ERRORLEVEL% == 0 (
	echo PostgreSQL is running already.
) else if exist "bin\pgsql" (
	echo Starting PostgreSQL . . .
	.\bin\RunHiddenConsole.exe .\bin\pgsql\bin\pg_ctl.exe -D .\data\pgsql -l .\logs\pgsql\logfile start
) else (
	color 0C
	echo PostgreSQL is not installed.
)

echo. & echo. & echo.
pause

@echo off
setlocal EnableDelayedExpansion

rem === Get architecture ===========================================================================
set ARCH=
if "%PROCESSOR_ARCHITECTURE%" == "AMD64" set ARCH=x64
if "%PROCESSOR_ARCHITECTURE%" == "x86" set ARCH=x86

if "%ARCH%" == "" (
	color 0C
	echo Error: Your processor architecture %PROCESSOR_ARCHITECTURE% is not supported by this script.
	pause >nul
	exit
)
rem ================================================================================================

rem === Read version configuration =================================================================
if not exist "install_versions.conf" (
		color 0C
		echo Configuration file "install_versionsz.conf" is missing.
		pause
		exit
)

for /f "delims=" %%x in (install_versions.conf) do (set "%%x")
rem ================================================================================================

rem === Check if the "Visual C++ Redistributable for Visual Studio 2017" is installed ==============
set VCInstalled=
if "%ARCH%" == "x64" reg query "HKEY_CLASSES_ROOT\Installer\Dependencies\,,amd64,14.0,bundle" >nul 2>nul && set VCInstalled=1
if "%ARCH%" == "x64" reg query "HKEY_CLASSES_ROOT\Installer\Dependencies\VC,redist.x64,amd64,14.16,bundle\Dependents\{427ada59-85e7-4bc8-b8d5-ebf59db60423}" >nul 2>nul && set VCInstalled=1
if "%ARCH%" == "x86" reg query "HKEY_CLASSES_ROOT\Installer\Dependencies\,,x86,14.0,bundle" >nul 2>nul && set VCInstalled=1
if "%ARCH%" == "x86" reg query "HKEY_CLASSES_ROOT\Installer\Dependencies\VC,redist.x86,x86,14.16,bundle\Dependents\{67f67547-9693-4937-aa13-56e296bd40f6}" >nul 2>nul && set VCInstalled=1

if "%PHPVersion%" neq "" (

	if "%VCInstalled%" == "" (
		echo YO "%VCInstalled%"
		color 0E
		echo PHP requires "Visual C++ Redistributable for Visual Studio 2017" to be installed.
		echo.
		echo A website will be opened. Download and install "vc_redist.%ARCH%.exe".
		pause
		if "%ARCH%" == "x64" start "" "https://download.visualstudio.microsoft.com/download/pr/9fbed7c7-7012-4cc0-a0a3-a541f51981b5/e7eec15278b4473e26d7e32cef53a34c/vc_redist.x64.exe"
		if "%ARCH%" == "x86" start "" "https://download.visualstudio.microsoft.com/download/pr/d0b808a8-aa78-4250-8e54-49b8c23f7328/9c5e6532055786367ee61aafb3313c95/vc_redist.x86.exe"
		echo.
		echo After you have installed required program, close this window and try again!
		pause >nul
		exit
	)
)
rem ================================================================================================

rem === Install RunHiddenConsole ===================================================================
if not exist "bin\RunHiddenConsole.exe" (
	if not exist "install_files\RunHiddenConsole.zip" (
		if not exist "install_files" mkdir "install_files"

		echo Downloading RunHiddenConsole from WEB . . .
		powershell.exe -nologo -noprofile -command "(new-object System.Net.WebClient).DownloadFile('https://redmine.lighttpd.net/attachments/download/660/RunHiddenConsole.zip', 'install_files\RunHiddenConsole.zip');" || (
			color 0C
			echo Failed to download "RunHiddenConsole.zip" file.
			pause >nul
			exit
		)
	)

	if not exist "install_files\RunHiddenConsole.zip" (
		color 0C
		echo File "RunHiddenConsole.zip" was not found in "install_files" directory.
		pause >nul
		exit
	)

	echo Extracting RunHiddenConsole from ZIP file . . .
	powershell.exe -nologo -noprofile -command "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('install_files\RunHiddenConsole.zip', 'bin');" || (
		color 0C
		echo Failed to unzip "RunHiddenConsole.zip" file.
		pause >nul
		exit
	)
	echo RunHiddenConsole has been extracted.
)
rem ================================================================================================

rem === Install PHP ================================================================================
if "%PHPVersion%" neq "" if not exist "bin\php" (
	echo PHP %PHPVersion% will be installed.

	set PHPZipFilename=php-%PHPVersion%-nts-Win32-VC15-"%ARCH%".zip

	if not exist "install_files\!PHPZipFilename!" (
		if not exist "install_files" mkdir "install_files"

		echo Downloading PHP %PHPVersion% from WEB . . .
		powershell.exe -nologo -noprofile -command "$cli = New-Object System.Net.WebClient; $cli.Headers['User-Agent'] = 'nobody'; $cli.DownloadFile('https://windows.php.net/downloads/releases/!PHPZipFilename!', 'install_files\!PHPZipFilename!');" || (
			color 0C
			echo File "!PHPZipFilename!" was not downloaded correctly.
			pause >nul
			exit
		)
	)

	if not exist "install_files\!PHPZipFilename!" (
		color 0C
		echo File "!PHPZipFilename!" was not found in "install_files" directory.
		pause >nul
		exit
	)

	echo Extracting PHP from ZIP file . . .
	powershell.exe -nologo -noprofile -command "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('install_files\!PHPZipFilename!', 'bin\php');" || (
		color 0C
		echo File "!PHPZipFilename!" in "install_files" directory was not unzipped correcty.
		echo Try to delete it and start over.
		pause >nul
		exit
	)
	echo PHP has been extracted.
)
rem ================================================================================================

rem === Install NginX ==============================================================================
if "%NginXVersion%" neq "" if not exist "bin\nginx" (
	echo NginX %NginXVersion% will be installed.

	set NginXZipFilename=nginx-%NginXVersion%.zip

	if not exist "install_files\!NginXZipFilename!" (
		if not exist "install_files" mkdir "install_files"

		echo Downloading NginX %NginXVersion% from WEB . . .
		powershell.exe -nologo -noprofile -command "(new-object System.Net.WebClient).DownloadFile('https://nginx.org/download/!NginXZipFilename!', 'install_files\!NginXZipFilename!');" || (
			color 0C
			echo Failed to download "!NginXZipFilename!" file.
			pause >nul
			exit
		)
	)

	if not exist "install_files\!NginXZipFilename!" (
		color 0C
		echo File "!NginXZipFilename!" was not found in "install_files" directory.
		pause
		exit
	)

	echo Extracting NginX from ZIP file . . .
	powershell.exe -nologo -noprofile -command "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('install_files\!NginXZipFilename!', 'bin');" || (
		color 0C
		echo Failed to unzip "!NginXZipFilename!" file.
		pause >nul
		exit
	)
	rename "bin\nginx-%NginXVersion%" "nginx"
	echo NginX has been extracted.
)
rem ================================================================================================

rem === Install PostgreSQL =========================================================================
if "%PostgreSQLVersion%" neq "" if not exist "bin\pgsql" (
	echo PostgreSQL %PostgreSQLVersion% will be installed.

	if "%ARCH%" == "x86" set PostgreSQLZipFilename=postgresql-%PostgreSQLVersion%-1-windows-binaries.zip
	if "%ARCH%" == "x64" set PostgreSQLZipFilename=postgresql-%PostgreSQLVersion%-1-windows-x64-binaries.zip

	if not exist "install_files\!PostgreSQLZipFilename!" (
		if not exist "install_files" mkdir "install_files"

		echo Downloading PostgreSQL %PostgreSQLVersion% from WEB . . .
		powershell.exe -nologo -noprofile -command "(new-object System.Net.WebClient).DownloadFile('https://get.enterprisedb.com/postgresql/!PostgreSQLZipFilename!', 'install_files\!PostgreSQLZipFilename!');" || (
			color 0C
			echo Failed to download "!PostgreSQLZipFilename!" file.
			pause >nul
			exit
		)
	)

	if not exist "install_files\!PostgreSQLZipFilename!" (
		color 0C
		echo File "!PostgreSQLZipFilename!" was not found in "install_files" directory.
		pause
		exit
	)

	echo Extracting PostgreSQL from ZIP file . . .
	powershell.exe -nologo -noprofile -command "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('install_files\!PostgreSQLZipFilename!', 'bin');" || (
		color 0C
		echo Failed to unzip "!PostgreSQLZipFilename!" file.
		pause >nul
		exit
	)
	echo PostgreSQL has been extracted.
)
rem ================================================================================================

rem === Set up PostgreSQL database =================================================================
if "%PostgreSQLVersion%" neq "" if not exist "data\pgsql\PG_VERSION" (
	if not exist "data\pgsql" mkdir "data\pgsql"
	if not exist "logs\pgsql" mkdir "logs\pgsql"

	echo Initializing PostgreSQL database . . .
	echo secret> postgresql_password.temp
	.\bin\pgsql\bin\initdb -D .\data\pgsql -U homestead --pwfile=postgresql_password.temp
	del postgresql_password.temp
	echo PostgreSQL database initialized.

	echo Setting up a new PostgreSQL database "homestead" . . .
	.\bin\pgsql\bin\pg_ctl.exe -D .\data\pgsql -l .\logs\pgsql\logfile start
	.\bin\pgsql\bin\createdb -U homestead homestead
	.\bin\pgsql\bin\pg_ctl.exe -D .\data\pgsql stop
	echo Database "homestead" has been created.
)
rem ================================================================================================

rem === Set public directory =======================================================================
if "%NginXVersion%" neq "" if not exist "www\public" (
	echo Creating "www\public" directory . . .
	mkdir "www\public"
	echo Directory created.
)
rem ================================================================================================

color 0A
echo. & echo. & echo. & echo All done.
pause

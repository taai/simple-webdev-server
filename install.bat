@echo off
setlocal EnableDelayedExpansion

rem === Read version configuration =================================================================
if not exist "install_versions.conf" (
		color 0C
		echo Configuration file "install_versionsz.conf" is missing.
		pause
		exit
)

for /f "delims=" %%x in (install_versions.conf) do (set "%%x")
rem ================================================================================================

rem === Install RunHiddenConsole ===================================================================
if not exist "bin\RunHiddenConsole.exe" (
	if not exist "install_files\RunHiddenConsole.zip" (
		echo Downloading RunHiddenConsole from WEB . . .
		if not exist "install_files" mkdir "install_files"
		powershell.exe -nologo -noprofile -command "& { (new-object System.Net.WebClient).DownloadFile('http://redmine.lighttpd.net/attachments/660/RunHiddenConsole.zip', 'install_files\RunHiddenConsole.zip'); }"
		echo Download has finished.
	)

	if not exist "install_files\RunHiddenConsole.zip" (
		color 0C
		echo File "RunHiddenConsole.zip" was not found in "install_files" directory.
		pause
		exit
	)

	echo Extracting RunHiddenConsole from ZIP file . . .
	powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('install_files\RunHiddenConsole.zip', 'bin'); }"
	echo RunHiddenConsole has been extracted.
)
rem ================================================================================================

rem === Check if the "Visual C++ Redistributable for Visual Studio 2015" is installed ==============
if "%PHPVersion%" neq "" (
	reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Dependencies\{2e085fd2-a3e4-4b39-8e10-6b8d35f55244}" >nul 2>nul || (
		color 0E
		echo PHP requires "Visual C++ Redistributable for Visual Studio 2015" to be installed.
		echo.
		echo A website will be opened. Download and install "vc_redist.x86.exe".
		pause
		start "" "https://www.microsoft.com/en-us/download/details.aspx?id=48145"
		echo.
		echo After you have installed required program, close this window and try again!
		pause >nul
		exit
	)
)
rem ================================================================================================

rem === Install PHP ================================================================================
if "%PHPVersion%" neq "" if not exist "bin\php" (
	echo PHP %PHPVersion% will be installed.

	set PHPZipFilename=php-%PHPVersion%-nts-Win32-VC14-x86.zip

	if not exist "install_files\!PHPZipFilename!" (
		echo Downloading PHP %PHPVersion% from WEB . . .
		if not exist "install_files" mkdir "install_files"
		powershell.exe -nologo -noprofile -command "& { (new-object System.Net.WebClient).DownloadFile('http://windows.php.net/downloads/releases/!PHPZipFilename!', 'install_files\!PHPZipFilename!'); }"
		echo Download has finished.
	)

	if not exist "install_files\!PHPZipFilename!" (
		color 0C
		echo File "!PHPZipFilename!" was not found in "install_files" directory.
		pause
		exit
	)

	echo Extracting PHP from ZIP file . . .
	powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('install_files\!PHPZipFilename!', 'bin\php'); }"
	echo PHP has been extracted.
)
rem ================================================================================================

rem === Install NginX ==============================================================================
if "%NginXVersion%" neq "" if not exist "bin\nginx" (
	echo NginX %NginXVersion% will be installed.

	set NginXZipFilename=nginx-%NginXVersion%.zip

	if not exist "install_files\!NginXZipFilename!" (
		echo Downloading NginX %NginXVersion% from WEB . . .
		if not exist "install_files" mkdir "install_files"
		powershell.exe -nologo -noprofile -command "& { (new-object System.Net.WebClient).DownloadFile('http://nginx.org/download/!NginXZipFilename!', 'install_files\!NginXZipFilename!'); }"
		echo Download has finished.
	)

	if not exist "install_files\!NginXZipFilename!" (
		color 0C
		echo File "!NginXZipFilename!" was not found in "install_files" directory.
		pause
		exit
	)

	echo Extracting NginX from ZIP file . . .
	powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('install_files\!NginXZipFilename!', 'bin'); }"
	rename "bin\nginx-%NginXVersion%" "nginx"
	echo NginX has been extracted.
)
rem ================================================================================================

rem === Install PostgreSQL =========================================================================
if "%PostgreSQLVersion%" neq "" if not exist "bin\pgsql" (
	echo PostgreSQL %PostgreSQLVersion% will be installed.

	set PostgreSQLZipFilename=postgresql-%PostgreSQLVersion%-1-windows-binaries.zip

	if not exist "install_files\!PostgreSQLZipFilename!" (
		echo Downloading PostgreSQL %PostgreSQLVersion% from WEB . . .
		if not exist "install_files" mkdir "install_files"
		powershell.exe -nologo -noprofile -command "& { (new-object System.Net.WebClient).DownloadFile('http://get.enterprisedb.com/postgresql/!PostgreSQLZipFilename!', 'install_files\!PostgreSQLZipFilename!'); }"
		echo Download has finished.
	)

	if not exist "install_files\!PostgreSQLZipFilename!" (
		color 0C
		echo File "!PostgreSQLZipFilename!" was not found in "install_files" directory.
		pause
		exit
	)

	echo Extracting PostgreSQL from ZIP file . . .
	powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('install_files\!PostgreSQLZipFilename!', 'bin'); }"
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

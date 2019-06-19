# Simple WebDev server set for Windows

The web development server set is made just of batch (.bat) scripts. The set is portable, you can store it on a flash drive.

If you don't want to install anything on your Windows machine or you want your project to use specific program version without reinstalling programs on your machine, or you just don't want to use heavy web development environment, this is for you. You control everything – you can can read and edit the batch scripts, if you want.

Currently this set contains of:
* newest [stable] PHP
* NginX
* PostgreSQL

## Usage

You can choose the program versions to install by editing the ```install_versions.conf``` file. The programs are being downloaded and extracted by executing ```install.bat``` script. You can also store pre-downloaded program files in ```install_files``` directory. If you don't want to install some program, remove its configuration line from ```install_versions.conf``` file.

**N.B.** Check if the newest [stable] PHP version number is set in ```install_versions.conf``` file, because PHP doesn't keep older PHP versions for download. For this reason you may want to pre-download it, if you plan to distribute this set for other people to use without making them to configure anything.

To start all programs, execute the ```start_everything.bat``` script. To stop all programs, execute the ```stop_everything.bat``` script. To start/stop programs seperately, execute other scripts which has very self-explanatory names.

The public web directory is ```www/public```.

The PHP and NginX configuration is stored in ```config``` directory.

Default PostgreSQL username is ```homestead``` and password is ```secret``` – just like in [Laravel Homestead](https://laravel.com/docs/master/homestead).

## Requirements

This probably works on any Windows 7/8/10 with pre-installed .NET 4+ (used for downloading and extracting ZIP files).

If you want to use PHP, the *Visual C++ Redistributable for Visual Studio 2017* is required to be installed on Windows machine. The ```install.bat``` script will open a download page for it, if it is not installed.

Also a small utility [RunHiddenConsole.exe](https://redmine.lighttpd.net/attachments/download/660/RunHiddenConsole.zip', 'install_files\RunHiddenConsole.zip) is being downloaded and used to start programs without keeping the "black screens" open.

## License

This set of batch scripts is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT).

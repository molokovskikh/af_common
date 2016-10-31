$ErrorActionPreference = "Stop"
choco feature enable -n=allowGlobalConfirmation
choco install mysql.workbench notepadplusplus 7zip googlechrome sysinternals consolez ilspy
choco install nuget.commandline -version 2.8.6
if ( -Not (Test-Path "C:\Program Files (x86)\Microsoft Visual Studio 14.0" )) {
  choco install visualstudio2015community
}
choco install resharper-platform -version 104.0.20151218.134438
choco install wget nano --source cygwin
if ( -Not (Test-Path "C:\tools\mysql" ))
{
  $source="\\offdc\MMedia\Московский офис\Файлы для установки системы (развертывания проекта с нуля)\файлы настроек\apps\MySQL\mysql-5.6.14-winx64"
  if ( Test-Path "mysql")
  {
    $source="mysql"
  }
  cp -r $source "C:\tools\mysql"
  C:\tools\mysql\bin\mysqld.exe --install
  net start mysql
}
C:\tools\cygwin\bin\bash --login -c "git config --global color.branch auto"
C:\tools\cygwin\bin\bash --login -c "git config --global color.diff auto"
C:\tools\cygwin\bin\bash --login -c "git config --global color.interactive auto"
C:\tools\cygwin\bin\bash --login -c "git config --global color.status auto"
C:\tools\cygwin\bin\bash --login -c "git config --global core.whitespace trailing-space,space-before-tab,cr-at-eol"
C:\tools\cygwin\bin\bash --login -c "git config --global core.editor nano"
$username=[Environment]::UserName
cp $env:USERPROFILE\projects\common\etc\.bashrc "C:\tools\cygwin\home\$username\.bashrc"
if ( -Not (Test-Path $env:USERPROFILE\AppData\Roaming\Console\)) {
    mkdir $env:USERPROFILE\AppData\Roaming\Console\
}
cp $env:USERPROFILE\projects\common\etc\Console.xml $env:USERPROFILE\AppData\Roaming\Console\Console.xml
$sources=nuget source
$sourceExists=$false
foreach ($line in $sources) {
	$sourceExists=$line.ToLower().IndexOf("common\nuget\") -ge 0
	if ($sourceExists) {
		break
	}
}
if (-Not $sourceExists) {
	nuget source add -Name local -Source $env:USERPROFILE/projects/common/nuget/
}
C:\tools\cygwin\bin\bash --login -c '/cygdrive/c/users/$USER/projects/common/install'

function curlex($url, $filename) {
  $path = [io.path]::gettemppath() + "\" + $filename
  if( test-path $path ) { rm -force $path }
  (new-object net.webclient).DownloadFile($url, $path)

  return new-object io.fileinfo $path
}

function installsilently($url, $name) {
  echo "Installing $name"
  $extension = (curlex $url $name).FullName
  $result = Start-Process -FilePath "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\VSIXInstaller.exe" -ArgumentList "/q $extension" -Wait -PassThru;
}

installsilently https://visualstudiogallery.msdn.microsoft.com/c8bccfe2-650c-4b42-bc5c-845e21f96328/file/75539/12/EditorConfigPlugin.vsix EditorConfigPlugin.vsix
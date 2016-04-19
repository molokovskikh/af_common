choco feature enable -n=allowGlobalConfirmation
choco install mysql.workbench
choco install notepadplusplus
choco install 7zip
choco install googlechrome
choco install sysinternals
choco install nuget.commandline
choco install visualstudio2015community
choco install consolez
choco install ilspy
cyg-get wget nano
if ( -Not (Test-Path "C:\tools\mysql" ))
{
 cp -r "\\offdc\MMedia\Московский офис\Файлы для установки системы (развертывания проекта с нуля)\файлы настроек\apps\MySQL\mysql-5.6.14-winx64" "C:\tools\mysql"
 C:\tools\mysql\bin\mysqld.exe --install
 net start mysql
}
bash --login -c git config --global color.branch auto
bash --login -c git config --global color.diff auto
bash --login -c git config --global color.interactive auto
bash --login -c git config --global color.status auto
bash --login -c git config --global core.whitespace trailing-space,space-before-tab,cr-at-eol
bash --login -c git config --global core.editor nano
cp -r "\\offdc\MMedia\Московский офис\Файлы для установки системы (развертывания проекта с нуля)\файлы настроек\.bashrc" "C:\tools\cygwin\home\$env:USERNAME\.bashrc"
if ( -Not (Test-Path $env:USERPROFILE\AppData\Roaming\Console\)) {
    mkdir $env:USERPROFILE\AppData\Roaming\Console\
}
cp $env:USERPROFILE\projects\common\Console.xml $env:USERPROFILE\AppData\Roaming\Console\Console.xml
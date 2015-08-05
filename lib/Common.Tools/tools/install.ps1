param($installPath, $toolsPath, $package, $project)

$git="git.exe"
if (Test-Path "C:\cygwin\bin\git.exe") {
	$git="C:\cygwin\bin\git.exe"
}
mkdir lib -erroraction 'silentlycontinue'
invoke-expression "$git submodule add git@git.analit.net:root/common-tools.git lib/common.tools"
invoke-expression "$git submodule update --init"
$path = "lib/common.tools/common.tools/common.tools.csproj" | resolve-path
$dte.solution.addfromfile($path)

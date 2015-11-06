param($installPath, $toolsPath, $package, $project, $name="common-tools")
$env:Path = $env:Path + ";C:\cygwin\bin"

$git="git.exe"
if (Test-Path "C:\cygwin\bin\git.exe") {
	$git="C:\cygwin\bin\git.exe"
}
mkdir lib -erroraction 'silentlycontinue'
invoke-expression "$git submodule add git@git.analit.net:root/$name.git lib/$name"
invoke-expression "$git submodule update --init"
$localname = $name -replace "-", "."
$path = "lib/$name/$localName/$localName.csproj" | resolve-path
$dte.solution.addfromfile($path)

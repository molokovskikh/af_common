param($installPath, $toolsPath, $package, $project)

mkdir lib -erroraction 'silentlycontinue'
git submodule add git@git.analit.net:root/common-tools.git lib/common.tools
git submodule update --init
$path = "lib/common.tools/common.tools/common.tools.csproj" | resolve-path
$dte.solution.addfromfile($path)

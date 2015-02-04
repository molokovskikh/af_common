param($installPath, $toolsPath, $package, $project)

mkdir lib -erroraction 'silentlycontinue'
git submodule add git@git.analit.net:root/test-support.git lib/test.support
git submodule update --init
$path = "lib/test.support/test.support/Test.Support.csproj" | resolve-path
$dte.solution.addfromfile($path)

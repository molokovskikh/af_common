import System.Linq
import Bake.Engine

def GetBuildConfig(globals as DuckDictionary):
	project = globals.Maybe.Project or globals.Maybe.project
	unless project:
		sln = FileSet("src/*.sln").Files.FirstOrDefault()
		raise "Не удалось определить имя проекта его нет в build.bake и src/*.sln не найден" unless sln
		project = Path.GetFileNameWithoutExtension(sln)
	buildTo = Path.GetFullPath(Path.Combine(globals.BuildRoot, project))
	projectFile = Path.GetFullPath("src/${project}/${project}.csproj")
	return (project, buildTo, projectFile)

def GetBuildConfig(globals as duck, project as string):
	buildTo = Path.GetFullPath(Path.Combine(globals.BuildRoot, project))
	projectFile = Path.GetFullPath("src/${project}/${project}.csproj")
	return (buildTo, projectFile)

def Build(globals as duck):
	project, _, _ = GetBuildConfig(globals)
	Build(globals, project)

def Build(globals as duck, project as string):
	buildTo, projectFile = GetBuildConfig(globals, project)
	MsBuild(projectFile,
			Target : "build",
			Parameters : { "OutputPath" : buildTo, "Configuration" : "release" },
			FrameworkVersion : globals.FrameworkVersion).Execute()
	Rm("${buildTo}/*.xml")
	src = Path.Combine("src/${project}/", "App." + GetConfigSufix(globals))
	config = "${buildTo}/${project}.exe.config"
	unless Exist(config):
		config = FileSet("$buildTo/*.config").Files.FirstOrDefault() or config
	Cp(src, config, true) if Exist(src)

def Clean(globals as duck):
	project, _, _ = GetBuildConfig(globals)
	Clean(globals, project)

def Clean(globals as duck, project as string):
	buildTo, projectFile = GetBuildConfig(globals, project)
	MsBuild(projectFile,
			Target : "clean",
			Parameters : { "OutputPath" : buildTo, "Configuration" : "release" },
			FrameworkVersion : globals.FrameworkVersion).Execute()
	if Exist(buildTo):
		Rm("${buildTo}/*", true)
	else:
		MkDir(buildTo)

def XCopyDeploy(globals as duck):
	project, _, _ = GetBuildConfig(globals)
	deploy = GetDeploy(globals, project)
	XCopyDeploy(globals, project, deploy)

def XCopyDeploy(globals as duck, project as string):
	deploy = GetDeploy(globals, project)
	XCopyDeploy(globals, project, deploy)

def XCopyDeploy(globals as duck, name as string, deployTo as string):
	buildTo, _ = GetBuildConfig(globals, name)

	files = FileSet("**/*.*", Excludes : GetExcludes(globals), BaseDirectory : buildTo)
	conf as DuckDictionary = globals.Configuration
	if conf.Maybe.Simulate:
		print "${files.Files.Count} files deployed to $deployTo"
		return
	Cp(files, deployTo, true)
	print "${files.Files.Count} files deployed to $deployTo"

def GetExcludes(globals as DuckDictionary):
	excludes = List()
	if globals.Maybe.ExcludesDeployDirectory:
		for directory in globals.ExcludesDeployDirectory:
			excludes.Add(directory)
	return excludes

def GetDeploy(globals as duck):
	project, _, _ = GetBuildConfig(globals)
	return GetDeploy(globals, project)

def GetDeploy(globals as DuckDictionary, project as string):
	deployTo = Path.Combine(globals.DeployRoot, project)

	if globals.Maybe.DeployAlias:
		deployTo = Path.Combine(globals.DeployRoot, globals.DeployAlias)

	if globals.Maybe.deployTo:
		deployTo = globals.deployTo

	if globals.Maybe.DeployTo:
		deployTo = globals.DeployTo

	if not deployTo:
		raise """Не знаю куда разворачивать проект нужно задать либо Globals.DeployTo = '<путь куда выкладывать>'
	либо название проекта Globals.Project тогда он будет выложен на Globals.DeployRoot по умолчанию это \\acdcserv.adc.analit.net\WebApps\"""
	return deployTo

import System.Linq
import Bake.Engine

def StartServices(services as ServiceController*):
	for service in services:
		service.Start()

def StopServices(services as ServiceController*):
	for service in services:
		if service.Status != ServiceControllerStatus.Stopped:
			service.Stop()

	for service in services:
		done = false
		iteration = 0
		while not done:
			iteration++
			service.WaitForStatus(ServiceControllerStatus.Stopped, TimeSpan.FromSeconds(20))
			done = service.Status == ServiceControllerStatus.Stopped or iteration > 3
			if not done:
				print "служба не остановилась за 20 секунд, буду ждать, всего жду 3 раза по 20 секунд"

def Impersonate(globals as DuckDictionary, server as string, action as Action):
	user as string
	password as string
	user = ""
	password = ""

	if globals.Maybe.User:
		user = globals.User
	if globals.Maybe.Password:
		password = globals.Password

	if String.IsNullOrEmpty(user) or String.IsNullOrEmpty(password):
		Console.Write("user for $server: ")
		user = Console.ReadLine()
		Console.Write("password: ")
		password = GetPassword()


	LOGON32_PROVIDER_DEFAULT = 0;
	LOGON32_LOGON_INTERACTIVE = 2;
	tokenHandle = IntPtr.Zero;

	if not LogonUser(user, "", password, LOGON32_LOGON_INTERACTIVE, LOGON32_PROVIDER_DEFAULT, tokenHandle):
		raise Win32Exception()

	globals.User = user
	globals.Password = password

	using WindowsIdentity.Impersonate(tokenHandle):
		try:
			action()
		ensure:
			CloseHandle(tokenHandle);

def GetServices(serviceName as string, servers as string*):
	services = List of ServiceController()
	for server in servers:
		serverServices = ServiceController.GetServices(server).Where({s| s.ServiceName == serviceName}).ToList()
		if not serverServices.Count:
			raise "Can`t find service \"${serviceName}\" on server ${server}"
		services.AddRange(serverServices)
	return services

def GetBuildConfig(globals as DuckDictionary):
	project = globals.Maybe.Project or globals.Maybe.project
	unless project:
		sln = FileSet("src/*.sln").Files.FirstOrDefault()
		raise "Не удалось определить имя проекта его нет в build.bake и src/*.sln не найден" unless sln
		project = Path.GetFileNameWithoutExtension(sln)
	buildTo = Path.GetFullPath(Path.Combine(globals.BuildRoot, project))
	projectFile = FileSet("src/${project}/${project}.*proj").FirstOrDefault()
	raise "Не могу найти файл проекта src/${project}/${project}.*proj" unless projectFile
	return (project, buildTo, projectFile)

def GetBuildConfig(globals as DuckDictionary, project as string):
	if Exist(project):
		#предполагаю что имя проекта в формате src/<project>/app/app.csproj
		output = Path.Combine(globals.BuildRoot, Path.GetFileName(Path.GetDirectoryName(Path.GetDirectoryName(project))))
		output = Path.GetFullPath(output)
		return (output, project)
	buildTo = Path.GetFullPath(Path.Combine(globals.BuildRoot, project))
	projectFile = FileSet("src/${project}/${project}.*proj").FirstOrDefault()
	raise "Не могу найти файл проекта src/${project}/${project}.*proj" unless projectFile
	return (buildTo, projectFile)

def Build(globals as DuckDictionary):
	project, _, _ = GetBuildConfig(globals)
	Build(globals, project)

def Build(globals as DuckDictionary, project as string):
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

def DeployService(globals as DuckDictionary, app as string, host as string):
	DeployService(globals, app, host, "\\\\$host\\apps\\$app")

def DeployService(globals as DuckDictionary, app as string, host as string, path as string):
	buildTo, _ = GetBuildConfig(globals, app)
	Impersonate(globals, host):
		services = GetServices(app, (host, ))
		StopServices(services)
		RepeatTry:
			XCopyDeploy(globals, app, path)
		StartServices(services)

def CopyAssets(output as string):
	return unless Exist("packages")
	return unless Exist("src/Common.Web.UI/Common.Web.Ui/Assets/Content/")

	assets = Path.Combine(output, "Assets", "Javascripts")
	for dir in Directory.GetDirectories("packages"):
		path = Path.Combine(dir, "Content", "Scripts")
		continue unless Exist(path)
		javaScripts = FileSet("*.min.js", BaseDirectory: path)
		if javaScripts.Files.Count:
			Cp(javaScripts, assets)
		else:
			Cp(FileSet("**.*", BaseDirectory: path), assets)
	javaScripts = FileSet("src/Common.Web.UI/Common.Web.Ui/Assets/Content/javascripts/**.*")
	Cp(javaScripts, assets) if javaScripts.Files.Count

	assets = Path.Combine(output, "Assets", "images")
	images = FileSet("src/Common.Web.UI/Common.Web.Ui/Assets/Content/images/**.*")
	Cp(images, assets, true) if images.Files.Count

	assets = Path.Combine(output, "Assets", "Stylesheets")
	for dir in Directory.GetDirectories("packages"):
		path = Path.Combine(dir, "Content", "Content")
		continue unless Exist(path)
		Cp(FileSet("**.*", BaseDirectory: path), assets)
	styleSheets = FileSet("src/Common.Web.UI/Common.Web.Ui/Assets/Content/Stylesheets/**.*")
	Cp(styleSheets, assets) if styleSheets.Files.Count

def BuildWeb(globals as DuckDictionary, project as string):
	buildTo, projectFile = GetBuildConfig(globals, project)
	projectPath = Path.GetDirectoryName(projectFile)

	MkDir(buildTo) if not Exist(buildTo)
	params = { "OutDir" : "${buildTo}\\bin\\",
		"OutputPath" : "${buildTo}\\bin\\",
		"Configuration" : "Release"}
	if globals.Maybe.Platform:
		params.Add("Platform", globals.Platform)
	sln = FileSet("src/*.sln").First()
	target = project
	if Exist(project):
		target = "Build"
		sln = project
	MsBuild(sln, "/verbosity:quiet", "/nologo",
			Target : target,
			Parameters : params,
			FrameworkVersion : globals.FrameworkVersion).Execute()
	Rm("${buildTo}/bin/*.xml")
	Cp(FileSet(["**/*.as?x",
				"**/*.svc",
				"**/*.brail",
				"**/*.brailjs",
				"**/*.swf",
				"**/*.gif",
				"**/*.png",
				"**/*.ico",
				"**/*.jpg",
				"**/*.js",
				"**/*.woff",
				"**/*.ttf",
				"**/*.svg",
				"**/*.eot",
				"**/*.zip",
				"**/*.css",
				"**/*.skin",
				"**/*.htm",
				"**/*.sitemap",
				"**/*.master",
				"**/*.ico",
				"**/*.odt",
				"**/*.doc",
				"**/*.svc",
				"robots.txt",
				"crossdomain.xml"],
				BaseDirectory: projectPath),
		buildTo, true)
	sufix = GetConfigSufix(globals)
	Cp("$projectPath/web.$sufix", "${buildTo}/Web.config")
	CopyAssets(buildTo)

def CleanWeb(globals as DuckDictionary, project as string):
	buildTo, projectFile = GetBuildConfig(globals, project)
	sln = FileSet("src/*.sln").First()
	target = "$project:clean"
	if Exist(project):
		target = "Clean"
		sln = project
	MsBuild(sln, "/verbosity:quiet", "/nologo",
			Target : target,
			Parameters : { "OutDir" : "${buildTo}\\bin\\",
						"Configuration" : "release" },
			FrameworkVersion : globals.FrameworkVersion).Execute()
	Rm("${buildTo}/*", true) if Exist(buildTo)

def Clean(globals as DuckDictionary):
	project, _, _ = GetBuildConfig(globals)
	Clean(globals, project)

def Clean(globals as DuckDictionary, project as string):
	buildTo, projectFile = GetBuildConfig(globals, project)
	MsBuild(projectFile,
			Target : "clean",
			Parameters : { "OutputPath" : buildTo, "Configuration" : "release" },
			FrameworkVersion : globals.FrameworkVersion).Execute()
	if Exist(buildTo):
		Rm("${buildTo}/*", true)
	else:
		MkDir(buildTo)

def XCopyDeploy(globals as DuckDictionary):
	project, _, _ = GetBuildConfig(globals)
	deploy = GetDeploy(globals, project)
	XCopyDeploy(globals, project, deploy)

def XCopyDeploy(globals as DuckDictionary, project as string):
	deploy = GetDeploy(globals, project)
	XCopyDeploy(globals, project, deploy)

def XCopyDeploy(globals as DuckDictionary, name as string, deployTo as string):
	buildTo, _ = GetBuildConfig(globals, name)

	files = FileSet("**/*.*", Excludes : GetExcludes(globals), BaseDirectory : buildTo)
	conf as DuckDictionary = globals.Configuration
	if conf.Maybe.Simulate:
		print "${files.Files.Count} files deployed to $deployTo"
		return
	impersonate = conf.Maybe.impersonate != null
	if impersonate:
		ImpersonateUser("deployer", '$sdfsd887!'):
			Cp(files, deployTo, true)
	else:
		Cp(files, deployTo, true)
	print "${files.Files.Count} files deployed to $deployTo"

def GetExcludes(globals as DuckDictionary):
	excludes = List()
	if globals.Maybe.ExcludesDeployDirectory:
		for directory in globals.ExcludesDeployDirectory:
			excludes.Add(directory)
	return excludes

def GetDeploy(globals as DuckDictionary):
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

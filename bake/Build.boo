import System
import System.Linq
import Bake.Engine
import FubuCsProjFile
import System.Linq.Enumerable

def GetConfigSufix(Globals as duck):
	if Globals.Environment == @Production:
		return "release.config"
	if Globals.Environment == @Local:
		return "config"
	env = Globals.Environment.ToLower()
	return "$env.config"

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

	i = 0
	while true:
		i++
		if String.IsNullOrEmpty(user) or String.IsNullOrEmpty(password):
			Console.Write("user for $server: ")
			user = Console.ReadLine()
			Console.Write("password: ")
			password = GetPassword()


		LOGON32_PROVIDER_DEFAULT = 0;
		LOGON32_LOGON_INTERACTIVE = 2;
		tokenHandle = IntPtr.Zero;
		try:
			if not LogonUser(user, "", password, LOGON32_LOGON_INTERACTIVE, LOGON32_PROVIDER_DEFAULT, tokenHandle):
				raise Win32Exception()
			break
		except e:
			user = null
			password = null
			if i > 3:
				raise
			print "${i}/3 - ${e.Message}"

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
	return GetBuildConfig(globals, null)

def FindSln():
	return Sln().FirstOrDefault()

def Sln():
	return FileSet("src/*.sln").Concat(FileSet("*.sln"))

def GetBuildConfig(globals as DuckDictionary, project as string):
	sln = FindSln()
	unless project:
		project = globals.Maybe.Project or globals.Maybe.project
		unless project:
			raise "Не удалось определить имя проекта его нет в build.bake и src/*.sln не найден" unless sln
			project = Path.GetFileNameWithoutExtension(sln)

	#если передано полное имя
	if File.Exists(project):
		projectFile = project
	else:
		#если передано частичное имя
		#проверяю src/<project>/app/app.*proj
		projectFile = FileSet("src/$project/app/app.*proj").FirstOrDefault()
		#проверяю src/<project>/<project>.*proj
		posiblePath = projectFile or FileSet("src/$project/$project.*proj").FirstOrDefault()
		projectFile = projectFile or FileSet("**/$project.*proj").FirstOrDefault()
		unless projectFile:
			if sln:
				solution = Solution.LoadFrom(sln)
				projectFile = solution.Projects.Where({p| p.Project.AssemblyName == project}).Select({p| p.Project.FileName}).FirstOrDefault()
		unless projectFile:
			raise "Не могу найти файл проекта $project"
	projectName = CsProjFile.LoadFrom(projectFile).AssemblyName
	output = Path.GetFullPath(Path.Combine(globals.BuildRoot, projectName))
	return (projectName, output, projectFile)

def CleanDeployDir(globals as DuckDictionary):
	CleanDeployDir(globals, null, null)

def CleanDeployDir(globals as DuckDictionary, project as string):
	CleanDeployDir(globals, project, null)

def CleanDeployDir(globals as DuckDictionary, project as string, deployTo as string):
	deployTo = deployTo or GetDeploy(globals, project)
	excludes = GetExcludes(globals);
	excludes.Add("*.log")
	Rm(FileSet("**/*.*", Excludes : excludes, BaseDirectory : deployTo))
	DeleteEmptyDirs(deployTo)

def DeleteEmptyDirs(root as string):
	return unless Directory.Exists(root)
	return if Directory.GetFiles(root).Length
	for dir in Directory.GetDirectories(root):
		DeleteEmptyDirs(dir)
	return if Directory.GetDirectories(root).Length
	Directory.Delete(root)

def Build(globals as DuckDictionary):
	Build(globals, null)

def Build(globals as DuckDictionary, project as string):
	project, buildTo, projectFile = GetBuildConfig(globals, project)
	MkDir(buildTo) if not Exist(buildTo)
	params = {
		"OutputPath" : buildTo,
		"Configuration" : "Release"
	}
	if globals.Maybe.Platform:
		params.Add("Platform", globals.Platform)
	BuildCore(globals, projectFile, params)

	src = Path.Combine(Path.GetDirectoryName(projectFile), "App." + GetConfigSufix(globals))
	config = "${buildTo}/${project}.exe.config"
	unless Exist(config):
		config = FileSet("$buildTo/*.config").Files.FirstOrDefault() or config
	Cp(src, config, true) if Exist(src)
	Rm("${buildTo}/*.xml")
	RmDir("$buildTo/_PublishedWebsites", true)

def GetSolutionProject(projectFile as string):
	sln = FindSln()
	solution = Solution.LoadFrom(sln)
	project = solution.Projects.FirstOrDefault({p| String.Compare(Path.GetFullPath(p.Project.FileName), Path.GetFullPath(projectFile), true) == 0})
	unless project:
		raise "Не удалось найти файл проекта $projectFile в $sln"
	return project

def FindSolutionProject(projectFile as string):
	sln = FindSln()
	solution = Solution.LoadFrom(sln)
	return solution.Projects.FirstOrDefault({p| String.Compare(Path.GetFullPath(p.Project.FileName), Path.GetFullPath(projectFile), true) == 0})

def BuildCore(globals as DuckDictionary, projectFile as string, params as IDictionary):
	sln = FindSln()
	solutionProject = FindSolutionProject(projectFile)
	if solutionProject:
		target = solutionProject.SolutionPath.Replace(".", "_")
		MsBuild(sln,
			Target : target,
			Parameters : params,
			Verbosity: GetVerbosity(globals),
			FrameworkVersion : globals.FrameworkVersion,
			ExecutablePath: globals.Maybe.MsbuildExe).Execute()
	else:
		MsBuild(projectFile,
			Parameters : params,
			Verbosity: GetVerbosity(globals),
			FrameworkVersion : globals.FrameworkVersion,
			ExecutablePath: globals.Maybe.MsbuildExe).Execute()

def DeployService(globals as DuckDictionary, app as string, host as string):
	project, _, _ = GetBuildConfig(globals, app)
	DeployService(globals, app, host, "\\\\$host\\apps\\$project")

def DeployService(globals as DuckDictionary, app as string, host as string, path as string):
	project, _, _ = GetBuildConfig(globals, app)
	serviceName = ReadGlobalConfig(globals, project, @ServiceName) or project

	Impersonate(globals, host):
		services = GetServices(serviceName, (host, ))
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
		if Exist(path):
			javaScripts = FileSet("**.js", BaseDirectory: path)
			if javaScripts.Files.Count:
				Cp(javaScripts, assets)
			else:
				Cp(FileSet("**.*", BaseDirectory: path), assets)

		fonts = Path.Combine(dir, "Content", "Fonts")
		if Exist(fonts):
			files = FileSet(["*.ttf", "*.svg", "*.woff", "*.woff2", "*.eot"], BaseDirectory: fonts)
			Cp(files, Path.Combine(output, "Assets", "Fonts"))

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

	assets = Path.Combine(output, "Assets", "Stylesheets")
	for dir in Directory.GetDirectories("packages"):
		path = Path.Combine(dir, "Content", "Content", "Css")
		continue unless Exist(path)
		Cp(FileSet("**.*", BaseDirectory: path), assets)

	styleSheets = FileSet("src/Common.Web.UI/Common.Web.Ui/Assets/Content/Stylesheets/**.*")
	Cp(styleSheets, assets) if styleSheets.Files.Count

def BuildWeb(globals as DuckDictionary, project as string):
	project, buildTo, projectFile = GetBuildConfig(globals, project)
	projectPath = Path.GetDirectoryName(projectFile)
	MkDir(buildTo) if not Exist(buildTo)
	params = { "OutDir" : "${buildTo}\\bin\\",
		"OutputPath" : "${buildTo}\\bin\\",
		"Configuration" : "Release"}
	if globals.Maybe.Platform:
		params.Add("Platform", globals.Platform)
	sln = FindSln()
	solutionProject = GetSolutionProject(projectFile)
	projectNameForMsbuild = solutionProject.SolutionPath.Replace(".", "_")
	target = projectNameForMsbuild
	MsBuild(sln, "/verbosity:quiet", "/nologo",
			Target : target,
			Parameters : params,
			FrameworkVersion : globals.FrameworkVersion,
			ExecutablePath: globals.Maybe.MsbuildExe).Execute()
	Rm("${buildTo}/bin/*.xml")
	Cp(FileSet(["**/*.as?x",
				"**/*.svc",
				"**/*.brail",
				"**/*.cshtml",
				"**/*.brailjs",
				"**/*.swf",
				"**/*.gif",
				"**/*.png",
				"**/*.ico",
				"**/*.jpg",
				"**/*.pdf",
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
	Cp("$projectPath/web.$sufix", "${buildTo}/Web.config", true)
	if(File.Exists("$projectPath/Views/web.config")) :
		Cp("$projectPath/Views/web.config", "${buildTo}/Views/web.config", true)
	CopyAssets(buildTo)

def CleanWeb(globals as DuckDictionary, project as string):
	project, buildTo, projectFile = GetBuildConfig(globals, project)
	sln = FindSln()
	solutionProject = GetSolutionProject(projectFile)
	projectNameForMsbuild = solutionProject.SolutionPath.Replace(".", "_")
	target = "$projectNameForMsbuild:clean"
	MsBuild(sln,
			Target : target,
			Verbosity: GetVerbosity(globals),
			Parameters : { "OutDir" : "${buildTo}\\bin\\",
						"Configuration" : "release" },
			FrameworkVersion : globals.FrameworkVersion,
			ExecutablePath: globals.Maybe.MsbuildExe).Execute()
	Rm("${buildTo}/*", true) if Exist(buildTo)

def GetVerbosity(globals):
	verbosity = "quiet"
	conf as DuckDictionary = globals.Configuration
	if conf.Maybe.msbuildDebug:
		verbosity = "detailed"
	return verbosity

def Clean(globals as DuckDictionary):
	Clean(globals, null)

def Clean(globals as DuckDictionary, project as string):
	project, buildTo, projectFile = GetBuildConfig(globals, project)
	MsBuild(projectFile,
			Target : "clean",
			Parameters : { "OutputPath" : buildTo, "Configuration" : "release" },
			FrameworkVersion : globals.FrameworkVersion,
			ExecutablePath: globals.Maybe.MsbuildExe).Execute()
	if Exist(buildTo):
		Rm("${buildTo}/*", true)
	else:
		MkDir(buildTo)

def XCopyDeploy(globals as DuckDictionary):
	XCopyDeploy(globals, null)

def XCopyDeploy(globals as DuckDictionary, project as string):
	XCopyDeploy(globals, project, null)

def XCopyDeploy(globals as DuckDictionary, project as string, deployTo as string):
	project, buildTo, _ = GetBuildConfig(globals, project)
	deployTo = deployTo or GetDeploy(globals, project)

	CleanDeployDir(globals, project, deployTo)

	files = FileSet("**/*.*", Excludes : GetExcludes(globals), BaseDirectory : buildTo)
	conf as DuckDictionary = globals.Configuration
	if conf.Maybe.Simulate:
		print "${files.Files.Count} files deployed to $deployTo"
		return
	ImpersonateIfNeeded(globals):
		Cp(files, deployTo, true)
	print "${files.Files.Count} files deployed to $deployTo"

def ImpersonateIfNeeded(globals as DuckDictionary, action as Action):
	conf as DuckDictionary = globals.Configuration
	impersonate = conf.Maybe.impersonate != null
	if impersonate:
		ImpersonateUser("deployer", '$sdfsd887!'):
			action()
	else:
		action()

def GetExcludes(globals as DuckDictionary):
	excludes = List()
	if globals.Maybe.ExcludesDeployDirectory:
		for directory in globals.ExcludesDeployDirectory:
			excludes.Add(directory)
	return excludes

def GetDeploy(globals as DuckDictionary):
	return GetDeploy(globals, null)

def GetDeploy(globals as DuckDictionary, project as string, deployAlias as string):
	project, _, _ = GetBuildConfig(globals, project)
	name = deployAlias or project
	deployTo = Path.Combine(globals.DeployRoot, name)

	if globals.Maybe.deployTo:
		deployTo = globals.deployTo

	if globals.Maybe.DeployTo:
		deployTo = globals.DeployTo

	if not deployTo:
		raise """Не знаю куда разворачивать проект нужно задать либо Globals.DeployTo = '<путь куда выкладывать>'
	либо название проекта Globals.Project тогда он будет выложен на Globals.DeployRoot по умолчанию это \\acdcserv.adc.analit.net\WebApps\"""
	return deployTo

def GetDeploy(globals as DuckDictionary, project as string):
	return GetDeploy(globals, project, globals.Maybe.DeployAlias)

def GetServersToDeploy(globals as DuckDictionary):
	servers = List of string()
	if globals.Maybe.Servers:
		for server in globals.Maybe.Servers:
			servers.Add(server.ToString())

	if not servers.Count:
		servers.Add(globals.Server.ToString())
	return servers

def Sign(path as string):
	certPath = GetResource("inforoomCS.pfx")
	password = "password"
	cert = X509Certificate2(File.ReadAllBytes(certPath), password)
	Exec("\"C:\\Program Files (x86)\\Windows Kits\\8.1\\bin\\x86\\signtool.exe\"",
		"sign /sha1 ${cert.Thumbprint} \"$path\"").Execute()

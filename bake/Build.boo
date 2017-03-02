import System
import System.Linq
import Bake.Engine
import FubuCsProjFile
import System.Linq.Enumerable
import System.DirectoryServices

class TestProject:
	_project as string

	property CheckExitCode as bool
	property ProjectFile as string
	property BuildOutput as string
	property TestOutput as string

	def constructor(projectFile as string):
		ProjectFile = projectFile
		_project = Path.GetFileNameWithoutExtension(projectFile)

	def FindOrInstallConsole(version as Version):
		map = { Version(3, 6, 1): Version(3, 6, 0) }
		if map.ContainsKey(version):
			version = map[version]
		root = "C:\\tools\\nunit-$version"
		unless Directory.Exists(root):
			MkDir(root)
			Exec("nuget", "install NUnit.Console -NoCache -Version $version -OutputDirectory $root").Execute()
		exe = FileSet("**/nunit?-console.exe", BaseDirectory: root).FirstOrDefault();
		raise "Не удалось найти консоль в $root по маске nunit*-console.exe" unless exe
		return exe

	def Test():
		Test("")

	def Test(args as string):
		dirs = Directory.GetDirectories("packages", "NUnit.*")
		if dirs.Length == 0:
			raise "Не могу найти nunit в директории packages, убедись что пакет установлен"
		nunitVersion = Version.Parse(Path.GetFileName(dirs[0]).Replace("NUnit.", ""))
		if nunitVersion > Version(3, 0):
			assembly = Path.Combine(Path.GetDirectoryName(ProjectFile), "bin/debug/${_project}.dll")
			unless Exist(assembly):
				name = CsProjFile.LoadFrom(ProjectFile).AssemblyName
				assembly = Path.Combine(Path.GetDirectoryName(ProjectFile), "bin/debug/$name.dll")
			print "test $assembly"
			assemblyDefinition = AssemblyDefinition.ReadAssembly(assembly)
			isX86 = assemblyDefinition.MainModule.Architecture == TargetArchitecture.I386
			arch = ""
			if isX86:
				arch = "--x86"
			nunit = Exec(FindOrInstallConsole(nunitVersion),
				"$args --workers=1 --result TestResult.xml;format=nunit2 --labels=all $arch \"${assembly}\"",
				BaseDirectory: Path.GetDirectoryName(assembly))
			nunit.CheckExitCode = CheckExitCode
			nunit.Execute()
			if nunit.ExitCode < 0:
				raise "Failt to run test ${nunit.ExecutablePath} ${nunit.CommandLine}"
			Mv(Path.Combine(nunit.BaseDirectory, "TestResult.xml"), "TestResult.xml")

			TestOutput = nunit.Output.ToString()
		else:
			assembly = Path.Combine(Path.GetDirectoryName(ProjectFile), "bin/debug/${_project}.dll")
			unless Exist(assembly):
				name = CsProjFile.LoadFrom(ProjectFile).AssemblyName
				assembly = Path.Combine(Path.GetDirectoryName(ProjectFile), "bin/debug/$name.dll")
			print "test $assembly"
			assemblyDefinition = AssemblyDefinition.ReadAssembly(assembly)
			isX86 = assemblyDefinition.MainModule.Architecture == TargetArchitecture.I386

			nunitPath = "nunit-console"
			if isX86:
				nunitPath = "nunit-console-x86"
			nunit = NUnit("\"" + assembly + "\"",
				ExecutablePath : nunitPath)
			nunit.Arguments.Add("/labels")

			nunit.Execute()

			TestOutput = nunit.Output.ToString()

	def ToString():
		return ProjectFile

def GetTestProjects(globals as DuckDictionary):
	return GetTestProjects(globals, null)

def GetTestProjects(globals as DuckDictionary, sln as string):
	sufixes = ("integration.csproj", "functional.csproj", "unit.csproj", "test.csproj", ".test.csproj", ".tests.csproj")
	projects = GetProjects(sln).Where({x| sufixes.Any({y| x.ToLower().EndsWith(y)}) })\
		.Select({f| TestProject(f)}).ToList()

	ignore = (of Regex: ,)
	if globals.Maybe.TestIgnore:
		ignore = ignore.Concat(globals.Maybe.TestIgnore).ToArray()

	return projects.Where({x| not ignore.Any({i| i.IsMatch(x.ToString())})}).ToList()

def ReadUserConfig(key as string):
	dir = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile)
	file = Path.Combine(dir, "bake.config")
	return unless File.Exists(file)
	lines = File.ReadAllLines(file)
	for line in lines:
		parts = line.Split(char('='))
		continue unless parts.Length == 2
		return parts[1] if parts[0] == key

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
	conf as DuckDictionary = globals.Configuration
	user as string = conf.Maybe.User or globals.Maybe.User or ReadUserConfig("User")
	password as string = conf.Maybe.Password or globals.Maybe.Password or ReadUserConfig("Password")

	i = 0
	while true:
		i++
		if String.IsNullOrEmpty(user):
			Console.Write("user for $server: ")
			user = Console.ReadLine()
		if String.IsNullOrEmpty(password):
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
		projectFile = projectFile or FileSet("src/$project/$project.*proj").FirstOrDefault()
		projectFile = projectFile or FileSet("**/$project.*proj").FirstOrDefault()
		projectFile = projectFile or FileSet("src/$project/app.*proj").FirstOrDefault()
		#проверяю частичный путь без префикса src
		projectFile = projectFile or FileSet("$project/app.*proj").FirstOrDefault()
		unless projectFile:
			if sln:
				solution = Solution.LoadFrom(sln)
				projectFile = solution.Projects.Where({p| p.Project.AssemblyName == project}).Select({p| p.Project.FileName}).FirstOrDefault()
		unless projectFile:
			raise "Не могу найти файл проекта $project"
	projectName = CsProjFile.LoadFrom(projectFile).AssemblyName
	output = Path.GetFullPath(Path.Combine(globals.BuildRoot, projectName))
	return (projectName, output, projectFile)

def CleanDeployDir(globals as DuckDictionary, dir as string):
	excludes = GetExcludes(globals);
	excludes.Add("*.log")
	Rm(FileSet("**/*.*", Excludes : excludes, BaseDirectory : dir))
	DeleteEmptyDirs(dir)

def DeleteEmptyDirs(root as string):
	return unless Directory.Exists(root)
	return if Directory.GetFiles(root).Length
	for dir in Directory.GetDirectories(root):
		DeleteEmptyDirs(dir)
	return if Directory.GetDirectories(root).Length
	try:
		Directory.Delete(root)
	except:
		print "fail to delete $root"
		raise

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
		if IsSimulation(globals):
			print "simulate: stop services ${join(services)}"
		else:
			StopServices(services)
		RepeatTry:
			XCopyDeploy(globals, app, path)
		if IsSimulation(globals):
			print "simulate: stop services ${join(services)}"
		else:
			StartServices(services)

def IsSimulation(globals as DuckDictionary):
	conf as DuckDictionary = globals.Configuration
	return conf.Maybe.Simulate

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
				"**/*.html",
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
	XCopyDeployDir(globals, buildTo, deployTo)

def XCopyDeployDir(globals as DuckDictionary, src as string, dst as string):
	RepeatTry:
		CleanDeployDir(globals, dst)
		files = FileSet("**/*.*", Excludes : GetExcludes(globals), BaseDirectory : src)
		ImpersonateIfNeeded(globals):
			if IsSimulation(globals):
				print "simulation: ${files.Files.Count} files deployed to $dst"
				return
			Cp(files, dst, true)
		print "${files.Files.Count} files deployed to $dst"

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
	SignFile(path, GetResource("inforoomCS.pfx"), "password")

def SignFile(filename as string, cert as string, password as string):
	Exec("\"C:\\Program Files (x86)\\Windows Kits\\8.1\\bin\\x86\\signtool.exe\"",
		"sign /f \"$cert\" /p \"$password\" \"$filename\"").Execute()

def SendReleaseNotification(global as DuckDictionary, subject as string, body as string):
	return if global.Environment != @Production
	conf as DuckDictionary = global.Configuration
	to = conf.Maybe.notifyTo or "UpdatesList@subscribe.analit.net"
	fromEmail = "r.kvasov@analit.net"
	user = Environment.UserName
	try:
		using s = DirectorySearcher():
			s.Filter = String.Format("(sAMAccountName={0})", user)
			entry = s.FindOne().GetDirectoryEntry()
			if entry:
				values = entry.Properties["mail"]
				if values.Count:
					fromEmail = values[0].ToString()
	except e:
		print "Не удалось определьть email отправителя $user использую dev@analit.net"
		print e
	smtp = SmtpClient("box.analit.net")
	smtp.Send(fromEmail, to, subject, body)

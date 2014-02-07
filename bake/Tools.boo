import System
import System.Threading
import System.Text
import System.IO
import System.Diagnostics

[DllImport("advapi32.dll", SetLastError: true, CharSet: CharSet.Unicode)]
def LogonUser(lpszUsername as String, lpszDomain as String, lpszPassword as String, dwLogonType as int, dwLogonProvider as int, ref phToken as IntPtr) as bool:
	pass

[DllImport("kernel32.dll", CharSet: CharSet.Auto)]
def CloseHandle(handle as IntPtr) as bool:
	pass

def ImpersonateUser(user as string, password as string, action as Action):
	LOGON32_PROVIDER_DEFAULT = 0;
	LOGON32_LOGON_INTERACTIVE = 2;
	tokenHandle = IntPtr.Zero;
	if not LogonUser(user, "", password, LOGON32_LOGON_INTERACTIVE, LOGON32_PROVIDER_DEFAULT, tokenHandle):
		raise Win32Exception()

	using WindowsIdentity.Impersonate(tokenHandle):
		try:
			action()
		ensure:
			CloseHandle(tokenHandle);

def RepeatTry(action as callable()):
	fin = false
	interation = 0
	while not fin:
		try:
			action()
			fin = true
		except e:
			raise if not e.Message.Contains("The process cannot access the file")\
				and not e.Message.Contains("Процесс не может получить доступ к файлу")
			interation++
			if interation >= 10:
				raise
			print "can`t access files, sleep..."
			System.Threading.Thread.Sleep(1000)

def CalculateRelativePath(base as string, dst as string):
	return Uri(Path.GetFullPath(base)).MakeRelative(Uri(Path.GetFullPath(dst))).Replace("/", "\\")

def GetResource(resource as string):
	return Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Resources/${resource}")

def Bash(cmd as string):
	path = Environment.CurrentDirectory.Replace("\\", "/")
	Sh("bash -l -c \"cd $path;$cmd\"")

def AskCredentials(request as string):
	user = Ask(request)
	password = AskPassword("password:")
	return (user, password)

def Ask(request as string):
	Console.Write(request)
	return Console.ReadLine()

def ExecuteProcess(exe as string, command as string):
	return ExecuteProcess(exe, command, null)

def ExecuteProcess(exe as string, command as string, baseDirectory as string):

	encoding as Encoding
	if exe.StartsWith("git"):
		encoding = Encoding.UTF8
	else:
		encoding = Encoding.GetEncoding(866)

	startInfo = ProcessStartInfo(exe, command,
		StandardOutputEncoding : encoding,
		StandardErrorEncoding : encoding,
		RedirectStandardOutput : true,
		RedirectStandardError : true,
		CreateNoWindow : true,
		UseShellExecute : false)
	if baseDirectory:
		startInfo.WorkingDirectory = baseDirectory
	output = ""
	error = ""
	process = Process.Start(startInfo)
	process.BeginOutputReadLine()
	process.BeginErrorReadLine()
	process.OutputDataReceived += {p, a| output += a.Data + "\r\n" }
	process.ErrorDataReceived += {p, a| error += a.Data + "\r\n"}
	process.WaitForExit(TimeSpan.FromMinutes(2).TotalMilliseconds)
	if error.Trim():
		raise "При запуске комманды '$exe $command' возникла ошибка, $error"
	#иногда процесс уже завершился но данные гдето "блуждают"
	unless output.Length:
		Thread.Sleep(100)
	return output

def GetVersion():
	lines = File.ReadAllLines("build/version.txt")
	if not lines.Length or not lines[0].Trim():
		raise "Файл 'build/version.txt' пустой, нужно указать номер версии"
	return lines[0].Trim()

def AskPassword(request as string):
	Console.Write(request)
	return GetPassword()

def GetPassword():
	password = "";
	while (info = Console.ReadKey(true)).Key != ConsoleKey.Enter:
		if info.Key == ConsoleKey.Backspace:
			password = password[0:-1]
		else:
			password += info.KeyChar
	Console.WriteLine();
	return password

def LastWord(table as string):
	word = ""
	for c in reversed(table):
		if c == char('.') or c == "_":
			break;
		if Char.IsUpper(c):
			word = c + word
			break
		word = c + word
	return ToPascal(word)

def ToPascal(text as string):
	return text unless text
	pascaled = ""
	toUpper = true
	if text.ToUpper() == text:
		text = text.ToLower()
	for c in text:
		if c == char('_'):
			toUpper = true
			continue;
		if toUpper:
			pascaled += c.ToString().ToUpper()
		else:
			pascaled += c.ToString()
		toUpper = false
	return pascaled[0].ToString().ToUpper() + pascaled[1:]

def GetConfigSufix(Globals as duck):
	if Globals.Environment == @Production:
		return "release.config"
	if Globals.Environment == @Local:
		return ".config"
	env = Globals.Environment.ToLower()
	return "$env.config"

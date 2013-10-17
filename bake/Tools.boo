import System
import System.Threading
import System.Text
import System.IO
import System.Diagnostics

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
	config = "release.config"
	if Globals.Environment != @Local and Globals.Environment != @Production:
		env = Globals.Environment.ToLower()
		config = "$env.config"
	return config

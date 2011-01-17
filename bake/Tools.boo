import System
import System.IO
import System.Diagnostics

def ExecuteProcess(exe as string, command as string):
	return ExecuteProcess(exe, command, null)

def ExecuteProcess(exe as string, command as string, baseDirectory as string):
	startInfo = ProcessStartInfo(exe, command,
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
	return output

def GetVersion():
	lines = File.ReadAllLines("build/version.txt")
	if not lines.Length or not lines[0].Trim():
		raise "Файл 'build/version.txt' пустой, нужно указать номер версии"
	return lines[0].Trim()

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

#def Lastify(text as string):
#	return Inflector.Singularize(text)
	#if text[-3:] == "ses":
	#	return text[0:-2]
	#if text[-1:] == "s":
	#	return text[0:-1]
	#return text

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
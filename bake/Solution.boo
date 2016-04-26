import System
import System.IO
import System.Text
import System.Collections.Generic
import Bake.IO.Extensions

def GetProjects():
	projects = List[of string]()
	if Exist("src"):
		for sln in FileSet("src/*.sln"):
			text = File.ReadAllText(sln)
			matches = /Project.+=[^,]+,([^,]+),/.Matches(text)
			for m in matches:
				value = m.Groups[1].Value.Replace("\"", "").Trim()
				path = Path.Combine("src", value)
				projects.Add(path) if Exist(path)
	else:
		for sln in FileSet("*.sln"):
			text = File.ReadAllText(sln)
			matches = /Project.+=[^,]+,([^,]+),/.Matches(text)
			for m in matches:
				value = m.Groups[1].Value.Replace("\"", "").Trim()
				projects.Add(value) if Exist(value)
	return projects

def GetProjectsForTest():
	if Exist("src"):
		return FileSet([\
			"src/**/*Tests.*proj",\
			"src/**/Functional.*proj",\
			"src/**/Integration.*proj",\
			"src/**/Test.*proj",\
			"**/*.Test.*proj",
			"src/**/Unit.*proj"],
			Excludes: ["**/Test.Support*.*proj"])
	else:
		return FileSet(["**/test.csproj", "**/*.Test.*proj"])

def BinVariants(name as string) as (string):
	return ("bin/debug/$name.exe",
		"bin/debug/$name.dll",
		"bin/$name.dll")

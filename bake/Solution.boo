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
				projects.Add(path) if File.Exists(path)
	else:
		for sln in FileSet("*.sln"):
			text = File.ReadAllText(sln)
			matches = /Project.+=[^,]+,([^,]+),/.Matches(text)
			for m in matches:
				value = m.Groups[1].Value.Replace("\"", "").Trim()
				projects.Add(value) if File.Exists(value)
	return projects.Select({x| Path.GetFullPath(x) }).Distinct()\
		.ToList()

def GetProjectsForTest():
	sufixes = ("integration.csproj", "functional.csproj", "unit.csproj", "test.csproj", ".test.csproj", ".tests.csproj")
	return GetProjects().Where({x| sufixes.Any({y| x.ToLower().EndsWith(y)}) })

def BinVariants(name as string) as (string):
	return ("bin/debug/$name.exe",
		"bin/debug/$name.dll",
		"bin/$name.dll")

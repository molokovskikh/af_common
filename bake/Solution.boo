import System
import System.IO
import System.Text
import System.Collections.Generic
import Bake.IO.Extensions

def GetProjects():
	return GetProjects(null)

def GetProjects(sln as string):
	sln = sln or FileSet("*.sln").Concat(FileSet("src/*.sln")).FirstOrDefault()
	projects = List[of string]()
	text = File.ReadAllText(sln)
	matches = /Project.+=[^,]+,([^,]+),/.Matches(text)
	root = Path.GetDirectoryName(sln)
	for m in matches:
		value = m.Groups[1].Value.Replace("\"", "").Trim()
		projects.Add(value)
	return projects.Select({x| Path.GetFullPath(Path.Combine(root, x)) }).Distinct()\
		.Where({x| File.Exists(x)})\
		.ToList()

def BinVariants(name as string) as (string):
	return ("bin/debug/$name.exe",
		"bin/debug/$name.dll",
		"bin/$name.dll")

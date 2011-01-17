import System
import System.IO
import System.Diagnostics
import System.Xml.Linq
import System.Xml.XPath.Extensions from System.Xml.Linq
import file from Tools.boo

class SvnTool:
	static def Command(command as string):
		return ExecuteProcess("svn", "$command --non-interactive")

	static def Update(path as string):
		Command("update \"${path}\"")

	static def Update():
		Command("update")

	static def Info():
		return Info("")
		
	static def Info(path as string):
		path = "\"" + path + "\"" if path
		output = ExecuteProcess("svn", "info $path --xml --non-interactive")
		return XElement.Load(StringReader(output))
		
	static def InfoEntry(path as string):
		return Info(path).XPathSelectElement("entry")

	static def GetRevision():
		return GetRevision(".")
	
	static def GetRevision(path as string):
		return InfoEntry(path).Attribute("revision").Value
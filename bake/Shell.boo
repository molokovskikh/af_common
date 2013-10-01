namespace Bake.Shell

import System
import System.Reflection
import System.Linq.Enumerable
import Boo.Lang.Interpreter

def ls(obj):
	for property in obj.GetType().GetProperties():
		continue if property.GetIndexParameters().Length
		value = property.GetValue(obj, null)
		print "${property.Name}, ${property.PropertyType} = $value"

def find(name as string):
	assemblies = AppDomain.CurrentDomain.GetAssemblies()
	types = assemblies.SelectMany({a|a.GetTypes()}).Where({t|t.Name.ToLower().Contains(name.ToLower())})
	for type in types:
		print type.FullName

def MakeFuzzi(interpreter as InteractiveInterpreter, console as InteractiveInterpreterConsole):
	console.Eval("import Bake.Shell from Shell")
	

#!/bin/sh

Update() {
	name=$1
	package=$2
	if [ -e lib/$name.dll ]
	then
		pushd .
		rm lib/$name.*
		cd packages
		nuget install $package
		popd
		bake packages:save
	fi

	if [ -e lib/$name ]
	then
		pushd .
		rm lib/$name -r
		cd packages
		nuget install $package
		popd
		bake packages:save
	fi
}

if [ -e lib/Castle.ActiveRecord.dll -o -e lib/Castle.ActiveRecord ]
then
	pushd .
	rm lib/Castle.ActiveRecord.*
	rm -r lib/Castle.ActiveRecord
	rm lib/Castle.Components.Validator.*
	rm -r lib/Castle.Components.Validator
	rm lib/ru -rf
	cd packages
	nuget install Castle.ActiveRecord
	popd
	bake packages:save
fi

if [ -e lib/Castle.MonoRail.Framework.dll ]
then
	pushd .
	rm lib/Castle.MonoRail.*
	rm lib/Castle.Core.*
	rm lib/Castle.Core -rf
	rm lib/Castle.Components.* -rf
	rm lib/Boo.Lang.*
	rm lib/Newtonsoft.Json.*
	rm lib/anrControls.Markdown.NET.*
	cd packages
	nuget install Castle.MonoRail
	popd
	bake packages:save
fi

if [ -e lib/LumiSoft.Net.dll ]
then
	version=`version.sh lib/LumiSoft.Net.dll | tail -n2 | head -n1 | cut -c1-14`
	if [ '2.8.3299.28802' == "$version"  ]
	then
		Update 'LumiSoft.Net' 'LumiSoft.Net'
	fi
	if [ '2.0.3679.25550' == "$version"  ]
	then
		Update 'LumiSoft.Net' 'LumiSoft.Net -Version 2.0.3679'
	fi
fi

Update 'RemoteOrderSenderService' 'RemoteOrderSenderService'
Update 'ICSharpCode.SharpZipLib' 'SharpZipLib'
Update 'Castle.Services.Logging.Log4netIntegration' 'Castle.Core-log4net -Version 2.5.2'
Update 'RemotePriceProcessor' 'RemotePriceProcessor'
Update 'MySql.Data' 'MySql.Data'
Update 'mysql.data' 'MySql.Data'
Update 'ExcelLibrary' 'MyExcelLibrary'
Update 'Rhino.Mocks' 'RhinoMocks'
Update 'Microsoft.Win32.TaskScheduler' 'TaskScheduler'
Update 'CassiniDev' 'CassiniDev -Version 3.5.1.2'
Update 'WatiNCssSelectorExtensions' 'Watin.Css'
Update 'TopShelf' 'TopShelf -Version 2.2.1'
Update 'NHibernate.Mapping.Attributes' 'NHibernate.Mapping.Attributes -Version 3.2.0'
Update 'Castle.Facilities.WcfIntegration' 'Castle.WcfIntegrationFacility'
Update 'Castle.WcfIntegration' 'Castle.WcfIntegrationFacility'

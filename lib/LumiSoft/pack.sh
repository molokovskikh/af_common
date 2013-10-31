#!/bin/sh

if [ -d LumiSoft_Net ]; then
	cd LumiSoft_Net
	svn update
	cd ..
else
	svn co --username readonly --password readonly https://svn.lumisoft.ee:8443/svn/LumiSoft_Net/
fi
msbuild.exe LumiSoft_Net/trunk/Net/Net.sln /p:Configuration=Release
cp LumiSoft_Net/trunk/Net/bin/release/* lib/net40/

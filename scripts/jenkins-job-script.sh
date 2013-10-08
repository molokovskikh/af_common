#!/bin/sh

PATH=/cygdrive/c/Windows/Microsoft.NET/Framework/v4.0.30319/:$PATH

if [ -n "SKIP_DB" ]; then
	mysqladmin --user=root --port=$(cat data/port) shutdown 2> /dev/null && sleep 2 || :
fi
git clean -fdx
git submodule foreach git clean -fdx

if [ -n "$AUTO_UPDATE" ]
then
	git pull
	git checkout master
	git submodule sync
	git submodule update --init
	git submodule foreach "git checkout master && git pull"
	git clean -fdx
	git submodule foreach git clean -fdx
fi

if [ -n "SKIP_DB" ]; then
	bake RunMySql path=data randomPort=true notInteractive=true
	port=$(cat data/port)
	grep "(Data Source|server)=localhost" src -lRP | xargs perl -i -pe "s/connectionString=\"([^\"]*)?port=\d+;([^\"]*)?\"/connectionString=\"port="$port";\1\2\"/gi"
	grep "(Data Source|server)=localhost" src -lRP | xargs perl -i -pe 's/(Data Source|server)=localhost/Data Source=localhost;port='$port'/gi'
fi

if [ -e ./scripts/prepare.sh ]
then
	./scripts/prepare.sh
else
	bake packages:install notInteractive=true | iconv -f cp866 -t cp1251
fi
bake TryToBuild Port=$port notInteractive=true | iconv -f cp866 -t cp1251
bake db:setup Port=$port notInteractive=true | iconv -f cp866 -t cp1251
bake test Port=$port notInteractive=true | iconv -f cp866 -t cp1251

git checkout .
git submodule foreach git checkout .
if [ -n "SKIP_DB" ]; then
	mysqladmin --user=root --port=$port shutdown
fi

#!/bin/sh

PATH=/cygdrive/c/Windows/Microsoft.NET/Framework/v4.0.30319/:$PATH

if [ -z "SKIP_DB" ]; then
	mysqladmin --user=root --port=$(cat data/port) shutdown 2> /dev/null && sleep 2 || :
fi
git clean -fdx
git submodule foreach git clean -fdx

if [ -n "$AUTO_UPDATE" ]
then
	git checkout master
	git pull
	git submodule sync
	git submodule update --init
	git submodule foreach "git checkout master && git pull"
	git clean -fdx
	git submodule foreach git clean -fdx
fi

if [ -z "SKIP_DB" ]; then
	bake RunMySql path=data randomPort=true notInteractive=true
	port=$(cat data/port)
	grep "(Data Source|server)=localhost" src -lRP | xargs perl -i -pe "s/connectionString=\"([^\"]*)?port=\d+;([^\"]*)?\"/connectionString=\"port="$port";\1\2\"/gi"
	grep "(Data Source|server)=localhost" src -lRP | xargs perl -i -pe 's/(Data Source|server)=localhost/Data Source=localhost;port='$port'/gi'
fi

if [ -e ./scripts/prepare.sh ]
then
	./scripts/prepare.sh
else
	bake packages:install notInteractive=true
fi
bake TryToBuild Port=$port notInteractive=true
if [ -z "SKIP_DB" ]; then
	bake db:setup Port=$port notInteractive=true
fi
bake test Port=$port notInteractive=true

git checkout .
git submodule foreach git checkout .
if [ -z "SKIP_DB" ]; then
	mysqladmin --user=root --port=$port shutdown
fi

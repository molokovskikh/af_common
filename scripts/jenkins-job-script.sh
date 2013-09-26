#!/bin/sh

PATH=/cygdrive/c/Windows/Microsoft.NET/Framework/v4.0.30319/:$PATH

mysqladmin --user=root --port=$(cat data/port) shutdown 2> /dev/null && sleep 2 || :
git clean -fdx
git submodule foreach git clean -fdx

bake RunMySql path=data randomPort=true notInteractive=true
port=$(cat data/port)
grep "(Data Source|server)=localhost" src -lRP | xargs perl -i -pe "s/connectionString=\"([^\"]*)?port=\d+;([^\"]*)?\"/connectionString=\"port="$port";\1\2\"/gi"
grep "(Data Source|server)=localhost" src -lRP | xargs perl -i -pe 's/(Data Source|server)=localhost/Data Source=localhost;port='$port'/gi'

if [ -e ./scripts/prepare.sh ]
then
	./scripts/prepare.sh
else
	bake packages:install notInteractive=true | iconv -f cp1251 -t utf-8
fi
bake TryToBuild db:setup test Port=$port notInteractive=true | iconv -f cp1251 -t utf-8

git checkout .
git submodule foreach git checkout .
mysqladmin --user=root --port=$port shutdown

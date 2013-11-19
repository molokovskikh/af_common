#!/bin/sh

function wait_pid {
	for i in `seq 0 120`; do
		pids=`ps -W | /bin/grep mysqld | awk '{print $1}'`
		for pid in $pids; do
			if [[ $1 == $pid ]]; then
				echo "wait for $1"
				sleep 1
			fi
		done
	done
}

clean()
{
	if [ -z "$SKIP_DB" ]; then
		pid=$(cat `find data -name '*.pid' | head -n 1`)
		mysqladmin --user=root --port=$port shutdown
		wait_pid $pid
	fi
}

trap "clean" ERR

set -e
set -x

PATH=/cygdrive/c/Windows/Microsoft.NET/Framework/v4.0.30319/:$PATH

if [ -z "$SKIP_DB" ]; then
	mysqladmin --user=root --port=$(cat data/port) shutdown 2> /dev/null && sleep 2 || :
fi
git clean -fdx
git submodule foreach git clean -fdx

if [ -n "$AUTO_UPDATE" ]
then
	auto-update.sh
fi

if [ -z "$SKIP_DB" ]; then
	bake -s RunMySql path=data randomPort=true notInteractive=true
	port=$(cat data/port)
	grep "(Data Source|server)=localhost" src -lRP | xargs perl -i -pe "s/connectionString=\"([^\"]*)?port=\d+;([^\"]*)?\"/connectionString=\"port="$port";\1\2\"/gi"
	grep "(Data Source|server)=localhost" src -lRP | xargs perl -i -pe 's/(Data Source|server)=localhost/Data Source=localhost;port='$port'/gi'
fi

if [ -e ./scripts/prepare.sh ]
then
	./scripts/prepare.sh
else
	bake -s packages:install notInteractive=true
	if [ $? -ne 0 ]; then
		exit $?
	fi
fi
bake TryToBuild Port=$port notInteractive=true
if [ -z "$SKIP_DB" ]; then
	bake db:setup Port=$port notInteractive=true
fi
bake generate:binding:redirection notInteractive=true
bake test Port=$port notInteractive=true

git checkout .
git submodule foreach git checkout .
clean

#!/bin/sh

set -e
set -x
set -v

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
	git checkout . || :
	git submodule foreach git checkout . || :
	if [ -z "$SKIP_DB" ]; then
		pid=$(cat `find data -name '*.pid' | head -n 1`)
		mysqladmin --user=root --port=$port shutdown
		wait_pid $pid
	fi
}

trap "clean" ERR

PATH=/cygdrive/c/Program\ Files\ \(x86\)/MSBuild/14.0/Bin/:$PATH
PATH=/cygdrive/c/bin/NUnit.Console.3.0.1/tools/:$PATH

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
	bake -s db:start path=data randomPort=true notInteractive=true | iconv -s -f cp866 -t utf-8 || : ; test ${PIPESTATUS[0]} -eq 0
	port=$(cat data/port)
	grep "(Data Source|server)=localhost" src -lRP | xargs perl -i -pe "s/connectionString=\"([^\"]*)?port=\d+;([^\"]*)?\"/connectionString=\"port="$port";\1\2\"/gi"
	grep "(Data Source|server)=localhost" src -lRP | xargs perl -i -pe 's/(Data Source|server)=localhost/Data Source=localhost;port='$port'/gi'
fi

if [ -e ./scripts/prepare.sh ]
then
	./scripts/prepare.sh | iconv -s -f cp866 -t utf-8 || : ; test ${PIPESTATUS[0]} -eq 0
else
	#build.bake может содержать ссылки на библиотеи и без них не соберется для этого нужен -s
	#так же там может быть настройка для установки пакетов по этому сначала пробуем загрузить build.bake
	(bake packages:fix || bake -s packages:fix) | iconv -s -f cp866 -t utf-8 ; test ${PIPESTATUS[1]} -eq 0
fi
bake TryToBuild Port=$port notInteractive=true | iconv -s -f cp866 -t utf-8 || : ; test ${PIPESTATUS[0]} -eq 0
if [ -z "$SKIP_DB" ]; then
	bake db:setup Port=$port notInteractive=true | iconv -s -f cp866 -t utf-8 || : ; test ${PIPESTATUS[0]} -eq 0
fi
bake test Port=$port notInteractive=true | iconv -s -f cp866 -t utf-8 || : ; test ${PIPESTATUS[0]} -eq 0

clean

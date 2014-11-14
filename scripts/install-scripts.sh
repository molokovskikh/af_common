#!/bin/sh

cd /bin/
rm apt-cyg
wget https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg
chmod +x apt-cyg

curl https://github.com/hecticjeff/shoreman/raw/master/shoreman.sh -sLo /bin/shoreman && \
	chmod 755 /bin/shoreman

#!/bin/sh

net share /delete debug
net share debug=`cygpath -aw .` /grant:Все,FULL
find | xargs chmod o+w
/cygdrive/c/Program\ Files/Microsoft\ Visual\ Studio\ 11.0/Common7/IDE/Remote\ Debugger/x64/msvsmon.exe /noauth /anyuser /nosecuritywarn /silent

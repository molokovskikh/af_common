#!/bin/sh

/cygdrive/c/Program\ Files\ \(x86\)/Windows\ Kits/10/Debuggers/x86/cdb -c ".loadby sos clr;!EEStack;qd" -p $1

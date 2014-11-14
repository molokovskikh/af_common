#!/bin/sh

/cygdrive/c/Program\ Files\ \(x86\)/Debugging\ Tools\ for\ Windows\ \(x86\)/cdb -c ".loadby sos clr;!EEStack;qd" -p $1

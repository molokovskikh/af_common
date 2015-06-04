#!/bin/sh

/cygdrive/c/Program\ Files/Debugging\ Tools\ for\ Windows\ \(x64\)/cdb -c ".loadby sos clr;!EEStack;qd" -p $1

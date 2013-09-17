out=`mktemp`
csc.exe /out:$(cygpath -wa $out) "$@" 2> /dev/null && chmod +x $out && $out
rm $out

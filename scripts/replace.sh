for f in ${*:3}
do
perl -i -pe "s/$1/$2/" $f
done

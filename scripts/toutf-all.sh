find -name *.cs | xargs file | /usr/bin/grep -v UTF-8 | cut -f1 -d: | xargs toutf.sh

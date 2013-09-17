git checkout . && git submodule foreach git checkout . && git pull && git submodule update && toutf-all.sh
git diff --name-only | xargs clean.sh
git commit -am "Перекодировал 1251 -> utf8" && git push && git submodule foreach git checkout .

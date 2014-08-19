#!/bin/sh

jsTemplate="`dirname $0`/qunit.template.js"
htmlTemplate="`dirname $0`/qunit.template.html"
echo "Название теста:"
read name
js="test/$name.js"
html="test/$name.html"
cp $jsTemplate $js
cp $htmlTemplate $html
echo "Создан $js"
echo "Создан $html"

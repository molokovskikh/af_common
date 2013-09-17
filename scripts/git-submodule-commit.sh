#!/bin/sh

git stash && git checkout master && git pull && git stash pop && git add . && git commit

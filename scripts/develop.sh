#!/bin/bash


cd ../blogsite

bundle exec jekyll serve -H 0.0.0.0 -P 1109 --incremental

cd -

exit 0


#!/bin/bash

input=$1
out=$input.fml

files=$(cat $input)

rm $out
for f in $files; do
	basename $f >> $out
done

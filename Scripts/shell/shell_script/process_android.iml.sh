#!/bin/bash
# Process android.iml
# usage:
# 1. put process_android.iml.sh in the same directory of android.iml
# 2. execute command:
#    ./process_android.iml.sh > android.ok.iml
# 3. rename android.ok.iml as android.iml
# 4. open android.ipr with AndroidStudio
input_file=android.iml

echo >> $input_file

cat $input_file | while read line
do
    # if include './frameworks/' and './out/', keep unchanged;
    # else, replace 'sourceFolder' with 'excludeFolder'
    tmp=`echo $line | grep -E '\./frameworks\/|\.\/out\/'`
    if [ -n "$tmp" ] ; then
        echo $line
    else
        tmp2=`echo $line | grep -E '\<orderEntry'`
        if [ -n "$tmp2" ] ; then
            echo $line
        else
            echo $line | sed 's/sourceFolder/excludeFolder/g'
        fi
    fi
done

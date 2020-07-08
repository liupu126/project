#!/bin/bash
#Program:
#	For test shell functions or commands.
#History:
#	2017/10/23	Liu Pu(Braden Liu)	First Release

# get directory's name below certain directory.
function getDirNamesBelowOneDir
{
	local dir_base

	dir_base=$1

	for file in $(ls ${dir_base})
	do
		[ -d ${dir_base}/${file} ] && echo ${file}
	done
}

# get the last part of full directory name
function getLastPartOfFullDir
{
	local dir_full

	dir_full=$1
	dir_full=${dir_full##*/}

	echo ${dir_full}
}

function testCaseIn
{
    tmp=$1
    case $tmp in
    europe|eu)
        echo "europe|eu"
    ;;
    *)
        echo "others"
    ;;
    esac
}

echo "# get directory names below certain directory"
getDirNamesBelowOneDir ~/work

echo "# get the last part of full directory name"
getLastPartOfFullDir /aa/bb/cc
getLastPartOfFullDir /aa/bb/cc.txt

echo "# test if case statement support | or not"
testCaseIn europe
testCaseIn eu
testCaseIn xxxxxx
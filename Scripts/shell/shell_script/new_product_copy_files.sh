#!/bin/bash
#Program:
#	Make a new "PRODUCT_COPY_FILES" file which is used to copy ".apk/.so" file to certain directory,
#	that include "system/app/"、"system/lib/" and so on. 
#History:
#	2015/12/05	Liu Pu(Braden Liu)	1st Release
#	2015/12/06	Liu Pu(Braden Liu)	2nd Release
#			1. add extension "allfiles" to copy dir1/x/y/z to dir2/x/y/z
#	2016/01/07	Liu Pu(Braden Liu)	3rd Release
#			1. optimize usage
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# the number of parameters
# SCRIPT_NAME="new_product_copy_files.sh"
SCRIPT_NAME=`echo $0 | cut -c 3-`
FILE_NAME=$1
DIR1=$2
EXTEN=$3
DIR2=$4
EXCLUDE_FILES="$SCRIPT_NAME $FILE_NAME"
EXTEN_APK=".apk"
EXTEN_SO=".so"
DIR_SYSTEM_APP="system/app/"
DIR_SYSTEM_LIB="system/lib/"
ALL_EXTENSIONS="$EXTEN_APK $EXTEN_SO"
EXTEN_ALL="all"
EXTEN_ALL_FILES="allfiles"

function usage()
{
	echo "Note:"
	echo -e "	You need to put this script in the directory which just include your '.apk/.so' file\n	like 'device/amlogic/m201/thailand_prebuilts/'"
	echo "Usage:"
	echo "	$0 output_file dir_prefix_from [extension] [dir_prefix_to]" 
	echo "Exammple:"
	echo "	# copy files by built-in variable ALL_EXTENSIONS($ALL_EXTENSIONS)"
	echo "		$0 output.mk device/amlogic/m201/thailand_prebuilts/"
	echo "		$0 output.mk device/amlogic/m201/thailand_prebuilts/ all"
	echo " "
	echo "	# copy all files(copy .../x/y/z/file to .../x/y/z/file)"
	echo "		$0 output.mk device/amlogic/m201/thailand_prebuilts/ allfiles [dir_prefix_to]"
	echo " "
	echo "	# copy files by certain extension"
	echo "		$0 output.mk device/amlogic/m201/thailand_prebuilts/ .apk system/app/"
}

function exclude_file()
{
	if [ $# -lt 1 ];then
		echo "Note:"
		echo "	You need to give 1 file name!!!"
		echo "Usage:"
		echo "	# if filename is inclued in EXCLUDE_FILES($EXCLUDE_FILES)"
		echo "	$0 filename"
		exit 1
	fi
	
	filename=$1
	for file in $EXCLUDE_FILES
	do
		temp=`echo $filename | grep -E "$file"`
		if [ -z $temp ];then
			echo "NULL" > /dev/null
		else
			#echo "Not NULL"
			return 1
		fi
	done

	return 0
}

function find_files()
{
	if [ $# -gt "2" ];then
		echo "Note:"
		echo "	You need to add a extension like '.apk' or a directory."
		echo "Usage:"
		echo "	# find files by certain extension"
		echo "	$0 extension [directory]"
		exit 1
	fi
	extension=$1
	directory=$2
	
	echo -e "PRODUCT_COPY_FILES += \c" >> $FILE_NAME
	
	if [ -z $directory ];then
		if [ $extension = $EXTEN_APK ];then
			directory=$DIR_SYSTEM_APP
		elif [ $extension = $EXTEN_SO ];then
			directory=$DIR_SYSTEM_LIB
		else
			echo "NULL" > /dev/null
		fi
	fi	
	
	files=
	if [ -z $extension ] || [ $extension == $EXTEN_ALL_FILES ];then
		files=`find ./ -type f | cut -c 3-`
	else
		files=`find ./ -name "*$extension" | cut -c 3-`
	fi

	for file in $files
	do
		file1=$file
		if [ $extension == $EXTEN_ALL_FILES ];then
			file2=$file1
		else
			file2=`basename $file`
		fi

		# if included in the $EXCLUDE_FILES, then do not write to $FILE_NAME
		exclude_file $file2
		ret=`echo $?`
		if [ $ret -eq "0" ];then
			echo "\\" >> $FILE_NAME
			echo -e "	$DIR1$file1:$directory$file2 \c" >> $FILE_NAME
		fi
	done

	echo >> $FILE_NAME
	echo >> $FILE_NAME
}

function find_all_extensions()
{
	for extension in $ALL_EXTENSIONS
	do
		find_files $extension
	done
}

function find_all_files()
{
	find_files $EXTEN $DIR2
}

function new_output_file()
{
	echo > $FILE_NAME
	echo >> $FILE_NAME
}

# print command executing
echo "Command:"
echo "	$0 $@"

# main
if [ $# -ge "3" ];then
	new_output_file
	if [ $EXTEN == $EXTEN_ALL ];then
		find_all_extensions
	elif [ $EXTEN == $EXTEN_ALL_FILES ];then
		find_all_files
		# find_files $EXTEN $DIR2
	else
		find_files $EXTEN $DIR2
	fi
elif [ $# -eq 2 ];then
	new_output_file
	find_all_extensions
else
	echo "ERROR: "
	echo "	the number of parameters is wrong!!!"
	usage
	exit 1
fi

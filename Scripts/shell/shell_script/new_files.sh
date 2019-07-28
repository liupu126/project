#!/bin/bash
#Program:
#	To new files, the number of files  is $1, each file's size is 1G.
#History:
#	2015/11/10	Liu Pu(Braden Liu)	First Release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#number of files
cnt=$1

#check if or not a number
temp=`echo $cnt | sed 's/[0-9]//g'`
if [ -n "$temp" ];then
	echo "Not a number"
	exit 1
fi

#new directory
dir=`date +%Y%m%d%H%M%S_${cnt}G`
mkdir -p $dir
chmod 777 $dir

#new files
for((i=1;i<=$cnt;i++))
do
	filename=`date +%Y%m%d%H%M%S_%N`
	dd if=/dev/zero of=${dir}/${filename} bs=1M count=1024
	chmod 777 ${dir}/${filename}
done

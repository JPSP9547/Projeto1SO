#!/bin/bash

. ./copyFile.sh
source copyFile.sh

# Initializing variables
checking=""
filter=""
exclude_file=""
source_dir=""
backup_dir=""

# Initializing counter
cError=0;
cWarnings=0;
cUpdated=0;
cCopied=0;
cDeleted=0;
sizeCopied=0;
sizeDeleted=0;


## FUNCTIONS

# prints the correct usage of the function
usage(){ 
	echo "[SHOULD BE] ./backup.sh [-c] dir_source dir_backup"
	exit 1
}

# prints not found message
nfound(){
	echo "[NOTFOUND]: "$1 ">" $2
	exit 1
}

#compModDate(){
	# Check wich file was first created and increment/print warning 
#}

## MAIN

# get options/flags
while getopts ":cb:r:" op; do
    case $op in
	c)
            echo "checking activated"
	;;
	*)
		usage
	;;
    esac
done

shift $((OPTIND-1))
source_dir="$1"
backup_dir="$2"

# validate source directory
if [ -d $source_dir ]; then
	if [ "$checking" == "1" ];then
		echo "Source directory exists"
	fi
else
	nfound "source" "$source_dir"

fi

# backup directory
if [ ! -d $backup_dir ];then
	if [ -z "$checking" ];then
		mkdir "$backup_dir"
	fi
	echo "mkdir $backup_dir"
fi


for file in "$source_dir"/*; do
    	
	if [[ -e $file ]]; then  # make sure
		copyFile "$file" "$backup_dir"
	fi

done




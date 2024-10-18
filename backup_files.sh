#!/bin/bash

# João Pereira[120010] & Thiago Vicente[121497]


# Assuming source_dir is the directory where your scripts are located
source_dir="./functions"  # or set it to your desired directory

for file in "$source_dir"/*.sh; do
    [ -f "$file" ] && source "$file"
done

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

# Initializing sizes
sizeCopied=0;
sizeDeleted=0;

## MAIN

# get options/flags
while getopts ":cb:r:" op; do
    case $op in
	c)
            echo "checking activated"
		checking=1
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
if [ ! -d $source_dir ]; then
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
		if [ "$checking" == "1" ];then
			copyFile 1 "$file" "$backup_dir"
		else
			copyFile "$file" "$backup_dir"
		fi
	fi

done




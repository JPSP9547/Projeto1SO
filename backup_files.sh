#!/bin/bash

shopt -s dotglob

######### Variabes

checking=""
source_dir=""
backup_dir=""


function_call="$0"
SCRIPT_DIR="$(dirname "$(realpath "$function_call")")"
DIR="$SCRIPT_DIR/functionsReal"

for file in "$DIR"/*; do
    if [[ -f "$file" ]]; then
        source "$file"
    fi
done

usage(){
	if [[ "$is_recursive" -eq 0 ]];then
		echo "[USAGE] ./backup.sh [-c] dir_source dir_backup"
	fi
	exit 1
}


########### MAIN

## Validates inputs
if [[ $# -lt 2 || $# -gt 3 ]]; then
    usage
fi

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
if [[ $# -ne 2 ]]; then
	usage
fi

source_dir="$1"
backup_dir="$2"

# check if it is a absolute path or not
if [[ "$source_dir" != /* ]]; then
    source_dir="./$source_dir"
fi
if [[ "$backup_dir" != /* ]]; then
    backup_dir="./$backup_dir"
fi

# removes last bar(/) from backup_dir path (for formatting reasons)
if [[ $souce_dir == */ ]]; then
    source_dir="${source_dir:0:-1}" 
fi

if [[ $backup_dir == */ ]]; then
    backup_dir="${backup_dir:0:-1}"
fi

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


## start backup of the source files
# call copy for each source file
for file in "$source_dir"/*; do
    	
	if [[ -f $file ]]; then  # make sure
		if [ "$checking" == "1" ];then
			copyFile 1 "$file" "$backup_dir"
		else
			copyFile "$file" "$backup_dir"
		fi
	fi

done

## Remove files from backup_dir that are not on source_dir
# Skip when backup dir is empty 
if [ ! -z "$(ls -A "$backup_dir")" ]; then 
	for file in "$backup_dir"/*; do
    		filename=$(basename "$file")
    		if [[ ! -e "$source_dir/$filename" ]]; then
				if [ -z "$checking" ];then
						rm -r "$file"
				fi

    		fi
	done
fi




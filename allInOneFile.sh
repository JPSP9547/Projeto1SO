#!/bin/bash

########### FUNCTIONS
usage(){
		echo "[SHOULD BE] ./backup.sh [-c] dir_source dir_backup"
		exit 1
}
compModDate(){
	# Functions has two parameters
	# arg1 is the source_dir file
	# arg2 is the backup_dir file
	# RETURN: returns 0 if arg1 last modification was after arg2 last modification
	# RETURN: return 1 otherwise
	# FUCNTIONS ASSUMES THAT ARG1 and ARG2 exists

	local file1="$1"
	local file2="$2"

	if [[ "$file1" -nt "$file2" ]];then
		return 0	
	fi
	return 1
	
}


######### Variabes

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
    	
	if [[ -e $file ]]; then  # make sure
		if [ "$checking" == "1" ];then
			copyFile 1 "$file" "$backup_dir"
		else
			copyFile "$file" "$backup_dir"
		fi
	fi

done

## Remove files from backup_dir that are not on source_dir
for file in "$backup_dir"/*; do
    filename=$(basename "$file")
    if [[ ! -e "$source_dir/$filename" ]]; then
        	rm "$file"
		((cDeleted++))
    fi
done




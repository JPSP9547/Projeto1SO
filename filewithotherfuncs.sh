#
# call copy for each source file!/bin/bash

# João Pereira[120010] & Thiago Vicente[121497]


# Add all functions to source
source_dir="./functions"

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
		
		echo "[SHOULD BE] ./backup.sh [-c] dir_source dir_backup"
		exit 1
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




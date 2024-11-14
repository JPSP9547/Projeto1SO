#!/bin/bash

# show hidden files
shopt -s dotglob

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
		echo "[USAGE] ./backup.sh [-c] [-b excludefile] [-r regx] dir_source dir_backup"
	fi
	exit 1
}

######### Variables
checking=""
filter=""
exclude_file=""
source_dir=""
backup_dir=""
is_recursive=0
exclude_file=""
regx=".*"
hasExclude=0


# get options/flags
while getopts ":czb:r:" op; do
    case $op in
	c)
        echo "Checking activated"
		checking=1
	;;
	b)
		exclude_file="$OPTARG"
		hasExclude=1
	;;
	r)
		regx="$OPTARG"
		hasRegx=1
	;;
	z)
		is_recursive=1
	;;
	*)
		usage
	;;
    esac
done

shift $((OPTIND-1))
if [[ $# -ne 2 ]]; then
echo $2
echo $@
    usage
fi

if [[ $hasExclude == 1 ]];then
	if [[ ! -f "$exclude_file" ]];then
		hasExclude=0
	fi
fi

source_dir=$(realpath "$1")
if [ $? -ne 0 ]; then
    echo "Can't resolve source directory path"
    exit 1
fi
backup_dir=$(realpath "$2")
if [ $? -ne 0 ]; then
    echo "Can't resolver backup directory path"
    exit 1
fi

if [[ "$backup_dir" == "$source_dir"* ]]; then
  echo "[ERROR] $backup_dir is inside $source_dir"
  exit 1
fi


if [[ "$source_dir" != /* &&  "$source_dir" != ./* ]]; then
	source_dir="./$source_dir"
fi
if [[ "$backup_dir" != /* && "$backup_dir" != ./* ]]; then
    backup_dir="./$backup_dir"
fi

# removes last bar(/) from backup_dir path (for formatting reasons)
if [[ $source_dir == */ ]]; then
    source_dir="${source_dir:0:-1}"
fi

if [[ $backup_dir == */ ]]; then
    backup_dir="${backup_dir:0:-1}"
fi
# validate source directory

if [ ! -d "$source_dir/" ]; then
	nfound "source" "$source_dir"
	exit 1
fi


# backup directory
if [ ! -d "$backup_dir" ];then
	if [ -z "$checking" ];then
		mkdir -p "$backup_dir"
		if [[ $? -eq 1 ]];then
		    echo "[ERROR] could not create directory $backup_sir"
			exit 1
		fi

	fi
	echo "mkdir $backup_dir"
fi

if [[ "$hasExclude" -eq 1 ]]; then
    mapfile -t exclude_list < "$exclude_file"
else
    exclude_list=()
fi

## start backup of the source files
# call copy for each source file

for item in "$source_dir"/*; do


	base_item=$(basename "$item")

	if [[ $base_item =~ $regx ]]; then
		if [[ -f $item ]]; then

			findElement ${exclude_list[@]} "$base_item"
			if [[ $? -eq 0 ]];then
        			continue
           fi
			if [ "$checking" == "1" ];then
				copyFile 1 "$item" "$backup_dir"
			else
				copyFile "$item" "$backup_dir"
			fi
		elif [[ -d $item ]];then
			new_backup_dir="$backup_dir/$(basename "$base_item")"
			if [[ "$checking" -eq 1 ]]; then
			    params=" -c -z \"$item\" \"$new_backup_dir\""
			else
				params="-z \"$item\" \"$new_backup_dir\""
			fi

			#echo $command
			output="$(eval "$function_call $params")"

			# prints every cp and mkdir statement
			echo "$output" | grep -E '^(cp|mkdir|rm)'

		fi
	fi

done

## Remove files from backup_dir that are not on source_dir
# Skip when backup dir is empty
if [[ -d "$backup_dir" &&  ! -z "$(ls -A "$backup_dir")" ]]; then
	for file in "$backup_dir"/*; do
    	filename=$(basename "$file")
    	if [[ ! -e "$source_dir/$filename" ]]; then

			if [ -z "$checking" ];then
	    			rm "$file"
			fi

    	fi
	done
fi

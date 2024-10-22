#!/bin/bash

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

########### 
nfound(){
	# Prints not found message
	# arg1 is the field name
	# arg2 is the given path
	if [[ "$is_recursive" -eq 0 ]];then
		echo "[NOTFOUND]: "$1 ">" $2
	fi
	exit 1
}

usage(){
	if [[ "$is_recursive" -eq 0 ]];then
		echo "[USAGE] ./backup.sh [-c] [-b excludefile] [-r regx] dir_source dir_backup"
	fi
	exit 1
}

compModDate(){
	# Functions has two parameters
	# arg1 is the source_dir file
	# arg2 is the backup_dir file
	# RETURN: returns 0 if arg1 last modification was after arg2 last modification
	# RETURN: return 1 otherwise
	# FUNCTIONS ASSUMES THAT ARG1 and ARG2 exists

	local file1="$1"
	local file2="$2"

	if [[ "$file1" -nt "$file2" ]];then
		return 0	
    elif [[ "$file2" -nt "$file1" ]];then
        echo "[WARNING] Backed file ($file2) is newer than source file ($file1) (SHOULD NOT HAPPEN)"
        return 1
    else
        return 1 #if dates are equal it will not copy the file
    fi	
}

copyFile(){
    	#function has 3 arguments
    	#argument1 : absolute path of file to be copied
     	#argument2 : absolute path of directory where file will be copied
    	#argument3 : -c
        #function checks dates of files and only copies if source file is newer than backed files
        #FUNCTION ASSUMES ARGUMENT1 IS NOT A DIRECTORY

        if [[ $# -eq 2 ]]; then
            file=$1
            destination=$2
            copy=1
        elif [[ $# -eq 3 ]]; then
            
            file=$2
            destination=$3
            copy=0

        else
            echo "Bad use of function copyFile"
			return 1
        fi

	  	file="$(echo $file | tr -s '/')"
        fileName="$(basename "$file")"
        
        if [[ -f "$destination/$fileName" ]]; then
            compModDate "$file" "$destination/$fileName"

            if [[ $? -eq 0 ]]; then

                if [[ $copy -eq 1 ]]; then
                    cp -a "$file" "$destination"
                fi

                echo "cp -a $file $destination/$fileName"
	
		    	return 0

			
	    	else
                return 1

            fi

        else

        if [[ $copy -eq 1 ]]; then
            cp -a "$file" "$destination"
         fi

        echo "cp -a $file $destination/$fileName"

        return 0
    fi
}


########### MAIN

# save the name for recursive call
function_call="$0" 


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
	usage 
fi

if [[ $hasExclude == 1 ]];then
	if [[ ! -f "$exclude_file" ]];then
		hasExclude=0
	fi
fi

source_dir="$1"
backup_dir="$2"


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
if [ ! -d "$source_dir" ]; then
	nfound "source" "$source_dir"
	exit 1
fi

# backup directory
if [ ! -d "$backup_dir" ];then
	if [ -z "$checking" ];then
		mkdir -p "$backup_dir"

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
    
	if [[ "${exclude_list[*]}" == *"$base_item"* ]]; then
        continue 
    fi

	if [[ $base_item =~ $regx ]]; then
		if [[ -f $item ]]; then 
			if [ "$checking" == "1" ];then
				copyFile 1 "$item" "$backup_dir"
			else
				copyFile "$item" "$backup_dir"
			fi
		elif [[ -d $item ]];then
			new_backup_dir="$backup_dir/$(basename "$base_item")"
			
			if [[ "$checking" -eq 1 ]]; then
				command="$function_call -c -z $item $new_backup_dir"
			else
				command="$function_call -z $item $new_backup_dir"
			fi

			#echo $command
			output="$($command )"
			echo "$output" | grep -E '^(cp|mkdir)' 

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


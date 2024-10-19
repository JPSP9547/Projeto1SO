#!/bin/bash

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



########### FUNCTIONS
usage(){
	echo "[SHOULD BE] ./backup.sh [-c] dir_source dir_backup"
	end_print
}
end_print(){
	echo "While backuping src: $cErrors Errors; $cWarnings Warnings; $cUpdated Updated; $cCopied Copied (${sizeCopied}B); $cDeleted deleted (${sizeDeleted}B)"
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
    elif [[ "$file2" -nt "$file1" ]];then
        echo "[WARNING] Backed file ($file2) is newer than source file ($file1) (SHOULD NOT HAPPEN)"
	  ((cWarnings++))
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

        if [[ $# == 2 ]]; then
            
            file=$1
            destination=$2
            copy=1
        elif [[ $# == 3 ]]; then
            
            file=$2
            destination=$3
            copy=0

        else
            echo "Bad use of function copyFile"
        fi

	  file="$(echo $file | tr -s '/')"
        fileName="$(echo $file | tr "/" " " | awk '{print $NF}')"    
        
        if [[ -f "$destination/$fileName" ]]; then
            compModDate $file "$destination/$fileName"

            if [[ $? -eq 0 ]]; then

                if [[ $copy -eq 1 ]]; then
                    cp -a $file $destination
                    return 0
                fi

                echo "cp -a $file $destination/$fileName"
	
		    file_size=$(stat -c %s "$file")
    			((cUpdated++))
			sizeCopied=$((sizeCopied + file_size))
		    	return 0

			
	    else
                return 1

            fi

        else

            if [[ $copy -eq 1 ]]; then
                cp -a $file $destination
            fi

            echo "cp -a $file $destination/$fileName"
            ((cCopied++))

		file_size=$(stat -c %s "$file")
		sizeCopied=$((sizeCopied + file_size))
            return 0

        fi
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
     
			file_size=$(stat -c %s "$file")
			sizeDeleted=$((sizeDeleted + file_size))
			if [ -z "$checking" ];then
	    			rm "$file"
			fi
	    		((cDeleted++))
    		fi
	done
fi

end_print


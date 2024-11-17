#!/bin/bash

#MAIN
backup_check(){

    if [[ $# != 2 ]]; then
        echo "Script has to receive 2 arguments"
        return 1
    fi

    if [[ ! -d "$1" && -d "$2" ]]; then
        echo "Arguments have to be directories"
        return 1
    fi

    work_dir="$1"
    backup_dir="$2"

    # removes last bar(/) from backup_dir path (for formatting reasons)
    if [[ "$work_dir" == */ ]]; then
        work_dir="${work_dir:0:-1}" 
    fi

    if [[ "$backup_dir" == */ ]]; then
        backup_dir="${backup_dir:0:-1}"
    fi

    if [ ! -z "$(ls -A "$backup_dir")" ]; then 
        for file in "$backup_dir"/*; do
            fileName="$(basename "$file")"
            if [[ -d "$file" ]]; then
                #check if folder exists in work_dir
                #call this script again but backup_dir = current dir and work_dir = work_dir + current_dir(only last part)
		    folderName="$( basename "$file" )" #**
		    work_dirRecursive="$work_dir/$folderName"
            backup_dirRecursive="$file"
			echo "folderName = $folderName"
            echo "work_dir = $work_dir"
            echo "work_dirRecursive = $work_dirRecursive"
            echo "backup_dirRecursive = $backup_dirRecursive"

           if [[ -d "$work_dirRecursive" ]]; then
               echo "recursiva $work_dirRecursive $backup_dirRecursive"
               backup_check "$work_dirRecursive" "$backup_dirRecursive"    
          	fi


            else
                if [[ -f "$work_dir/$fileName" ]];then
                    if [[ $(md5sum "$file" | awk '{print $1}') != $(md5sum "$work_dir/$fileName" | awk '{print $1}') ]]; then
                        echo "$file and $work_dir/$fileName differ"
                    fi
                fi
            fi
        done
    fi

}

backup_check "$1" "$2"

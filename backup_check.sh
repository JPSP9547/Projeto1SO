#!/bin/bash

#MAIN
backup_check(){

    if [[ $# != 2 ]]; then
        echo "Script has to receive 2 arguments"
        return 1
    fi

    if [[ ! -d $1 && -d $2 ]]; then
        echo "Arguments have to be directories"
        return 1
    fi

    work_dir=$1
    backup_dir=$2

    # removes last bar(/) from backup_dir path (for formatting reasons)
    if [[ $work_dir == */ ]]; then
        work_dir="${work_dir:0:-1}" 
    fi

    if [[ $backup_dir == */ ]]; then
        backup_dir="${backup_dir:0:-1}"
    fi

    if [ ! -z "$(ls -A "$backup_dir")" ]; then 
        for file in "$backup_dir"/*; do
            fileName=$(basename "$file")
            if [[ -d $file ]]; then
                #TODO
                #check if folder exists in work_dir
                #call this script again but backup_dir = current dir and work_dir = work_dir + current_dir(only last part)
                folderName=echo $file | tr "/" " " | awk '{print $NF}'
                work_dirRecursive="$work_dir/$folderName"
                backup_dirRecursive="$file"


            if [[ -d $work_dirRecursive ]]; then
                backup_check $work_dirRecursive $backup_dirRecursive    
            else
                echo "Folder $file does not exist on $work_dir"
            fi


            else
                if [[ -f "$work_dir/$fileName" ]];then
                    if [[ $(md5sum "$file" | awk '{print $1}') != $(md5sum "$work_dir/$fileName" | awk '{print $1}') ]]; then
                        echo "$file and $work_dir/$fileName differ"
                    fi
                else
                    echo "$file does not exist in $work_dir (SHOULD NOT HAPPEN)"
                fi
            fi
        done

        for file in "$work_dir"/*; do
            fileName=$(basename "$file")
            if [[ -d $file ]]; then
                echo $file
                folderName=echo $file | tr "/" " " | awk '{print $NF}'
                work_dirRecursive="$file"
                backup_dirRecursive="$backup_dir/$folderName"


            if [[ -d $backup_dirRecursive ]]; then
                backup_check $work_dirRecursive $backup_dirRecursive    
            else
                echo "Folder $file does not exist on $backup_dir"
            fi


            else
                if [[ -f "$backup_dir/$fileName" ]];then
                    if [[ $(md5sum "$file" | awk '{print $1}') != $(md5sum "$backup_dir/$fileName" | awk '{print $1}') ]]; then
                        echo "$file and $backup_dir/$fileName differ"
                    fi
                else
                    echo "$file does not exist in $backup_dir (SHOULD NOT HAPPEN)"
                fi
            fi
        done

    elif [ ! -z "$(ls -A "$work_dir")" ]; then
        for file in "$work_dir"/*; do
            if [[ -f $file ]]; then
                
                fileName=$(basename "$file")

                echo "$file does not exist on $backup_dir"
            fi
        done

    fi

}

backup_check $1 $2

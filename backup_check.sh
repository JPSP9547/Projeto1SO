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

    local work_dir="$1"
    local backup_dir="$2"

    # removes last bar(/) from backup_dir path (for formatting reasons)
    if [[ "$work_dir" == */ ]]; then
        work_dir="${work_dir:0:-1}" 
    fi

    if [[ "$backup_dir" == */ ]]; then
        backup_dir="${backup_dir:0:-1}"
    fi
    
    local arrayOfFile=() #array where files already checked will be put

    if [[ ! -z "$(ls -A "$work_dir")" ]]; then
        for file in "$work_dir"/*; do
            if [[ -d "$file" ]]; then
                #TODO
                #CODIGO PARA TRABALHAR COM PASTAS
                folderName="$( basename $file )" #**
		        local backup_dirRecursive="$backup_dir/$folderName"

                if [[ -d "$backup_dirRecursive" ]]; then
                    local work_dirRecursive="$file"
                    backup_check "$work_dirRecursive" "$backup_dirRecursive"

                else
                    echo "[FOLDER] $folderName/ doest not exist on $backup_dir"
                
                fi

            elif [[ -f "$file" ]]; then
                fileName="$(basename $file)"
                
                if  [[ ! -f "$backup_dir/$fileName" ]]; then
                    echo "[FILE] $file does not exist on $backup_dir/"
                else
                    mdSumWork=$(md5sum "$file" | awk '{print $1}')
                    mdSumBack=$(md5sum "$backup_dir/$fileName" | awk '{print $1}')
                    
                    if [[ $mdSumWork != $mdSumBack ]]; then
                        echo "[FILE] $file and $backup_dir/$fileName differ"
                    fi
                fi
            else
                echo "Error while analysing files"
            fi
        done
    fi

    if [[ ! -z "$(ls -A "$backup_dir")" ]]; then
         for file in "$backup_dir"/*; do
            if [[ -d $file ]]; then
                #TODO
                #CODIGO PARA TRABALHAR COM PASTAS
                folderName="$( basename $file )" #**
		        work_dirRecursive="$work_dir/$folderName"

                if [[ -d "$work_dirRecursive" ]]; then
                    backup_dirRecursive="$file"
                    backup_check "$work_dirRecursive" "$backup_dirRecursive"

                else
                    echo "[FOLDER] $backup_dir/$folderName/ doest not exist on $work_dir"
                
                fi

            elif [[ -f "$file" ]]; then
                fileName=$(basename "$file")
                
                if  [[ ! -f "$work_dir/$fileName" ]]; then
                    echo "$file does not exist on $work_dir/ (SHOULD NOT HAPPEN)"
                fi
                #arrayOfFile+="$backup_dir/$fileName"
            else
                echo "Error while analysing files"
            fi
        done
    fi


}

backup_check "$1" "$2"

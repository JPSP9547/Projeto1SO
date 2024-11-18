#!/bin/bash

removeRecursive(){
    # recives 3 arguments
    # arg1 is the main directory
    # arg2 is the directory that will be changed
    # arg3 is the checking value
    # RETURNS 2 values (count, size)

    local main_dir="$1"
    local other_dir="$2"
    local checking="$3"

    local count=0 # contador de quantas remoções foram feiras
    local size=0 # tamanho dos documentos removidos

    for file in "$other_dir"/*; do

        filename=$(basename "$file")

        if [[ -d "$file" ]];then

            if [[ ! -e "$main_dir/$filename"  ]];then

                # call removeRecursiveHelper
                result=$(removeRecursiveHelper "$file" "$checking")
                echo "$result" | grep 'rm'
                
                # ski+s to last line where the return values are
                result="${result##*$'\n'}"

                dir_count=$(echo "$result" | cut -d ' ' -f 1)
                dir_size=$(echo "$result" | cut -d ' ' -f 2)

                ((count += dir_count))
                ((size += dir_size))

                # remove directory if not checking
                if [[ "$checking" -eq 0 ]];then
	    			rm -r "$file"
				fi
				echo "rm -r $file"

			else
                # call recursive for other dir
                result=$(removeRecursive "$main_dir/$filename" "$file" 1)
                echo "$result" | grep 'rm'
                result="${result##*$'\n'}"

                dir_count=$(echo "$result" | cut -d ' ' -f 1)
                dir_size=$(echo "$result" | cut -d ' ' -f 2)

                ((count += dir_count))
                ((size += dir_size))

            fi

        elif [[ -f "$file" ]];then

            # if doenst exist in main then remove it
            if [[ ! -e "$main_dir/$filename" ]];then

            file_size=$(stat -c "%s" "$file")
            ((size += file_size))
            ((count++))

            if [[ "$checking" -eq 0 ]];then
    			rm -r "$file"
			fi
			echo "rm $file"

            fi
        fi
    done

    # return values
    echo "$count $size"
}

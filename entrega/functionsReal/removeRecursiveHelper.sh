#!/bin/bash
removeRecursiveHelper() {
    # removes every element from the dir recursively

    local dir="$1"
    local checking="$2"

    local dir_count=0
    local dir_size=0

    for item in "$dir"/*;do

        # if it is directory, then call it recursively
        if [[ -d "$item" ]]; then
            result=$(removeRecursiveHelper "$item" "$checking")
            echo "$result" | grep 'rm'
            result="${result##*$'\n'}"

            sub_count=$(echo "$result" | cut -d ' ' -f 1)
            sub_size=$(echo "$result" | cut -d ' ' -f 2)
            dir_count=$((dir_count + sub_count))
            dir_size=$((dir_size+ sub_size))

            if [[ "$checking" -eq 0 ]];then
    			rm -r "$item"
			fi
			echo "rm $item"

		# if is a item then remove it
		elif [[ -f "$item" ]]; then
            item_size=$(stat -c "%s" "$item")
            ((dir_size += item_size))
            ((dir_count++))

            if [[ "$checking" -eq 0 ]];then
    			rm "$item"
			fi
			echo "rm  $item"

    	fi
    done

    # return values
    echo "$dir_count $dir_size"
}

#!/bin/bash
findElement(){
	#FUNCTIONS NEEDS 2 params
	# $1 is the array
	# $2 is the element to search
	args=($@)
	lst=(${args[@]::${#args[@]}-1})
	toFind=${args[@]: -1}
	for i in "$lst";do
  		if [[ $i == "$toFind" ]];then
    			return 0
  		fi
	done
	return 1
}

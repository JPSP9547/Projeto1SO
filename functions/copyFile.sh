#!/bin/bash

. ./functions/compModDate.sh

# after validation does backup. EXPECTS VALIDATED INPUT
copyFile(){
    	#function has 3 arguments
    	#argument1 : absolute path of file to be copied
     	#argument2 : absolute path of directory where file will be copied
    	#argument3 : -c 
    	

    if [[ $# == 2 ]]; then
      local file=$1
      local destination_true=$2
	
	local filename=$(basename "$file")
      local destination="$backup_dir/$filename"
      
      if [[ -e $destination ]]; then
          compModDate "$file" "$destination"
	    if [[ $? -ne 0 ]];then
	    	return 0
	    fi
      fi

	cp -a $file "$destination_true"
    
        if [[ $? -eq 0 ]]; then
            
            echo "cp -a $file $destination_true"

            echo "" #prints new line
            return 0
        else
            echo "Error while copying"
        
            echo "" #prints new line
            return 1
        fi

    elif [[ $# == 3 ]]; then
        local file=$2
        local destination=$3
        
	  
	local filename=$(basename "$file")
      local destination_true="$backup_dir/$filename"
      
      if [[ -e $destination ]]; then
          compModDate "$file" "$destination"
	    if [[ $? -ne 0 ]];then
	    	continue
	    fi
      fi

        echo "cp -a $file $destination_true"
        echo ""

        return 0
    fi
}



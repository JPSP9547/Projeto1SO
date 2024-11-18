#!/bin/bash
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
            echo "Bad use of function copyFile" >&2
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


#!/bin/bash

# João Pereira[] & Thiago Vicente[121497]

# Initializing variables
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


## FUNCTIONS

# prints the correct usage of the function
usage(){ 
	echo "[SHOULD BE] ./backup.sh [-c] dir_source dir_backup"
	exit 1
}

# prints not found message
nfound(){
	echo "[NOTFOUND]: "$1 ">" $2
	exit 1
}

compModDate(){
	return 0;	
}

# after validation does backup. EXPECTS VALIDATED INPUT
backup(){
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


## MAIN

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
source_dir="$1"
backup_dir="$2"

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


for file in "$source_dir"/*; do
    	
	if [[ -e $file ]]; then  # make sure
		if [ "$checking" == "1" ];then
			backup 1 "$file" "$backup_dir"
		else
			backup "$file" "$backup_dir"
		fi
	fi

done




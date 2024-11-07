nfound(){
	# Prints not found message
	# arg1 is the field name
	# arg2 is the given path
	if [[ "$is_recursive" -eq 0 ]];then
		echo "[NOTFOUND]: "$1 ">" $2
	fi
	exit 1
}



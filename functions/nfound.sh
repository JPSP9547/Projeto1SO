nfound(){
	# Prints not found message
	# arg1 is the field name
	# arg2 is the given path

	echo "[NOTFOUND]: "$1 ">" $2
	exit 1
}

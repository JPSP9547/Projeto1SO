compModDate(){
	# Functions has two parameters
	# arg1 is the source_dir file
	# arg2 is the backup_dir file
	# RETURN: returns 0 if arg1 last modification was after arg2 last modification
	# RETURN: return 1 otherwise
	# FUCNTIONS ASSUMES THAT ARG1 and ARG2 exists

	local file1="$1"
	local file2="$2"

	if [[ "$file1" -nt "$file2" ]];then
		return 0	
	fi
	return 1
	
}

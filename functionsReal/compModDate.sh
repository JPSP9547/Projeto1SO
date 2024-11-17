compModDate(){
	# Functions has two parameters
	# arg1 is the source_dir file
	# arg2 is the backup_dir file
	# RETURN: returns 0 if arg1 last modification was after arg2 last modification
	# RETURN: return 1 otherwise
	# FUNCTIONS ASSUMES THAT ARG1 and ARG2 exists

	local file1="$1"
	local file2="$2"

	if [[ "$file1" -nt "$file2" ]];then
		return 0
    elif [[ "$file2" -nt "$file1" ]];then
        echo "[WARNING] Backed file ($file2) is newer than source file ($file1) (SHOULD NOT HAPPEN)" >&2
        ((cWarnings++))
		return 1
    else
        return 1 #if dates are equal it will not copy the file
    fi
}

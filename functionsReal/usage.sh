usage(){
	if [[ "$is_recursive" -eq 0 ]];then
		echo "[USAGE] ./backup.sh [-c] [-b excludefile] [-r regx] dir_source dir_backup"
	fi
	exit 1
}

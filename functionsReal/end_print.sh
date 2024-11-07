end_print(){
    # prints the final output or returns a recursive data
	if [[ "$is_recursive" -eq 1 ]];then
		local result=("$cError" "$cWarnings" "$cUpdated" "$cCopied" "$sizeCopied" "$cDeleted" "$sizeDeleted")
		echo "${result[@]}"
		exit 0
	else
		echo "While backing up src: $cError Errors; $cWarnings Warnings; $cUpdated Updated; $cCopied Copied (${sizeCopied}B); $cDeleted deleted (${sizeDeleted}B)"
		exit $1
	fi
}

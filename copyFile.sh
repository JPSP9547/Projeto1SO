#!/bin/bash

function copyFile(){
    #Author: Joao Pereira
    #functions excepts arguments to be validated
    #function has 2 arguments
    #argument1 : absolute path of file to be copied
    #argument2 : absolute path of directory where file will be copied
    #function has a paremeter -c that makes it show the copy command but not execute it
    #use copyFile [-c] file destination

    if [[ $# == 2 ]]; then
        local file=$1
        local destination=$2

        cp -a $file "$destination"
    
        if [[ $? -eq 0 ]]; then
            
            echo "cp -a $file $destination"

            echo "" #prints new line
            return 0
        else
            echo "Error while copying"
        
            echo "" #prints new line
            return 1
        fi

    elif [[ $# == 3 && $1 == "-c" ]]; then
        local file=$2
        local destination=$3
        
        echo "cp -a $file $destination"
        echo ""

        return 0

    else
        echo "Wrong use of parameters and/or arguments"
    fi
}

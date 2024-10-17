#!/bin/bash

. ./copyFile.sh
source copyFile.sh


if [[ $# == 3 && $1 == "-c" ]]; then
    sourceDirectory=$2
    destinationDirectory=$3
    
    for file in "$sourceDirectory"/*
    do
        echo $file
        if [[ -f $file  ]];then  #checks if file is a "normal" file and exists
            copyFile -c $file $destinationDirectory
        fi 
    done

elif [[ $# == 2 && -d $1 && -d $2 ]]; then
    sourceDirectory=$1
    destinationDirectory=$2

    for file in "$sourceDirectory"/*
    do
        if [[ -f $file  ]];then  #checks if file is a "normal" file and exists
            copyFile $file $sourceDirectory
        fi 
    done
else
    echo "Wrong usage of parameters"
    return 1
fi



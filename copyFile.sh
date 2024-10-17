#!/bin/bash

function copyFile(){
    #a funcao tem dois argumentos
    #argumento1 : localizacao absoluta do ficheiro a copiar
    #argumento2 : localizacao absoluta da diretoria para onde o ficheiro vai

    file=$1
    destination=$2

    cp $file $destination
    
    if [[ $? -eq 0 ]]; then
        echo "cp $file $destination\n"
        return 0
    else
        echo "Error while copying\n"
        return 1
    fi
        
}

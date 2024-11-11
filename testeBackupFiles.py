import subprocess, sys
import os

def testeBasicoPastaDstVazia(pastaSrc, pastaDst): #teste que apenas vê se o programa copia
    comando = "./backup_files.sh" + " " + pastaSrc + " " + pastaDst + " > output.txt"
    
   # current_directory = os.getcwd()
    #if os.path.exists(current_directory+"/output.txt"):
     #   os.remove(current_directory+"/output.txt")

    subprocess.run(comando, shell=True, executable="/bin/bash")
    
    files = [file for file in os.listdir(pastaSrc) if os.path.isfile(file)]
    
    expectedOutput = set()
    for file in files:
        stringSrc = pastaSrc + file
        stringDst = pastaDst + file

        expectedOutput.add("cp -a " + stringSrc + " " + stringDst)
    
    f = open("output.txt", "r")
    actualOutput = set()
    
    for line in f:
        actualOutput.add(line.replace("\n", "").replace("//","/").replace("././","./"))    
    f.close()
    
    if expectedOutput != actualOutput:
        print("TesteBasicoPastaDstVazia failed")
        print("\tExpected output :", expectedOutput)
        print("\tActual output:", actualOutput)




testeBasicoPastaDstVazia("./", "~/Escola/SO/testeProjeto")

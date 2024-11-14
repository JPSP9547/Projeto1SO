O problema foi dividido de forma a torná-lo mais modular, visando a reutilização do código e facilitando a manutenção e a compreensão. Cada função desempenha um papel fundamental na execução do processo de backup. A seguir, iremos analisar as funções utilizadas e sua contribuição para a solução.

<h6>findElement()</h6>  
Esta função recebe 2 argumentos, um array e um valor a se procurar. 
<div class="code-snippet">
<pre>
<b>Entrada:</b> 
- array: A lista de elementos para pesquisar 
- elemento: O elemento que estamos procurando 
.
<b>Saída: </b>
- Retorna 0 se o elemento for encontrado 
- Retorna 1 se o elemento não for encontrado
.
<b>Execução</b>
	args ← array
	lst ← args[0 até comprimento(args)-1]
	toFind ← args[último]
	para cada item em lst faça:
		se item é igual a toFind então
			retorne 0 
		fim se 
	fim para
	retorne 1
</pre>
</div>


<h6>compModDate()</h6>
Esta função recebe 2 caminhos para ficheiros e compara a última data de modificação. usando o comando "<b>-nt</b>". 
<div class="code-snippet">
<pre>
<b>Entrada:</b> 
- file1: Caminho para o arquivo fonte
- file2:  Caminho para o arquivo de backup
- .
<b>Saída: </b>
- Retorna 0 se <i>file1</i> foi modificado depois de <i>file2</i>
- Retorna 1 se <i>file2</i> foi modificado depois de <i>file1</i>, 
	ou se as datas de modificação são iguais
.
<b>Execução</b>
	se file1 foi modificado depois de file2 então 
		retorne 0 
	senão se file2 foi modificado depois de file1 então 
		exiba mensagem de advertência 
		retorne 1 
	fim se 
	retorne 1
</pre>
</div>


<h6>copyFile()</h6>
Esta função recebe um ficheiro ,um diretório para onde realizar a cópia e um valor <i><b>copy</b></i> que indica se a cópia deve ser realizada.
<div class="code-snippet">
<pre>
<b>Entrada:</b>
- file: Caminho do arquivo a ser copiado
- destination: Caminho do diretório de destino
- copy: Se 1, copia o arquivo; se 0, apenas verifica as datas
.
<b>Saída:</b>
- Retorna 0 se o arquivo for copiado com sucesso
- Retorna 1 se ocorrer um erro durante a cópia
.
<b>Execução</b>
	se o arquivo já existe no destino então
	    comparar a data de modificação entre o arquivo e o de backup
	    se o arquivo fonte for mais recente então
	        se copy for 1 então
	            copie o arquivo para o destino
	            se ocorrer erro ao copiar então
	                retorne 1
	            fim se
	            atualize os contadores de cópias
	            retorne 0
	        fim se
	    fim se
	fim se
	.
	se o arquivo não existe no destino e copy for 1 então
	    copie o arquivo para o destino
	    se ocorrer erro ao copiar então
	        retorne 1
	    fim se
	    atualize os contadores de cópias
	    retorne 0
	fim se
</pre>
</div>

<h6>usage()</h6>
Exibe a mensagem de uso do script.
<div class="code-snippet">
<pre>
<b>Entrada:</b>
- Nenhuma
.
<b>Saída:</b>
- Exibe a mensagem de uso do script
.
<b>Execução:</b>
	Exiba "[USAGE] ./backup.sh [-c] [-b excludefile] [-r regx] ... dir_source dir_backup"
</pre>
</div>

<h6>nfound()</h6>
Exibe mensagem de erro se o diretório ou arquivo não for encontrado.
<div class="code-snippet">
<pre>
Entrada:
- field: O tipo de entidade (arquivo ou diretório) que não foi encontrado
- path: Caminho do arquivo ou diretório que não foi encontrado
.
Saída:
- Exibe mensagem de erro e termina a execução do script
.
Execução:
	Exiba "[NOTFOUND]: campo "$field" > "$path"
	Terminar execução
</pre>
</div>

<h6>end_print()</h6>
Exibe estatísticas do backup. É só usado no backup_summary.sh.
<div class="code-snippet">
<pre>
Entrada:
- is_recursive: Indica se a execução é recursiva ou não
.
Saída:
- Exibe o resumo das operações realizadas (Erros, Warnings, Arquivos Copiados, etc.)
- Finaliza a execução do script
.
Execução:
	Se is_recursive for 1 então
	    Exiba resumo das estatísticas de backup (Erros, Warnings, Arquivos Copiados, etc.)
	Senão
	     Exiba resumo e encerre o script
	Fim se
</pre>
</div>


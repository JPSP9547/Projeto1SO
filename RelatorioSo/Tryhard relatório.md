
<h1>Introdução</h1>

**Do que se trata?**
Este projeto foi realizado no âmbito da disciplina de Sistemas Operativos cujo objetivo foi a criação de 3 scripts para criação e atualização de cópias de segurança.

- O backup_files.sh tem o objetivo de criar e/ou atualizar uma cópia de segurança em que se assume que não existem diretórios. 
- O backup.sh tem o mesmo objetivo do backup_files.sh, mas neste já se assume a possibilidade da existência de diretórios. 
- O backup_summary.sh é similar ao backup.sh, mas este tem informação sobre quantos ficheiros foram copiados/eliminados e sobre o espaço que esses mesmos ficheiros ocupavam. 
- O backup_check.sh serve para avaliar se os ficheiros na diretoria que foi copiada são iguais aos da diretoria que contém a sua cópia de segurança.  
Todos os scripts escrevem no terminal as operações de cópias ou de eliminação de ficheiros/diretorias que fizeram.

<div class="page-break"></div>

**Metodologia de Desenvolvimento**

Para o desenvolvimento deste projeto, adotamos a ferramenta **Git** como controle de versão, permitindo que ambos os desenvolvedores trabalhassem de maneira independente em partes distintas do projeto. Essa abordagem facilitou a colaboração e o gerenciamento de alterações, especialmente ao modularizar as funcionalidades em arquivos separados.

Inicialmente, definimos as responsabilidades de cada função, especificando claramente os parâmetros de entrada, o comportamento esperado e o valor de retorno de cada uma. Com essa estruturação, decidimos a divisão das tarefas entre os membros da equipe, garantindo uma organização eficiente do trabalho.

As responsabilidades ficaram distribuídas da seguinte forma:

- **João Pereira (120010)** foi responsável por implementar a função **`copy_file()`**, pela lógica por trás da função **`backup_check()`** e pela criação dos testes do sistema.
- **Thiago Vicente (121497)** ficou encarregado de desenvolver as funções **`compModeDate()`**, **`usage()`**, **`nfound()`**, **`find_element()`**, de desenvolver e os arquivos de backup (**`backup.sh`**, **`backup_files.sh`**, **`backup_summary.sh`**) e de fazer os últimos retoques do **`backup_check.sh`**.

O trabalho foi realizado sem intercorrências, uma vez que cada desenvolvedor seguiu as orientações estabelecidas e contribuiu dentro de sua área de responsabilidade. Abaixo, apresentamos uma descrição detalhada das funcionalidades implementadas em cada função e arquivo.

**Testes**

Para testar os scripts, iremos testar uma cópia em que a pasta destino está vazia, uma cópia em que a pasta destino tem alguns dos arquivos da pasta source, uma cópia em que a pasta destino tem arquivos que não pertencem à pasta source e vamos testar uma cópia em que a pasta destino tem os mesmos arquivos da pasta source mas alguns foram modificados. Também iremos testar pastas com ficheiros escondidos e com espaços nos nomes. Nos scripts que tiverem parâmetros opcionais iremos testá-los com e sem esses parâmetros.
Os teste apresentados neste relatório não representam a totalidade dos testes feitos, mas sim apenas os mais pertinentes de serem discutidos.



<div class="page-break"></div>
<h1>Estruturas de dados</h1>

Nesta secção, vamos analisar as principais estruturas de dados utilizadas no script, que são fundamentais para o armazenamento e manipulação de informações durante o processo de backup. Veremos como arrays, variáveis inteiras e strings são usados para controlar a execução e otimizar a organização dos dados.

**Arrays**
Os **arrays** são usados para armazenar listas de itens, como os arquivos a excluir ou os argumentos passados para o script.
<h6>Uso:</h6>
<div class="code-block">
  <span class="array">exclude_list=()</span>  # <span class="comment">Array para armazenar arquivos a serem excluídos</span>
  <span class="array">args=($@)</span>        # <span class="comment">Array que contém os parâmetros passados para o script</span>
  <span class="array">lst=(${args[@]::${#args[@]}-1})</span>  # <span class="comment">Array contendo todos os elementos de args, exceto o último</span>
</div>

**Strings**
No Bash são tratadas como arrays de caracteres e são usadas para armazenar sequências de texto. Foram usadas para armazenar dados como *paths* e *regex*.
<h6>Uso:</h6>
<div class="code-block">
  <span class="variable">source_dir=""</span>  # <span class="comment">Caminho do diretório de origem</span><br>
  <span class="variable">backup_dir=""</span>  # <span class="comment">Caminho do diretório de backup</span><br>
  <span class="variable">regx=".*"</span>  # <span class="comment">Expressão regular para filtrar arquivos</span><br>
  <span class="variable">exclude_file=""</span>  # <span class="comment">Arquivo contendo os arquivos a excluir</span>
</div>



<div class="page-break"></div>
<h1>Como dividimos o problema (funções)</h1>

<spam>O problema foi dividido de forma a torná-lo mais modular, visando a reutilização do código e facilitando a manutenção e a compreensão. Cada função desempenha um papel fundamental na execução do processo de backup. A seguir, iremos analisar as funções utilizadas e sua contribuição para a solução.</spam>

<h6>findElement()</h6>  

<spam>Esta função recebe 2 argumentos, um array e um valor a se procurar.</spam> 
<div class="code-block">
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

<spam>Esta função recebe 2 caminhos para ficheiros e compara a última data de modificação. usando o comando "<b>-nt</b>".</spam> 

<div class="code-block">
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

<spam>Esta função recebe um ficheiro ,um diretório para onde realizar a cópia e um valor <i><b>copy</b></i> que indica se a cópia deve ser realizada.</spam>
<div class="code-block">
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

<spam>Exibe a mensagem de uso do script.</spam>
<div class="code-block">
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

<spam>Exibe mensagem de erro se o diretório ou arquivo não for encontrado.</spam>
<div class="code-block">
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

<spam>Exibe estatísticas do backup. É só usado no backup_summary.sh.</spam>
<div class="code-block">
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

<div class="page-break"></div>
<h1>Ficheiros Principais</h1>

Todos os scripts têm 2 argumentos obrigatórios, sendo o primeiro deles a diretoria que vai ser copiada e o segundo a diretoria para onde a cópia deverá ir.

<h3>backup_files.sh</h3>
O objetivo do código é realizar um backup de arquivos de um diretório de origem para um diretório de backup, podendo incluir a opção de verificar se os arquivos precisam ser copiados (modo de verificação) ou realmente realizar a cópia. Também garante que arquivos no diretório de backup que não existam mais no diretório de origem sejam removidos.
Para além dos parametros obrigatórios o script tem um parametro opcional:
-c, com este parametro o script não irá efetuar a cópia dos ficheiros, apenas escrevendo no terminal as operações que faria, mas sem as executar

<b>Etapas:</b>

- Importar funções
<div class = "code-block">
<pre>
function_call="$0" <span class = "comment"># Usa-se o function_call para determinar o caminho de acesso às funções</span>
SCRIPT_DIR="$(dirname "$(realpath "$function_call")")"
DIR="$SCRIPT_DIR/functionsReal"
for file in "$DIR"/*; do
    if [[ -f "$file" ]]; then
        source "$file"
    fi
done
</pre>
</div>

- Declaração de variáveis
<div class ="code-block">
<pre>
checking=""
source_dir=""
backup_dir=""
</pre>
</div>

- Ler as opções do usuário e processar as diferentes possiblidades.
<div class ="code-block">
<pre>
while getopts ":c:" op; do
    case $op in
	...
	esac
done
</pre>
</div>

- Validar os diretórios ( e lidar com o possível erro do <b>realpath</b> )
<div class ="code-block">
<pre>
source_dir=$(realpath "$1")
if [ $? -ne 0 ]; then
    echo "Can't resolve source directory path"
    exit 1
fi
backup_dir=$(realpath "$2")
if [ $? -ne 0 ]; then
    ...
fi
if [[ "$backup_dir" == "$source_dir"* ]]; then
  echo "[ERROR] $backup_dir is inside $source_dir"
  exit 1
fi
</pre>
</div>

- Criar o diretório backup caso necessário
<div class ="code-block">
<pre>
Se backup_dir não existe então
	criar backup_dir
fim se
</pre>
</div>

- Copiar cada ficheiro
<div class ="code-block">
<pre>
Para cada elemento de source_dir
	se é um ficheiro
		chamar <b>copy_file( elemento, backup_dir )</b>
	fim se
fim para
</pre>
</div>

- Remover elementos do backup_dir que não fazem parte do source_dir
<div class ="code-block">
<pre>
Para cada elemento de backup_dir
	se elemento não existe no source_dir
		<b>remover</b> elemento
	fim se
fim para
</pre>
</div>

<b>Testes</b>
<small>Teste de cópia básica(foram copiados ficheiros para uma pasta vazia)</small>
![[testeBasicoBackupFiles 1.png]]

<small>Teste pastas com espaços</small>
![[testeBasicoBackupFilesComEspaco 1.png]]

<small>Teste cópia com todos os ficheiros já colocados na pasta destino e com a mesma data de alteração</small>
![[testeBackupFilesTodosFicheirosIguais 1.png]]

<small>Teste cópia em que existem ficheiros na pasta de destino que não existem na pasta que irá ser copiada</small>
![[testeBackupFilesRemoveFiles 1.png]]

<small>Teste cópia em que existem um ficheiro com data de alteração mais recente na pasta destino do que na pasta que vai ser copiada</small>

![[newerFileInBackup 1.png]]

<small>Teste do parametro -c</small>
![[teste-c.png]]

<small>Teste em que ambas as pastas têm os mesmos ficheiros, mas a pasta que vai ser copiada tem um arquivo que foi alterado</small>
![[ficheiroMaisNovoNaSrc.png]]

<div class="page-break"></div>
<h3>backup.sh</h3> O objetivo deste script é realizar um backup de arquivos e sub-diretórios de um diretório de origem para um diretório de backup, com opções de verificação, exclusão de arquivos, filtro por expressão regular. 
 -c, com este parametro o script não irá efetuar a cópia dos ficheiros, apenas escrevendo no terminal as operações que faria, mas sem as executar

-b [file], com este parametro o script irá ignorar os ficheiros cujo nome estão no ficheiro file

-r [regex_expression], com este parametro o script irá ignorar os ficheiros cujo nome se inclui na expressão regex [regex-expression]

<b>A seguir só as etapas que diferem do backup_files.sh:</b>
- Inicializar variáveis
<div class ="code-block">
<pre>
...
filter=""
is_recursive=0
regx=".*" 
hasExclude=0
...
</pre>
</div>
- Leitura de Opções/Flags 
<div class="code-block"> 
<pre> 
<span class="comment" ># a option <b>z</b> recursividade e não deve ser usada pelo usuário</span>
while getopts ":czb:r:" op; do 
	 case $op in # Processar as opções 
	...
esac 
done 
</pre> 
</div>

- Carregar Arquivo de Exclusões
<div class="code-block"> 
<pre> 
if [ -f "$exclude_file" ]; then 
	mapfile -t exclude_list  "$exclude_file" 
else exclude_list=()
fi 
</pre>
</div>

- Iniciar o backup dos arquivos
<div class="code-block"> 
<pre> 
<b>Para</b> cada item no diretório de origem: 
	Obter o nome base do item (sem o caminho) 
	Se o item corresponder à expressão regular fornecida: 
		Se o item for um arquivo e não estiver na lista de exclusões: 
			Se o modo de verificação estiver ativado: 
				Realizar a verificação (sem copiar o arquivo) 
			Caso contrário: 
				 Copiar o arquivo para o diretório de backup 
			Se o item for um diretório e o backup for recursivo: 
				Realizar o backup recursivo para o diretório 
Fim para
</pre>
</div>

<b>Testes</b>
<u>Backup.sh</u>

<small>Teste parametro -b</small>

![[parametroB.png]]

<small>Teste parametro -r</small>

![[parametror 1.png]]

<small>Teste com 2 parametros ao mesmo tempo</small>
![[2ParametrosAomesmoTempo.png]]

<small> Teste com pasta que existe na pasta destino mas que não existe na pasta que vai ser copiada</small>
![[rmdir.png]]

<small>Teste com pasta que  existe na pasta que vai ser copiada mas não existe na pasta destino</small>
![[criarPasta.png]]

<small>Teste com pastas escondidas</small>
![[testeFicheirosEscondidos.png]]

<small>Todos os testes que foram feitos para o backup_files.sh também foram feitos para este script com algumas adaptações(assumindo já a existência de pastas e de ficheiros lá dentro incluindo pastas com espaços)</small>

<div class="page-break"></div>
<h3>backup_summary.sh</h3>
O objetivo deste script é realizar o backup de arquivos e subdiretórios de um diretório de origem para um diretório de backup, com opções de verificação, exclusão de arquivos, e a contagem e exibição de estatísticas detalhadas sobre o processo de backup.
 -c, com este parametro o script não irá efetuar a cópia dos ficheiros, apenas escrevendo no terminal as operações que faria, mas sem as executar

-b [file], com este parametro o script irá ignorar os ficheiros cujo nome estão no ficheiro file

-r [regex_expression], com este parametro o script irá ignorar os ficheiros cujo nome se inclui na expressão regex [regex-expression]

<b>A seguir só as etapas que diferem do backup.sh:</b>
- Inicialização de variáveis
<div class ="code-block">
<pre>
...
<span class = "comment"># Contadores de status </span>
cError=0 
cWarnings=0 
cUpdated=0 
cCopied=0 
cDeleted=0
<span class="comment"># Tamanho dos arquivos copiados e excluídos</span> 
sizeCopied=0 
sizeDeleted=0
...
</pre>
</div>

- Exibir estatisticas finais
<div class="code-block"> 
<pre> 
<span class = "comment"># Exibir estatísticas detalhadas sobre o backup </span>
se modo recursivo: 
	exibir erro, aviso, arquivos copiados, excluídos, etc. 
senão: 
	exibir resumo final com o total de erros, avisos, arquivos copiados, deletados fim
</pre> 
</div>

- Neste código, após cada <b>cp</b> e <b>rm</b> as variáveis de contagem e tamanho são alterados

<div class="code-block"> 
<pre> 
...
cp -a "$file" "$destination"
if [[ $? -ne 0 ]]; then
	<b>((cError++))</b>
	return 1
else
	file_size=$(stat -c %s "$file")
	<b>((cCopied++))</b>
	sizeCopied=$((sizeCopied + file_size))
	return 0
fi
...
if [ -d "$file" ]; then
	num_files=$(find "$file" -type f | wc -l)
	dir_size=$(du -sb "$file" | cut -f1)
	<b>((cDeleted += num_files))</b>
    <b>((sizeDeleted += dir_size))</b>
else
    file_size=$(stat --format=%s "$file")
    <b>((sizeDeleted += file_size))</b>
    <b>((cDeleted++))</b>
fi
if [ -z "$checking" ];then
	rm -r "$file"
fi
...
</pre> 
</div>

- Após as chamadas as variáveis são atualizadas
<div class = "code-block">
<pre>
...
<span class = "comment" ># res é o output de parametros da chamada recursiva</span>
cError=$((cError + res[0]))
cWarnings=$((cWarnings + res[1]))
cUpdated=$((cUpdated + res[2]))
cCopied=$((cCopied + res[3]))
sizeCopied=$((sizeCopied + res[4]))
cDeleted=$((cDeleted + res[5]))
sizeDeleted=$((sizeDeleted + res[6]))
...
</pre>
</div>

<div class="page-break"></div>

<b>Testes</b>
<small>Foram utilizados os mesmos testes que os do backup.sh devido à similaridade do código, acrescentando-se apenas alguns testes</small>

<small>Foi usado um teste em que a pasta destino tem 2 arquivos que não estão na pasta que vai ser copiada(um na raiz e outro em uma subpasta) e em que 1 arquivo na pasta destino é mais novo do que um da pasta que vai ser copiada.
O resto dos arquivos será igual</small>

![[testeBackupSummary.png]]

<small>Foi usado uma pasta em que uma subpasta e um ficheiro têm espaços no nome para testar como o programa trata estes ficheiros</small>
![[testeBackup_SummaryEspacos.png]]

<small>Foram usadas duas pastas com os mesmos ficheiros</small>
![[testeBackupSummaryPastasIguais.png]]

<div class="page-break"></div>
<h3>Backup_check.sh</h3>
O objetivo deste script é confirmar que os ficheiros que se encontram tanto na pasta destino tanto na pasta que irá ser copiada são iguais.

<h3>Etapas</h3>

- Validar inputs do script
<div class = "code-block">
<pre>
     if [[ $# != 2 ]]; then
        echo "Script has to receive 2 arguments"
        return 1
    fi

    if [[ ! -d $1 && -d $2 ]]; then
        echo "Arguments have to be directories"
        return 1
    fi

</pre>
</div>

- Retirar a "/" (caso exista) do fim do path da diretoria (para normalizar o comportamento do código caso o input seja com ou sem a "/" no fim)
<div class = "code-block">
<pre>
  work_dir=$1
   backup_dir=$2

    # removes last bar(/) from backup_dir path (for formatting reasons)
    if [[ $work_dir == */ ]]; then
        work_dir="${work_dir:0:-1}" 
    fi

    if [[ $backup_dir == */ ]]; then
        backup_dir="${backup_dir:0:-1}"
    fi
</pre>
</div>

- Iterar pelos ficheiros e ver se são diferentes

<div class = "code-block">
<pre>
se backup_dir existe e não está vazio, entao
	para cada ficheiro em backup_dir
		se ficheiro é um diretorio
			chamar funcao para com argumentos , "work_dir/nome do ficheiro"  e ficheiro
		senao
			se ficheiro é um ficheiro normal
				se md5sum(ficheiro) != md5sum(work_dir/nome de ficheiro)
					print("os ficheiros sao diferentes")
</pre>
</div>

<h3>Testes</h3>
<small>Foi usada uma pasta com todos os ficheiros iguais menos 2, um na raiz e outro em uma subpasta</small>

![[testeBackupCheck.png]]

<small>Foram usadas subpastas com espaços e um ficheiro diferentes também ele com espaços para testar o comportamento do programa quer com subpastas quer com nomes que tenham espaços</small>
<bdiv class="page-break"></b>
![[backup_checkMonstro.png]]
<div class="page-break"></div>
<h1>Como resolvemos certos problemas</h1>

Durante o desenvolvimento, surgiram alguns desafios que puderam ser superados através de pesquisas.

<h6>Backup de ficheiros escondidos (.file)</h6>

O bash por padrão só inclui no <i>globbing</i> os arquivos que não começam com ponto, logo os ficheiros escondidos não são normalmente incluidos em comandos como <i>ls</i>,... . Este desafio foi resolvido com uma simples linha de comando.

<div class="code-block">
<pre>
shopt -s dotglob <span class="comment"># Faz com que os ficheiros começados com '<b>.</b>' sejam incluídos no globbing </span>
</pre>
</div>


<h6>Verificar se o diretório destino estava dentro da source</h6>

Verificar se o diretório de destivo estava dentro da source é um passo importante para o <b>backup.sh</b> e <b>backup_summary.sh</b> visto que estes 2 utilizam recursividade para iterar sobre todos os diretórios da pasta source e caso o diretório destino estivesse dentro da source aconteceria um loop infinito.
A função <b>realpath</b> do bash foi de grande ajuda para a solução que encontramos.

<div class = "code-block">
<pre>
<b>source_dir</b> = argumento 1 (diretório de origem)
<b>backup_dir</b> = argumento 2 (diretório de backup)
.
Se <b>source_dir</b> não for um caminho válido:
	Exibir : "Não foi possível resolver o caminho do diretório de origem"
	Finalizar o processo
Se <b>backup_dir</b> não for um caminho válido:
	Exibir "Não foi possível resolver o caminho do diretório de backup"
	Finalizar o processo
Se <b>backup_dir</b> é um subdiretório de <b>source_dir</b>:
	Exibir: "[ERRO] backup_dir está dentro de source_dir"
	Finalizar o processo
</pre>
</div>

<b>[NOTA]</b> no backup_summary.sh o "Finalizar o processo" é feito atravez da função <b>end_print()</b>.

<h6>Usar <i>realpath</i> para chamadas recursivas</h6>

A solução que encontramos para este ponto foi justamente <b>não</b> usar o realpath em todas as chamadas recursivas. De facto pela forma como o código está estruturado o realpath só precisa ser utilizado na primeira chamada. Para controlar em qual chamada é que estavamos foi fácil, só foi preciso adicionar uma nova <b>flag ( opção )</b> no getopts que  assinala se uma chamada é recursiva ou não.

<h6>Display dos passos efetuados na chamada recursiva</h6>

Ao fazer a chamada recursiva nós guardamos todos os outputs numa variável para termos um melhor controlo sobre os displays.

<div class = "code-block">
...
output = "output da chamada recursiva"
...
</div>

Depois escolhemos quais linhas do output é que queriamos dar display (<b>echo</b>)

<div class = "code-block">
...
output = "output da chamada recursiva"
echo $output" | grep -E '^(cp|mkdir|rm|While)' <span class = "comment"># display só às informações importantes</span>
...
</div>

<h6>Summary das alterações no backup_summary.sh</h6>

A diferença entre o backup.sh e o backup_summary.sh é a disponibilização de informação à cerca das alterações realizadas pelo script. Para superar esta etapa a solução que encontramos foi de usar uma versão diferente das funções que são usadas no backup.sh.

Então no ficheiro backup_summary.sh contêm uma copia definição de todas as funções no próprio ficheiro. Essas cópias contam com alterações para que a contagem possa ser feita.
Alterações do ficheiro:

Variáveis para contagem (<i><b>counters</i></b>)

<div class = "code-block">
<pre>
# contadores de ocorrências
cError=0
cWarnings=0
cUpdated=0
cCopied=0
cDeleted=0
# contadores de tamanho
sizeCopied=0
sizeDeleted=0
</pre>
</div>

<h7>Manter a contagem através de chamadas recursivas</h7>

<div class = "code-block">
<pre>
output= "Saídas da chamada Recursiva"
...
res= "última linha do output da recursiva" <span class="comment"># A última linha do output corresponde ao <b>end_print()</b> do dirétorio filho</span>
# Adicionar à contagem atual a contagem dos seus subdiretórios 
cError += res->cErros 
cWarnings += res->cWarnings
cUpdated  += res->cUpdated
cCopied += res->cCopied
sizeCopied += res->sizeCopied
cDeleted += res->cDeleted
sizeDeleted += res->sizeDeleted
</pre>
</div>

<b>[NOTA]</b> os contadores foram colocados a seguir a todas as funções <b><i>rm</i></b>, <b><i>cp</i></b>.


<div class="page-break"></div>
<h1>Bibliografia</h1>


- Stack Overflow. (n.d.). _Stack Overflow: Where developers learn, share, & build careers_. Recuperado de [https://stackoverflow.com/](https://stackoverflow.com/)
- GNU Project. (n.d.). _Bash manual_. Recuperado de (https://www.gnu.org/software/bash/manual/bash.html)
- Linux Die. (n.d.). _Bash man page_. Recuperado de https://linux.die.net/man/1/bash


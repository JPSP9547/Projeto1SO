<h5>backup_files.sh</h5>
O objetivo do código é realizar um backup de arquivos de um diretório de origem para um diretório de backup, podendo incluir a opção de verificar se os arquivos precisam ser copiados (modo de verificação) ou realmente realizar a cópia. Também garante que arquivos no diretório de backup que não existam mais no diretório de origem sejam removidos.

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


<h5>backup.sh</h5> O objetivo deste script é realizar um backup de arquivos e sub-diretórios de um diretório de origem para um diretório de backup, com opções de verificação, exclusão de arquivos, filtro por expressão regular. 

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


<h5>backup_summary.sh</h5>
O objetivo deste script é realizar o backup de arquivos e subdiretórios de um diretório de origem para um diretório de backup, com opções de verificação, exclusão de arquivos, e a contagem e exibição de estatísticas detalhadas sobre o processo de backup.

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

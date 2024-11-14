
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

<h7>Variáveis para contagem (<i><b>counters</i></b>)</h7>

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

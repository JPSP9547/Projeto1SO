[[Relatório so]]

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


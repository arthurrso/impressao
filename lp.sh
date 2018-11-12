#!/bin/bash

#crontab -e
#0 0 1 * * /lp.sh

#recebe o arquivo por parametro
arquivo_a_ser_impresso=$1
#recupera usuario
user=`who | awk {'print$1'}`

printf "Usuario acessando o sistema = $user\n"

qtd_linhas=`wc -l $arquivo_a_ser_impresso | awk '{print $1}'`
qtd_carac=`wc -c $arquivo_a_ser_impresso | awk '{print $1}'`

printf "Linhas = $qtd_linhas\nCaracteres = $qtd_carac\n"

#aqui faz a soma para garantir que o arquivo que tem apenas 1 caracter ou 1 linha ja tem uma pagina
pag_linhas=`echo "1+($qtd_linhas/60)" | bc`
pag_carac=`echo "1+($qtd_carac/3600)" | bc`

printf "Pag_linhas = $pag_linhas\n"
printf "Pag_carac = $pag_carac\n"

#faz a conta para saber se calcula o numero de paginas atraves de linhas ou caracteres (o que for maior)
if [ $pag_linhas -gt $pag_carac ] 
then	
	printf "O arquivo possui $pag_linhas paginas \n"
	pag_total=$pag_linhas
else
	printf "O arquivo possui $pag_carac paginas \n"
	pag_total=$pag_carac
fi

#$(date +%d) - recupera o mes atual

#recupera as informacoes do usuario corrente no arquivo
relatorio_usr=`cat relatorio.txt | grep $user`

#verifica se o grep encontrou alguma coisa. Se encontrou o usuario ja imprimiu. Se nao, eh a primeira impressao
if [[ ! -z $relatorio_usr ]]
then	
	#acessa os dados do usuario no arquivo
	printf "O usuario existe \n"
	info_usr=`echo $relatorio_usr | tr ";" " "`
	usr_name=`echo $info_usr | awk '{print$1}'`
	usr_prints=`echo $info_usr | awk '{print$2}'`
	usr_page_prints=`echo $info_usr | awk '{print$3}'`
	usr_balance=`echo $info_usr | awk '{print$4}'`
	#mostra as informacoes na tela dos dados atuais (inutil, serve apenas para acompanhar)
	printf "$info_usr\n$usr_name\n$usr_prints\n$usr_page_prints\n$usr_balance\n"
	usr_prints=`echo '1+'$usr_prints | bc`
	usr_page_prints=`echo $pag_total '+' $usr_page_prints | bc`
	usr_balance=`echo $usr_balance '-' $pag_total | bc`
	#mostra na tela as informacoes do usuario depois da impressao (inutil, serve apenas para acompanhar)
	printf "Novo = $usr_prints\n"
	printf "Novo = $usr_page_prints\n"
	printf "Novo = $usr_balance\n"
	#gera uma variavel com o novo relatorio depois da impressao para atualizar no arquivo
	new_report=`echo $user';'$usr_prints';'$usr_page_prints';'$usr_balance`

	#grava no arquivo as novas informacoes do usuario
	grep -v "$user" relatorio.txt >> relatorio.txt.2
	rm -fr relatorio.txt
	mv relatorio.txt.2 relatorio.txt
	`echo $new_report >> relatorio.txt`
	`echo cat relatorio.txt`
else
	#cria o usuario com os dados de sua primeira impressao
	printf "vou criar o usuario\n"
	new_balance=`echo '30-'$pag_total | bc`
	`echo $user';1;'$pag_total';'$new_balance >> relatorio.txt`
fi
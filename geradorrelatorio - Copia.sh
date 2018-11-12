#!/bin/bash

arquivo=$1

printf "\nGerando relatorio sobre dados dos usuarios no arquivo $arquivo \n\n"

printf "====================================================== \n"


conteudo=`cat $arquivo | tr ";" "\n"`

printf "usuario 	N_IMP	PAG_IMP SALDO\n"

for output in `cat $arquivo`
	do
		echo $output | tr ";" "	"
	done
printf "====================================================== \n"

printf "LEGENDA: \nN_IMP = numero de impressoes \nPAG_IMP = numero de paginas impressas\nSALDO = saldo de paginas no mes que o usuario pode imprimir\n"


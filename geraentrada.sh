#24 16 * * * bash /home/danilotc/Documentos/ADM-SYSTEM/Impressao/geraentrada.sh

who | awk '{print $1 ";0;0;30"}' | sort | uniq -u >> entrada.txt

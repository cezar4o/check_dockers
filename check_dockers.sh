# Author     : Fedya Serafiev
# Version    : 1.0
# License    : MIT
# Copyright  : Fedya Serafiev (2023)
# Github     : https://github.com/cezar4o/check_dockers
# Contact    : https://urocibg.eu/

#!/bin/bash
TOKEN=""
chat_id=""
FILE=proverka-konteineri
_dockerlist=$(docker ps -a --format "table {{.Names}}" | tail -n +2)
_zapylnene=""
#for i in $_dockerlist; do docker container inspect -f '{{.State.Status}}' $i; done
for z in $_dockerlist; do
	eee=$(docker container inspect -f '{{.State.Status}}' $z)
	if [[ "$eee" != "running" ]]; then
		if [[ $z == *_* ]]; then
			z=${z//_/-}
		fi
		_zapylnene+="$z"
		_zapylnene+=" "
	fi
done	
if [[ -n $_zapylnene ]]; then
        echo 0 > ${FILE}
else
        echo 1 > ${FILE}
fi
down=`grep -ic "1" ${FILE}`
if [ $down -eq 1 ]; then
  if [ -f ${FILE}.txt ]; then
    textt="🟢 *Супер! Всички контейнери работят!*%0A%0A"
    curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" -d chat_id=${chat_id} -d text="${textt}" -d parse_mode=Markdown
    rm -rf ${FILE}.txt
  fi
else
  if [ -f ${FILE}.txt ]; then
   echo "$tt" >> ${FILE}.txt
  else
    textt="🔴 *Спряли контейнери:*%0A%0A"
    textt+=$(echo $_zapylnene | tr ' ' '\n')
    curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" -d chat_id=${chat_id} -d text="${textt}" -d parse_mode=Markdown
    echo "$tt" > ${FILE}.txt
  fi
fi

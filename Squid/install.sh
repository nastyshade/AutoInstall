#!/bin/bash

source "../global.sh"

echo
echo -e "${ROUGE}. . : : [ S Q U I D ] : : . .${NEUTRE}"
echo ""

echo "# Installation des librairies requises" > ${RAPPORT} 2>&1
start_spinner "# Installation des librairies requises"
apt-get update >> ${RAPPORT} 2>&1
apt-get install squid3 -y --force-yes >> ${RAPPORT} 2>&1
stop_spinner $?

echo "# Configuration de Squid" > ${RAPPORT} 2>&1
start_spinner "# Configuration de Squid"
cd /etc/squid3 >> ${RAPPORT} 2>&1
touch /etc/squid3/censure.txt >> ${RAPPORT} 2>&1
cp squid.conf squid.conf.bak >> ${RAPPORT} 2>&1
cat squid.conf.bak | egrep -v -e '^[[:blank:]]*#|^$' > squid.conf >> ${RAPPORT} 2>&1
sed -i "1iacl localnet src ${PLAGE_IP}" squid.conf >> ${RAPPORT} 2>&1
sed -i "/acl CONNECT method CONNECT/ a\acl censure url_regex -i \"/etc/squid3/censure.txt\"" squid.conf >> ${RAPPORT} 2>&1
sed -i "/http_access deny manager/ a\http_access deny censure" squid.conf >> ${RAPPORT} 2>&1
echo "visible_hostname $(hostname)" >> squid.conf >> ${RAPPORT} 2>&1
echo "cache_mgr ${MAIL}" >> squid.conf >> ${RAPPORT} 2>&1
stop_spinner $?

echo "# Redemarrage du service Squid" > ${RAPPORT} 2>&1
start_spinner "# Redemarrage du service Squid"
restart squid3 >> ${RAPPORT} 2>&1
stop_spinner $?

echo ""
echo -e "${JAUNE}Installation du service Squid finie"
echo -e "Log de l'installation: ${RAPPORT}"
echo -e ""
echo -e "Appuyer sur Entrée pour quitter${NEUTRE}"
read a

clear
exit 0

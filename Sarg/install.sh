#!/bin/bash

source "../global.sh"

echo
echo -e "${ROUGE}. . : : [ S A R G ] : : . .${NEUTRE}"
echo ""

echo "# Installation des librairies requises" > ${RAPPORT} 2>&1
start_spinner "# Installation des librairies requises"
apt-get update >> ${RAPPORT} 2>&1
apt-get install sarg -y --force-yes >> ${RAPPORT} 2>&1
stop_spinner $?

echo "# Configuration de Sarg" > ${RAPPORT} 2>&1
start_spinner "# Configuration de Sarg"
mkdir ${SARG_WWW} >> ${RAPPORT} 2>&1
cp /etc/sarg/sarg.conf /etc/sarg/sarg.conf.bak >> ${RAPPORT} 2>&1
cp /etc/sarg/sarg-reports.conf /etc/sarg/sarg-reports.conf.bak >> ${RAPPORT} 2>&1
sed -i 's/access_log \/var\/log\/squid\/access.log/access_log\/var\/log\/squid3\/access.log/' /etc/sarg/sarg.conf >>${RAPPORT} 2>&1
sed -i 's/#graphs yes/graphs yes/' /etc/sarg/sarg.conf >> ${RAPPORT} 2>&1
sed -i 's/#graph_days_bytes_bar_color orange/graph_days_bytes_bar_color orange/' /etc/sarg/sarg.conf >> ${RAPPORT} 2$
sed -i 's/charset Latin1/charset UTF-8/' /etc/sarg/sarg.conf >> ${RAPPORT} 2>&1
sed -i "s/HTMLOUT=\/var\/lib\/sarg/HTMLOUT=${SARG_WWW//\//\\/}/" /etc/sarg/sarg-reports.conf >> ${RAPPORT} 2>&1
stop_spinner $?

echo "# Ajout des cron jobs" > ${RAPPORT} 2>&1
start_spinner "# Ajout des cron jobs"
echo "00 08-18/1 * * * root sarg-reports today" >> /etc/crontab
echo "00 00 * * * root sarg-reports daily" >> /etc/crontab
echo "00 01 * * 1 root sarg-reports weekly" >> /etc/crontab
echo "30 02 1 * * root sarg-reports monthly" >> /etc/crontab
stop_spinner $?

echo ""
echo -e "${JAUNE}Installation du service Sarg finie"
echo -e "Log de l'installation: ${RAPPORT}"
echo -e ""
echo -e "Appuyer sur Entrée pour quitter${NEUTRE}"
read a

clear
exit 0

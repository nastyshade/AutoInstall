#!/bin/bash

source "../spinner.sh"

NEUTRE="\033[0;0m"
ROUGE="\033[31;1m"
JAUNE="\033[33;1m"
RAPPORT="/var/log/AutoInstall/unbound.log"

mkdir -p /var/log/AutoInstall/
touch ${RAPPORT}
clear

echo
echo -e "${ROUGE}. . : : [ U N B O U N D ] : : . .${NEUTRE}"
echo ""

echo "# Installation des librairies requises" > ${RAPPORT} 2>&1
start_spinner "# Installation des librairies requises"
apt-get install build-essential libssl-dev -y --force-yes >> ${RAPPORT} 2>&1
stop_spinner $?

echo "# Telechargement du packet Unbound DNS" >> ${RAPPORT} 2>&1
start_spinner "# Telechargement du packet Unbound DNS"
wget -q http://www.unbound.net/downloads/unbound-latest.tar.gz >> ${RAPPORT} 2>&1
stop_spinner $?

echo "# Compilation" >> ${RAPPORT} 2>&1
start_spinner "# Compilation"
mkdir dwl >> ${RAPPORT} 2>&1
tar xfz unbound-latest.tar.gz -C dwl >> ${RAPPORT} 2>&1
cd dwl >> ${RAPPORT} 2>&1
cd $(ls) >> ${RAPPORT} 2>&1
./configure -q >> ${RAPPORT} 2>&1
make -s >> ${RAPPORT} 2>&1
make install -s >> ${RAPPORT} 2>&1
cd ../../ >> ${RAPPORT} 2>&1
stop_spinner $?

echo "# Creation du groupe / utilisateur unbound" >> ${RAPPORT} 2>&1
start_spinner "# Creation du groupe / utilisateur unbound"
groupadd unbound >> ${RAPPORT} 2>&1
useradd -d /var/unbound -m -g unbound -s /bin/false unbound >> ${RAPPORT} 2>&1
stop_spinner $?

echo "# Creation du PID" >> ${RAPPORT} 2>&1
start_spinner "# Creation du PID"
mkdir -p /var/unbound/var/run >> ${RAPPORT} 2>&1
chown -R unbound:unbound /var/unbound >> ${RAPPORT} 2>&1
ln -s /var/unbound/var/run/unbound.pid /var/run/unbound.pid >> ${RAPPORT} 2>&1
stop_spinner $?

echo "# Creation du script stop / start pour unbound" >> ${RAPPORT} 2>&1
start_spinner "# Creation du script stop / start pour unbound"
cp init-d-unbound "/etc/init.d/unbound" >> ${RAPPORT} 2>&1
chmod 755 /etc/init.d/unbound >> ${RAPPORT} 2>&1
update-rc.d unbound defaults >> ${RAPPORT} 2>&1
stop_spinner $?

echo "# Creation de la configuration unbound" >> ${RAPPORT} 2>&1
start_spinner "# Creation de la configuration unbound"
cp unbound.conf "/var/unbound/unbound.conf" >> ${RAPPORT} 2>&1
stop_spinner $?

echo "# Telechargement des serveurs racines" >> ${RAPPORT} 2>&1
start_spinner "# Telechargement des serveurs racines"
wget -q ftp://ftp.internic.net/domain/named.cache -O /var/unbound/named.cache >> ${RAPPORT} 2>&1
stop_spinner $?

echo "# Lancement du service Unbound" >> ${RAPPORT} 2>&1
start_spinner "# Lancement du service Unbound"
/etc/init.d/unbound start >> ${RAPPORT} 2>&1
stop_spinner $?

echo ""
echo -e "${JAUNE}Installation du service Unbound finie"
echo -e "Log de l'installation: /var/log/AutoInstall/unbound.log"
echo -e ""
echo -e "Appuyer sur Entrée pour quitter${NEUTRE}"
read a

clear
exit 0

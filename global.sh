source "../spinner.sh"

NEUTRE="\033[0;0m"
ROUGE="\033[31;1m"
JAUNE="\033[33;1m"
RAPPORT="/var/log/AutoInstall.log"

touch ${RAPPORT}
clear

# SQUID
PLAGE_IP="192.168.0.0/24"
MAIL="login@provider.com"

# SARG
SARG_WWW="/var/www/html/sarg"


#newlineprompt variable
nl=`echo $'\n\e[0;30m'`
nlp=`echo $'\n>\e[0;30m'`
#color variable
cecho=`echo -e $'\e[1;31m'`


read -p "Do you want to download Mariadb via yum ?, $nl 1. Enter Y to download it with th default link, $nl 2. Enter the new Link to download it via another link, $nl 3. Enter N to skip it $nlp" -r

if [[ $REPLY =~ ^[Yy]$ ]]; then
 
 sudo  yum -y install mariadb-server mariadb
 sudo systemctl start mariadb 
 firewall-cmd --permanent --zone=public --add-port=3306/tcp
 firewall-cmd  --reload
 echo "Please add new user to mysql tzy20Si3$"
 mysql -u root
else 

 echo "Skipping mysql download"

fi

#!/bin/bash


#newlineprompt variable
nl=`echo $'\n\e[0;30m'`
nlp=`echo $'\n>\e[0;30m'`
#color variable
cecho=`echo -e $'\e[1;31m'`

if [[ $(whoami) != "root" ]]; then
 echo "Need to be root"
exit 1
fi

read -p "$cecho Do you wish to set proxy for installation? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]] && [[ -f proxyset.sh ]]; then
	sudo chmod a+x proxyset.sh
	./proxyset.sh
	sudo chmod 777 proxyset.sh
elif [[ ! -f nexusinstall.sh ]]; then
 	echo "File proxyset.sh not found"

else 
	echo "Skipping...."
fi 

read -p "$cecho Do you wish to Install Nexus maven proxy repository? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]] && [[ -f nexusinstall.sh ]]; then
	
	sudo chmod a+x nexusinstall.sh
	./nexusinstall.sh
	sudo chmod 777 nexusinstall.sh

elif [[ ! -f nexusinstall.sh ]]; then
 	echo "File nexusinstall.sh not found"

else 
	echo "Skipping...."
fi


read -p "$cecho Do you wish to Install JBOSS AS 7 Application server? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]] && [[ -f jbossinstall.sh ]]; then
	
	sudo chmod a+x jbossinstall.sh
	./jbossinstall.sh
	sudo chmod 777 jbossinstall.sh

elif [[ ! -f jbossinstall.sh ]]; then

 	echo "File jbossinstall.sh not found"

else 
	echo "Skipping...."
fi


read -p "$cecho Do you wish to Install tomcat Application server? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	
	sudo yum install tomcat 

else 
	echo "Skipping...."
fi



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
	sudo chmod 644 proxyset.sh
elif [[ ! -f proxyset.sh ]]; then
 	echo "File proxyset.sh not found"

else 
	echo "Skipping...."
fi 

read -p "$cecho Do you wish to Install Nexus maven proxy repository? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]] && [[ -f nexusinstall.sh ]]; then
	
	sudo chmod a+x nexusinstall.sh
	./nexusinstall.sh
	sudo chmod 644 nexusinstall.sh

elif [[ ! -f nexusinstall.sh ]]; then
 	echo "File nexusinstall.sh not found"

else 
	echo "Skipping...."
fi


read -p "$cecho Do you wish to Install JBOSS AS 7 Application server? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]] && [[ -f jbossinstall.sh ]]; then
	
	sudo chmod a+x jbossinstall.sh
	./jbossinstall.sh
	sudo chmod 644 jbossinstall.sh

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


read -p "$cecho Do you wish to Install Jenkins CI server? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	
	wget http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
        sudo mv jenkins.repo /etc/yum.repos.d/jenkins.repo
	sudo yum install tomcat 

else 
	echo "Skipping...."
fi


read -p "$cecho Do you wish to Install utilities such as ssh and telnet? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	
	sudo yum install net-tools telnet openssh-server openssh-client 
	sudo chkconfig sshd on
	sudo service sshd start
        sudo firewall-cmd --zone=public --add-port=22/tcp --permanent 
	sudo firewall-cmd --reload
	test "$(read -p 'Please enter Y to edit ssh config(PermitRootLogin no, AllowUsers usera userb , N to skip:  ' -r ; echo $REPLY)" == "Y" && (sudo nano /etc/ssh/sshd_config) || (echo "ssh config not set...")
	sudo service sshd restart


else oo

	echo "Skipping...."
fi

sudo groupadd appservers
sudo groupadd databaseservers

read -p "$cecho Do you wish to Install mysql database server? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]] && [[ -f mysqlinstall.sh ]]; then
	
	sudo chmod a+x mysqlinstall.sh
	./mysqlinstall.sh
	sudo chmod 644 mysqlinstall.sh

elif [[ ! -f mysqlinstall.sh ]]; then

 	echo "File mysqlinstall.sh not found"

else 
	echo "Skipping...."
fi


read -p "$cecho Do you wish to Install apache archiva server? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]] && [[ -f archivainstall.sh ]]; then
	
	sudo chmod a+x archivainstall.sh
	./archivainstall.sh
	sudo chmod 644 archivainstall.sh

elif [[ ! -f archivainstall.sh ]]; then

 	echo "File archivainstall.sh not found"

else 
	echo "Skipping...."
fi


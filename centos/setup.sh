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
	echo "$cecho Skipping.... $nl"
fi 

read -p "$cecho Do you wish to run yum update? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]] && [[ -f proxyset.sh ]]; then
	
	sudo yum update  

else 
	echo "$cecho Skipping.... $nl"
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


else 

	echo "$cecho Skipping.... $nl"
fi



read -p "$cecho Do you wish to Install Nexus maven proxy repository? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]] && [[ -f nexusinstall.sh ]]; then
	
	sudo chmod a+x nexusinstall.sh
	./nexusinstall.sh
	sudo chmod 644 nexusinstall.sh

elif [[ ! -f nexusinstall.sh ]]; then
 	echo "File nexusinstall.sh not found"

else 
	echo "$cecho Skipping.... $nl"
fi


read -p "$cecho Do you wish to Install JBOSS AS 7 Application server? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]] && [[ -f jbossinstall.sh ]]; then
	
	sudo chmod a+x jbossinstall.sh
	./jbossinstall.sh
	sudo chmod 644 jbossinstall.sh

elif [[ ! -f jbossinstall.sh ]]; then

 	echo "File jbossinstall.sh not found"

else 
	echo "$cecho Skipping.... $nl"
fi


read -p "$cecho Do you wish to Install apache server? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	
	sudo yum install httpd
	sudo chkconfig --add httpd
	sudo chkconfig httpd on 
	sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
	sudo firewall-cmd --reload
	sudo service httpd restart

else 
	echo "$cecho Skipping.... $nl"
fi

read -p "$cecho Do you wish to Install apache tomcat Application server? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	
	sudo yum install tomcat
	sudo chkconfig --add tomcat
	sudo chkconfig tomcat on 
	firewall-cmd --zone=public --add-port=8080/tcp --permanent
	firewall-cmd --reload
	sudo service tomcat restart

else 
	echo "$cecho Skipping.... $nl"
fi

read -p "$cecho Do you wish to Install apache archiva server into tomcat? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]] && [[ -f archivainstall.sh ]]; then
	
	sudo chmod a+x archivainstall.sh
	./archivainstall.sh
	sudo chmod 644 archivainstall.sh

elif [[ ! -f archivainstall.sh ]]; then

 	echo "File archivainstall.sh not found"

else 
	echo "$cecho Skipping.... $nl"
fi

read -p "$cecho Do you wish to Install jenkins CI server into tomcat? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]] && [[ -f jenkinsinstall.sh ]]; then
	
	sudo chmod a+x jenkinsinstall.sh
	./jenkinsinstall.sh
	sudo chmod 644 jenkinsinstall.sh

elif [[ ! -f jenkinsinstall.sh ]]; then

 	echo "File jenkinsinstall.sh not found"

else 
	echo "$cecho Skipping.... $nl"
fi

read -p "$cecho Do you wish to Install redmine Project management platform? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	
	sudo yum -y install zlib-devel curl-devel openssl-devel httpd-devel apr-devel apr-util-devel mysql-devel
	sudo chkconfig sshd on
	sudo service sshd start
        sudo firewall-cmd --zone=public --add-port=22/tcp --permanent 
	sudo firewall-cmd --reload
	test "$(read -p 'Please enter Y to edit ssh config(PermitRootLogin no, AllowUsers usera userb , N to skip:  ' -r ; echo $REPLY)" == "Y" && (sudo nano /etc/ssh/sshd_config) || (echo "ssh config not set...")
	sudo service sshd restart


else 

	echo "$cecho Skipping.... $nl"
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
	echo "$cecho Skipping.... $nl"
fi



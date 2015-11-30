#!/bin/bash

nl=`echo  $'\n'`
wd=`pwd` #current Working Directory

if [ "$(whoami)" != "root" ]; then
  echo "Sorry, you are not root"
  exit 1
fi

echo "Please, make sure you are conected to a working network $nl"

echo "Current http_proxy detected is  $http_proxy"

echo "Please, enter your proxy IP Address(If not as above)"

read proxyIP

echo "Please, enter your proxy PORT number(If not as above)"

read proxyPORT
 

echo "Please, enter your proxy username (If any)"

read proxyUsername
 
read -s -p "Please, enter your proxy password (If any) $nl" proxyPassword 
 

if [[  $proxyIP  ||  $proxyPORT ]]; then
	http_proxy=""
	if [[ $proxyUsername ]]; then
		http_proxy="http://${proxyUsername}:${proxyPassword}@${proxyIP}:${proxyPORT}"
	else
		http_proxy="http://${proxyIP}:${proxyPORT}"
	fi 

	echo -e "Your proxy will be set to $http_proxy \n"

	export http_proxy=$http_proxy
	export https_proxy=$http_proxy
else
	echo -e "HTTP Proxy not set, will use direct connection for all http requests during setup \n"
	echo -e "Will now continue without proxy \n"
fi

#Setting Aptitue Proxy
if [[ $http_proxy ]]; then
	echo "Will now try to set Proxy in Aptitude configuration file, Please enter password if required..."
	sudo printf "Acquire::http::proxy \"$http_proxy\"; \nAcquire::https::proxy \"$http_proxy\";" | sudo tee  /etc/apt/apt.conf.d/proxy
else
	#Set apttitude proxy 
	read -n 1 -p "Please, Enter Y to set aptitude proxy to default (127.0.0.1:3128) $nl" setAptitudeProxyToDefault
	echo
	if [[ $setAptitudeProxyToDefault =~ ^[Yy]$ ]]; then
		echo -e "Will now try to set Proxy in Aptitude configuration file, Please enter password if required..."
		printf "Acquire::http::proxy \"http://127.0.0.1:3128\"; \nAcquire::https::proxy \"http://127.0.0.1:3128\"; \n" | sudo tee  /etc/apt/apt.conf.d/proxy:3128
		echo -e "Proxy  set"
	else
		echo
		echo "Not setting proxy in Aptitude configuration file"
	fi 
fi

#Adding new user

echo -e "\n If you wish to add a new user, please type in the username and press enter else leave empty and press enter $nl"

read newuser

if [ $newuser ]; then
	
	echo "Adding user $newuser"
	sudo adduser $newuser
	sudo passwd $newuser
	sudo printf "\n$newuser ALL=(ALL:ALL) ALL" | sudo tee -a  /etc/sudoers
	su $newuser

else
	echo "New user not added, will continue Installation with $(whoami)"
fi

#Adding other repo sources  
#For oracle JAVA
sudo -E add-apt-repository ppa:webupd8team/java  
   
#Updating apt
sudo apt-get update -y  && sudo apt-get upgrade -y && sudo apt-get dist-upgrade

#Installing Applications

sudo apt-get install -y cntlm && echo "Installed CNTLM, Please edit and set appropriately and exit"  && sudo nano /etc/cntlm.conf && sudo service cntlm restart


read -n 1 -p "Please, Enter Y to set proxy to default (127.0.0.1:3128) $nl" setCntlmProxy
echo

if [[ $setCntlmProxy =~ ^[Yy]$ ]]; then
	export http_proxy=http://127.0.0.1:3128
	export https_proxy=http://127.0.0.1:3128
	echo "Proxy  set"
else
	echo "Proxy not set"
fi

echo -e "\034[30m Installing Softwares from aptitude PPA Repositories"

test "$(read -p 'Install gtodo? [Y/N]' R ; echo $R)" = "Y" && (sudo apt-get install -y  skype && echo -e "\034[30m Installed skype. $nl" ) || (echo "skipped, not installed")

test "$(read -p 'Install System Information Utility Programs? [Y/N]' R ; echo $R)" = "Y" && (sudo apt-get install -y  hardinfo && echo -e "\034[30m Installed hardinfo. $nl" ) || (echo "skipped, not installed")
 
test "$(read -p 'Install Text and terminal utils? [Y/N]' R ; echo $R)" = "Y" && (sudo apt-get install -y sublime-text terminator && echo -e "\034[30m Installed Sublime Text. $nl" ) || (echo "skipped, not installed")

test "$(read -p 'Install git, npm ?  [Y/N]' R ; echo $R)" = "Y" && (sudo apt-get install -y git npm && echo -e "\034[30m Installed git. $nl" ) || (echo "skipped, not installed")

test "$(read -p 'Install java&maven ? [Y/N]' R ; echo $R)" = "Y" && (sudo apt-get install -y oracle-java7-installer oracle-java8-installer maven && echo -e "\034[30m Installed Maven.  $nl" ) || (echo "skipped, not installed")

test "$(read -p 'Install simple IDEs ? [Y/N]' R ; echo $R)" = "Y" && (sudo apt-get install -y netbeans eclipse-platform eclipse-jdt  && echo -e "\034[30m Installed netbeans.  $nl" ) || (echo "skipped, not installed")
 
test "$(read -p 'Install mysql database and tools ? [Y/N]' R ; echo $R)" = "Y" && (sudo apt-get install -y mysql-server mysql-workbench && echo -e "\034[30m Installed mysql-server.  $nl" ) || (echo "skipped, not installed")
  
test "$(read -p 'Install web and app servers? [Y/N]' R ; echo $R)" = "Y" && (sudo apt-get install -y apache2 tomcat7 tomcat7-user && echo -e "\034[30m Installed Apache2.  $nl" ) || (echo "skipped, not installed")

test "$(read -p 'Install terminal downloader utils ? [Y/N]' R ; echo $R)" = "Y" && (sudo apt-get install -y curl axel && echo -e "\034[30m Installed curl.  $nl" ) || (echo "skipped, not installed")


#Manuall by Curl
echo "Installing grails ruby version managers by curl "
read -p "Do you want to install these packages? " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then

	curl -s get.gvmtool.net | bash && echo "Installed Grails version manager"

	curl https://raw.githubusercontent.com/creationix/nvm/v0.11.1/install.sh | bash && echo "Installed node version Manager"

	gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

	curl -sSL https://get.rvm.io | bash -s stable --ruby=jruby --gems=rails,puma &&  echo "Installed RVM WITH JRUBY"
fi

source "~/.sdkman/bin/sdkman-init.sh"

gvm install grails && "Installed grails..."

gvm install groovy && "Installed groovy..."

echo -e "\035[37m Installing Manual Softwares, They will be downloaded"

test -d ~/Downloads && (echo "Download Folder exists") || (echo "Download folder doesnt exist, Will create it" ; /bin/mkdir ~/Downloads)

echo "Entering Downloads folder to begin Manual Downloads and Installations"
cd ~/Downloads

manualInstallsDir=/opt/manualInstalls

test -d $manualInstallsDir && (echo "Manual Installation Folder Exists..."; sudo /bin/chmod  777 -Rv $manualInstallsDir) || (echo "Manual Installation Folder does not exist, Creating it..."; sudo /bin/mkdir $manualInstallsDir; sudo /bin/chmod  777 -Rv $manualInstallsDir)

javaDir=$manualInstallsDir/java
java8Dir=$manualInstallsDir/java/jdk1.8
java7Dir=$manualInstallsDir/java/jdk1.7

IDEsDir==$manualInstallsDir/IDEs
appServersDir=$manualInstallsDir/appServers
jbossDir=$appServersDir/jboss
 
sudo /bin/chmod 777 -Rv $manualInstallsDir


#Auto Manuall
echo "Installing Google Chrome"
if [[ $(getconf LONG_BIT) = "64" ]]
then
	echo "64bit Detected" &&
	echo "Installing Google Chrome" &&
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
	sudo dpkg -i google-chrome-stable_current_amd64.deb &&
	rm -f google-chrome-stable_current_amd64.deb
else
	echo "32bit Detected" &&
	echo "Installing Google Chrome" &&
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb &&
	sudo dpkg -i google-chrome-stable_current_i386.deb &&
	rm -f google-chrome-stable_current_i386.deb
fi

test -d $IDEsDir && (echo "IDEs Folder exists in $IDEsDir") || (echo "IDEs folder doesnt exist in $manualInstallsDir, Will create it" ; sudo /bin/mkdir -p $IDEsDir)

#Downloading Eclipse
 cd $wd
if [[ $(getconf LONG_BIT) = "64" ]]
then
	echo "64bit Detected" &&
	echo "Downloading Eclipse IDE for 64 bit" &&
	wget http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/helios/SR1/eclipse-jee-helios-SR1-linux-gtk-x86_64.tar.gz  &&
	sudo tar -xvf eclipse-jee-helios-SR1-linux-gtk-x86_64.tar.gz --directory $IDEsDir &&
	rm -f eclipse-jee-helios-SR1-linux-gtk-x86_64.tar.gz
else
	echo "32bit Detected" &&
	echo "Installing Eclipse IDE" &&
	wget http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/helios/SR1/eclipse-jee-helios-SR1-linux-gtk.tar.gz &&
	sudo tar -xvf eclipse-jee-helios-SR1-linux-gtk.tar.gz  --directory $IDEsDir &&
	rm -f sudo tar -xvf eclipse-jee-helios-SR1-linux-gtk.tar.gz
fi

echo "Cleaning Up" && sudo apt-get -f install && sudo apt-get autoremove && sudo apt-get -y autoclean && sudo apt-get -y clean

test -d $javaDir && (echo "JAVA Folder exists in $javaDir") || (echo "JAVA folder doesnt exist in $javaDir, Will create it" ; sudo /bin/mkdir -p $javaDir)

test -d $java7Dir && (echo "JAVA 7 Folder exists in $java7Dir") || (echo "JAVA 7 folder doesnt exist in $java7Dir, Will create it" ; sudo /bin/mkdir -p $java7Dir)

test -d $java8Dir && (echo "JAVA 8 Folder exists in $java8Dir") || (echo "JAVA 8 folder doesnt exist in $java8Dir, Will create it" ; sudo /bin/mkdir -p $java8Dir)

test -d $appServersDir && (echo "appservers Folder exists in $appServersDir") || (echo "appServers folder doesnt exist in $appServersDir, Will create it" ; sudo /bin/mkdir $appServersDir)

test -d $jbossDir && (echo "JBOSS Folder exists in $jbossDir") || (echo "JBOSS folder doesnt exist in $jbossDir, Will create it" ; sudo /bin/mkdir $jbossDir)

test -d $IDEsDir && (echo "IDEs Folder exists in $IDEsDir") || (echo "IDes folder doesnt exist in $IDEsDir, Will create it" ; sudo /bin/mkdir $IDEsDir)

jbossas7downloadurl="http://download.jboss.org/jbossas/7.0/jboss-as-7.0.1.Final/jboss-as-web-7.0.1.Final.zip"
oraclejava8downloadurl="http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.tar.gz"
netbeans8downloadurl="http://download.netbeans.org/netbeans/8.0.2/final/bundles/netbeans-8.0.2-linux.sh"
eclipsedownloadurl="https://eclipse.org/downloads/download.php?file=/oomph/epp/mars/R1a/eclipse-inst-linux32.tar.gz&mirror_id=1068"
ggtsdownloadurl="http://dist.springsource.com/release/STS/3.6.4.RELEASE/dist/e4.4/groovy-grails-tool-suite-3.6.4.RELEASE-e4.4.2-linux-gtk.tar.gz"


echo "Will try to download jdk1.8.0_60 now from url $oraclejava8downloadurl, enter new url for you prefer a different java8 version,then else press enter..."
 
read newurl  

if [[ $newurl ]]; then
	oraclejava8downloadurl=$newurl
fi

read -p "Do you wish to manualy download and install JAVA1.8 $nl" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	if [[ -f java8Dir.tar.gz ]]; then
		while read -p "java archive detected, Enter Y to download it again, N to continue $nl" -r
		do
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				
				wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  $oraclejava8downloadurl -O java8Dir.tar.gz
	  			tar -xvf  java8Dir.tar.gz  --directory $java8Dir
				echo "java Archive was extracted successfully to $java8Dir $nl"
				break;

	  		elif [[  $REPLY =~ ^[Nn]$  ]]; then
				
				tar -xvf  java8Dir.tar.gz  --directory $java8Dir
				echo "java Archive was extracted successfully to $java8Dir $nl"
				break;

			fi
		done
	else

		wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  $oraclejava8downloadurl -O java8Dir.tar.gz
		tar -xvf  java8Dir.tar.gz  --directory $java8Dir
		echo "java Archive was extracted successfully to $java8Dir $nl" 

	fi
fi
 
#JBOSS7

echo "Will try to download jbossas7 now from url $jbossas7downloadurl, enter new url for you prefer a different jboss version,then else press enter..."
 
read newurl  

if [[ $newurl ]]; then
	jbossas7downloadurl=$newurl
fi

read -p "Do you wish to install JBOSS7 $nl" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	if [[ -f jboss7.1.zip ]]; then
		while read -p "JBOSS7 archive detected, Enter Y to download it again, N to continue $nl" -r
		do
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				
				wget   $jbossas7downloadurl -O jboss7.1.zip
	  			unzip jboss7.1.zip  -d $jbossDir
				echo "JBOSS7 Archive was extracted successfully to $jbossDir $nl"
				break;

	  		elif [[  $REPLY =~ ^[Nn]$  ]]; then
				
				unzip jboss7.1.zip  -d $jbossDir
				echo "JBOSS7 Archive was extracted successfully to $jbossDir $nl"
				break;

			fi
		done
	else

		wget   $jbossas7downloadurl -O jboss7.1.zip
		unzip jboss7.1.zip  -d $jbossDir
		echo "JBOSS7 Archive was extracted successfully to $jbossDir $nl" 

	fi
fi

cd $wd
 
echo "Creating Development Folder"
#Develop folder
mkdir -p ~/develop

#Get Git

read -p "$cecho Do you wish to checkout your work repos? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]] && [[ -f workrepos.sh ]]; then
	
	sudo chmod a+x workrepos.sh
	./workrepos.sh
	sudo chmod 644 workrepos.sh

elif [[ ! -f workrepos.sh ]]; then

 	echo "File workrepos.sh not found"

else 
	echo "$cecho Skipping.... $nl"
fi

read -p "$cecho Do you wish to Install netbeans IDE? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	
	cd ~/Downloads
	wget -O netbeans8.sh 
	sudo chmod a+x netbeans8.sh
	./netbeans8.sh
	sudo chmod 644 netbeans8.sh
	rm netbeans8.sh 

else 
	echo "$cecho Skipping.... $nl"
fi

read -p "$cecho Do you wish to Install netbeans IDE? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	
	cd ~/Downloads
	wget -O eclipse.tar.gz $eclipsedownloadurl
	tar -zxvf eclipse.tar.gz --directory $IDEsDir
	echo "[Desktop Entry]
Name=Eclipse 
Type=Application
Exec=env UBUNTU_MENUPROXY=0 eclipse44
Terminal=false
Icon=eclipse
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
Name[en]=Eclipse 
Exec=env UBUNTU_MENUPROXY=0 eclipse" | tee ~/Desktop/eclipse.desktop
	sudo ln -s $IDEsDir/eclipse/eclipse /usr/local/bin/eclipse44
	sudo cp $IDEsDir/eclipse/icon.xpm /usr/share/pixmaps/eclipse.xpm
	rm eclipse.tar.gz 
else 
	echo "$cecho Skipping.... $nl"
fi

read -p "$cecho Do you wish to Install ggts IDE? $nl 1. Enter Y and press enter to install $nl 2. Enter N to skip installation $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	
	cd ~/Downloads
	wget -O ggts.tar.gz $ggtsdownloadurl
	tar -xvf ggts.tar.gz --directory $IDEsDir
	echo "[Desktop Entry]
Name=GGTS 
Type=Application
Exec=env UBUNTU_MENUPROXY=0 GGTS
Terminal=false
Icon=ggts
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
Name[en]=GGTS 
Exec=env UBUNTU_MENUPROXY=0 ggts" | tee ~/Desktop/ggts.desktop
	sudo rm /usr/local/bin/ggts
	sudo ln -s $IDEsDir/ggts-bundle/ggts-3.6.4.RELEASE/GGTS /usr/local/bin/ggts
	sudo cp $IDEsDir/ggts-bundle/ggts-3.6.4.RELEASE/icon.xpm /usr/share/pixmaps/ggts.xpm
	echo "You can INstall the maven plugin via market place http://download.ggts.org/technology/m2e/releases, egit via http://download.eclipse.org/egit/updates"
	rm ggts.tar.gz 
	echo "GGTS Now Installed............................."
else 
	echo "$cecho Skipping.... $nl"
fi

cd $pwd
source "workrepos.sh"

cd
git clone https://github.com/JohnTheBeloved/mybashscript.git .mybash
cd .mybash
git pull origin master
echo "source ~/.mybash/mybin.sh" | tee .profile
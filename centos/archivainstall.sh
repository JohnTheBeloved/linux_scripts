
#newlineprompt variable
nl=`echo $'\n\e[0;30m'`
nlp=`echo $'\n>\e[0;30m'`
#color variable
cecho=`echo -e $'\e[1;31m'`
 
archiva_download_link="http://www.us.apache.org/dist/archiva/1.3.9/binaries/apache-archiva-1.3.9.war"
read -p "Do you want to download archiva Maven proxy via $archiva_download_link ?, $nl 1. Enter Y to download it with th default link, $nl 2. Enter the new Link to download it via another link, $nl 3. Enter N to skip it $nlp" -r

if [[ $REPLY =~ ^[Yy]$ ]]; then

 wget $archiva_download_link 
 
elif [[ $REPLY =~ ^[Nn]$ ]]; then

echo "$cecho Skipping archiva Download... $nl"
 
else

  wget $REPLY

fi

if [[ -f apache-archiva-1.3.9.war ]]; then 
     
   read -p "$cecho Please set $nl appserver.home=/usr/share/tomcat(CATALINA_HOME)(CATALINA_HOME) in war WEB-INF/classes/application.properties file and $nl appserver.base=/usr/share/tomcat in war WEB-INF/classes/application.properties file $nl OR set enviromnent variable : export CATALINA_OPTS='-Dappserver.home=CATALINA_HOME -Dappserver.base=CATALINA_HOME' $nl Press Enter to continue after setting the configs $nlp" -r
      
   echo "$cecho Moving apache-archiva-1.3.9.war to /usr/local/archiva/archiva.war $nl"
   sudo mkdir -p /usr/local/archiva
   sudo chmod -Rv 777 /usr/local/archiva
   
   sudo mv apache-archiva-1.3.9.war /usr/local/archiva/archiva.war
  
   wget http://www.eu.apache.org/dist//db/derby/db-derby-10.12.1.1/db-derby-10.12.1.1-bin.zip
   unzip db-derby-10.12.1.1-bin.zip
   sudo mv db-derby-10.12.1.1-bin/lib/derby.jar db-derby-10.12.1.1-bin/lib/derbytools.jar /usr/share/tomcat/lib/
   rm -rf db-derby-10.12.1.1-bin
   rm db-derby-10.12.1.1-bin.zip

   wget  http://central.maven.org/maven2/org/apache/tomcat/tomcat-dbcp/7.0.30/tomcat-dbcp-7.0.30.jar
   sudo mv tomcat-dbcp-7.0.30.jar /usr/share/tomcat/lib/

   wget http://repo2.maven.org/maven2/javax/mail/mail/1.4.1/mail-1.4.1.jar
   sudo mv mail-1.4.1.jar /usr/share/tomcat/lib/mail-1.4.1.jar

   wget http://repo2.maven.org/maven2/javax/activation/activation/1.1.1/activation-1.1.1.jar
   sudo mv activation-1.1.1.jar /usr/share/tomcat/lib/activation-1.1.1.jar  

   echo "Copying archiva configuration file from conf/archiva.xml to /etc/tomcat/Catalina/localhost/"
   
   sudo cp ../config/archiva.xml /etc/tomcat/Catalina/localhost/archiva.xml 
   read -p "Please, make sure you've added javamail jars(activation.jar and mail.jar) to java lib or tomcat lib $nl, Press enter to continue" -r
   
   echo "$cecho Restarting tomcat service $nl" 

   sudo service tomcat restart

   tail -f /var/log/tomcat/*.*
   
fi

#newlineprompt variable
nl=`echo $'\n\e[0;30m'`
nlp=`echo $'\n>\e[0;30m'`
#color variable
cecho=`echo -e $'\e[1;31m'`
 
jenkins_download_link="https://updates.jenkins-ci.org/download/war/1.633/jenkins.war"
read -p "Do you want to download jenkins  CI war via $jenkins_download_link ?, $nl 1. Enter Y to download it with th default link, $nl 2. Enter the new Link to download it via another link, $nl 3. Enter N to skip it $nlp" -r

if [[ $REPLY =~ ^[Yy]$ ]]; then

 wget $jenkins_download_link 
 
elif [[ $REPLY =~ ^[Nn]$ ]]; then

echo "$cecho Skipping jenkins Download... $nl"
 
else

  wget $REPLY

fi

if [[ -f jenkins.war ]]; then 
    
   echo "$cecho Moving jenkins.war to /usr/local/jenkins/jenkins.war $nl"
   sudo mkdir -p /usr/local/jenkins
   sudo chmod -Rv 777 /usr/local/jenkins
   
   sudo mv jenkins.war /usr/local/jenkins/jenkins.war
  
   
   echo "Copying jenkins configuration file from conf/jenkins.xml to /etc/tomcat/Catalina/localhost/"
   sudo cp ../config/jenkins.xml /etc/tomcat/Catalina/localhost/jenkins.xml   
  
   echo "$cecho Restarting tomcat service $nl" 
   
   sudo service tomcat restart

   tail -f /var/log/tomcat/*.*
   
fi


#newlineprompt variable
nl=`echo $'\n\e[0;30m'`
nlp=`echo $'\n>\e[0;30m'`
#color variable
cecho=`echo -e $'\e[1;31m'`

archiva_download_version=
archiva_version=
archiva_bundle=
read -p "Enter archiva version to download $nlp" archiva_download_version
if [[ $archiva_download_version == "latest" ]]; then
  read -p "Please enter the offical version number $nlp" archiva_version
  archiva_bundle="apache-archiva-$archiva_download_version.war" 
else
  archiva_version=$archiva_download_version
  archiva_bundle="apache-archiva-$archiva_version.war"
  
fi
archiva_download_link="http://www.us.apache.org/dist/archiva/1.3.9/binaries/$archiva_bundle"
read -p "Do you want to download archiva Maven proxy via $archiva_download_link ?, $nl 1. Enter Y to download it with th default link, $nl 2. Enter the new Link to download it via another link, $nl 3. Enter N to skip it $nlp" -r

if [[ $REPLY =~ ^[Yy]$ ]]; then

 wget $archiva_download_link 
 
elif [[ $REPLY =~ ^[Nn]$ ]]; then

echo "$cecho Skipping archiva Download... $nl"
 
else

  wget $REPLY

fi

if [[ -f $archiva_bundle ]]; then
   CATALINA_HOME=/usr/share/tomcat
   echo "$cecho Moving $archiva_bundle to $CATALINA_HOME $nl"
   mkdir -p /usr/share/tomcat/archiva
   
   mv $archiva_bundle $CATALINA_HOME
   
   sudo tar -xvf $archiva_bundle --d  
   
   rm $archiva_bundle
   sudo chmod -Rv 777 /usr/local/archiva-$archiva_version
   sudo chmod -Rv 777 /usr/local/sonatype-work
   sudo ln -sf /usr/local/archiva-$archiva_version /usr/local/archiva
   cd /usr/local/archiva
   ./bin/archiva start
   
fi





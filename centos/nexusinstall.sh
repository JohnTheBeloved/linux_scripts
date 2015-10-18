
#newlineprompt variable
nl=`echo $'\n\e[0;30m'`
nlp=`echo $'\n>\e[0;30m'`
#color variable
cecho=`echo -e $'\e[1;31m'`

nexus_download_version=
nexus_version=
nexus_bundle=
read -p "Enter nexus version to download $nlp" nexus_download_version
if [[ $nexus_download_version == "latest" ]]; then
  read -p "Please enter the offical version number $nlp" nexus_version
  nexus_bundle="nexus-$nexus_download_version-bundle.tar.gz" 
else
  $nexus_version = $nexus_download_version
  nexus_bundle="nexus-$nexus_version-bundle.tar.gz"
  
fi
nexus_download_link="http://www.sonatype.org/downloads/$nexus_bundle"
read -p "Do you want to install Nexus Maven proxy via $nexus_download_link ?, $nl 1. Enter Y to download it with th default link, $nl 2. Enter the new Link to download it via another link, $nl 3. Enter N to skip it $nlp" -r

if [[ $REPLY =~ ^[Yy]$ ]]; then

 wget $nexus_download_link 
 
elif [[ $REPLY =~ ^[Nn]$ ]]; then

echo "$cecho Skipping Sonatype Nexus Download... $nl"
 
else

  wget $REPLY

fi

if [[ -f $nexus_bundle ]]; then
   
   echo "$cecho Extracting $nexus_bundle archive $nl"
   sudo tar -xvf $nexus_bundle --directory /usr/local 
   rm $nexus_bundle
   sudo chmod -Rv 777 /usr/local/nexus-$nexus_version
   sudo chmod -Rv 777 /usr/local/sonatype-work
   sudo ln -sf /usr/local/nexus-$nexus_version /usr/local/nexus
   cd /usr/local/nexus
   ./bin/nexus start
   
fi





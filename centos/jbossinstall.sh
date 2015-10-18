
#newlineprompt variable
nl=`echo $'\n\e[0;30m'`
nlp=`echo $'\n>\e[0;30m'`
#color variable
cecho=`echo -e $'\e[1;31m'`

echo "This script will install JBOSS AS 7" 
 jboss_download_link="http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip"
jboss_bundle="jboss-as-7.1.1.Final.zip"
read -p "Continue with JBOSS AS 7 Installation? $nl 1 Enter Y to download and Install $nl 2. Enter N to skip $nlp" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then

 wget $jboss_download_link 
  
else

echo "$cecho Skipping JBOSS AS 7 Download and Installation... $nl"

fi

if [[ -f $jboss_bundle ]]; then
   
   echo "$cecho Extracting JBOSS $jboss_bundle bundle $nl"
   sudo unzip $jboss_bundle -d /usr/local 
   rm $jboss_bundle
   sudo chmod -Rv 777 /usr/local/jboss-as-7.1.1.Final
   sudo ln -sf /usr/local/jboss-as-7.1.1.Final /usr/local/jboss
   cd /usr/local/jboss
   cd bin
   ./add-user.sh   
   sudo adduser jboss
   
   sudo chown jboss.jboss /usr/local/jboss-as-7.1.1.Final
   
fi






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
   sudo ln -sf /usr/local/jboss-as-7.1.1.Final /usr/local/jboss-as
   sudo ln -sf /usr/local/jboss-as /usr/share/jboss-as
   sudo chmod 777 -Rv /usr/local/jboss-as
   cd /usr/local/jboss-as
   cd bin
   ./add-user.sh   
   sudo adduser -G appservers jboss-as
   
   sudo chown -Rv jboss-as:appservers /usr/local/jboss-as-7.1.1.Final
   sudo chmod 755 /var/log/jboss-as/console.log
   sudo mkdir -p /etc/jboss-as.d/
   sudo cp /usr/local/jboss-as/bin/init.d/jboss-as.conf /etc/jboss-as/jboss-as.conf
   sudo cp /usr/local/jboss-as/bin/init.d/jboss-as-standalone.sh /etc/init.d/jboss-as

   sudo chmod a+x /etc/init.d/jboss-as

   sudo chkconfig --add jboss-as
   sudo chkconfig jboss-as on

   read -p "$cecho Please edit standalone.xml configuration and set $nl 1. increase port numbers y 5,  Press Enter to edit it $nl" -p

   sudo nano /usr/local/jboss-as-7.1.1.Final/standalone/configuration/standalone.xml
      
   read -p "$cecho Please edit jboss-as.conf configuration and set $nl 1. increase port numbers by 5,  Press Enter to edit it $nl" -r

    sudo nano /etc/jboss-as/jboss-as.conf

     read -p "$cecho Will now start jboss ,  Press Enter to continue! $nl 1. set JBOSS_USER $nl 2. Increase STARTUP_WAIT & SHUTDOWN_WAIT times $nl 3. And Also set log path  $nl $cecho Press Enter to continue $nl " -r

    sudo mkdir /var/run/jboss-as
    sudo chown jboss-as:appservers /var/run/jboss-as
    sudo service jboss-as start

   
fi





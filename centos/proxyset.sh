
#newlineprompt variable
nl=`echo $'\n\e[0;30m'`
nlp=`echo $'\n>\e[0;30m'`
#color variable
cecho=`echo -e $'\e[1;31m'`

echo  "$cecho Starting script... $nl"

test "$(read -p 'Please make sure you are connected to the internet, set proxy in the second prompt if connecting through a proxy! Enter Y to continue :  ' -r ; echo $REPLY)" == "Y" && (echo "OK") || (exit 1)

read -p "Please, enter your proxy IP Address(If any) $nlp" proxyIP
http_proxy=
if [[ $proxyIP ]]; then
     
read -p "Please, enter your proxy PORT number $nlp" proxyPort

read -p "Please, enter your proxy username(if any) $nlp" proxyUsername

if [[ $proxyUsername ]]; then
    
     read -p "Please, enter your proxy password" proxyPassword
     http_proxy="http://${proxyUsername}:${proxyPassword}@${proxyIP}:${proxyPort}"
else
     http_proxy="http://${proxyIP}:${proxyPort}"
fi 

export http_proxy=$http_proxy
export https_proxy=$http_proxy
printf "\nexport http_proxy=$http_proxy \nexport https_proxy=$http_proxy" | sudo tee /etc/profile.d/proxy
printf "\nexport http_proxy=$http_proxy \nexport https_proxy=$http_proxy" | sudo tee -a ~/.bashrc
#printf "Defaults    env_keep += \"http_proxy https_proxy\"" | sudo tee -a /etc/sudoers


echo "$cecho http_proxy is now $http_proxy"


test "$(read -p 'Please enter Y to set yum proxy , N to skip:  ' -r ; echo $REPLY)" == "Y" && (sudo nano /etc/yum.conf) || (echo "Yum proxy not set")


else
echo "$cecho Proxy not set, will connect directly to internet $nl...."
fi


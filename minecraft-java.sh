sudo echo "@reboot root (cd /usr/games/minecraft && export JVMMEM=\`expr \$(free -m | sed -n 2p | awk '{print \$2}') - 256\` && sudo java -Xmx\$(echo \$JVMMEM)M -Xms\$(echo \$JVMMEM)M -jar /usr/games/minecraft/mcserver.jar --nogui)" > /etc/cron.d/minecraft
mkdir /usr/games/minecraft
sudo chown ubuntu /usr/games/minecraft
cd /usr/games/minecraft
jsonurl=$(curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq '.versions[0].url')
jsonurl="${jsonurl#\"}" && jsonurl="${jsonurl%\"}"
downloadurl=$(curl $jsonurl |jq '.downloads.server.url')
downloadurl="${downloadurl#\"}" && downloadurl="${downloadurl%\"}"
sha1=$(curl $jsonurl |jq '.downloads.server.sha1')
sha1="${sha1#\"}" && sha1="${sha1%\"}"
if [ $(sha1sum server.jar | awk '{print $1}') != $sha1 ]; then echo "Hash check error, not installed" > status.log ;fi
wget -O mcserver.jar $downloadurl
java -Xmx512M -Xms512M -jar mcserver.jar --nogui
sudo chown ubuntu eula.txt
echo "eula=true" > eula.txt
export JVMMEM=`expr $(free -m | sed -n 2p | awk '{print $2}') - 256`
sudo -u ubuntu screen -dmSL minecraft java -Xmx$(echo $JVMMEM)M -Xms$(echo $JVMMEM)M -jar /usr/games/minecraft/mcserver.jar --nogui
sudo apt install unzip screen wget -y
mkdir /usr/games/minecraft
cd /usr/games/minecraft
URL=`curl -L https://minecraft.net/en-us/download/server/bedrock/ 2>/dev/null| grep bin-linux | sed -e 's/.*<a href=\"\(https:.*\/bin-linux\/.*\.zip\).*/\1/'` 
sudo wget -O mcserver.zip $URL
sudo unzip mcserver.zip
sudo rm mcserver.zip
echo "@reboot root (cd /usr/games/minecraft && LD_LIBRARY_PATH=. ./bedrock_server)" > /etc/cron.d/minecraft
sudo chmod +x ./bedrock_server
sudo LD_LIBRARY_PATH=. ./bedrock_server
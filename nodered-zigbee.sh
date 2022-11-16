#!/bin/bash

# run script : bash <(curl -sL https://raw.githubusercontent.com/jackrobotics/pi/main/nodered-zigbee.sh)

echo "=================================================="
echo "= Software By Sonthaya Boonchan ( JackRoboticS ) ="
echo "=================================================="

echo "=================================================="
echo "= Install Node-RED                               ="
echo "=================================================="

# Install NodeRed
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered) --node14 --confirm-root --confirm-install --skip-pi

sudo systemctl enable nodered.service
sudo systemctl start nodered.service


# Install Zigbee2MQTT
echo "=================================================="
echo "= Install Zigbee2MQTT                            ="
echo "=================================================="
# Set up Node.js repository and install Node.js + required dependencies
sudo curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs git make g++ gcc

# Verify that the correct nodejs and npm (automatically installed with nodejs)
# version has been installed
echo "=================================================="
echo "= Check Node Version                             ="
node --version  # Should output v14.X, V16.x, V17.x or V18.X
npm --version  # Should output 6.X, 7.X or 8.X
echo "=================================================="


# Create a directory for zigbee2mqtt and set your user as owner of it
sudo mkdir /opt/zigbee2mqtt
sudo chown -R ${USER}: /opt/zigbee2mqtt

# Clone Zigbee2MQTT repository
echo "=================================================="
echo "= Git Clone  Zigbee2MQTT                         ="
echo "=================================================="
git clone -b 1.23.0 --depth 1 https://github.com/Koenkk/zigbee2mqtt.git /opt/zigbee2mqtt

# Install dependencies (as user "pi")
cd /opt/zigbee2mqtt

echo "=================================================="
echo "= Install Dependencies                           ="
echo "=================================================="
sudo npm ci


echo "=================================================="
echo "= Install frontend                               ="
echo "=================================================="
rm -rf /opt/zigbee2mqtt/data/configuration.yaml
echo "homeassistant: false
permit_join: false
mqtt:
  base_topic: zigbee2mqtt
  server: 'mqtt://localhost'
serial:
  port: /dev/ttyUSB0
frontend: true" >> /opt/zigbee2mqtt/data/configuration.yaml

# Install PM2
echo "=================================================="
echo "= Install PM2                                    ="
echo "=================================================="
sudo npm install pm2@latest -g
cd /opt/zigbee2mqtt
echo "=================================================="
echo "= PM2 Auto Start Service Zigbee2MQTT             ="
echo "=================================================="
sudo pm2 start index.js --name zigbee
sudo pm2 startup
sudo pm2 save

echo "=================================================="
echo "= Setup Finish                                   ="
echo "= Nodered : 127.0.0.1:1880                       ="
echo "= Zigbee  : 127.0.0.1:8080                       ="
echo "= Auto Setup By Sonthaya Boonchan (JackRoboticS) ="
echo "= Version : 0.1 ( dev version )                  ="
echo "=================================================="

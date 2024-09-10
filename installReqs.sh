#!/bin/bash

echo -e "\n\n\n\nThis system is NOT ready to use.  The install script takes a while.  Give it a bit.\n\n" > /etc/motd


yum install git ansible-core unzip wget -y

## Need to get opentofu
wget https://get.opentofu.org/install-opentofu.sh -O /tmp/install-opentofu.sh 
chmod +x /tmp/install-opentofu.sh 
/tmp/install-opentofu.sh --install-method rpm

cd /tmp
wget https://download.torero.dev/torero-v1.1.0-linux-amd64.tar.gz 
sudo tar xzvf torero-v1.1.0-linux-amd64.tar.gz 
sudo mv torero /usr/local/bin
sudo chmod 755 /usr/local/bin/torero

export TORERO_APPLICATION_WORKING_DIR="/opt/torero"
export TORERO_APPLICATION_AUTO_ACCEPT_EULA="true"
export TORERO_SERVER_USE_TLS="false"
export TORERO_APPLICATION_MODE="server"
export TORERO_SERVER_LISTEN_ADDRESS="0.0.0.0"

/usr/local/bin/torero server &&

#Alert that it's ready to be used cause it takes a while
echo "All services should be up and ready now.  Go for it!" | wall
echo "This system is ready to use.  The install script has completed." > /etc/motd

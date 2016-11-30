**work in progress**

# Deluge Installer
* Systemd Service
* WebUI with https Enabled 
* Remote Client Enabled
* FlexGet for automatic tv shows
* ufw firewall and opens ports
* installs the required packages
* creates a deluge user
* input your deluge username and password

## Defaults
* tested on Ubuntu 16.04 and in LXC
* ufw opens 8122 (webui)
* ufw opens 58846 (remote client)
* ufw opens 56000 (public incoming for torrent)
* ufw opens 57000 (public outgoing for torrent)
* Downloads incomplete to /home/deluge/incomplete
* Move completed to /home/deluge/complete
* Flexget automatic downloads to /home/deluge/autotv/Show/Season

## Install
* apt-get install git ca-certificates -y
* git clone https://github.com/nwgat/deluge-installer.git
* chmod +x deluge-installer/deluge-installer.sh
* cd deluge-installer && ./deluge-installer.sh

## Install in LXC
* apt-get install lxc -y
* sudo lxc-create -n seed -t ubuntu && lxc-start -n seed 
* lxc-attach -n seed
* apt-get install git ca-certificates -y
* git clone https://github.com/nwgat/deluge-installer.git
* chmod +x deluge-installer/deluge-installer.sh
* cd deluge-installer && ./deluge-installer.sh
* exit
* wget https://raw.githubusercontent.com/nwgat/deluge-installer/master/lxc-route-helper.sh
* chmod +x  lxc-route-helper.sh && ./lxc-route-helper.sh 

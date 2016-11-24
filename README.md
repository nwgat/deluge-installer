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

### Defaults
* tested on Ubuntu 16.04 and in LXC
* ufw opens 8122 (webui)
* ufw opens 58846 (remote client)
* ufw opens 9000 (public port for torrent)
* Downloads incomplete to /home/deluge/incomplete
* Move completed to /home/deluge/complete
* Flexget automatic downloads to /home/deluge/autotv/Show/Season
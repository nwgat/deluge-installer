ip=`(hostname -I | sed 's/ //g')`
echo $ip

echo ""
echo "## nwgat.ninja deluge installer ##"
echo "https://nwgat.ninja"
echo ""
echo "Username"
read -e usr
echo "Password"
read -e pw

echo ""
echo "Installing Packages"
apt-get install -qq software-properties-common -y >> /dev/null
add-apt-repository ppa:deluge-team/ppa -y >> /dev/null
apt-get update -qq >> /dev/null
apt-get install -qq deluged deluge-web deluge-console nano wget python-pip ufw -y >> /dev/null
pip install -q flexget >> /dev/null

echo "Setting up Systemd"
wget -q https://raw.githubusercontent.com/nwgat/etc/master/deluge/deluged.service -O /etc/systemd/system/deluged.service
wget -q https://raw.githubusercontent.com/nwgat/etc/master/deluge/deluge-web.service -O /etc/systemd/system/deluge-web.service

echo "Opening Firewall"
ufw allow 8122
ufw allow 58846
ufw allow 9000

echo "Setting up Deluge"
adduser --disabled-password --gecos "" deluge

su -c 'deluged && pkill -9 deluged' deluge
su -c 'echo "$usr:$pw:10" >> $HOME/.config/deluge/auth' deluge

systemctl start deluged && systemctl enable deluged >> /dev/null
systemctl start deluge-web && systemctl enable deluge-web >> /dev/null

su -c 'deluge-console "config -s allow_remote True"' deluge
su -c 'deluge-console "config allow_remote"' deluge
su -c 'deluge-console "config -s download_location /home/deluge/incomplete"' deluge
su -c 'deluge-console "config -s move_completed_path /home/deluge/complete"' deluge
su -c 'deluge-console "config -s listen_ports (9000, 9000)"' deluge
su -c 'deluge-console "config -s move_completed true' deluge

systemctl status deluged deluge-web >> /dev/null

echo ""
echo "Deluge is now setup"
echo "¤¤¤ WARNING webui is unprotected by default, SET PASSWORD WARNING ¤¤¤"
echo ""
echo "Details:"
echo "WebUI: http://$ip:8122 (default password is deluge)"
echo "Remote Client: $ip:58846"
echo "Username: $usr"
echo "Password: $pw"
echo ""

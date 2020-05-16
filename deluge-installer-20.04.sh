ip=`(hostname -I | awk '{print $1}')`

echo ""
echo -e "\e[44m## nwgat.ninja deluge installer ##\e[0m"
echo "https://nwgat.ninja"
echo ""
echo -e "\e[44mUsername\e[0m"
read -e usr
echo -e "\e[44mPassword\e[0m"
read -e pw

echo ""
echo -e "\e[44mInstalling Packages\e[0m"
apt-get install -qq software-properties-common -y
add-apt-repository ppa:deluge-team/stable -y
apt-get update -qq
apt-get install -qq deluged deluge-console nano wget python-pip ufw -y
pip install -q flexget
echo ""
echo -e "\e[44mSetting up Systemd\e[0m"
cp systemd/deluged.service /etc/systemd/system/
echo "Done."
systemctl daemon-reload
echo ""
echo -e "\e[44mOpening Firewall\e[0m"
ufw allow 8112
ufw allow 46123
ufw allow 58846
ufw allow 56000
ufw allow 57000
echo ""
echo -e "\e[44mSetting up Deluge\e[0m"
adduser --disabled-password --gecos "" deluge
su -c 'deluged' deluge
sleep 5
pkill -9 deluged
systemctl start deluged
systemctl enable deluged
sleep 5
mkdir /home/deluge/incomplete
mkdir /home/deluge/complete
su -c 'deluge-console "config -s allow_remote True"' deluge
su -c 'deluge-console "config -s download_location /home/deluge/incomplete"' deluge
su -c 'deluge-console "config -s move_completed true"' deluge
su -c 'deluge-console "config -s move_completed_path /home/deluge/complete"' deluge
su -c 'deluge-console "config -s listen_ports (56000, 56000)"' deluge
su -c 'deluge-console "config -s random_outgoing_ports false"' deluge
su -c 'deluge-console "config -s outgoing_ports (57000, 57000) "' deluge
su -c 'deluge-console "config -s random_port false"' deluge
su -c 'deluge-console "config -s max_active_downloading 100"' deluge
su -c 'deluge-console "config -s max_active_limit 100"' deluge
su -c 'deluge-console "config -s max_active_seeding 100"' deluge

systemctl restart deluged

echo ""
echo "Deluge is now setup"
echo "¤¤¤ WebUI is disabled by defult ¤¤¤"
echo "enable with systemctl start deluge-web && systemctl enable deluge-web"
echo ""
echo -e "\e[44mDetails:\e[0m"
echo "WebUI: https://$ip:8112 (default password is deluge)"
echo "Remote Client: $ip"
echo "Username: $usr"
echo "Password: $pw"
echo ""

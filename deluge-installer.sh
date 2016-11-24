ip=`(hostname -I | awk '{print $1}')`

echo ""
echo "## nwgat.ninja deluge installer ##"
echo "https://nwgat.ninja"
echo ""
echo "Username"
read -e usr
echo "Password"
read -e pw

echo ""
echo -e "\e[44mInstalling Packages\e[0m"
apt-get install -qq software-properties-common -y
add-apt-repository ppa:deluge-team/ppa -y
apt-get update -qq
apt-get install -qq deluged deluge-web deluge-console nano wget python-pip ufw -y
pip install -q flexget
echo ""
echo -e "\e[44mSetting up Systemd\e[0m"
#cp systemd/deluged.service /etc/systemd/system/
#cp systemd/deluge-web.service /etc/systemd/system/
wget https://raw.githubusercontent.com/nwgat/etc/master/deluge/deluged.service -O /etc/systemd/system/deluged.service
wget https://raw.githubusercontent.com/nwgat/etc/master/deluge/deluge-web.service -O /etc/systemd/system/deluge-web.service
echo "Done."
systemctl daemon-reload
echo ""
echo -e "\e[44mOpening Firewall\e[0m"
ufw allow 8122
ufw allow 58846
ufw allow 9000
echo ""
echo -e "\e[44mSetting up Deluge\e[0m"
adduser --disabled-password --gecos "" deluge
su -c 'deluged' deluge
su -c 'pkill -9 deluged' deluge
echo $usr:$pw:10 >> /home/deluge/.config/deluge/auth
echo "auth added"
chown deluge /home/deluge/.config/deluge/auth
systemctl start deluged deluge-web && systemctl enable deluged deluge-web
sleep 5
su -c 'deluge-console "config -s allow_remote True"' deluge
su -c 'deluge-console "config -s download_location /home/deluge/incomplete"' deluge
su -c 'deluge-console "config -s move_completed_path /home/deluge/complete"' deluge
su -c 'deluge-console "config -s listen_ports (9000, 9000)"' deluge
su -c 'deluge-console "config -s move_completed true"' deluge

systemctl stop deluged deluge-web && systemctl start deluged deluge-web

echo ""
echo "Deluge is now setup"
echo "¤¤¤ WARNING webui is unprotected by default, SET PASSWORD WARNING ¤¤¤"
echo ""
echo -e "\e[44mDetails:\e[0m"
echo "WebUI: http://$ip:8122 (default password is deluge)"
echo "Remote Client: $ip:58846"
echo "Username: $usr"
echo "Password: $pw"
echo ""

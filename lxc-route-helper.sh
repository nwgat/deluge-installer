ip=`(hostname -I | awk '{print $1}')`
echo "lxc container?"
read -p lxc

iptables -t nat -A PREROUTING -p tcp -d $ip --dport 58846 -j DNAT --to-destination $lxc:58846
iptables -t nat -A PREROUTING -p tcp -d $ip --dport 8112 -j DNAT --to-destination $lxc:8112
iptables -t nat -A PREROUTING -p tcp -d $ip --dport 9000 -j DNAT --to-destination $lxc:9000

iptables -t nat -A POSTROUTING -j MASQUERADE

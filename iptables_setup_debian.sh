#!/bin/bash
set -e

# Шаг 1: Применение правил iptables
iptables -F
iptables -P INPUT DROP
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -m comment --comment "#---SSH" -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 53 -m comment --comment "#---DNS" -j ACCEPT
iptables -A INPUT -s 103.21.244.0/22,103.22.200.0/22,104.16.0.0/13,103.31.4.0/22,104.24.0.0/14,108.162.192.0/18,131.0.72.0/22,141.101.64.0/18,162.158.0.0/15,172.64.0.0/13,173.245.48.0/20,188.114.96.0/20,190.93.240.0/20,197.234.240.0/22,198.41.128.0/17 -p tcp --dport 80 -m comment --comment "#---CF" -j ACCEPT
iptables -A INPUT -s 103.21.244.0/22,103.22.200.0/22,104.16.0.0/13,103.31.4.0/22,104.24.0.0/14,108.162.192.0/18,131.0.72.0/22,141.101.64.0/18,162.158.0.0/15,172.64.0.0/13,173.245.48.0/20,188.114.96.0/20,190.93.240.0/20,197.234.240.0/22,198.41.128.0/17 -p tcp --dport 443 -m comment --comment "#---CF" -j ACCEPT
iptables -A INPUT -p icmp -m state --state NEW -m icmp --icmp-type 8,11,3 -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,ACK SYN,ACK -m state --state NEW -j REJECT --reject-with tcp-reset
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK,URG FIN,SYN,RST,ACK,URG -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
##antiDDOS
iptables -A INPUT -p tcp --syn -m limit --limit 1/s --limit-burst 5 -j ACCEPT
iptables -A INPUT -p tcp --syn -j DROP
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s --limit-burst 5 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
iptables -A INPUT -s 181.214.92.0/24 -j DROP
iptables -A INPUT -s 80.91.162.0/24 -j DROP

# Шаг 2: Сохранение правил в файл
iptables-save > /etc/iptables/rules.v4

# Шаг 3: Добавление правил в автозагрузку
if [ ! -d "/etc/network/if-pre-up.d" ]; then
    mkdir -p /etc/network/if-pre-up.d
fi

cat > /etc/network/if-pre-up.d/iptables <<EOL
#!/bin/sh
/sbin/iptables-restore < /etc/iptables/rules.v4
EOL

chmod +x /etc/network/if-pre-up.d/iptables

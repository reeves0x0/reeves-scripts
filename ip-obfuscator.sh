#!/bin/bash

read -p "IP address to obfuscate (IPv4 only): " ip

if ! echo "$ip" | grep -Pq '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'; then
    echo "Invalid IP address: $ip"
    exit 1
fi

IFS='.' read -ra ipmod <<< "$ip"
first=${ipmod[0]}
hex=$(printf '%x' $first)

decimal=0
for ((i=1; i<4; i++)); do
    decimal=$((decimal + ipmod[$i] * 256 ** (3 - $i) ))
done

final="0x$hex.$decimal"

echo -e "\nYour obfuscated IP address:"
echo -e "\033[1;33m$final\033[0m"

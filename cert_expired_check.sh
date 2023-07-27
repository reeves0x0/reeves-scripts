#!/bin/bash


#requirements
echo "requirements - - - install dateutils"


# Массив с доменами
domains=("reeves.su" "blog.reeves.su" "wiki.reeves.su")

for domain in "${domains[@]}"; do
echo "Проверка домена: $domain"
expiration_date=$(echo | openssl s_client -connect "$domain":443 2>/dev/null | openssl x509 -noout -dates | grep "notAfter" | cut -d "=" -f 2)

# Преобразование даты сертификата в секунды
expiration_seconds=$(dateutils.dconv -i "%b %d %H:%M:%S %Y %Z" -f "%s" "$expiration_date")

# Текущая дата в секундах
current_seconds=$(date +%s)

# Вычисляем разницу между текущей датой и датой истечения сертификата
days_left=$(( (expiration_seconds - current_seconds) / 86400 ))

if [ $days_left -gt 0 ]; then
echo "Сертификат действителен еще $days_left дней."
else
echo "Сертификат истек или недействителен!"
fi

echo
done

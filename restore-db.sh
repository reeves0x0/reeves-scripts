#!/bin/bash

# Установите ваш электронный адрес
email="your_email@example.com"

# Установите имя базы данных, имя пользователя и пароль
db_name="database_name"
db_user="database_user"
db_pass="database_password"

# Путь к файлу резервной копии базы данных
backup_file="/path/to/backup_file.sql"

# Получаем имя хоста
hostname=$(hostname)

# Проверяем свободное место на диске
free_space=$(df / | tail -1 | awk '{print $4}')
min_space=51200000

if [ $free_space -lt $min_space ]; then
    free_space_gb=$(echo "scale=2; $free_space / 1024 / 1024" | bc)
    echo "Host: $hostname, Free space: $free_space_gb GB" | mail -s "Host: $hostname, Free space: $free_space_gb GB" $email
else
    # Восстанавливаем базу данных
    mysql_output=$(mysql -u $db_user -p$db_pass $db_name < $backup_file 2>&1)

    # Проверяем статус восстановления
    if [ $? -eq 0 ]; then
        echo "Host: $hostname, SUCCESS" | mail -s "Host: $hostname, SUCCESS" $email
    else
        echo "Host: $hostname, MySQL Error: $mysql_output" | mail -s "Host: $hostname, MySQL Error" $email
    fi
fi

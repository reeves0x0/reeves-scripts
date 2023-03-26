#!/bin/bash

#мой скрипт для быстрого создания systemd сервиса, который будет запускать какой то скрипт. Заменить переменные SERVICE_NAME и SCRIPT_PATH

SERVICE_NAME="my_custom_service"
SCRIPT_PATH="/path/to/your/script-2.sh"

# Создаем файл сервиса
echo "[Unit]
Description=My Custom Service
After=network.target

[Service]
Type=simple
ExecStart=$SCRIPT_PATH
Restart=on-failure
User=root
Group=root

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/$SERVICE_NAME.service

# Обновляем список сервисов и включаем автозапуск
systemctl daemon-reload
systemctl enable $SERVICE_NAME.service

# Запускаем сервис
systemctl start $SERVICE_NAME.service

# Проверяем статус сервиса
systemctl status $SERVICE_NAME.service

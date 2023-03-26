#!/bin/bash

# Убедитесь, что скрипт запущен с правами администратора
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root"
  exit 1
fi

# Приветственное сообщение
echo "Данный скрипт установит следующие программы:"
echo "1.  Zsh, Oh My Zsh, Git, yay"
echo "2.  Архиваторы (p7zip, unzip, unrar, zip)"
echo "3.  NetworkManager и модули VPN"
echo "4.  Офисные программы (LibreOffice-still-ru)"
echo "5.  Веб-браузеры (Firefox, Chromium)"
echo "6.  Утилиты для сети (inetutils)"
echo "7.  Утилиты для скриншотов (flameshot)"
echo "8.  Торрент-клиент (qBittorrent)"
echo "9.  Поддержка файловой системы NTFS (ntfs-3g)"
echo "10. Мессенджеры (Telegram, qTox)"
echo "11. IDE и текстовые редакторы (PyCharm, Gedit)"
echo "12. Программа для шифрования (VeraCrypt)"
echo "13. FTP-клиент (FileZilla)"
echo "14. Инструмент для работы с базами данных (DBeaver)"
echo "15. Терминал с всплывающим окном (Yakuake)"
echo "16. Системный монитор (htop)"
echo ""

# Запрос на подтверждение пользователя
read -p "Вы хотите установить все перечисленные программы? (y/n): " choice

if [[ $choice != "y" && $choice != "Y" ]]; then
  echo "Установка отменена."
  exit 1
fi


# Обновление системы
pacman -Syu --noconfirm

# Установка zsh и git
pacman -S --noconfirm zsh git

# Установка oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)

# Установка yay (AUR helper)
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si --noconfirm
cd /
rm -rf /tmp/yay

# Установка архиваторов
pacman -S --noconfirm p7zip unzip unrar zip

# Установка NetworkManager и модулей VPN
pacman -S --noconfirm networkmanager networkmanager-openvpn networkmanager-vpnc networkmanager-openconnect networkmanager-pptp networkmanager-l2tp

# Включение NetworkManager
systemctl enable NetworkManager
systemctl start NetworkManager

# Установка офисных программ
pacman -S --noconfirm libreoffice-still-ru

# Установка веб-браузеров
pacman -S --noconfirm firefox chromium

# Установка утилит для сети
pacman -S --noconfirm inetutils

# Установка утилит для скриншотов
pacman -S --noconfirm flameshot

# Установка торрент-клиента
pacman -S --noconfirm qbittorrent

# Установка поддержки файловой системы NTFS
pacman -S --noconfirm ntfs-3g

# Установка мессенджеров
pacman -S --noconfirm telegram-desktop
yay -S --noconfirm qtox

# Установка IDE и текстовых редакторов
yay -S --noconfirm pycharm-community-edition
pacman -S --noconfirm gedit

# Установка программы для шифрования
yay -S --noconfirm veracrypt

# Установка FTP-клиента
pacman -S --noconfirm filezilla

# Установка инструмента для работы с базами данных
pacman -S --noconfirm dbeaver

# Установка терминала с всплывающим окном
pacman -S --noconfirm yakuake

# Установка системного монитора
pacman -S --noconfirm htop

# Вывод информации об успешной настройке
echo "Arch Linux configuration completed"


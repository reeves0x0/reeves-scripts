#!/bin/bash

# 1. При запуске просит указать имя пользователя
echo "Введите имя пользователя:"
read USERNAME

# Проверка существования пользователя
if ! id -u "$USERNAME" >/dev/null 2>&1; then
  echo "Пользователь не найден."
  exit 1
fi

# 2. В домашней папке пользователя в .bashrc вставляем две строки
HOME_DIR=$(eval echo "~$USERNAME")
BASHRC="${HOME_DIR}/.bashrc"

echo "neofetch" >> "$BASHRC"
echo 'PS1="\[\e[31m\]\h\[\e[m\]@\[\e[32m\]\u\[\e[m\]*\[\e[33m\]\w\[\e[m\] "' >> "$BASHRC"

# Если находит файл .zshrc, то вставляет в него строку
ZSHRC="${HOME_DIR}/.zshrc"
if [ -f "$ZSHRC" ]; then
  echo 'PS1="%F{120}%n%F{red}@%F{green}%m:%F{141}%d$ %F{reset}"' >> "$ZSHRC"
fi

# 3. Потом в папке пользователя находит файл .config/mc/ini и меняет там строку
MC_INI="${HOME_DIR}/.config/mc/ini"
if [ -f "$MC_INI" ]; then
  sed -i 's/skin=default/skin=xoria256/' "$MC_INI"
fi

# 4. Заменяет содержимое файла /etc/screenrc
SCREENRC="/etc/screenrc"

cat > "$SCREENRC" << EOF
startup_message off
defscrollback 5000
termcapinfo xterm ti@:te@
termcapinfo xterm-color ti@:te@
hardstatus alwayslastline
hardstatus string '%{gk}[%{G}%H%{g}][%= %{wk}%?%-Lw%?%{=b kR}(%{W}%n*%f %t%?(%u)%?%{=b kR})%{= kw}%?%+Lw%?%?%= %{g}]%{=b C}[%m/%d/%y %C %A]%{W}'
vbell off
shell -$SHELL
logtstamp on
logtstamp after 1
termcapinfo xterm* ti@:te@
term xterm-256color
EOF

#!/bin/bash

# Укажите путь к zip-файлу бэкапа
ZIP_FILE="$HOME/backup-YYYY-MM-DD_HH-MM-SS.zip"

# Проверяем существование файла бэкапа
if [ ! -e "$ZIP_FILE" ]; then
  echo "Error: Backup file $ZIP_FILE not found"
  exit 1
fi

# Извлекаем файлы из архива
TEMP_RESTORE_DIR="$HOME/restore-$(date +%Y-%m-%d_%H-%M-%S)"
mkdir -p "$TEMP_RESTORE_DIR"
unzip "$ZIP_FILE" -d "$TEMP_RESTORE_DIR"

# Восстанавливаем файлы и папки
cp -r "$TEMP_RESTORE_DIR/.ssh" "$HOME"
cp -r "$TEMP_RESTORE_DIR/job" "$HOME"
cp -r "$TEMP_RESTORE_DIR/own" "$HOME"
cp "$TEMP_RESTORE_DIR/.bashrc" "$HOME"
cp "$TEMP_RESTORE_DIR/.zshrc" "$HOME"

# Устанавливаем правильные права на файлы
chmod 700 "$HOME/.ssh"
chmod 600 "$HOME/.ssh/authorized_keys" 2>/dev/null
chmod 600 "$HOME/.ssh/id_rsa" 2>/dev/null
chmod 644 "$HOME/.ssh/id_rsa.pub" 2>/dev/null
chmod 600 "$HOME/.ssh/known_hosts" 2>/dev/null
chmod 600 "$HOME/.bashrc"
chmod 600 "$HOME/.zshrc"

# Удаляем временную папку восстановления
rm -rf "$TEMP_RESTORE_DIR"

# Выводим информацию о завершении восстановления
echo "Restore completed"

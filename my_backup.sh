#!/bin/bash

# Указываем исходные данные для бэкапа
BACKUP_SOURCE=(
  "$HOME/.ssh"
  "$HOME/job"
  "$HOME/own"
  "$HOME/.bashrc"
  "$HOME/.zshrc"
)

# Создаем папку для бэкапа
BACKUP_DIR="$HOME/backup-$(date +%Y-%m-%d_%H-%M-%S)"
mkdir -p "$BACKUP_DIR"

# Копируем файлы и папки в папку бэкапа
for item in "${BACKUP_SOURCE[@]}"; do
  if [ -e "$item" ]; then
    cp -r "$item" "$BACKUP_DIR"
  else
    echo "Warning: $item not found"
  fi
done

# Упаковываем папку бэкапа в архив zip
ZIP_FILE="$HOME/backup-$(date +%Y-%m-%d_%H-%M-%S).zip"
zip -r "$ZIP_FILE" "$BACKUP_DIR"

# Удаляем временную папку бэкапа
rm -rf "$BACKUP_DIR"

# Выводим информацию о созданном бэкапе
echo "Backup created: $ZIP_FILE"

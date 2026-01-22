#!/bin/bash
OUTPUT_FILE="directory_dump.txt"
echo "=== СТРУКТУРА ДИРЕКТОРИЙ ===" > $OUTPUT_FILE
find . -type d | sort >> $OUTPUT_FILE

echo -e "\n\n=== ФАЙЛЫ И ИХ СОДЕРЖИМОЕ ===" >> $OUTPUT_FILE
find . -type f -name "*" | while read file; do
    echo -e "\n\n=== Файл: $file ===" >> $OUTPUT_FILE
    echo "Разрешения: $(ls -la "$file" | awk '{print $1}')" >> $OUTPUT_FILE
    echo "Владелец: $(ls -la "$file" | awk '{print $3}')" >> $OUTPUT_FILE
    echo "Размер: $(ls -la "$file" | awk '{print $5}') байт" >> $OUTPUT_FILE
    echo "--- Содержимое ---" >> $OUTPUT_FILE
    if [[ "$file" == *.yml ]] || [[ "$file" == *.yaml ]] || [[ "$file" == *.cfg ]] || [[ "$file" == *.txt ]] || [[ "$file" == *.ini ]]; then
        cat "$file" >> $OUTPUT_FILE 2>/dev/null || echo "[бинарный файл или нет прав]" >> $OUTPUT_FILE
    else
        head -50 "$file" >> $OUTPUT_FILE 2>/dev/null || echo "[бинарный файл или нет прав]" >> $OUTPUT_FILE
    fi
done

csad2627KI407MitiaievOleksandrViachelslavovych14

ПІП: [ПІП]  
Група: [група]  
Варіант: 14 (Python, venv + скрипт запуску, pytest)

## Опис проєкту

Проєкт демонструє створення кросплатформного Python Hello World із віртуальним середовищем `venv`, скриптами запуску, тестами `pytest` і CI на GitHub Actions для Windows, Linux та macOS. Для підготовки структури й перевірок використовується агент VS Code Copilot `build-engineer`.

## Запуск агента

1. Відкрийте папку репозиторію у VS Code.
2. Перейдіть у гілку `feature`, у якій агент створює файли проєкту, тестів і CI.
3. Відкрийте Copilot Chat.
4. У списку агентів виберіть `build-engineer`.
5. Виконайте команду `/init`.

Команда `/init` послідовно перевіряє Git і налаштовує `.gitignore`, створює Python-проєкт, build-скрипти й тести, додає GitHub Actions та запускає фінальну перевірку.

## Commands

- `/git-init` — перевірити Git-репозиторій і підготувати `.gitignore`.
- `/create-project` — створити структуру Python Hello World проєкту.
- `/create-build` — налаштувати залежності, локальні скрипти й тести.
- `/create-actions` — створити CI workflow для Windows, Linux і macOS.
- `/check` — перевірити проєкт, тести, CI та Git ignore-правила без виправлення файлів.
- `/init` — послідовно виконати всі кроки початкового налаштування та перевірки.
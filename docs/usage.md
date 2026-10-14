# Використання

Усі команди проєкту запускайте з кореня репозиторію. Для створення файлів проєкту перейдіть у гілку `feature`.

## Запуск агента

1. Відкрийте папку репозиторію у VS Code.
2. Відкрийте Copilot Chat.
3. Виберіть агента `build-engineer`.
4. Для повного налаштування виконайте `/init`.
5. Для окремої read-only перевірки виконайте `/check`.

## Локальна збірка та перевірка

Linux/macOS:

```sh
./ci.sh
```

Windows:

```bat
ci.bat
```

## Запуск Hello World

Запустити зібрану копію:

```sh
python3 dist/hello.py
```

```bat
python dist\hello.py
```

Або запустити скрипт проєкту, який використовує `.venv`:

```sh
./run.sh
```

```bat
run.bat
```

## Запуск тестів

Linux/macOS:

```sh
.venv/bin/python -m pytest -v
```

Windows:

```bat
.venv\Scripts\python -m pytest -v
```
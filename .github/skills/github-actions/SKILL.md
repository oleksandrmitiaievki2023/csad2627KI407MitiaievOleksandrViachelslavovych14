---
name: github-actions
description: "Use when creating or validating the GitHub Actions workflow for the Python project on Linux, Windows, and macOS."
---

# GitHub Actions

Створи кросплатформний GitHub Actions workflow для наявного Python-проєкту. Цей skill описує майбутній workflow; у гілці `develop` створюй лише інструкції агента, skills, prompt-команди та документацію. Файл workflow створюй у гілці `feature`.

## Вхід

- Наявні CI-скрипти `ci.sh` і `ci.bat`.
- `ci.sh` має бути виконуваним у Git.

## Вихід

Створи `.github/workflows/ci.yml` з такими властивостями:

- Тригери `push` і `pull_request`, кожен лише для гілок `develop` і `master`.
- Одна job із `runs-on: ${{ matrix.os }}` та матрицею `os: [ubuntu-latest, windows-latest, macos-latest]`; встанови `fail-fast: false`.
- Кроки: checkout, `actions/setup-python@v5` із `python-version: "3.12"`, запуск відповідного CI-скрипту та завантаження артефакту.
- На `ubuntu-latest` і `macos-latest` запускай `./ci.sh` із `shell: bash`.
- На `windows-latest` запускай `ci.bat` із `shell: cmd`.
- Завантажуй `dist/` через `actions/upload-artifact@v4`; ім'я має бути `hello-${{ matrix.os }}`, а `if-no-files-found` — `error`.
- У жодному кроці `run` не викликай Python, pip чи pytest напряму. Workflow запускає тільки `./ci.sh` або `ci.bat`; залежностями, тестами й `dist/` керують ці скрипти.
- Workflow не має потребувати облікових даних або читати чи виводити конфіденційні значення.

Приклад структури workflow:

```yaml
name: CI

on:
  push:
    branches: [develop, master]
  pull_request:
    branches: [develop, master]

jobs:
  build:
    runs-on: ${{ matrix.os }}
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - name: Run CI on Linux and macOS
        if: ${{ matrix.os != 'windows-latest' }}
        shell: bash
        run: ./ci.sh
      - name: Run CI on Windows
        if: ${{ matrix.os == 'windows-latest' }}
        shell: cmd
        run: ci.bat
      - uses: actions/upload-artifact@v4
        with:
          name: hello-${{ matrix.os }}
          path: dist/
          if-no-files-found: error
```

## Правила роботи

1. Перевір гілку та наявність CI-скриптів до створення workflow. Не створюй файл workflow у `develop`.
2. Перевір, чи `.github/workflows/ci.yml` уже існує. Не перезаписуй файл без перевірки; якщо його вміст відрізняється, повідом шлях і зупинись до запису.
3. Переконайся, що `ci.sh` має executable bit у Git. Якщо ні, встанови його командою `git update-index --chmod=+x -- ci.sh`; не змінюй mode інших файлів.
4. Не додавай окремі кроки встановлення Python-залежностей, запуску тестів або створення `dist/`: це відповідальність `ci.sh` і `ci.bat`.
5. Перед завершенням покажи diff або список змін і результати перевірок.

## Перевірки

- Перевір YAML через `actionlint`, якщо він доступний; інакше розбери файл Python-модулем `yaml`. Якщо використовуєш PyYAML, врахуй, що YAML 1.1 може трактувати ключ `on` як boolean; для структурної перевірки застосуй сумісний loader або перевір отриману структуру відповідно.
- Переконайся, що в workflow є всі три runner-и: `ubuntu-latest`, `windows-latest`, `macos-latest`.
- Перевір усі поля тригерів, `fail-fast: false`, Python `3.12`, оболонки та команди платформних кроків.
- Переконайся, що в полях `run` немає прямих команд Python, pip або pytest, а є лише `./ci.sh` і `ci.bat`.
- Переконайся, що upload step використовує `actions/upload-artifact@v4`, `hello-${{ matrix.os }}`, `dist/` і `if-no-files-found: error`.
- Переконайся, що в `.github/workflows/ci.yml` немає слів `token`, `password` або `secret` без урахування регістру.
- Перевір Git mode `100755` для `ci.sh`. Якщо скрипт не має executable bit, зупинись із поясненням; не вважай CI готовим.

## Приклад

Вхід:

```text
Наявні скрипти: ci.sh, ci.bat
Гілки: develop, master
Операційні системи: ubuntu-latest, windows-latest, macos-latest
```

Очікуваний результат:

```text
.github/workflows/ci.yml валідний
Матриця: ubuntu-latest, windows-latest, macos-latest
Linux/macOS: ./ci.sh (bash)
Windows: ci.bat (cmd)
Артефакт: hello-${{ matrix.os }} з dist/
```

Типова помилка: `ci.sh` не має executable bit, тому запуск `./ci.sh` завершується помилкою. Виправ лише mode `ci.sh` через `git update-index --chmod=+x -- ci.sh`, повторно перевір його та повідом результат.
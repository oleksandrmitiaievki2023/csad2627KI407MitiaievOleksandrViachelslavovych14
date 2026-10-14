---
name: build-and-test
description: "Use when adding or checking pytest configuration, test_basic_addition, venv-based run and CI scripts, and the dist output for the Python Hello World project."
---

# Build and Test

Налаштуй встановлення залежностей, локальний запуск, юніт-тестування та підготовку `dist/` для наявного Python-проєкту. Цей skill описує майбутні файли проєкту; у гілці `develop` створюй лише інструкції агента, skills, prompt-команди та документацію. Проєктні файли створюй у гілці `feature`.

## Вхід

- Наявні `src/hello.py` і `src/add.py`.

## Вихід

- `requirements.txt` містить `pytest>=7` рівно один раз; зберігай усі інші наявні залежності.
- `pytest.ini` містить:

  ```ini
  [pytest]
  pythonpath = src
  testpaths = tests
  ```

- `tests/test_basic.py` імпортує `add` і визначає тест:

  ```python
  from add import add


  def test_basic_addition():
      assert add(2, 3) == 5
  ```

- `run.sh` і `run.bat` створюють `.venv`, лише якщо його ще немає, встановлюють `requirements.txt` через Python з `.venv` і запускають `src/hello.py` через той самий інтерпретатор.
- `ci.sh` і `ci.bat` створюють `.venv`, якщо його немає, встановлюють `requirements.txt`, виконують `python -m pytest -v` через Python з `.venv`, а після успішних тестів копіюють `src/hello.py` і `src/add.py` у `dist/`.
- `run.sh` і `ci.sh` мають executable bit у Git. `.venv/` виключено з Git.

## Створення середовища

- Linux/macOS: якщо `.venv` відсутній, виконай `python3 -m venv .venv`.
- Windows: якщо `.venv` відсутній, виконай `python -m venv .venv`.
- Не видаляй і не перестворюй наявний `.venv`. Якщо він пошкоджений або не містить очікуваного інтерпретатора, повідом про це й зупинись.
- Не використовуй `activate`. Усі встановлення пакетів, запуски Python, pytest і перевірки скрипту виконуй безпосередньо через інтерпретатор середовища:
  - Linux/macOS: `.venv/bin/python`
  - Windows: `.venv\Scripts\python`
- Створення самого середовища є винятком: для нього використовуй системні `python3` або `python` згідно з платформою.
- Якщо команда створення venv не знаходить `python3` чи `python`, зупинись і повідом точну відсутню команду та потрібну платформну альтернативу. Не переходь непомітно на інший інтерпретатор.

## Вимоги до скриптів

### Linux/macOS

- Обидва скрипти починаються з `#!/usr/bin/env bash` і `set -euo pipefail`.
- `run.sh` створює `.venv` за відсутності, виконує `.venv/bin/python -m pip install -r requirements.txt`, потім `.venv/bin/python src/hello.py`.
- `ci.sh` створює `.venv` за відсутності, виконує `.venv/bin/python -m pip install -r requirements.txt`, потім `.venv/bin/python -m pytest -v`; лише після успішного pytest створює `dist/` і копіює туди обидва модулі з `src/`.
- Після створення скриптів додай їх до Git-індексу та виконай `git update-index --chmod=+x -- run.sh ci.sh`. Переконайся, що Git показує mode `100755` для обох скриптів; не змінюй mode інших файлів.

### Windows

- `run.bat` створює `.venv` за відсутності командою `python -m venv .venv`, встановлює залежності командою `".venv\Scripts\python" -m pip install -r requirements.txt`, а потім запускає `".venv\Scripts\python" src\hello.py`.
- `ci.bat` створює `.venv` за відсутності, встановлює залежності через `".venv\Scripts\python" -m pip`, запускає `".venv\Scripts\python" -m pytest -v`, створює `dist\` і копіює обидва файли `src\` у `dist\` лише після успішних тестів.
- Після кожної команди, що може завершитися помилкою, негайно перевіряй `%errorlevel%` і заверши скрипт ненульовим кодом при помилці, наприклад: `if errorlevel 1 exit /b %errorlevel%`.
- Не розміщуй перевірку `%errorlevel%` після команди всередині багаторядкового блоку в дужках, де розкриття змінної може передувати виконанню команди. Для умовного створення venv використовуй керування потоком без такого блоку.

## Ідемпотентність і Git

- Не перестворюй `.venv`, якщо каталог уже існує.
- Не додавай повторний рядок `pytest>=7` до `requirements.txt`. Якщо вже є інша або конфліктна вимога до `pytest`, повідом про це, не перезаписуй файл і зупинись.
- Перевір `.gitignore`; додай `.venv/`, лише якщо цей шаблон ще не виключає середовище. Зберігай решту наявного вмісту.
- Не додавай `.venv/` до Git. Перед завершенням перевір, що він не відстежується.
- Не перезаписуй наявні файли з іншим вмістом. Повідом конфліктний шлях і зупинись до запису, щоб не залишити часткову зміну.

## Перевірки

- Запусти `ci.sh` на Linux/macOS або `ci.bat` на Windows. Переконайся, що `python -m pytest -v` через Python з `.venv` показує `test_basic_addition PASSED` і завершується успішно.
- Переконайся, що існує `dist/hello.py`.
- Перевір копію через Python із `.venv`: Linux/macOS — `.venv/bin/python dist/hello.py`; Windows — `".venv\Scripts\python" dist\hello.py`. Очікуваний stdout: `Hello, World!`.
- Переконайся, що `run.sh` і `ci.sh` мають Git mode `100755`, а `.venv/` не відстежується.
- Якщо `python` або `python3` не знайдено, чи перевірку неможливо виконати на поточній ОС, повідом конкретну причину та не оголошуй відповідний критерій пройденим.

## Приклад

Вхід:

```text
Наявні файли: src/hello.py, src/add.py
Платформа: Linux
```

Очікуваний результат перевірок:

```text
$ .venv/bin/python -m pytest -v
tests/test_basic.py::test_basic_addition PASSED

$ .venv/bin/python dist/hello.py
Hello, World!
```

Типові помилки: `python3` відсутній на Linux/macOS або `python` відсутній на Windows; використання неправильного шляху інтерпретатора (`.venv/bin/python` проти `.venv\Scripts\python`); `.venv/` потрапив до Git; pytest не пройшов, тому `dist/` не був підготовлений. Зупинись на помилці, назви причину й не вважай роботу успішною.
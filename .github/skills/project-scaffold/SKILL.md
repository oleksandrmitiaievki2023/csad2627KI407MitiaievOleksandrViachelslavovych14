---
name: project-scaffold
description: "Use when scaffolding the Python Hello World project, creating src/hello.py and src/add.py, and ensuring tests/, docs/, and README.md are present without overwriting existing files."
---

# Project Scaffold

Створи мінімальний Python-проєкт Hello World у корені репозиторію. Цей skill описує майбутні файли проєкту; у гілці `develop` створюй лише інструкції агента, skills, prompt-команди та документацію. Scaffold-файли створюй у гілці `feature`.

## Вхід

- `language=Python`
- `project_name=hello`

## Вихід

- `src/hello.py` друкує `Hello, World!` та використовує функцію `add` з модуля `add`.
- `src/add.py` визначає `def add(a: int, b: int) -> int` і повертає суму аргументів.
- Каталоги `tests/` і `docs/` існують та залишаються порожніми.
- `README.md` створюється лише якщо його ще немає.

Приклад вмісту `src/hello.py`:

```python
from add import add

print("Hello, World!")
assert add(1, 2) == 3
```

Приклад вмісту `src/add.py`:

```python
def add(a: int, b: int) -> int:
    return a + b
```

## Правила створення

1. Перевір поточну гілку. Не створюй scaffold-файли в `develop`; виконуй цю дію у `feature`.
2. Перевір наявність кожного цільового файлу до будь-якого запису: `src/hello.py`, `src/add.py` і `README.md`.
3. Ніколи не перезаписуй наявні файли. Якщо наявний файл має інший вміст, повідом його шлях і зупинись до внесення змін, щоб не залишити частково створений scaffold. Якщо вміст уже відповідає потрібному, залиш файл без змін.
4. Створи відсутні файли, каталоги `tests/` і `docs/`, а також `README.md` лише за його відсутності. Не додавай файлів-заповнювачів у порожні каталоги.
5. Не видаляй файли та не змінюй вміст, не пов'язаний із цим scaffold.

## Перевірки

- Переконайся, що `src/hello.py` існує.
- Запускай скрипт із кореня репозиторію:
  - Linux/macOS: `python3 src/hello.py`
  - Windows: `python src\hello.py`
- Переконайся, що запуск завершується успішно та друкує `Hello, World!`.
- Повідом, якщо запуск неможливо перевірити в поточному середовищі; не оголошуй цю перевірку пройденою.

## Приклад

Вхід:

```text
language=Python
project_name=hello
```

Очікуваний результат на Linux/macOS:

```text
$ python3 src/hello.py
Hello, World!
```

Очікуваний результат на Windows:

```text
> python src\hello.py
Hello, World!
```

Типова помилка: цільовий файл уже існує з іншим вмістом. У такому разі назви конфліктний шлях, нічого не перезаписуй і зупинись.
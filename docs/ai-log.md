1. ```text
Я роблю лабораторну роботу: AI-агент для VS Code Copilot, який у репозиторії
генерує кросплатформний Python проєкт Hello World (venv + скрипт запуску + pytest) і CI
на GitHub Actions (Windows, Linux, macOS).
Зараз я в гілці develop і створюю ТІЛЬКИ інструкції агента (manifest, skills,
prompts-команди, документацію). Не створюй src/, tests/, requirements.txt, pytest.ini, run.sh, run.bat, ci.yml, ci.sh, ci.bat:
їх згенерує агент пізніше в гілці feature.
Файли створюй по одному, коли я попрошу. Мова інструкцій: українська,
імена файлів і команд: англійською.
   ```

2. ```text
Створи файл .github/agents/build-engineer.agent.md з YAML frontmatter
(description, tools) і розділами:
1. Роль: build engineer для Python/venv проєктів.
2. Область відповідальності: scaffold, збірка, юніт-тести, CI.
3. Доступні skills: project-scaffold, build-and-test, github-actions (з
   шляхами).
4. Доступні commands: git-init, create-project, create-build, create-actions,
   check, init (з коротким описом).
5. Правила роботи з файлами: ніколи не перезаписувати наявні файли без
   перевірки; ідемпотентність (повторний запуск не дублює вміст); показувати
   diff/список змін перед завершенням.
6. Заборонені дії: видалення файлів, git push --force, переписування історії,
   зміна захисту гілок, робота з секретами/токенами, публікація даних.
7. Порядок роботи.
8. Критерії успішного завершення: існує dist/hello.py і python dist/hello.py друкує Hello, World!; тест test_basic_addition (pytest) проходить; ci.yml містить ubuntu/windows/macos і лише викликає ci.sh/ci.bat; .venv/ і dist/ не під Git; check завершується без помилок.
9. Поведінка при помилці: зупинитись, показати причину, не вважати роботу успішною.
   ```

3. ```text
Створи .github/skills/project-scaffold/SKILL.md.
Frontmatter: name: project-scaffold, description (коли застосовувати).
Вхід: language=Python, project_name=hello.
Вихід: src/hello.py (друкує "Hello, World!" і використовує add), src/add.py
(def add(a: int, b: int) -> int), порожні каталоги tests/ та docs/, README (якщо немає).
Правила: не перезаписувати наявні файли; якщо файл існує і відрізняється, повідомити.
Перевірки: src/hello.py існує; вказана команда запуску (python3 src/hello.py на
Linux/macOS або python src\hello.py на Windows). Типова помилка: файл вже існує
з іншим вмістом.
Додай приклад входу та очікуваного результату.
   ```

4. ```text
Створи .github/skills/build-and-test/SKILL.md.
Frontmatter: name: build-and-test, description (коли застосовувати).
Вхід: наявні src/hello.py, src/add.py.
Вихід: requirements.txt (pytest>=7), pytest.ini ([pytest], pythonpath = src,
testpaths = tests), tests/test_basic.py з тестом test_basic_addition
(assert add(2, 3) == 5), скрипти запуску run.sh (bash, set -euo pipefail) і run.bat:
створюють .venv, якщо його немає, ставлять requirements.txt і запускають src/hello.py;
скрипти ci.sh (bash, set -euo pipefail) і ci.bat: створюють .venv, ставлять
requirements.txt, виконують python -m pytest -v і копіюють src/hello.py та
src/add.py у dist/. Усі виклики робити через інтерпретатор з venv
(.venv/bin/python або .venv\Scripts\python), без activate. Для створення venv:
python3 -m venv .venv (Linux/macOS), python -m venv .venv (Windows).
ci.sh і run.sh мають бути виконуваними (git update-index --chmod=+x).
ci.bat і run.bat після кожної команди перевіряють %errorlevel% і завершуються з
ненульовим кодом при помилці.
Перевірки: pytest показує test_basic_addition PASSED; існує dist/hello.py і
python dist/hello.py друкує Hello, World!. Типові помилки: python/python3 не знайдено;
на Windows інтерпретатор у .venv\Scripts, на Linux/macOS у .venv/bin; .venv
не повинен потрапляти в Git. Ідемпотентність: не перестворювати .venv, якщо він є;
не дублювати рядки в requirements.txt.
Додай приклад входу та очікуваного результату.
   ```

5. ```text
Створи .github/skills/github-actions/SKILL.md.
Frontmatter: name: github-actions, description (коли застосовувати).
Вихід: .github/workflows/ci.yml: тригери push і pull_request на develop та master;
одна job з matrix os: [ubuntu-latest, windows-latest, macos-latest], fail-fast: false;
кроки: checkout, actions/setup-python@v5 з python-version: "3.12", запуск ./ci.sh (не Windows, shell: bash) або ci.bat (Windows, shell: cmd),
upload-artifact з dist/ (actions/upload-artifact@v4, унікальне ім'я hello-${{ matrix.os }},
if-no-files-found: error). ВАЖЛИВО: у кроках run файлу ci.yml НЕ має бути команд python/pip/pytest напряму,
лише запуск ci.sh/ci.bat. Без секретів.
Перевірки: YAML валідний (python -c "import yaml..." або actionlint, якщо є);
у файлі є три ОС; немає слів token/password/secret.
Типова помилка: ci.sh без прав на виконання.
Додай приклад входу та очікуваного результату.
   ```

6. ```text
Створи .github/prompts/git-init.prompt.md.
Frontmatter: description, agent: build-engineer.
Розділи: Передумови, Дії, Очікувані файли, Команди перевірки, Повідомлення про помилку, Ідемпотентність.
Дії: перевірити, що поточний каталог є git-репозиторієм (git rev-parse); створити .gitignore або ДОПОВНИТИ його без дублів рядками build/, dist/, out/, .vs/, .venv/, venv/, __pycache__/, *.pyc, .pytest_cache/, .env, *.pem, *.key; показати git status.
Нічого не видаляти.
   ```

7. ```text
Створи .github/prompts/create-project.prompt.md.
Frontmatter: description, agent: build-engineer.
Розділи: Передумови (git-репозиторій), Дії (виконати інструкції зі skill .github/skills/project-scaffold/SKILL.md з language=Python, project_name=hello), Очікувані файли (src/hello.py, src/add.py), Команди перевірки (src/hello.py існує), Повідомлення про помилку, Ідемпотентність.
   ```

8. ```text
Створи .github/prompts/create-build.prompt.md.
Frontmatter: description, agent: build-engineer.
Розділи: Передумови (є src/hello.py, src/add.py), Дії (виконати skill .github/skills/build-and-test/SKILL.md), Очікувані файли (requirements.txt, pytest.ini, tests/test_basic.py, run.sh, run.bat, ci.sh, ci.bat), Команди перевірки, Повідомлення про помилку, Ідемпотентність.
   ```

9. ```text
Створи .github/prompts/create-actions.prompt.md.
Frontmatter: description, agent: build-engineer.
Розділи: Передумови (є ci.sh і ci.bat), Дії (виконати skill .github/skills/github-actions/SKILL.md), Очікувані файли (.github/workflows/ci.yml), Команди перевірки (валідність YAML, три ОС, виклик лише ci.sh/ci.bat), Повідомлення про помилку, Ідемпотентність.
   ```

10. ```text
Створи .github/prompts/check.prompt.md.
Frontmatter: description, agent: build-engineer.
Режим: ТІЛЬКИ ЧИТАННЯ. Не створювати і не змінювати файли проєкту (тимчасові каталоги .venv/, .pytest_cache/ дозволені, вони в .gitignore).
Виконати перевірки і вивести таблицю PASS/FAIL:
1. Існують .github/agents/build-engineer.agent.md і три SKILL.md.
2. Кожен skill має розділи Вхід, Вихід, Перевірки.
3. Існують src/hello.py, src/add.py, tests/test_basic.py, requirements.txt, pytest.ini, run.sh, run.bat, ci.sh, ci.bat.
4. Створення середовища (python3 -m venv .venv; на Windows python -m venv .venv) і pip install -r requirements.txt проходять.
5. python -m pytest -v з інтерпретатором із .venv: test_basic_addition passed.
6. src/hello.py запускається інтерпретатором із .venv і друкує Hello, World!.
7. ci.yml: валідний YAML, містить ubuntu-latest, windows-latest, macos-latest, у кроках run викликає лише ci.sh/ci.bat (без прямих команд python/pip/pytest).
8. git ls-files не містить build/, dist/, .venv/, .env, *.key, *.pem.
9. .gitignore містить build/, dist/ і .venv/.
Якщо є хоча б один FAIL: вказати який саме і завершити зі статусом FAILED. Якщо все PASS: статус PASSED.
Додай розділи: Передумови, Повідомлення про помилку.
   ```

11. ```text
Створи .github/prompts/init.prompt.md.
Frontmatter: description, agent: build-engineer.
Ти оркестратор. Виконуй кроки СТРОГО по порядку, читаючи і виконуючи інструкції з файлів:
1. .github/prompts/git-init.prompt.md
2. .github/prompts/create-project.prompt.md
3. .github/prompts/create-build.prompt.md
4. .github/prompts/create-actions.prompt.md
5. .github/prompts/check.prompt.md
Після кожного кроку перевіряй результат. Якщо крок завершився помилкою: ЗУПИНИСЬ, не виконуй наступні, виведи звіт (який крок, причина, що виправити). Не оголошуй успіх без PASSED від check.
Повторний запуск не повинен руйнувати чи дублювати наявні файли.
У кінці виведи таблицю: крок, статус, створені/змінені файли.
Додай розділи: Передумови, Очікувані файли, Повідомлення про помилку.
   ```

12. ```text
Онови README.md (зараз там лише назва репозиторія, збережи її): ПІП [ПІП], група [група], варіант 14 (Python, venv + скрипт запуску, pytest), короткий опис проєкту, розділ "Запуск агента": відкрити папку у VS Code, відкрити Copilot Chat, вибрати агента build-engineer, виконати /init. Додай список commands. Залиш плейсхолдери для ПІП і групи.
   ```

13. ```text
Створи docs/architecture.md з розділами:
1. Які проблеми вирішує агент.
2. Які skills використовує і за що вони відповідають.
3. Які commands доступні користувачу.
4. Які дані передаються між етапами (project_name -> src/ -> requirements.txt/pytest.ini/run.sh/run.bat -> ci.sh/ci.bat -> ci.yml).
5. Як оркестратор init обробляє помилки.
6. Таблиця відповідності файлів ролям: agent -> .github/agents/, skills -> .github/skills/, commands -> .github/prompts/.
7. Примітка, що використано формат VS Code Copilot (custom agents, prompt files, agent skills).
   ```
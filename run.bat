@echo off
if exist ".venv\Scripts\python.exe" goto venv_ready
if exist ".venv" goto invalid_venv
python -m venv .venv
if errorlevel 1 exit /b %errorlevel%

:venv_ready
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 exit /b %errorlevel%
".venv\Scripts\python.exe" src\hello.py
if errorlevel 1 exit /b %errorlevel%
exit /b 0

:invalid_venv
echo The existing .venv has no Windows Python interpreter. 1>&2
exit /b 1
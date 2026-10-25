@echo off
cd /d "%~dp0"
python tools\build_cup.py %*
if errorlevel 1 pause

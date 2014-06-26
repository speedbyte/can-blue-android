set MAKE_MODE=DOS
del /s /q %CD%\makeout\*
rmdir /s /p %CD%\makeout
mkdir %CD%\makeout
make -fMakefile
pause
set source_dir=.
set emacs_dir=C:\Users\Administrator\AppData\Roaming
set destination_dir=%emacs_dir%\.emacs.d

if not exist "%destination_dir%" mkdir "%destination_dir%"
xcopy /S /Q /Y "%source_dir%"  "%destination_dir%"

copy "%destination_dir%\.emacs" "%emacs_dir%\.emacs"
echo "Install Successfully! :-)\n"

#!/bin/sh

mkdir -p ~/.emacs.d
cp -r ./* ~/.emacs.d/
cp ./.emacs ~/.emacs.d/
cp ./.gitignore ~/.emacs.d/
cp -r ./.git ~/.emacs.d/

#cp ./.emacs  ~
cp ~/.emacs.d/.emacs ~
echo "Install Successfully! :-)"
echo

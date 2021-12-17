#!/bin/bash

cd ~
git clone https://github.com/lothan/.dotfiles.git
cd .dotfiles
stow zsh
stow emacs

# echo 'source /usr/share/pwndbg/gdbinit.py' >> ~/.gdbinit

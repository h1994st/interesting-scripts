#!/bin/bash

set -e;

# Install dependencies
SYSTEM=`uname -s`
if [SYSTEM = "Linux"] ; then
    echo "Linux"
    sudo apt-get install git vim ctags
fi

# Back-up
mv ~/.vim ~/vimbak
mv ~/.vimrc ~/.vimrc.bak
git clone https://github.com/h1994st/vim-conf.git ~/.vim

# Clone Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install plugins
vim +PluginInstall +qall
echo 'Done!'


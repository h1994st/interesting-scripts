#!/bin/bash

set -e;

# Install dependencies
SYSTEM=`uname -s`
if [ $SYSTEM = "Linux" ] ; then
    echo "Linux"
    sudo apt-get install git vim ctags
fi

# Back-up
if [ -d $HOME/.vim ] ; then
    mv $HOME/.vim $HOME/vimbak;
fi

if [ -e $HOME/.vimrc ] ; then
    mv $HOME/.vimrc $HOME/.vimrc.bak
fi

git clone https://github.com/h1994st/vim-conf.git $HOME/.vim

ln -s $HOME/.vim/vimrc $HOME/.vimrc

# Clone Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

# Install plugins
vim +PluginInstall +qall
echo 'Done!'


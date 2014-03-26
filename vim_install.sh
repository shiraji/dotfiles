#!/bin/bash
cd /usr/local/src
wget ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
tar jxvf vim-7.4.tar.bz2
cd vim74
mkdir patches
#http://ftp.vim.org/pub/vim/patches/7.4/
curl -O 'ftp://ftp.vim.org/pub/vim/patches/7.4/7.4.[001-218]'
cd ..
cat patches/7.4.* | patch -p0
./configure --enable-multibyte --enable-xim --enable-fontset --with-features=big --prefix=$HOME/local
make && make install

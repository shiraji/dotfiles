#!/bin/bash

SRC_DIR="$HOME/src"
VIM74_DIR="/vim74"
WORK_DIR=${SRC_DIR}${VIM74_DIR}

mkdir -p ${SRC_DIR}
wget ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2 -P ${SRC_DIR}
tar jxvf ${SRC_DIR}/vim-7.4.tar.bz2 -C ${SRC_DIR}
mkdir -p ${WORK_DIR}/patches
#http://ftp.vim.org/pub/vim/patches/7.4/
curl -o ${WORK_DIR}/patches/7.4.#1 'ftp://ftp.vim.org/pub/vim/patches/7.4/7.4.[001-218]'

# makeとかはcurrentフォルダが重要なので、移動する。
cd ${WORK_DIR}
cat ${WORK_DIR}/patches/7.4.* | patch -p0
${WORK_DIR}/configure --enable-multibyte --enable-xim --enable-fontset --with-features=big --prefix=$HOME/local
make && make install

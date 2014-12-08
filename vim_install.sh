#!/bin/bash

SRC_DIR="$HOME/src"
VIM74_DIR="/vim74"
WORK_DIR=${SRC_DIR}${VIM74_DIR}
PATCH_DIR=${WORK_DIR}/patches
PATCH_NUMBER=1
MD5SUMS_FOR_DL_PATCH="MD5SUMS_DL"
MD5SUMS_FROM_SERVER="MD5SUMS"

__get_patch() {
  x=$1
  _is_background=$2

  if [ $x -gt $PATCH_NUMBER ]; then
    return
  fi

  _patch_number=`printf "%03d\n" $x`
  if [ $_is_background ]; then
    wget "ftp://ftp.vim.org/pub/vim/patches/7.4/7.4.${_patch_number}" -O ${PATCH_DIR}/7.4.${_patch_number} &
  else
    wget "ftp://ftp.vim.org/pub/vim/patches/7.4/7.4.${_patch_number}" -O ${PATCH_DIR}/7.4.${_patch_number}
  fi
}

# vim本体の準備
mkdir -p ${SRC_DIR}
wget -O ${SRC_DIR}/vim-7.4.tar.bz2 ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
tar jxvf ${SRC_DIR}/vim-7.4.tar.bz2 -C ${SRC_DIR}

# パッチの準備
mkdir -p ${PATCH_DIR}
cd ${PATCH_DIR}

# http://ftp.vim.org/pub/vim/patches/7.4/
# MD5SUMSからパッチ数を取得する。また、このファイルで後でDLの確認を行う
wget "ftp://ftp.vim.org/pub/vim/patches/7.4/MD5SUMS" -O ${PATCH_DIR}/${MD5SUMS_FROM_SERVER}
PATCH_NUMBER=`wc -l ${PATCH_DIR}/${MD5SUMS_FROM_SERVER} | cut -f1 -d ' '`

for (( x=1; x<=$PATCH_NUMBER; x=x+1 )); do
  __get_patch $x true
  __get_patch $(( x=$x+1 )) true
  __get_patch $(( x=$x+1 )) true
  __get_patch $(( x=$x+1 )) true
  __get_patch $(( x=$x+1 )) false
  sleep 5
done

# foregoundで終わるとは限らないので、10秒待つ。それでも終わってなかった場合、エラー。
sleep 10

# MD5SUMSのローカル側のファイルを初期化する。
cp /dev/null ${PATCH_DIR}/${MD5SUMS_FOR_DL_PATCH}

for (( x=1; x<=$PATCH_NUMBER; x=x+1)); do
  _patch_number1=`printf "%03d\n" $x`
  # MD5SUMSにはファイル名しか記載していないため、こちらもファイル名のみの指定にする
  md5sum 7.4.${_patch_number1} >> ${MD5SUMS_FOR_DL_PATCH}
done

# patchのDLの確認
diff ${PATCH_DIR}/${MD5SUMS_FOR_DL_PATCH} ${PATCH_DIR}/${MD5SUMS_FROM_SERVER}

if [ $? -eq 0 ]; then
  # makeとかはcurrentフォルダが重要なので、移動する。
  cd ${WORK_DIR}
  cat ${PATCH_DIR}/7.4.* | patch -p0
  ${WORK_DIR}/configure --enable-multibyte --enable-xim --enable-fontset --with-features=big --prefix=$HOME/local
  make && make install
else
  echo "patchのダウンロードに失敗しています。"
fi

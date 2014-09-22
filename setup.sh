#!/bin/bash

VIMRC=".vimrc"
ZSHRC=".zshrc"
SCREENRC=".screenrc"
TMUXCONF=".tmux.conf"
GEMRC=".gemrc"
VIM_CONF=".vim/conf"
GIT_CONFIG=".gitconfig"
TIG_DOWNLOAD_DIR="~/tig"
TIGRC=".tigrc"

#$HOME以下にある設定ファイル。スペースで分ける。
DOT_FILES=( .bashrc $VIM_CONF $VIMRC $GIT_CONFIG .gitignore $ZSHRC $SCREENRC $TMUXCONF $GEMRC $TIGRC )

# もし、パラメータが渡されていたら、そちらを利用する。
if [ $# -gt 0 ]; then
  DOT_FILES=()
  for var in "$@"
  do
    DOT_FILES+=($var)
  done
fi

__handule_current_file() {
  currentFile=$1
  if [ -e $currentFile ]; then
    if [ ! -L $currentFile ]; then
      #シンボリックリンクでなかったら、ファイルをバックアップ。
      backupFile=$currentFile.`date "+%Y%m%d%H%M%S"`
      cp -prf $currentFile $backupFile
      echo "Create backup: $backupFile"
    fi
    #ファイルの削除。
    unlink $currentFile
    echo "Delete $currentFile"
  fi
}

__create_current_file_dir() {
  _currentFileDir=$1
  #シンボリックリンク作成対象のフォルダが存在していない場合、フォルダを作成する。
  if [ ! -d "${_currentFileDir}" ]; then
    mkdir -p ${_currentFileDir}
    echo "Create directory: ${_currentFileDir}"
  fi
}

__install_vimrc() {
  # vim74をインストールする
  bash ./vim_install.sh

  #neobundleをインストールする
  mkdir -p $HOME/.vim/bundle/
  git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
  bash ./neobundle_install.sh

  #NERDTreeのプラグインをインストールする。
  git clone git://gist.github.com/205807 ~/.vim/bundle/nerdtree/nerdtree_plugin/205807
}

__install_screenrc() {
  # screenのソケットの保存先をHOME直下にする
  mkdir $HOME/.screen
  chmod 700 $HOME/.screen
}

__install_tigrc() {
  # tigのインストール
  git clone https://github.com/jonas/tig.git $TIG_DOWNLOAD_DIR
  cd $TIG_DOWNLOAD_DIR
  make
  make install
  cd ~/dotfiles
}

for file in ${DOT_FILES[@]}
do
  # バリデーション
  if [ ! -e $file ]; then
    echo "$file does not exist"
    continue
  fi

  currentFile=$HOME/$file
  __handule_current_file $currentFile

  #絶対パスを探す
  _dir=$(dirname $HOME/dotfiles/setup.sh)
  __create_current_file_dir $(dirname ${currentFile})

  #リンクを張る
  ln -s ${_dir}/$file $currentFile
  echo "Create symbolic link: $currentFile"

  if [ "$file" = $VIMRC ]; then
    __install_vimrc_related
  fi

  if [ "$file" = $SCREENRC ]; then
    __install_screenrc
  fi

  if [ "$file" = $TIGRC ]; then
    __install_tigrc
  fi

done

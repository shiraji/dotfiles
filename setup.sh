#!/bin/bash

VIMRC="vimrc"
ZSHRC="zshrc"
SCREENRC="screenrc"
TMUXCONF="tmux.conf"
GEMRC="gemrc"
VIM_CONF="vim/conf"
GIT_CONFIG="gitconfig"
TIG_DOWNLOAD_DIR="$HOME/tig"
TIGRC="tigrc"
BASHRC="bashrc"
PECO="peco/config.json"
BIN="$HOME/bin"
NVIM_CONF="nvim/conf"
CONFIG="config"

_only_file_copy=false

#$HOME以下にある設定ファイル。スペースで分ける。
DOT_FILES=( $BASHRC $VIM_CONF $VIMRC $GIT_CONFIG $ZSHRC $SCREENRC $TMUXCONF $GEMRC $TIGRC $PECO $NVIM_CONF $CONFIG )

__parse_parameters() {
  var=$1
  TEMP_DOT_FILES=()
  case $var in
    -o|--only-file-copy)
    _only_file_copy=true
    shift
    ;;
    *)
    TEMP_DOT_FILES+=($var)
    shift
    ;;
  esac

  if [ ${#TEMP_DOT_FILES[@]} -ge 0 ]; then
    DOT_FILES=$TEMP_DOT_FILES
  fi
}

# もし、パラメータが渡されていたら、そちらを利用する。
if [ $# -gt 0 ]; then
  for var in "$@"
  do
    __parse_parameters $var
  done
fi

__prepare_current_file() {
  currentFile=$1
    if [ ! -L $currentFile ]; then
      #シンボリックリンクでなかったら、ファイルをバックアップ。
      backupFile=$currentFile.`date "+%Y%m%d%H%M%S"`
      cp -prf $currentFile $backupFile
      echo "Create backup: $backupFile"
    fi
    #ファイルの削除。
    unlink $currentFile
    echo "Delete $currentFile"
}

__create_current_file_dir() {
  _currentFileDir=$1
  #シンボリックリンク作成対象のフォルダが存在していない場合、フォルダを作成する。
  if [ ! -d "${_currentFileDir}" ]; then
    mkdir -p ${_currentFileDir}
    echo "Create directory: ${_currentFileDir}"
  fi
}

__install_vim() {
  # vim74をインストールする
  bash ./vim_install.sh

  #neobundleをインストールする
  mkdir -p $HOME/.vim/bundle/
  git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
  bash ./neobundle_install.sh

  #NERDTreeのプラグインをインストールする。
  git clone git://gist.github.com/205807 ~/.vim/bundle/nerdtree/nerdtree_plugin/205807
}

__install_zshrc() {
  # .zshフォルダの作成
  mkdir -p ~/.zsh/

  # zshのincremetal searchできるようにする
  curl -o ~/.zsh/incr-0.2.zsh -L http://mimosa-pudica.net/src/incr-0.2.zsh
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
  make && make install
  cd ~/dotfiles
}

__install_ssh_iterm_background_script() {
  if [ ! -d "$BIN/773849" ]; then
    git clone https://gist.github.com/pol/773849 $BIN/773849
  fi
}

for file in ${DOT_FILES[@]}
do
  # バリデーション
  if [ ! -e $file ]; then
    echo "$file does not exist"
    continue
  fi

  currentFile=$HOME/.$file
  __prepare_current_file $currentFile

  #絶対パスを探す
  _dir=$(dirname $HOME/dotfiles/setup.sh)
  __create_current_file_dir $(dirname ${currentFile})

  #リンクを張る
  ln -s ${_dir}/$file $currentFile
  echo "Create symbolic link: $currentFile"

  # ファイルコピーだけなら、ループに戻る
  if [ "$_only_file_copy" = true ]; then
    continue
  fi

  if [ "$file" = $VIMRC ]; then
    __install_vim
  fi

  if [ "$file" = $ZSHRC ]; then
    __install_zshrc
  fi

  if [ "$file" = $SCREENRC ]; then
    __install_screenrc
  fi

  if [ "$file" = $TIGRC ]; then
    __install_tigrc
  fi

done

# ファイルに関わらない設定をここでする。
if [ "$_only_file_copy" = false ]; then
  __install_ssh_iterm_background_script
fi

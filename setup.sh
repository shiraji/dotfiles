#!/bin/bash

VIMRC=".vimrc"
ZSHRC=".zshrc"
SCREENRC=".screenrc"
TMUXCONF=".tmux.conf"
GEMRC=".gemrc"
VIM_CONF=".vim/conf"

#$HOME以下にある設定ファイル。スペースで分ける。
DOT_FILES=( .bashrc $VIM_CONF $VIMRC .gitconfig .gitignore $ZSHRC $SCREENRC $TMUXCONF $GEMRC )

for file in ${DOT_FILES[@]}
do
	currentFile=$HOME/$file
	if [ -a $currentFile ]; then
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
	#リンクを張る

	#絶対パスを探す
	_dir=$(dirname $HOME/dotfiles/setup.sh)
	_currentFileDir=$(dirname ${currentFile})

	#シンボリックリンク作成対象のフォルダが存在していない場合、フォルダを作成する。
	if [ ! -d "${_currentFileDir}" ]; then
		mkdir -p ${_currentFileDir}
		echo "Create directory: ${_currentFileDir}"
	fi

	ln -s ${_dir}/$file $currentFile
	echo "Create symbolic link: $currentFile"

	if [ "$file" = $VIMRC ]; then
		#neobundleをインストールする
		mkdir -p $HOME/.vim/bundle/
		git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
		vim -e -c "NeoBundleInstall" -c "q" -c "q"

		#NERDTreeのプラグインをインストールする。
		git clone git://gist.github.com/205807 ~/.vim/bundle/nerdtree/nerdtree_plugin/205807
	fi

	if [ "$file" = $ZSHRC ]; then
		#oh-my-zshの設定を持ってくる。
		git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

    # .zshフォルダの作成
    mkdir -p ~/.zsh/

    # zshのincremetal searchできるようにする
    curl -o ~/.zsh/incr-0.2.zsh -L http://mimosa-pudica.net/src/incr-0.2.zsh
	fi

done

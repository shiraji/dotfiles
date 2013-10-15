# dotfiles
##概要
いろんなところで使われているdotfilesのぱくり。setup.shを利用することにより、シンボリックリンクが張られる。

##使い方
    git clone git@github.com:shiraji/dotfiles.git
    cd dotfiles
    bash setup.sh

##対象ファイルの増やし方
dotfilesの中に対象の設定ファイルを置き、setup.shのDOT_FILESの中にその対象ファイル名を記載する。

##setup.shの説明
setup.shはdotfilesにシンボリックリンクを貼ってくれる。
リリース先のファイルが存在しており、対象ファイルがシンボリックリンクではなかった場合、
そのファイルをバックアップしておく。バックアップ先はおなじフォルダに同じファイル名+.`date "+%Y%m%d%H%M%S"
また、現在、vimにはneobundle, zshにはoh-my-zshを利用しているため、それのインストールもする。

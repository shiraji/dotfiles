" NeoBundle 設定 ------------------------------------

set nocompatible
filetype off
if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim
	call neobundle#rc(expand('~/.vim/bundle/'))
endif

NeoBundle 'Shougo/neobundle.vim'
" 非同期処理用プラグイン
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin' : 'make -f make_cygwin.mak',
    \ 'mac' : 'make -f make_mac.mak',
    \ 'unix' : 'make -f make_unix.mak',
  \ },
\ }
" ruby用のプラグイン。ただ、vim --versionで+rubyになってないと使えない。
NeoBundle 'vim-ruby/vim-ruby'
" :Rcontrollerとかでファイルを開く
NeoBundle 'tpope/vim-rails'
" :Gwriteでgit addなど、Git系のプラグイン
NeoBundle 'tpope/vim-fugitive'
" Railsのテストフレームワーク、cucumberのプラグイン
NeoBundle 'tpope/vim-cucumber'
" vimで閉じタグを付けてくれる
NeoBundle 'tpope/vim-endwise'
" 複数コメント入れたり、消したり
NeoBundle 'scrooloose/nerdcommenter'
" nginxの設定ファイルの色つけ
NeoBundle 'nginx.vim'
" cssの色つけ
" NeoBundle 'css.vim'
" PHPのシンタックス
NeoBundle 'php.vim'
" 他のプラグインで使うライブラリ
NeoBundle 'L9'
" vimを開きつつ走らせる :QuickRun ruby
NeoBundle 'thinca/vim-quickrun'
" 保存時に構文チェック、その時に:Errorsとやれば何がダメか教えてくれる
NeoBundle 'scrooloose/syntastic'
" ファイルツリー表示
NeoBundle 'scrooloose/nerdtree'
" cacheなどからのコンプリーション
NeoBundle 'Shougo/neocomplcache.vim'
" タグなどの囲みをvimで扱いやすくする。cs"'で"を'へ。ds"で"削除など
NeoBundle 'tpope/vim-surround'
" Fuzzyfinder tfでファイル検索、tlで開いているファイルの中身の検索
NeoBundle 'FuzzyFinder'
" neosnippet。neocomplcacheのプラグイン。スニペットを利用できる
NeoBundle 'Shougo/neosnippet'
" neosnippetのデフォルトのsnippet
NeoBundle 'Shougo/neosnippet-snippets'
" nerdtreeプラグイン
NeoBundle 'jistr/vim-nerdtree-tabs'

filetype plugin indent on
filetype indent on


" NERDTree ---------------------------
"参照 http://blog.livedoor.jp/kumonopanya/archives/51048805.html

"<C-p>でNERDTreeをオンオフ。いつでもどこでも。
"map <silent> <C-p>   :NERDTreeToggle<CR>
"lmap <silent> <C-p>  :NERDTreeToggle<CR>
" nmap <silent> <C-p>      :NERDTreeToggle<CR>
" vmap <silent> <C-p> <Esc>:NERDTreeToggle<CR>
" omap <silent> <C-p>      :NERDTreeToggle<CR>
" imap <silent> <C-p> <Esc>:NERDTreeToggle<CR>
" cmap <silent> <C-p> <C-u>:NERDTreeToggle<CR>

"引数なしでvimを開いたらNERDTreeを起動、
"引数ありならNERDTreeは起動しない、引数で渡されたファイルを開く。
autocmd vimenter * if !argc() | NERDTree | endif

"他のバッファをすべて閉じた時にNERDTreeが開いていたらNERDTreeも一緒に閉じる。
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"NERDChristmasTree カラー表示する。
"Defaultでカラー表示、カラースキーマを設定しているとそちらが優先される？
"Values: 0 or 1.
"Default: 1.
"let g:NERDChristmasTree=1

"ファイルオープン後の動作
"0 : そのままNERDTreeを開いておく。
"1 : NERDTreeを閉じる。
"Values: 0 or 1.
"Default: 0
"let g:NERDTreeQuitOnOpen=0
"let g:NERDTreeQuitOnOpen=1

"NERDTreeIgnore 無視するファイルを設定する。
"'\.vim$'ならばfugitive.vimなどのファイル名が表示されない。
let g:NERDTreeIgnore=['\.clean$', '\.swp$', '\.bak$', '\~$']

"NERDTreeShowHidden 隠しファイルを表示するか？
"f コマンドの設定値
"0 : 隠しファイルを表示しない。
"1 : 隠しファイルを表示する。
"Values: 0 or 1.
"Default: 0.
"let g:NERDTreeShowHidden=0
let g:NERDTreeShowHidden=1

"ディレクトリだけ表示してファイル名は隠す。
"ファイルの表示、非表示をトグルするときの初期値。
"F コマンドの設定初期値
"0 : 最初からファイルを表示しない。
"1 : 最初からファイルを表示する。
"Values: 0 or 1.
"Default: 1.
"let g:NERDTreeShowFiles=0
"let g:NERDTreeShowFiles=1

"カーソルラインをハイライト表示する。
"（カラースキーマが優先される？）
"0 : 色付けしない。
"1 : カラー表示をする。
"Values: 0 or 1.
"Default: 1.
"let g:NERDTreeHighlightCursorline=0
"let g:NERDTreeHighlightCursorline=1

"ブックマークリストの表示。
"0 : ブックマークリストを最初から表示しない。
"1 : ブックマークリストを最初から表示する。
"Values: 0 or 1.
"Default: 0.
"let g:NERDTreeShowBookmarks=0
let g:NERDTreeShowBookmarks=1

"NERDTreeのツリーを開く場所、左側か、右側か。
"Values: "left" or "right"
"Default: "left".
"let g:NERDTreeWinPos="left"
"let g:NERDTreeWinPos="right"

"NERDTreeのツリーの幅
"Default: 31.
"let g:NERDTreeWinSize=45

"ブックマークや、ヘルプのショートカットをメニューに表示する。
"0 表示する
"1 表示しない
"Values: 0 or 1.
"Default: 1.
let g:NERDTreeMinimalUI=0
"let g:NERDTreeMinimalUI=1

"NERDTreeを+|`などを使ってツリー表示をする。
"ディレクトリが閉じている場合には+を先頭につける。
"ディレクトリが開いている場合には~を先頭につける。
"ファイルには-を先頭につける。
"0 : 綺麗に見せる。
"1 : +|`などを使わない
"Values: 0 or 1
"Default: 1.
let g:NERDTreeDirArrows=0
"let g:NERDTreeDirArrows=1

"マウス操作方法
"NERDTreeMouseMode
"Values: 1, 2 or 3.
"Default: 1.
"1 : ファイル、ディレクトリ両方共ダブルクリックで開く。
"2 : ディレクトリのみシングルクリックで開く。
"3 : ファイル、ディレクトリ両方共シングルクリックで開く。
"let g:NERDTreeMouseMode=1
let g:NERDTreeMouseMode=2
"let g:NERDTreeMouseMode=3

"NERDTreeBookmarksFile
"ブックマークを記録したファイルの設置場所を指定。
"Values: a path
"Default: $HOME/.NERDTreeBookmarks

"NERDTreeShowLineNumbers
"0 : 行番号を表示しない。
"1 : 行番号を表示する。
"Values: 0 or 1.
"Default: 0.
"let NERDTreeShowLineNumbers=0
"let NERDTreeShowLineNumbers=1

"NERDTreeStatusline NERDtreeウィンドウにステータスラインを表示。
"Values: Any valid statusline setting.
"Default: %{b:NERDTreeRoot.path.strForOS(0)}
let g:NERDTreeStatusline="m:menu u:up C:in"

"NERDTreeSortDirs表示されるディレクトリ名をソート
let g:NERDTreeSortDirs=1

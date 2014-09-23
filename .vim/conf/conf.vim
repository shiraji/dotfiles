" Common -------------------------------
set nocompatible				" vim
"colorscheme metroid			" カラースキームの設定
set background=light			" 背景色の傾向(カラースキームがそれに併せて色の明暗を変えてくれる)

" File ---------------------------------
set autoread				" 更新時自動再読込み
set hidden				" 編集中でも他のファイルを開けるようにする
set noswapfile				" スワップファイルを作らない
set nobackup				" バックアップを取らない
autocmd BufWritePre * :%s/\s\+$//ge	" 保存時に行末の空白を除去する
syntax on				" シンタックスカラーリングオン

" Indent -------------------------------
" tabstop:				Tab文字を画面上で何文字分に展開するか
" shiftwidth:				cindentやautoindent時に挿入されるインデントの幅
" softtabstop:				Tabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=2 shiftwidth=2 softtabstop=0
set autoindent smartindent		" 自動インデント，スマートインデント
set expandtab  " tabをスペースに置換。

" Assist imputting ---------------------
set backspace=indent,eol,start		" バックスペースで特殊記号も削除可能に
set formatoptions=lmoq			" 整形オプション，マルチバイト系を追加
set whichwrap=b,s,h,s,<,>,[,]		" カーソルを行頭、行末で止まらないようにする
if $TMUX == ''
  set clipboard=unnamed,autoselect		" バッファにクリップボードを利用する
endif
" set paste   " 常にペーストモード
set pastetoggle=<F11>   " ペーストモードを簡単にできるようにF11

" Complement Command -------------------
set wildmenu				" コマンド補完を強化
set wildmode=list:full			" リスト表示，最長マッチ

" Search -------------------------------
set wrapscan				" 最後まで検索したら先頭へ戻る
set ignorecase				" 大文字小文字無視
set smartcase				" 大文字ではじめたら大文字小文字無視しない
set incsearch				" インクリメンタルサーチ
set hlsearch				" 検索文字をハイライト

" View ---------------------------------
set showmatch				" 括弧の対応をハイライト
set showcmd				" 入力中のコマンドを表示
set showmode				" 現在のモードを表示
set number				" 行番号表示
set nowrap				" 画面幅で折り返さない
set list					" 不可視文字表示
set listchars=tab:>\ 			" 不可視文字の表示方法
set notitle				" タイトル書き換えない
set scrolloff=5				" 行送り
set display=uhex				" 印字不可能文字を16進数で表示

highlight JpSpace cterm=underline ctermfg=Blue guifg=Blue
au BufRead,BufNew * match JpSpace /　/

hi Visual guifg=White guibg=LightBlue gui=none ctermfg=White ctermbg=LightBlue

set cursorline				" カーソル行をハイライト
augroup cch
	autocmd! cch
	autocmd WinLeave * set nocursorline
	autocmd WinEnter,BufRead * set cursorline
augroup END
:hi clear CursorLine
:hi CursorLine gui=underline
" hi CursorLine ctermbg=darkgray guibg=darkgray
hi CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

" StatusLine ---------------------------
set laststatus=2				" ステータスラインを2行に
set statusline=%<%f\ #%n%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%y%=%l,%c%V%5P\ \%{fugitive#statusline()}

" Charset, Line ending -----------------
set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
set ffs=unix,dos,mac			" LF, CRLF, CR
if exists('&ambiwidth')
	set ambiwidth=double		" UTF-8の□や○でカーソル位置がずれないようにする
endif

" When insert mode, change statusline.
let g:hi_insert = 'hi StatusLine gui=None guifg=Black guibg=DarkBlue cterm=None ctermfg=Black ctermbg=DarkBlue'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

" enter to clear search highlight
nnoremap <ESC><ESC> :noh<CR><CR>

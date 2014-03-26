"   1 が設定されていればコマンドラインウィンドウで |:s| した後に自動的に |nohlsearch| を呼び出します。
let g:over_enable_auto_nohlsearch = 1

"  1 が設定されていればコマンドラインウィンドウで |:s| 時にパターン箇所のハイライトを行います。
let g:over_enable_cmd_window = 1

" vim-overの起動のショートカット
nnoremap <silent> <C-m> :OverCommandLine<CR>

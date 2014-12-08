"   1 が設定されていればコマンドラインウィンドウで |:s| した後に自動的に |nohlsearch| を呼び出します。
let g:over_enable_auto_nohlsearch = 1

"  1 が設定されていればコマンドラインウィンドウで |:s| 時にパターン箇所のハイライトを行います。
let g:over_enable_cmd_window = 1

" :sでvim-overが起動できるように修正
cnoreabb <silent><expr>s getcmdtype()==':' && getcmdline()=~'^s' ? 'OverCommandLine<CR><C-u>%s;<C-r>=get([], getchar(0), '')<CR>' : 's'

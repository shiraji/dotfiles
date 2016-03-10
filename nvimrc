if &compatible
    set nocompatible
  endif
  set runtimepath^=~/.nvim/bundle/repos/github.com/Shougo/nein.vim

  call dein#begin(expand('~/.cache/dein'))

  call dein#add(~/.nvim/bundle/repos/github.com/Shougo/nein.vim)
  call dein#add('Shougo/neocomplete.vim')

  call dein#end()

  filetype plugin indent on
endif

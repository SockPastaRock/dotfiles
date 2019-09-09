
"{{{*/ Defaults

runtime! debian.vim
syntax on
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

"}}}*/
"{{{*/ Custom

set backspace=indent,eol,start
set foldmethod=marker

nnoremap <leader><leader> :CommandT<CR>
colorscheme yin

call plug#begin('~/.vim/plugged')

" Plug 'wincent/command-t'
" Plug 'valloric/youcompleteme'

call plug#end()

"}}}*/

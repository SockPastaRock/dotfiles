
"{{{ defaults

runtime! debian.vim

if has("syntax")
  syntax on
endif

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

"}}}
"{{{ functions

"{{{ RunProj


function! RunProj()
	write
	if (&ft=='dart')
		:call RunDart()
	elseif (&ft=='python')
	    :call CloseTerm()
		:call RunPython()
	endif
endfunction

"}}}
"{{{ RunPython


function! RunPython()
    :terminal bash -c "cd %:h && python %:t"
	:call feedkeys("\<C-\>\<C-n>10\<C-w>_i\<C-w>w")
endfunction

"}}}
"{{{ RunDart


function! RunDart()
	if bufwinnr('__Flutter_Output__') > 0
		:FlutterHotReload
	else
		:FlutterRun
	    :call feedkeys("\<C-\>\<C-n>10\<C-w>_\<C-w>w")
	endif
endfunction

"}}}
"{{{ CloseTerm


function! CloseTerm()
	try
        :bd! !bash*
	catch
	endtry
	try
		:FlutterQuit
        :bd! __Flutter_Output__
	catch
	endtry
endfunction

"}}}

"}}}
"{{{ remaps

"{{{ normal mode

" Leader is \
nnoremap <leader>% :source ~/.vimrc<CR>
nnoremap <leader>. :badd $MYVIMRC<CR>:b ~/.vimrc<CR>
nnoremap <leader>/ :set foldmethod=marker<CR>
nnoremap <leader>] :buffers<CR>:buffer<Space>
nnoremap <leader><leader> :CtrlP<CR>
nnoremap <leader>sr :%s//g<Left><left>

nnoremap <leader>r :call RunProj()<CR>
nnoremap <leader>e :call RunProj()<CR>
nnoremap <leader>q :call CloseTerm()<CR>

"}}}
"{{{ insert mode

inoremap <tab> <space><space><space><space>

"}}}
"{{{ visual mode

" Search replace
vnoremap <leader>sr :<backspace><backspace><backspace><backspace><backspace>%s/\%V/g<Left><left>
" Replace input w/ yank
vnoremap <leader>ry :<backspace><backspace><backspace><backspace><backspace>%s/\%V/<C-r>"/g<C-b><Right><Right><Right><Right><Right>
" Replace yank with input
vnoremap <leader>yr :<backspace><backspace><backspace><backspace><backspace>%s/\%V<C-r>"//g<Left><Left>

"}}}

"}}}
"{{{ misc

autocmd BufWritePre * %s/\s\+$//e  "Remove trailing whitespace on save
set tabstop=4
set number relativenumber
set foldmethod=marker
set backspace=indent,eol,start
set splitbelow
colorscheme yin
set noequalalways


" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" YCM autoclose scratch preview
let g:ycm_autoclose_preview_window_after_completion = 1

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir = "~/.vim/UltiSnips"

" ctags
set tags=tags

set termguicolors

"}}}
"{{{ plugins

" Autoinstall vimplug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'prettier/vim-prettier'
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
Plug 'kien/ctrlp.vim'
Plug 'valloric/youcompleteme'
Plug 'sirver/ultisnips'
Plug 'ervandew/supertab'
Plug 'bronson/vim-trailing-whitespace'

call plug#end()

"}}}

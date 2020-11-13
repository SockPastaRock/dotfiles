
"{{{ defaults

runtime! debian.vim

if has("syntax")
  " syntax on
endif

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

"}}}
"{{{ functions

"{{{ ToggleArgs


function! ToggleArgs()
    if g:args
        let g:args = 0
    else
        let g:args = 1
        let g:prev_args = ""
    endif
endfunction

"}}}
"{{{ Profile

"{{{ ProfileProj


function! ProfileProj()
    write
    if (&ft=='python')
        :call CloseTerm()
        :call ProfilePython()
    endif
endfunction

"}}}
"{{{ ProfilePython


function! ProfilePython()
    if g:args
        call inputsave()
        let l:args = input('')
        call inputrestore()
        if l:args == ""
            :execute ':terminal ++rows=10 ++shell echo "Profiling program. This may take some time.." && cd %:h && python -m cProfile -s tottime %:t ' g:prev_args ' > %:t.profile && cat %:t.profile'
        else
            let g:prev_args = l:args
            :execute ':terminal ++rows=10 ++shell echo "Profiling program. This may take some time.." && cd %:h && python -m cProfile -s tottime %:t ' l:args ' > %:t.profile && cat %:t.profile'
        endif
    else
        :execute ':terminal ++rows=10 ++shell echo "Profiling program. This may take some time.." && cd %:h && python -m cProfile -s tottime %:t > %:t.profile && cat %:t.profile'
    endif
    :call feedkeys("\<C-w>p")
endfunction

"}}}

"}}}
"{{{ Debug

"{{{ DbgProj


function! DbgProj()
    write
    if (&ft=='python')
        :call CloseTerm()
        :call DbgPython()
    endif
endfunction

"}}}
"{{{ DbgPython


function! DbgPython()
    if g:args
        call inputsave()
        let l:args = input('')
        call inputrestore()
        if l:args == ""
            :execute ':terminal ++rows=10 ++shell cd %:h && python -m pdb %:t ' g:prev_args
        else
            let g:prev_args = l:args
            :execute ':terminal ++rows=10 ++shell cd %:h && python -m pdb %:t ' l:args
        endif
    else
        :execute ':terminal ++rows=10 ++shell cd %:h && python -m pdb %:t'
    endif
    ":call feedkeys("\<C-w>p")
endfunction

"}}}

"}}}
"{{{ Run

"{{{ RunProj


function! RunProj()
    write
    if (&ft=='dart')
        :call RunDart()
    elseif (&ft=='python')
        :call CloseTerm()
        :call RunPython()
    elseif (&ft=='asm')
        :call CloseTerm()
        :call RunAssembly()
    elseif (&ft=='tex')
        :call CloseTerm()
        :call RunLatex()
    endif
endfunction

"}}}
"{{{ RunPython


function! RunPython()
    if g:args
        call inputsave()
        let l:args = input('')
        call inputrestore()
        if l:args == ""
            :execute ':terminal ++rows=10 ++shell cd %:h && python %:t ' g:prev_args
        else
            let g:prev_args = l:args
            :execute ':terminal ++rows=10 ++shell cd %:h && python %:t ' l:args
        endif
    else
        :execute ':terminal ++rows=10 ++shell cd %:h && python %:t'
    endif
    :call feedkeys("\<C-w>p")
endfunction

"}}}
"{{{ RunLatex


function! RunLatex()
    write
    :terminal bash -c "cd %:h && pdflatex %:t && pdflatex %:t && zathura %:r.pdf"
    :call feedkeys("\<C-\>\<C-n>10\<C-w>_i\<C-w>p")
endfunction

"}}}
"{{{ RunDart


function! RunDart()
    if bufwinnr('__Flutter_Output__') > 0
        :FlutterHotReload
    else
        :FlutterRun
        :call feedkeys("\<C-\>\<C-n>10\<C-w>_\<C-w>p")
    endif
endfunction

"}}}
"{{{ RunAssembly


function! RunAssembly()
    write
    :terminal bash -c "nasm -f elf %:p -o %:r.o && ld -m elf_i386 -s -o %:r %:r.o && ./%:r"
    :call feedkeys("\<C-\>\<C-n>10\<C-w>_i\<C-w>p")
endfunction

"}}}

"}}}
"{{{ CloseTerm


function! CloseTerm()
    try
        :bd! !*
    catch
    endtry
    try
        :FlutterQuit
        :bd! __Flutter_Output__
    catch
    endtry
endfunction

"}}}
"{{{ OpenTerm


function! OpenTerm()
    :call CloseTerm()
    :execute ':terminal ++rows=10'
endfunction

"}}}
"{{{ GitTree


function! GitTree()
    :call CloseTerm()
    :execute ':terminal ++rows=20 ++shell git log --graph --full-history --all --color'
endfunction

"}}}

"}}}
"{{{ remaps

"{{{ normal mode

nnoremap <leader>% :source ~/.vimrc<CR>
nnoremap <leader>. :badd $MYVIMRC<CR>:b ~/.vimrc<CR>
nnoremap <leader>/ :set foldmethod=marker<CR>
nnoremap <leader>] :buffers<CR>:buffer<Space>
nnoremap <leader><leader> :CtrlP<CR>
nnoremap <leader>sr :%s//g<Left><left>

nnoremap <leader>r :call RunProj()<CR>
nnoremap <leader>d :call DbgProj()<CR>
nnoremap <leader>t :call OpenTerm()<CR>
nnoremap <leader>g :call GitTree()<CR>
nnoremap <leader>a :call ToggleArgs()<CR>
nnoremap <leader>p :call ProfileProj()<CR>
nnoremap <leader>q :call CloseTerm()<CR>

"}}}
"{{{ insert mode

inoremap <tab> <space><space><space><space>

"}}}
"{{{ visual mode

" Search replace
vnoremap <leader>sr :<backspace><backspace><backspace><backspace><backspace>%s/\%V/g<Left><left>

" Replace yank w/ input
vnoremap <leader>ry :<backspace><backspace><backspace><backspace><backspace>%s/\%V<C-r>"//g<Left><Left>

" Replace input w/ yank
vnoremap <leader>yr :<backspace><backspace><backspace><backspace><backspace>%s/\%V/<C-r>"/g<C-b><Right><Right><Right><Right><Right>

" Maintain selection on indent
vnoremap > >gv
vnoremap < <gv

"}}}

"}}}
"{{{ misc

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

set tabstop=4
set number relativenumber
set foldmethod=marker
set backspace=indent,eol,start
set splitbelow
set noequalalways

colorscheme yin

" statusline
set laststatus=2
set statusline=%F%m

" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" ctags
set tags=tags

"}}}
"{{{ globals

" select if user inputs commandline arguments
let g:args = 0
let g:prev_args = ""

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

"}}}
"{{{ plugins

" Autoinstall vimplug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'kien/ctrlp.vim'                       " Fuzzyfinder
Plug 'valloric/youcompleteme'               " Autocomplete
Plug 'sirver/ultisnips'                     " Snippets
Plug 'ervandew/supertab'                    " Autocomplete and Snippets play nice together
" Plug 'dart-lang/dart-vim-plugin'          " app development
" Plug 'thosakwe/vim-flutter'               " app development
" Plug 'bronson/vim-trailing-whitespace'    " Trim whitespace on save
" Plug 'prettier/vim-prettier'              " autostyling

call plug#end()

"}}}

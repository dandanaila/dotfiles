set nocompatible

set hlsearch
set laststatus=2
set ruler
set nu
set expandtab
set tabstop=2
set shiftwidth=2
set cindent
set filetype=on
set fdm=syntax
syntax on
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/
autocmd BufWritePre * :%s/\s\+$//e

" Python specific overrides.
autocmd filetype python :set fdm=indent | map <C-u> :s/^#//<CR>:noh<CR> | map <C-c> :s/^/#/<CR>:noh<CR>
autocmd filetype python nmap <F7> :!python %<CR>

" C++ specific overrides.
autocmd filetype cpp :set fdm=syntax | map <C-u> :s/^\/\///<CR>:noh<CR> | map <C-c> :s/^/\/\//<CR>:noh<CR>
autocmd filetype cpp nmap <F7> :!g++ -std=c++11 %<CR>

" Java specific overrides.
autocmd filetype java :set fdm=syntax | set tabstop=4 | set shiftwidth=4 | map <C-u> :s/^\/\///<CR>:noh<CR> | map <C-c> :s/^/\/\//<CR>:noh<CR>
autocmd filetype java match OverLength /\%101v.\+/

autocmd filetype yaml :set fdm=indent | set tabstop=2 | set shiftwidth=2

nmap <F5>  :set foldlevel=0
nmap <F8>  :!make run<CR>
nmap <F9>  :!make compile<CR>
nmap <F10> :!make clean<CR>

hi User1 ctermfg=1  ctermbg=0 cterm=bold
hi User2 ctermfg=2  ctermbg=0 cterm=bold
hi User3 ctermfg=3  ctermbg=0 cterm=bold
hi User4 ctermfg=4  ctermbg=0 cterm=bold
hi User5 ctermfg=5  ctermbg=0 cterm=bold
hi User7 ctermfg=6  ctermbg=0 cterm=bold
hi User8 ctermfg=7  ctermbg=0 cterm=bold
hi User9 ctermfg=8  ctermbg=0 cterm=bold
hi User0 ctermfg=9  ctermbg=0 cterm=bold


function! GitBranch()
  let branch = system("git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* //'")
  if branch != ''
    return ''.substitute(branch, '\n', '', 'g')
  en
  return ''
endfunction

set statusline=
set statusline+=%7*\ [%{GitBranch()}]\        "Git Branch if present
set statusline+=%1*\ %f\                      "Relative file name
set statusline+=%3*\ %=\ %c,%l/%L\ (%03p%%)\  "Col:Rownumber/total (%)
set statusline+=%4*\ \ %m%r%w\ %P\ \          "Modified? Readonly? Top/bot.
set laststatus=2

:au FocusGained * :redraw!
:au FocusLost * :redraw!
:au InsertEnter * :redraw!
:au InsertLeave * :redraw!

call plug#begin()

Plug 'dense-analysis/ale'
Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }

call plug#end()


" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

let g:ale_linters = {
\ 'sh': ['shellcheck'],
\ 'java': [],
\ }
let g:ale_fixers = {
\ 'sh': ['shfmt'],
\ 'java': ['google_java_format'],
\}

let g:ale_sh_shfmt_options='-i 2'
let g:ale_java_eclipselsp_path="~/lwcode/eclipselsp"
let g:ale_java_eclipselsp_workspace_path="/home/coder/lwcode/services/"

" Move between warnings or errors with ALENext and ALEPrevious
nmap <silent> <leader>aj :ALENext<cr>
nmap <silent> <leader>ak :ALEPrevious<cr>
" ALEFix will format the file in place
nmap <silent> <leader>af :ALEFix<cr>


" let g:ale_fix_on_save = 1

nmap <F4> :silent !tmux send-keys -t "{next}" "grep -Irn " <cword> " ." Enter<CR><C-l><CR>

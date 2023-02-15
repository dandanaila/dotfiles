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
autocmd filetype python :set fdm=indent | map <C-u> :s/^#//<CR>:noh<CR> | map <C-c> :s/^/#/<CR>:noh<CR>
autocmd filetype cpp :set fdm=syntax | map <C-u> :s/^\/\///<CR>:noh<CR> | map <C-c> :s/^/\/\//<CR>:noh<CR>
autocmd filetype java :set fdm=syntax | map <C-u> :s/^\/\///<CR>:noh<CR> | map <C-c> :s/^/\/\//<CR>:noh<CR>

autocmd filetype python nmap <F7> :!python %<CR>
autocmd filetype cpp nmap <F7> :!g++ -std=c++11 %<CR>

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

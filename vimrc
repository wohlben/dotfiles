execute pathogen#infect()

set number
set linebreak
set showbreak=+++
set textwidth=100
set showmatch
set nospell
set visualbell
 
set hlsearch
set smartcase
set ignorecase
set incsearch
 
 
set ruler
 
set undolevels=1000
set backspace=indent,eol,start
 
cnoremap w!! w !sudo tee > /dev/null %

autocmd Filetype markdown set spell spelllang=de_DE

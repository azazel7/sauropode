syntax on
set background=dark
set number
set showmatch " montrer les correspondance entre les parentheses
set backupcopy=no

" modifier la navigation dans les onglets
map <C-right> :tabnext<CR>
map <C-k> :tabnext<CR>
map <C-left> :tabprevious<CR>
map <C-j> :tabprevious<CR>
map <C-t> :tabedit 
map <F8> :w<CR>
map <C-a> ggVG
map <F9> :set invpaste paste?<CR>i
map <F12> :NERDTreeToggle<CR>


let NERDTreeWinPos="right"
let NERDChristmasTree=1
" demarrage de pathogene
let mapleader=","

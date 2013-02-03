syntax on
set background=dark
set number
set showmatch " montrer les correspondance entre les parentheses
set backupcopy=no

" Raccourci
" Onglet
map <C-right> :tabnext<CR>
map <C-k> :tabnext<CR>
map <C-left> :tabprevious<CR>
map <C-j> :tabprevious<CR>
map <C-t> :tabedit 
" Sauvegarde
map <F8> :w<CR>
" Tout selectioner
map <C-a> ggVG
" Passer ou sortir du mode collage
map <F9> :set invpaste paste?<CR>i
" Afficher l'arbre des fichiers
map <F12> :NERDTreeToggle<CR>
" Afficher la liste des tâches
map <F11> :TaskList<CR>

let NERDTreeWinPos="right"
let NERDChristmasTree=1
" demarrage de pathogene
let mapleader=","

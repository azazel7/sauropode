syntax on
set background=dark
set number
set showmatch " montrer les correspondance entre les parentheses
set backupcopy=no

source $HOME/.vim/colors/color1.vim

" Raccourci
" Onglet
map <C-right> :tabnext<CR>
map <C-k> :tabnext<CR>
map <C-left> :tabprevious<CR>
map <C-j> :tabprevious<CR>
map <C-t> :tabedit 
" Tout selectioner
map <C-a> ggVG
" Afficher l'arbre des fichiers
map <F12> :NERDTreeToggle<CR>
imap <C-o> <ESC>:NERDTreeToggle<CR>
" Afficher la liste des tâches
map <F11> :TaskList<CR>
" Recharger les tag pour omnicomplete et ainsi mettre à jour les classes en C++
map <F10> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q<CR>
" Passer ou sortir du mode collage
map <F9> :set invpaste paste?<CR>i
" Sauvegarde
map <F8> :w<CR>
" Afficher la sortie des executables externes
map <F7> :!<CR>
" Commante la ligne courante
map <F6> ,c<SPACE>
"Tag list On ouvre la tag list, puis on passe 3 fois à gauche pour avoir le curseur dessus
map <F5> :TlistToggle<CR><C-w>h<C-w>h<C-w>h

let NERDTreeWinPos="right"
let NERDChristmasTree=1
" demarrage de pathogene
let mapleader=","


" Voir pour ajouter raccourci vim-a, taglist

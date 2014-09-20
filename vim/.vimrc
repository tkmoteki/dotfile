"タブの設定
set expandtab "タブ入力を複数の空白入力に置き換える
set tabstop=2 "画面上でタブ文字が占める幅
set shiftwidth=2 "自動インデントでずれる幅
set softtabstop=2 "連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent "改行時に前の行のインデントを継続する
set smartindent "改行時に入力された行の末尾に合わせて次の行のインデントを増減する

set nocompatible
set backspace=start,eol,indent
set whichwrap=b,s,[,],<,>,~
set mouse=
syntax on
set nohlsearch
highlight StatusLine ctermfg=black
ctermbg=grey
highlight CursorLine ctermfg=none
ctermbg=darkgray cterm=none
highlight MatchParen ctermfg=none
ctermbg=darkgray
highlight Comment ctermfg=DarkGreen
ctermbg=NONE
highlight Directory cterm=DarkGreen
ctermbg=NONE
set laststatus=2
set statusline=%F%r%h%=
set number
set incsearch
set ignorecase
set wildmenu wildmode=list:full
nmap <silent> <Tab> 15<Right>
vmap <silent> <Tab> <C-o>15<Left>
nmap <silent> <S-Tab> 15<Left>
vmap <silent> <S-Tab> <C-o>15<Left>
nmap <silent> <C-n>
:update<CR>:bn<CR>
imap <silent> <C-n>
<ESC>:update<CR>:bn<CR>
vmap <silent> <C-n>
<ESC>:update<CR>:bn<CR>
cmap <slient> <C-n>
<ESC>:update<CR>:bn<CR>
" :e時のTab補完
set wildmode=longest,list
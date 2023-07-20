" Use a line cursor within insert mode and a block cursor everywhere else.
"
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"


" Show line numbers
set number

" Turn on syntax highlighting
syntax on

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Set indents
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround

" Enable mouse
set mouse=a

call plug#begin('~/.local/share/nvim/plugged')

" Appearance
Plug 'nanotech/jellybeans.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bronson/vim-trailing-whitespace'

" Navigation
Plug 'kien/ctrlp.vim'
Plug 'bronson/vim-visual-star-search'
Plug 'easymotion/vim-easymotion'

" VCS
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'               " Git magic

" Code
Plug 'tpope/vim-endwise'                " Match open/close structures
Plug 'tpope/vim-commentary'             " Toggle comments
Plug 'tpope/vim-repeat'                 " Repeat plugin actions

" Misc
Plug 'tpope/vim-obsession'              " Auto update session files
Plug 'cespare/vim-toml'

call plug#end()

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = 'ro'

let g:ctrlp_match_window = 'max:30'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']


" Automatic Formatting
"
" c Auto-wrap comments using textwidth, inserting the current comment
"   leader automatically.
" q Allow formatting of comments with "gq"
" n When formatting text, recognize numbered lists
" j Where it makes sense, remove a comment leader when joining lines
set formatoptions=cqnj
set textwidth=72                        " Auto wrap width
set expandtab                           " Insert spaces instead of tabs
set tabstop=4                           " Width of a tab character
set shiftwidth=0                        " Width of indent step $(tabstop)
set softtabstop=-1                      " Num spaces inserted $(shiftwidth)
set shiftround                          " Round to next indentation level


" Display
set number                              " Show line numbers
set colorcolumn=+0,80                   " Show print margins $(textwidth)
silent! colorscheme jellybeans          " Ignore color scheme if not installed


" User Interface
set mouse=a                             " Enable the mouse
set scrolloff=5                         " Keep lines above/below cursor
set sidescrolloff=5                     " Keep columns left/right of cursor
set virtualedit=all                     " Allow cursor to be placed anywhere
set clipboard=unnamedplus               " Use traditional clipboard

noremap <Space> i <Esc>                 " Space bar inserts a space
noremap <Return> o<Esc>                 " Enter inserts a new line below
noremap t :tabedit<Space>               " Open a file in a new tab
noremap <F5> <Esc>:setlocal spell!<CR>  " Toggle spell checking


" File Specific
augroup filetype_make
    autocmd!
    autocmd FileType make setlocal noexpandtab
augroup END

augroup filetype_git
    autocmd!
    autocmd FileType gitcommit setlocal colorcolumn+=50
augroup END

augroup filetype_text
    autocmd!
    autocmd FileType text setlocal spell
    autocmd FileType markdown setlocal spell
    autocmd FileType gitcommit setlocal spell
    autocmd FileType hgcommit setlocal spell
    autocmd FileType svn setlocal spell
augroup END


" Final
set exrc                                " Load per-project configs
set secure                              " Disable shell and write commands

augroup vim_enter                       " Auto load session files
    autocmd!
    autocmd VimEnter * nested call OpenSession()
augroup END

function! OpenSession()
    if argc() == 0
        if filereadable("Layout.vim")
            source Layout.vim
        elseif filereadable("Session.vim")
            source Session.vim
        endif
    endif
endfunction


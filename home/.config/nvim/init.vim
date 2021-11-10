" To install vim-plug:
"   sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

call plug#begin('~/.local/share/nvim/plugged')

" Appearance
Plug 'nanotech/jellybeans.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bronson/vim-trailing-whitespace'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'mkitt/tabline.vim'

" Navigation
Plug 'kien/ctrlp.vim'
Plug 'bronson/vim-visual-star-search'
Plug 'easymotion/vim-easymotion'
Plug 'rhysd/clever-f.vim'

" VCS
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'               " Git magic

" Code
Plug 'editorconfig/editorconfig-vim'    " Per-project coding styles
Plug 'tpope/vim-endwise'                " Match open/close structures
Plug 'tpope/vim-commentary'             " Toggle comments
Plug 'tpope/vim-repeat'                 " Repeat plugin actions
Plug 'rhysd/vim-clang-format'           " clang-format integration

" Misc
Plug 'dhruvasagar/vim-table-mode'       " Auto-format tables
Plug 'tpope/vim-eunuch'                 " Vim sugar for UNIX commands
Plug 'tpope/vim-obsession'              " Auto update session files
Plug 'cespare/vim-toml'

if !has('nvim')
    Plug 'tpope/vim-sensible'           " Use modern settings
endif

call plug#end()

" Appearance
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

let g:indent_guides_tab_guides = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_enable_on_vim_startup = 1

" Navigation
let g:ctrlp_match_window = 'max:30'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

let g:clever_f_fix_key_direction = 1

" Code
let g:EditorConfig_exclude_patterns = ['fugitive://.\*']

let mapleader = ";"                     " Set early on; some plugins use <leader>

" Misc
let g:table_mode_corner="|"


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
set list                                " Show whitespace
set listchars=tab:>\ ,nbsp:~            " Replacement strings for whitespace
silent! colorscheme jellybeans          " Ignore color scheme if not installed


" User Interface
set mouse=a                             " Enable the mouse
set scrolloff=5                         " Keep lines above/below cursor
set sidescrolloff=5                     " Keep columns left/right of cursor
set virtualedit=all                     " Allow cursor to be placed anywhere
set clipboard=unnamedplus               " Use traditional clipboard

noremap <Space> i <Esc>                 " Space bar inserts a space
noremap <Return> o<Esc>                 " Enter inserts a new line below
noremap <F5> <Esc>:setlocal spell!<CR>  " Toggle spell checking
map <C-o> :NERDTreeToggle<CR>           " Open NERDTree


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

augroup filetype_clang
    autocmd!
    autocmd BufNewFile,BufRead .clang-format set syntax=yaml
    autocmd BufNewFile,BufRead .clang-tidy set syntax=yaml
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
        let l = "Layout" . $MONITOR . ".vim"
        let s = "Session" . $MONITOR . ".vim"
        if filereadable(l)
            execute "source " . l
        elseif filereadable(s)
            execute "source " . s
        endif
    endif
endfunction


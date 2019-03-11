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
Plug 'tpope/vim-repeat'                 " Repeat plugin actions (if supported)

" Misc
Plug 'tpope/vim-obsession'              " Update session files automatically
Plug 'cespare/vim-toml'

call plug#end()



" Print the line number in front of each line.
set number

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=5

" Maximum width of text that is being inserted.  A longer line will be
" broken after white space to get this width.
set textwidth=72

" 'colorcolumn' is a comma separated list of screen columns that are
" highlighted with ColorColumn |hl-ColorColumn|.  Useful to align text.
" Will make screen redrawing slower.  The screen column can be an absolute
" number, or a number preceded with '+' or '-', which is added to or
" subtracted from 'textwidth'.
set colorcolumn=+0,80

" The minimal number of screen columns to keep to the left and to the right
" of the cursor if 'nowrap' is set.
set sidescrolloff=5

" Toggle spell checking with F5
noremap <F5> <Esc>:setlocal spell!<CR>

silent! colorscheme jellybeans

" Enable the use of the mouse.
set mouse=a

" Use X11 clipboard
set clipboard=unnamedplus

" This is a sequence of letters which describes how automatic
" formatting is to be done.
"
" letter    meaning when present in 'formatoptions'
" -------------------------------------------------
"   c       Auto-wrap comments using textwidth, inserting the current comment
"           leader automatically.
"   q       Allow formatting of comments with "gq".
"   n       When formatting text, recognize numbered lists.
"   j       Where it makes sense, remove a comment leader when joining lines.
set formatoptions=cqnj

" Number of spaces that a <Tab> in the file counts for.
set tabstop=4

" Number of spaces to use for each step of (auto)indent.
" When zero the 'ts' value will be used.
set shiftwidth=0

" Number of spaces that a <Tab> counts for while performing editing
" operations, like inserting a <Tab> or using <BS>.  It "feels" like
" <Tab>s are being inserted, while in fact a mix of spaces and <Tab>s is
" used.  This is useful to keep the 'ts' setting at its standard value
" of 8, while being able to edit like it is set to 'sts'.  However,
" commands like "x" still work on the actual characters.
" When 'sts' is zero, this feature is off.
" When 'sts' is negative, the value of 'shiftwidth' is used.
set softtabstop=-1

" In Insert mode: Use the appropriate number of spaces to insert a
" <Tab>.  Spaces are used in indents with the '>' and '<' commands and
" when 'autoindent' is on.  To insert a real tab when 'expandtab' is
" on, use CTRL-V<Tab>.
set expandtab

" Round indent to multiple of 'shiftwidth'.
set shiftround

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

augroup vim_enter
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

" Virtual editing means that the cursor can be positioned where there is
" no actual character.  This can be halfway into a tab or beyond the end
" of the line.
set virtualedit=all

" Space bar inserts a space
nnoremap <Space> i <Esc>

" Enter inserts a new line below
nnoremap <Return> o<Esc>

" Open a file in a new tab
nnoremap t :tabedit<Space>

let g:ctrlp_match_window = 'max:30'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Update airline symbols/delimiters
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


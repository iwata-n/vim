" 設定
set clipboard=unnamed,autoselect
set list
set listchars=tab:>-,extends:<,trail:-
set nowrap
set number
set nobackup
set cursorline
set autochdir

set fileencoding=utf-8
set encoding=utf-8
set fileformat=dos

set guitablabel=%{GuiTabLabel()}

" キーマップ
nnoremap <C-Tab>   gt
nnoremap <C-S-Tab> gT
noremap <C-CR> o<ESC>
vnoremap v $h

nnoremap <C-f> :call <SID>open()<CR><CR>
noremap <C-l> :Explore<CR>

autocmd FileType * set softtabstop=4
autocmd FileType * set shiftwidth=4
autocmd FileType * set expandtab

" python用の設定
filetype plugin on
autocmd FileType python set autoindent
autocmd FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python set expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType python let g:pydiction_location = '~/.vim/pydiction/complete-dict'
autocmd FileType python map <silent> <C-P> :call <SID>ExecPy()<CR>

" rst用の設定
autocmd FileType rst map <silent> <C-P> :call <SID>MakeRst()<CR>

autocmd FileType javascript set expandtab
autocmd FileType javascript set tabstop=2
autocmd FileType javascript set shiftwidth=2
autocmd FileType javascript set softtabstop=2

" コメントアウト
autocmd FileType python nnoremap // ^i //<Esc>

au BufNewFile,BufRead *.pde setf arduino
au BufNewFile,BufRead *.ino setf arduino


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"ファイル名が11文字以上の場合、末尾を切り詰めて10文字にする。
function! GuiTabLabel()
    let label = expand("%:t")
    if strlen(label) > 10 
      let label = strpart(label, 0, 10) . ".."
    endif
    return label
endfunction

" pythonの実行
function! s:ExecPy()
    exe "!python2.7 %"
endfunction

" Make rest
function! s:MakeRst()
    exe "make html"
endfunction

" finderで開く
function! s:open()
    exe "!open ./"
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set imdisable


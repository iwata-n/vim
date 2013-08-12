" release autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" エディタの設定
set infercase " 補完時に大文字小文字を区別しない
set clipboard=unnamed,autoselect " デフォルトのレジスタをクリップボードにする
set list
set listchars=tab:>-,extends:<,trail:-
set nowrap
set number
set guitablabel=%{GuiTabLabel()} " タブの見た目
set cursorline
"set autochdir
set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set matchpairs& matchpairs+=<:> " 対応括弧に'<'と'>'のペアを追加
set imdisable
set t_vb= " スクリーンベルの無効化
set novisualbell " スクリーンベルの無効化

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" バックアップとスワップを無効化
set nowritebackup
set nobackup
set noswapfile


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ファイルフォーマット
set fileencoding=utf-8
set encoding=utf-8
set fileformat=unix


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" キーマップ
nnoremap <C-Tab>   gt
nnoremap <C-S-Tab> gT
noremap <C-CR> o<ESC>
vnoremap v $h
nnoremap tt :tabnew<CR>

" nnoremap <C-f> :call <SID>open()<CR><CR>
nnoremap <C-f> :FufFile<CR>
nnoremap <C-d> :VimFilerExplorer<CR>

" 入力モード中に素早くjjと入力した場合はESCとみなす
inoremap jj <Esc>

" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" TABにて対応ペアにジャンプ
nnoremap <Tab> %

" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <silent> <C-z> :cd %:h<CR>


" ファイル毎の設定
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
" neobundleの設定
set nocompatible
filetype off
if has('vim_starting')
  set runtimepath+=~/.vim/neobundle.vim.git
  call neobundle#rc(expand('~/.bundle'))
endif

NeoBundle 'thinca/vim-quickrun'
NeoBundle 'git://github.com/Shougo/neocomplcache.git'
NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-scripts/Align'
NeoBundle 'L9'
NeoBundle 'FuzzyFinder'

filetype plugin on
filetype indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle "thinca/vim-template"
" テンプレート中に含まれる特定文字列を置き換える
autocmd MyAutoCmd User plugin-template-loaded call s:template_keywords()
function! s:template_keywords()
    silent! %s/<+DATE+>/\=strftime('%Y-%m-%d')/g
    silent! %s/<+FILENAME+>/\=expand('%:r')/g
endfunction
" テンプレート中に含まれる'<+CURSOR+>'にカーソルを移動
autocmd MyAutoCmd User plugin-template-loaded
    \   if search('<+CURSOR+>')
    \ |   silent! execute 'normal! "_da>'
    \ | endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundleLazy "Shougo/vimfiler", {
      \ "depends": ["Shougo/unite.vim"],
      \ "autoload": {
      \   "commands": ["VimFilerTab", "VimFiler", "VimFilerExplorer"],
      \   "mappings": ['<Plug>(vimfiler_switch)'],
      \   "explorer": 1,
      \ }}
" close vimfiler automatically when there are only vimfiler open
autocmd MyAutoCmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif
let s:hooks = neobundle#get_hooks("vimfiler")
function! s:hooks.on_source(bundle)
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_enable_auto_cd = 1

  " vimfiler specific key mappings
  autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
  function! s:vimfiler_settings()
    " ^^ to go up
    nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
    " use R to refresh
    nmap <buffer> R <Plug>(vimfiler_redraw_screen)
    " overwrite C-l
    nmap <buffer> <C-l> <C-w>l
  endfunction
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundleLazy "mattn/gist-vim", {
      \ "depends": ["mattn/webapi-vim"],
      \ "autoload": {
      \   "commands": ["Gist"],
      \ }}

" vim-fugitiveは'autocmd'多用してるっぽくて遅延ロード不可
NeoBundle "tpope/vim-fugitive"
NeoBundleLazy "gregsexton/gitv", {
      \ "depends": ["tpope/vim-fugitive"],
      \ "autoload": {
      \   "commands": ["Gitv"],
      \ }}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle "nathanaelkane/vim-indent-guides"
let g:indent_guides_enable_on_vim_startup = 1
let s:hooks = neobundle#get_hooks("vim-indent-guides")
function! s:hooks.on_source(bundle)
  let g:indent_guides_guide_size = 1
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundleLazy 'majutsushi/tagbar', {
      \ "autload": {
      \   "commands": ["TagbarToggle"],
      \ },
      \ "build": {
      \   "mac": "brew install ctags",
      \ }}
nmap <Leader>t :TagbarToggle<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 " Djangoを正しくVimで読み込めるようにする
NeoBundleLazy "lambdalisue/vim-django-support", {
      \ "autoload": {
      \   "filetypes": ["python", "python3", "djangohtml"]
      \ }}
" Vimで正しくvirtualenvを処理できるようにする
NeoBundleLazy "jmcantrell/vim-virtualenv", {
      \ "autoload": {
      \   "filetypes": ["python", "python3", "djangohtml"]
      \ }}

NeoBundleLazy "davidhalter/jedi-vim", {
      \ "autoload": {
      \   "filetypes": ["python", "python3", "djangohtml"],
      \   "build": {
      \     "mac": "pip install jedi",
      \     "unix": "pip install jedi",
      \   }
      \ }}
let s:hooks = neobundle#get_hooks("jedi-vim")
function! s:hooks.on_source(bundle)
  " jediにvimの設定を任せると'completeopt+=preview'するので
  " 自動設定機能をOFFにし手動で設定を行う
  let g:jedi#auto_vim_configuration = 0
  " 補完の最初の項目が選択された状態だと使いにくいためオフにする
  let g:jedi#popup_select_first = 0
  " quickrunと被るため大文字に変更
  let g:jedi#rename_command = '<Leader>R'
endfunction

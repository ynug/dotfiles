" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.config/nvim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif





" 矢印キーを無効化する
" normal mode
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
noremap <Backspace> <Nop>
" insert  mode
inoremap <Down> <Nop>
inoremap <UP> <Nop>
inoremap <Right> <Nop>
inoremap <Left> <Nop>
" visual mode
vnoremap  <Up> <nop>
vnoremap  <Down> <nop>
vnoremap  <Left> <nop>
vnoremap  <Right> <nop>

" vim 画面分割
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')


" yamlの文法をrubyを通してチェックする
autocmd FileType yaml nmap ,e :execute '!ruby -ryaml -e "begin;YAML::load(open('."'"."%"."'".","."'"."r"."'".').read);rescue ArgumentError=>e;puts e;end"'

" clipboad共有 macで確認
set clipboard=unnamed
" True Color
set termguicolors
" mouse disable
set mouse-=a
" line number enable
set number
" don't create undofile (.un~)
:set noundofile
" カーソル行を目立たせる
set cursorline
" カラースキームを設定
colorscheme molokai
" タブ入力を複数の空白入力に置き換える
set expandtab

" 画面上でタブ文字が占める幅
set tabstop=2
" オートインデント数
set shiftwidth=2
" tab 入力時の空白数
set softtabstop=2

" ファイルタイプの検索を有効にする
filetype plugin on
" ファイルタイプに合わせたインデントを利用
filetype indent on
" sw=softtabstop, sts=shiftwidth, ts=tabstop
autocmd FileType c           setlocal sw=4 sts=4 ts=4
autocmd FileType java        setlocal sw=4 sts=4 ts=4


" バックアップファイルを作成しない
:set nobackup

" Show invisible characters
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%,space:.

syntax on

" typescriptファイル設定
au BufNewFile,BufRead *.ts,*tsx set filetype=typescript

" velocityファイル設定
au BufNewFile,BufRead *.vm set ft=velocity

" cloudformationファイル設定
au BufRead,BufNewFile *template.yaml set ft=cloudformation.yaml

" vim-airline 設定
"let g:airline_theme = 'dark'
" Powerline系フォントを利用する
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_theme = 'papercolor'
nnoremap <C-p> :bprevious<CR>
nnoremap <C-n> :bnext<CR>


" deniteの設定
nnoremap    [denite]   <Nop>
nmap    <Space> [denite]
" denite.nvim keymap
nnoremap <silent> [denite]f :Denite file<CR>
nnoremap <silent> [denite]u :Denite file/rec<CR>
nnoremap <silent> [denite]m :Denite file_mru<CR>
nnoremap <silent> [denite]g :Denite grep<CR>

autocmd FileType denite call s:denite_my_setting()
function! s:denite_my_setting() abort
  nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
  nnoremap <silent><buffer><expr> <C-o> denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> q denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc> denite#do_map('quit')
  nnoremap <silent><buffer><expr> <BS>    denite#do_map('move_up_path')
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  inoremap <silent><buffer><expr> <BS>    denite#do_map('move_up_path')
  inoremap <silent><buffer><expr> <Esc>   denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>   denite#do_map('quit')
  inoremap <silent><buffer><expr> <BS> denite#do_map('move_up_path')
  inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

call denite#custom#var('file/rec', 'command', ['pt', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])
call denite#custom#var('grep', 'command', ['pt', '--nogroup', '--nocolor', '--smart-case', '--hidden'])
call denite#custom#var('grep', 'default_opts', [])
call denite#custom#var('grep', 'recursive_opts', [])
let s:denite_options = {
      \ 'prompt' : '👉 ',
      \ 'start_filter': 1,
      \ 'highlight_matched_char': 'Search',
      \ }
call denite#custom#option('default', s:denite_options)


"autocmd FileType denite call s:denite_my_settings()
"function! s:denite_my_settings() abort
"  nnoremap <silent><buffer><expr> i
"        \ denite#do_map('open_filter_buffer')
"  nnoremap <silent><buffer><expr> <CR>
"        \ denite#do_map('do_action')
"  nnoremap <silent><buffer><expr> q
"        \ denite#do_map('quit')
"endfunction
"
"call denite#custom#var('file/rec', 'command', ['pt', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])
"call denite#custom#var('grep', 'command', ['pt', '--nogroup', '--nocolor', '--smart-case', '--hidden'])
"call denite#custom#var('grep', 'default_opts', [])
"call denite#custom#var('grep', 'recursive_opts', [])
"let s:denite_win_width_percent = 0.85
"let s:denite_win_height_percent = 0.7
"call denite#custom#option('default', {
"    \ 'split': 'floating',
"    \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
"    \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
"    \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
"    \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
"    \ })

"defx
" NERDTreeのような感じではない。どちらかといえば deniteな感じ
nnoremap <silent> <Space>j :Defx -split=vertical -winwidth=37 ./<CR>
"nnoremap <silent> <Space>x :Defx -split=no ./<CR>
autocmd FileType defx call s:defx_my_settings()
  function! s:defx_my_settings() abort
    " Define mappings
    nnoremap <silent><buffer><expr> <CR>
    \ defx#do_action('drop')
    nnoremap <silent><buffer><expr> c
    \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> m
    \ defx#do_action('move')
    nnoremap <silent><buffer><expr> p
    \ defx#do_action('paste')
    "nnoremap <silent><buffer><expr> l
    "\ defx#do_action('open')
    "nnoremap <silent><buffer><expr> E
    "\ defx#do_action('open', 'vsplit')
    "nnoremap <silent><buffer><expr> P
    "\ defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> o
    \ defx#do_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> K
    \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
    \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> M
    \ defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> C
    \ defx#do_action('toggle_columns',
    \                'mark:filename:type:size:time')
    nnoremap <silent><buffer><expr> S
    \ defx#do_action('toggle_sort', 'time')
    nnoremap <silent><buffer><expr> d
    \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
    \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> !
    \ defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> x
    \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> yy
    \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> .
    \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> ;
    \ defx#do_action('repeat')
    nnoremap <silent><buffer><expr> h
    \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
    \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> q
    \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> <Space>
    \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
    \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
    \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
    \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-l>
    \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
    \ defx#do_action('print')
    nnoremap <silent><buffer><expr> cd
    \ defx#do_action('change_vim_cwd')
  endfunction


"vim-lsp
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


" ale
" エラー行に表示するマーク
let g:ale_sign_error = '⨉'
let g:ale_sign_warning = '⚠'
" エラー行にカーソルをあわせた際に表示されるメッセージフォーマット
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" エラー表示の列を常時表示
let g:ale_sign_column_always = 1

" ファイルを開いたときにlint実行
let g:ale_lint_on_enter = 1
" ファイルを保存したときにlint実行
let g:ale_lint_on_save = 1

let g:ale_linters = { 'javascript': ['eslint'] }

set encoding=utf-8

scriptencoding utf-8

""" release autogroup in MyAutoCmd
augroup MyAutoCmd
    autocmd!
augroup END

""" 表示関係
set t_Co=256
set background=dark
" colorscheme molokai

function! s:setCommentColor()
  hi Comment cterm=NONE ctermfg=194
  hi Search cterm=NONE ctermfg=160 ctermbg=192
endfunction
autocmd VimEnter * call s:setCommentColor()

syntax on
set list                " 行番号の表示
set number              " 不可視文字の可視化
" set relativenumber              " 不可視文字の可視化
set wildmenu            " コマンドライン補完が強力になる
set showcmd             " コマンドを画面の最下部に表示する
set wrap                " 長いテキストの折り返し
set textwidth=0         " 自動的に改行が入るのを無効化
set colorcolumn=120      " その代わり80文字目にラインを入れる
function! s:SetCursorLine()
  set cursorline
  hi cursorline cterm=underline guifg=green
  " hi Visual ctermbg=blue ctermfg=30
  " hi Visual  guifg=White guibg=LightBlue gui=none
  " hi Visual cterm=NONE ctermbg=0 ctermfg=NONE guibg=Grey40
  hi Visual cterm=bold ctermbg=27 ctermfg=NONE
  hi Cursor ctermbg=green ctermfg=green
endfunction
autocmd VimEnter * call s:SetCursorLine()

" 前時代的スクリーンベルを無効化
set t_vb=
set novisualbell
set foldmethod=indent    " 折り畳み
set foldlevel=100    " ファイルを開くときに折り畳みをしない

""" 編集関係
set infercase           " 補完時に大文字小文字を区別しない
" set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
" set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=2         " 対応括弧のハイライト表示を3秒にする
set autoindent          " 改行時にインデントを引き継いで改行する

" 改行時にインデントを引き継ぎたいが、それ以外の場面では引き継ぎたくない

set shiftwidth=2        " インデントにつかわれる空白の数
au BufNewFile,BufRead *.yml set shiftwidth=2
set softtabstop=2       " <Tab>押下時の空白数
set expandtab           " <Tab>押下時に<Tab>ではなく、ホワイトスペースを挿入する
set tabstop=2           " <Tab>が対応する空白の数
au BufNewFile,BufRead *.yml set tabstop=2
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set nf=                 " インクリメント、デクリメントを10進数にする

" 対応括弧に'<'と'>'のペアを追加
set matchpairs& matchpairs+=<:>

" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start

" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在しているかどうかで設定を分ける必要がある
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus,unnamed
else
    set clipboard& clipboard+=unnamed
endif

" Swapファイル, Backupファイルを全て無効化する
set nowritebackup
set nobackup
set noswapfile

""" 検索関係
set ignorecase          " 大文字小文字を区別しない
set smartcase           " 検索文字に大文字がある場合は大文字小文字を区別
set incsearch           " インクリメンタルサーチ
set hlsearch            " 検索マッチテキストをハイライト

" バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

""" マクロおよびキー設定
" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" カーソル下の単語を * で検索
" vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
" nnoremap n nzz
" nnoremap N Nzz
nnoremap * *Nzz<Esc>
vnoremap * *Nzz<Esc>
" nnoremap # #zz
nnoremap # <Nop>
" nnoremap g* g*zz
" nnoremap g# g#zz

" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk

" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %

" [ と打ったら [] って入力されてしかも括弧の中にいる(以下同様)
inoremap [ []<left>
inoremap ( ()<left>
inoremap { {}<left>
" inoremap < <><left>

" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" タブ間の移動
nnoremap <C-n> gt
nnoremap <C-p> gT

" :e などでファイルを開く際にフォルダが存在しない場合は自動作成
function! s:mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)

" vim 起動時のみカレントディレクトリを開いたファイルの親ディレクトリに指定
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif
    if a:bang == ''
        pwd
    endif
endfunction
autocmd MyAutoCmd VimEnter * call s:ChangeCurrentDir('', '')


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
  let g:rc_dir    = expand('~/.vim/rc')
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






" " *******************************************************
" " syntastic
" " *******************************************************
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" set laststatus=2
" set statusline=[%n]\ %<%f%h%m

" " let g:syntastic_always_populate_loc_list = 1
" " let g:syntastic_auto_loc_list = 1
" " let g:syntastic_check_on_open = 1
" " let g:syntastic_check_on_wq = 0

" let g:syntastic_python_checkers = ['flake8']
" let g:flake8_ignore="E501, W"

" let g:syntastic_python_flake8_args="--max-line-length=200 --ignore=E501"

autocmd FileType python setlocal completeopt-=preview
set nocompatible
filetype on

let g:NERDSpaceDelims=1
let g:NERDDefaultAlign='left'

filetype plugin indenton
autocmd FileType vue syntax sync fromstart
 let g:ft = ''


function! NERDCommenter_before()
  if &ft == 'vue'
    let g:ft = 'vue'
    let stack = synstack(line('.'), col('.'))
    if len(stack) > 0
      let syn = synIDattr((stack)[0], 'name')
      if len(syn) > 0
        exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      endif
    endif
  endif
endfunction

function! NERDCommenter_after()
  if g:ft == 'vue'
    setf vue
    let g:ft = ''
  endif
endfunction

let g:ctrlp_working_path_mode = 0

" インサートモードでも削除等できるようにする
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>
set list listchars=tab:\¦\

" Oでinsert modeに入らずに下に空行を入れる
nnoremap O :<C-u>call append(expand('.'), '')<Cr>j

set wildignore+=*/node_modules/*,*/dist/*,*.dll,*.exe,tags,*.jpg,*jpeg,*.png,*.mp3,*.svg,*.log,*.lock,package-lock.json,*/venv/*,*/venv*/*,*pyc,*/static/*,*.sqlite3,*.sqlite3*,*sql,*/IPython/*,*.mo,venv,**/venv/**
" CtrlPで、不要なフォルダーを除外
    "\ 2: ['node_modules', 'hg --cwd %s locate -I .'],
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others'],
    \ 2: ['node_modules', 'venv'],
    \ },
  \ 'fallback': 'find %s -type f'
  \ }

" F7でファイル整形
map <F7> mzgg=G`z

" if has('mac')
  " set ttimeoutlen=1
  " let g:imeoff = 'osascript -e "tell application \"System Events\" to key code 102"'
  " augroup MyIMEGroup
  "   autocmd!
  "   autocmd InsertLeave * :call system(g:imeoff)
  " augroup END
  " noremap <silent> <ESC> <ESC>:call system(g:imeoff)<CR>
" endif

" j二回連打でノーマルモードに戻る
inoremap <silent> jj <ESC>
" https://kujirahand.com/blog/index.php?vi%E3%81%A7ESC%E3%82%AD%E3%83%BC%E3%81%8C%E9%81%A0%E3%81%84%E3%81%A8%E6%80%9D%E3%81%A3%E3%81%9F%E3%82%89
imap <C-j> <esc>
noremap! <C-j> <esc>

set splitright

" if &term =~ '256color'
"     " Disable Background Color Erase (BCE) so that color schemes
"     " work properly when Vim is used inside tmux and GNU screen.
"     set t_ut=
" endif


inoremap <C-e> <Esc>$a
noremap <C-e> $
inoremap <C-a> <Esc>^i
noremap <C-a> ^

set synmaxcol=320

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=8 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

vnoremap > >gv
vnoremap < <gv


let g:indentLine_faster = 1
nmap <silent><Leader>i :<C-u>IndentLinesToggle<CR>

" let g:indentLine_setColors = 0
" Vim
let g:indentLine_color_term = 110

" GVim
let g:indentLine_color_gui = '#A4E57E'

" none X terminal
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)

" Background (Vim, GVim)
" let g:indentLine_bgcolor_term =
let g:indentLine_bgcolor_gui = '#FF5F00'


if &term =~ '256color'
    set t_ut=
endif


" vimgrep
set grepprg=grep\ -rnIH\ --exclude-dir=.svn\ --exclude-dir=.git\ --exclude-dir=node_modules
set wildignore+=*/node_modules/*,*/dist/*,*.dll,*.exe,tags,*.jpg,*jpeg,*.png,*.mp3,*.svg,*.log,*.lock,package-lock.json,*/venv/*,*/venv*/*,*pyc,*/static/*,*.sqlite3,*.sqlite3*,*sql
autocmd QuickfixCmdPost vimgrep copen
autocmd QuickfixCmdPost grep copen

" grep の書式を挿入
nnoremap <expr> <Space>g ':vimgrep /\<' . expand('<cword>') . '\>/j **/*.' . expand('%:e')
nnoremap <expr> <Space>G ':sil grep! ' . expand('<cword>') . ' *'


" json
set conceallevel=0
let g:vim_json_syntax_conceal = 0


" easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
" map <Leader> <Plug>(easymotion-prefix)

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
map <Space>s <Plug>(easymotion-bd-f2)
nmap <Space>s <Plug>(easymotion-overwin-f2)
" nmap <Space><Space>s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Space>j <Plug>(easymotion-j)
map <Space>k <Plug>(easymotion-k)
map <Space>w <Plug>(easymotion-w)
map <Space>b <Plug>(easymotion-b)

" 候補表示順を変更
" let g:EasyMotion_keys = 'fjdkslaureiwoqpvncm'


let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.linenr = '行'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = ' 字'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

let g:airline_theme = 'light'

set statusline+=%F



let g:airline_section_x=''
let g:airline_section_y=''
let g:airline_section_c='%F'




" ale
" let g:ale_lint_on_enter = 0

" nmap <silent> <Subleader>p <Plug>(ale_previous)
" nmap <silent> <Subleader>n <Plug>(ale_next)
" nmap <silent> <Subleader>a <Plug>(ale_toggle)

" function! s:ale_list()
"   let g:ale_open_list = 1
"   call ale#Queue(0, 'lint_file')
" endfunction
" command! ALEList call s:ale_list()
" nnoremap <Subleader>m  :ALEList<CR>

" let g:ale_sh_shellcheck_options = '-e SC1090,SC2059,SC2155,SC2164'

" 保存時のみ実行する
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
" 表示に関する設定
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:airline#extensions#ale#open_lnum_symbol = '('
let g:airline#extensions#ale#close_lnum_symbol = ')'
let g:ale_echo_msg_format = '[%linter%]%code: %%s'
highlight link ALEErrorSign Tag
highlight link ALEWarningSign StorageClass
" Ctrl + kで次の指摘へ、Ctrl + jで前の指摘へ移動
nmap <Space><C-k> <Plug>(ale_previous_wrap)
nmap <Space><C-j> <Plug>(ale_next_wrap)


set completeopt=menuone,noinsert



" yankround.vim
"" キーマップ
" nmap p <Plug>(yankround-p)
" xmap p <Plug>(yankround-p)
" nmap P <Plug>(yankround-P)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)

" <C-p><C-n>は貼り付け直後にしか有効ではありません。
" もしもそれが勿体ないと感じるのでしたら、<expr>を使ったマッピングでyankround#is_active()を使うことで、普段は別の役割を持たせることが出来ます。
" 例えば、yankroundが有効でないときの<C-p>で、:CtrlPを呼び出すなど。
nnoremap <silent><SID>(ctrlp) :<C-u>CtrlP<CR>
nmap <expr><C-p> yankround#is_active() ? "\<Plug>(yankround-prev)" : "<SID>(ctrlp)"

"" 履歴取得数
let g:yankround_max_history = 30

" ""履歴一覧(kien/ctrlp.vim)
" nnoremap <silent>g<C-p> :<C-u>CtrlPYankRound<CR>

""履歴一覧(kien/ctrlp.vim)
nnoremap <silent>g<C-p> :<C-u>Unite yankround<CR>

let g:netrw_list_hide= '^\.'




" visualモードでの連続ペーストを可能にする
xnoremap p pviwy
xnoremap P Pviwy


" dやxでカットしないようにする。カットはxを使用する。
xnoremap d "_d
" sでカットしない
nnoremap s "_s
xnoremap s "_s

" pythonの場合のみWでスネークケースで移動
let extension = expand('%:e')
if extension == "py"
  map W /_<CR>l<Esc><Esc>
else
  map W /[A-Z]<CR><Esc><Esc>
endif


"netrw
" 画面上部の情報を非表示にする
let g:netrw_banner=0
" 表示形式をツリー形式にする
let g:netrw_liststyle=3
" 全ファイルをデフォルト表示
let g:netrw_hide=0


" netrw 中の t (新しいタブで開く) キーを無効化しメタキーが動作するようにする
augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END
function! NetrwMapping()
  noremap <buffer> <C-l> <C-w>l
endfunction

" ベルオフ
set belloff=all

""" release autogroup in MyAutoCmd
augroup MyAutoCmd
    autocmd!
augroup END

""" 表示関係
set t_Co=256
set background=dark
colorscheme molokai 

function! s:setCommentColor()
  hi Comment cterm=NONE ctermfg=194
  hi Search cterm=NONE ctermfg=160 ctermbg=192
endfunction
autocmd VimEnter * call s:setCommentColor()

syntax on
set list                " 行番号の表示
set number              " 不可視文字の可視化 
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
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
" nnoremap n nzz
" nnoremap N Nzz
nnoremap * *N
nnoremap # #zz
" nnoremap g* g*zz
nnoremap g# g#zz

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

" " *******************************************************
" " dein
" " *******************************************************
" if &compatible
"   set nocompatible
" endif
" set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim
" if dein#load_state(expand('~/.vim/dein'))
"     call dein#begin(expand('~/.vim/dein'))

"     call dein#add('Shougo/dein.vim')
"     call dein#add('Shougo/neocomplete.vim') " vimの補完機能
"     " call dein#add('Shougo/neosnippet.vim') " vimのsnippet機能。:NeoSnippetEditで編集可能。
"     " call dein#add('Shougo/neosnippet-snippets') " 基本的なsnippetのセット
"     " call dein#add('scrooloose/nerdtree') " ディレクトリをツリー表示できる
"     " call dein#add('vim-syntastic/syntastic') " 構文チェック。linterは適宜追加。
"     " call dein#add('tpope/vim-fugitive.git') " vim内でgitを扱えるようにする
"     " call dein#add('tpope/vim-surround') " 「テキストを囲うもの」の編集を行う
"     " call dein#add('vim-scripts/YankRing.vim') " テキストコピーの履歴を順々に参照できる。<C-p>, <C-n>で循環。
"     " call dein#add('davidhalter/jedi-vim', {'on_ft': 'python'}) " pythonの高機能な補完機能。

"     call dein#end()
"     call dein#save_state()
" endif
" filetype plugin indent on
" syntax enable
" " If you want to install not installed plugins on startup.
" if dein#check_install()
"   call dein#install()
" endif

" *******************************************************
" syntastic
" *******************************************************
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set laststatus=2
set statusline=[%n]\ %<%f%h%m

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

let g:syntastic_python_checkers = ['flake8']
let g:flake8_ignore="E501, W"

let g:syntastic_python_flake8_args="--max-line-length=200"

autocmd FileType python setlocal completeopt-=preview
set nocompatible
filetype on 

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#begin(expand('~/.vim/bundle/'))
    "insert here your Neobundle plugins"
    NeoBundle 'posva/vim-vue'
    " 必須プラグイン。コメントを簡単にon/offできる
    NeoBundle 'scrooloose/nerdcommenter'
    " NeoBundle 'Shougo/neomru.vim'
    " 良いプラグイン。:Gstatusや:Gdiffなどでgitのコマンドが使える。
    NeoBundle 'tpope/vim-fugitive'
    " 良いプラグライン。:CtrlPで設定したパス以下のファイルを検索できる。
    NeoBundle "ctrlpvim/ctrlp.vim"
    " 必須プラグイン。インデントに縦線を表示してくれる。
    NeoBundle 'Yggdroot/indentLine'
    " NeoBundle 'bling/vim-airline'
    NeoBundle 'vim-airline/vim-airline'
    NeoBundle 'vim-airline/vim-airline-themes'
    NeoBundle "scrooloose/syntastic"
    " NeoBundle "Shougo/neocomplete.vim"
    NeoBundle 'google/vim-searchindex'
    NeoBundle 'LeafCage/yankround.vim'
    NeoBundle 'dart-lang/dart-vim-plugin'
    NeoBundle 'digitaltoad/vim-pug'
    NeoBundle 'leafgarland/typescript-vim'
  call neobundle#end()
endif

filetype on
let g:NERDSpaceDelims=1
let g:NERDDefaultAlign='left'

filetype plugin indent on
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

" CtrlPで、不要なフォルダーを除外
    "\ 2: ['node_modules', 'hg --cwd %s locate -I .'],
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others'],
    \ 2: ['node_modules'],
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

let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" " airline symbols
" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = ''
" let g:airline_right_sep = ''
" let g:airline_right_alt_sep = ''
" let g:airline_symbols.branch = ''
" let g:airline_symbols.readonly = ''
" let g:airline_symbols.linenr = ''

let g:airline_theme = 'light'

set statusline+=%F


set splitright 

" quickbuf用マッピング
let g:qb_hotkey = "<space><space>"

" if &term =~ '256color'
"     " Disable Background Color Erase (BCE) so that color schemes
"     " work properly when Vim is used inside tmux and GNU screen.
"     set t_ut=
" endif


inoremap <C-e> <Esc>$a
noremap <C-e> $
inoremap <C-a> <Esc>^i
noremap <C-a> ^

let g:airline_section_x=''
let g:airline_section_y=''
let g:airline_section_c='%F'

set synmaxcol=320

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

vnoremap > >gv
vnoremap < <gv


" "----------------------------------------------------------
" " neocomplete・neosnippetの設定
" "----------------------------------------------------------
" if neobundle#is_installed('neocomplete.vim')
"     " Vim起動時にneocompleteを有効にする
"     let g:neocomplete#enable_at_startup = 1
"     " smartcase有効化. 大文字が入力されるまで大文字小文字の区別を無視する
"     let g:neocomplete#enable_smart_case = 1
"     " 3文字以上の単語に対して補完を有効にする
"     let g:neocomplete#min_keyword_length = 3
"     " 区切り文字まで補完する
"     let g:neocomplete#enable_auto_delimiter = 1
"     " 1文字目の入力から補完のポップアップを表示
"     let g:neocomplete#auto_completion_start_length = 1
"     " バックスペースで補完のポップアップを閉じる
"     inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"

"     " " エンターキーで補完候補の確定. スニペットの展開もエンターキーで確定・・・・・・②
"     " imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
"     " " タブキーで補完候補の選択. スニペット内のジャンプもタブキーでジャンプ・・・・・・③
"     " imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"
" endif



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


" yankround.vim {{{
"" キーマップ
nmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)
"" 履歴取得数
let g:yankround_max_history = 50
""履歴一覧(kien/ctrlp.vim)
nnoremap <silent>g<C-p> :<C-u>CtrlPYankRound<CR>


let g:netrw_list_hide= '^\.'



if &term =~ '256color'
    set t_ut=
endif


" vimgrep
set wildignore=*.dll,*.exe,tags,*.jpg,*jpeg,*.png,*.mp3,*.svg
set grepprg=grep\ -rnIH\ --exclude-dir=.svn\ --exclude-dir=.git\ --exclude-dir=node_modules
set wildignore=*/node_modules/*
autocmd QuickfixCmdPost vimgrep copen
autocmd QuickfixCmdPost grep copen

" grep の書式を挿入
nnoremap <expr> <Space>g ':vimgrep /\<' . expand('<cword>') . '\>/j **/*.' . expand('%:e')
nnoremap <expr> <Space>G ':sil grep! ' . expand('<cword>') . ' *'


" json
set conceallevel=0
let g:vim_json_syntax_conceal = 0

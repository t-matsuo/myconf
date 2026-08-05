".vimrc for Linux, Windows, Cygwin
"MATSUO Takatoshi(matsuo.tak@gmail.com)

"関数--------------------------------------------------------------
"カーソル下の単語と同じ単語を強調表示関数
function! HighlightWordUnderCursor()
    if getline(".")[col(".")-1] !~# '[[:punct:][:blank:]]'
        exec 'match' 'Search' '/\V\<'.expand('<cword>').'\>/'
    else
        match none
    endif
endf

"指定したプラグインがインストールされているか判別
function! Has_plugin(plugin)
  for line in split(execute(':echo &runtimepath'),",")
      "UNIX系の場合
      if (substitute(line,'.*/','','g') == a:plugin)
        return 1
        break
      endif
      "Windowsの場合
      if (substitute(line,'.*\','','g') == a:plugin)
        return 1
        break
      endif
  endfor
  return 0
endf

"基本設定----------------------------------------------------------
"Windows(kaoriya)は自動でプラグイン読み込み設定があるがLinux, Cygwinは無いため読み込む
if !Has_plugin('kaoriya')
  " ~/.vim/plugins下のディレクトリにサブディレクトリがあればruntimepathへ追加
  if !empty(glob('~/.vim/plugins/*'))
    for s:path in split(glob('~/.vim/plugins/*'), '\n')
      if s:path !~# '\~$' && isdirectory(s:path)
        let &runtimepath = &runtimepath.','.s:path
      endif
    endfor
    unlet s:path
  endif
endif

"ターミナル種別
if !Has_plugin('kaoriya')
  set term=xterm-256color
endif

"ステータスラインを常に表示(0:表示しない、1:2つ以上ウィンドウがある時だけ表示)
set laststatus=2
"ファイル名表示
set statusline=%F
"変更チェック表示
set statusline+=%m
"読み込み専用かどうか表示
set statusline+=%r
"ヘルプページなら[HELP]と表示
set statusline+=%h
"プレビューウインドウなら[Prevew]と表示
set statusline+=%w
"ファイルエンコーディング
set statusline+=\ [%{&fileencoding}]
"ファイルフォーマット
set statusline+=[%{&fileformat}]
"ファイルタイプ
set statusline+=[%{&filetype}]
"カーソル下の文字コード
set statusline+=\ [Code=%B]
"これ以降は右寄せ表示
set statusline+=%=
"現在行数/全行数
set statusline+=[行=%l/%L]
"列数
set statusline+=[列=%v]

"クリップボード連携
"set clipboard=unnamed,autoselect

"viminfo ファイルを作成しない
"set viminfo=
"swap ファイルを作成しない
set noswapfile
"バックアップファイルを作成しない
set nobackup
"un~ ファイル(undoの情報)を作成しない
set noundofile

"長い行も表示させる
set display=lastline

"カラースキーマ
colorscheme industry
set background=dark

"シンタックス有効化
syntax on

"マウス有効化
set mouse=a

"タブや行末のスペース、行末を表示さない
set nolist
"タブや行列のスペース、行末を表示する場合の記号
set listchars=tab:»˗,trail:_,eol:↲,extends:»,precedes:«,nbsp:%

"カーソル行/列を強調表示 (再描画が遅くなる)
"set cursorline
"set cursorcolumn

"デフォルトは行番号を表示させない
set nonumber

"タブのインデントサイズ
set tabstop=4

"自動インデントのサイズ
set shiftwidth=4

"勝手なインデントを全て無効化
set noautoindent
set nosmartindent
set nocindent
set indentexpr=
" paste有効にするとinoremapが効かないので無効化
" set paste

"タブを自動でスペースに変換 (set pasteの後で実行すること)
set expandtab

"検索のハイライト有効化
set hlsearch

"バックスペースの挙動を修正
" 0 ":set backspace=" と同じ(Vi互換)
" 1 ":set backspace=indent,eol" と同じ
" 2 ":set backspace=indent,eol,start" と同じ
set backspace=2

"autoインデントをデフォルトで無効
set noautoindent

"autoインデントをF11で切り替える
set pastetoggle=<f11>

"全角文字の表示
if exists('&ambiwidth')
  if $TMUX != ''
    set ambiwidth=single
  else
    set ambiwidth=double
  endif
endif

"補完メニューの高さ
set pumheight=10

"デフォルトのコマンドモードの高さ
autocmd FileType vim set cmdheight=2

"タブバーを常に表示 (1=2つ以上のタブがある場合, 2=常に表示)
set showtabline=2
" タブバーにタブ番号を表示する関数
function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " 現在選択されているタブかどうかでハイライトを切り替え
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    " タブ番号を設定 (例: [1])
    let s .= ' ' . (i + 1) . ':'
    " タブ内のバッファ名（ファイル名）を取得して追加
    let buflist = tabpagebuflist(i + 1)
    let winnr = tabpagewinnr(i + 1)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    if bufname == ''
      let s .= '[No Name]'
    else
      let s .= fnamemodify(bufname, ':t') " パスを除いたファイル名のみ
    endif
    let s .= ' '
  endfor
  " 残りのスペースを埋める
  let s .= '%#TabLineFill#%T'
  return s
endfunction
"作成した関数をタブバーに適用
set tabline=%!MyTabLine()

"キーマップ設定----------------------------------------------------
""ノーマルモード------
"アスタリスクでの検索時に次の単語に自動移動しない
nnoremap * *N

"x削除でyankしない
nnoremap x "_x
"d削除でyankしない
"nnoremap d "_d
"D削除でyankしない
"nnoremap D "_D
"DDをyankなしのddとして扱う
nnoremap DD "_dd

"Ctrl-c二回で検索ハイライト解除
nnoremap  <C-c><C-c> :<C-u>nohlsearch<cr><Esc>
"TAB, Shift-Tabでインデント追加/削除
nnoremap <TAB> v><Esc>
nnoremap <S-TAB> v<<Esc>

if Has_plugin('tcomment')
    "Ctrl-\ でコメントアウト/解除
    nnoremap <C-\> :TComment<cr>
endif

"Ctr-b Ctrl-n で次のバッファ
nnoremap <C-b><C-n> :bnext<CR>
"Ctr-b Ctrl-p で前のバッファ
nnoremap <C-b><C-p> :bprev<CR>
"Ctr-b Ctrl-l バッファを選択
nnoremap <C-b><C-l> :buffers<CR>:b<Space>

"Ctrl-i Ctrl-c でタブ作成
nnoremap <C-i><C-c> :tabnew<CR>
"Ctrl-i Ctrl-k でタブクローズ
nnoremap <C-i><C-k> :tabclose<CR>

"gt で次のタブ (デフォルト動作)
"Ctrl-i Ctrl-n で次のタブ
nnoremap <C-i><C-n> gt

"gT で前のタブ (デフォルト動作)
"Ctrl-i Ctrl-p で前のタブ
nnoremap <C-i><C-p> gT

"Ctrl-i Ctrl-l でタブ一覧
nnoremap <C-i><C-l> :tabs<CR>:tabnext<Space>

"Ctrl-i 数字で N番目のタブに移動
nnoremap <C-i>1 1gt
nnoremap <C-i>2 2gt
nnoremap <C-i>3 3gt
nnoremap <C-i>4 4gt
nnoremap <C-i>5 5gt
nnoremap <C-i>6 6gt
nnoremap <C-i>7 7gt
nnoremap <C-i>8 8gt
nnoremap <C-i>9 9gt

""挿入モード---------
"Shift-Tabでインデント削除
inoremap <S-TAB> <Esc>v<<Esc>a

"挿入モードでもコメントアウト有効化
if Has_plugin('tcomment')
    inoremap <C-\> <C-o>:TComment<cr>
endif

"ビジュアルモード----
"インデント追加・削除時後に選択範囲を再選択
vnoremap > >gv
vnoremap < <gv
"Tab, Shift-Tabでインデント追加/削除
vmap <TAB> >
vmap <S-TAB> <

if Has_plugin('tcomment')
    "Ctrl-\ でコメントアウト/解除 & 再選択
    vnoremap <C-\> :TCommentMaybeInline<cr>gv
endif

"autocmd設定-------------------------------------------------------
augroup myautocmd
    "autocmd二重定義回避のための設定
    autocmd! myautocmd

	"GUIの背景とフォントの色
    autocmd VimEnter * hi Normal guifg=#b3b3b3 guibg=Black

    "全角スペースハイライト有効化
    autocmd BufNew,BufRead,VimEnter * syntax match JISX0208Space "　" display containedin=ALL
    autocmd VimEnter * hi JISX0208Space term=underline ctermbg=238 guibg=#114422

    "行頭/行末スペースハイライト
    "autocmd BufNew,BufRead,VimEnter * syntax match SOLSpace "^ \+" display containedin=ALL
    autocmd BufNew,BufRead,VimEnter * syntax match SOLSpace " \+$" display containedin=ALL
    autocmd VimEnter * hi SOLSpace term=underline ctermbg=52 guibg=#331133

    "タブハイライト
    autocmd BufNew,BufRead,VimEnter * syntax match Tab "\t" display containedin=ALL
    autocmd VimEnter * hi Tab term=underline ctermbg=234 guibg=#202000

    "カーソル行の単語ハイライト
    "set updatetime=10
    "autocmd! CursorHold,CursorHoldI * call HighlightWordUnderCursor()

    "制御文字等はグレー表示 (autocmdを使用してカラースキーマ変更時も上書きされないようにしている)
    autocmd VimEnter * hi NonText    ctermbg=None ctermfg=59 guibg=NONE guifg=Gray
    autocmd VimEnter * hi SpecialKey ctermbg=None ctermfg=59 guibg=NONE guifg=Gray

    "補完メニューの色
    autocmd VimEnter * hi Pmenu       ctermbg=Gray ctermfg=Black guibg=Gray guifg=Black "非選択メニューの色
    autocmd VimEnter * hi PmenuSel    ctermbg=Red  ctermfg=White guibg=Red  guifg=White "選択メニューの色
    autocmd VimEnter * hi PmenuSbar   ctermbg=Gray               guibg=Gray             "スクロールバーの色
    autocmd VimEnter * hi PmenuThumb  ctermbg=Red                guibg=Red              "スクロールレバーの色

    "カレント行の色を設定
    autocmd VimEnter * hi CursorLine term=None cterm=None ctermbg=None gui=None guibg=NONE

    "カレント列の色を設定
    autocmd VimEnter * hi CursorColumn term=None cterm=None ctermbg=234 gui=None guibg=#171717

    "コメント行内での改行時の自動フォーマット入を無効化
    autocmd FileType * set comments=

    "ファイル種別によるタブインデント変更
    "autocmd BufNewFile,BufRead *.c   set tabstop=4
    "autocmd BufNewFile,BufRead *.go  set tabstop=4

    "挿入モード時にステータスバーの色を変更
    autocmd InsertEnter * hi StatusLine term=bold,reverse cterm=bold ctermfg=White ctermbg=Blue  guifg=#6666ff guibg=White    "挿入モード時の色
    autocmd InsertLeave * hi StatusLine term=bold,reverse cterm=bold ctermfg=Black ctermbg=White guifg=#aaaaaa guibg=#222222 "通常モード時の色

    "vimスクリプトのファイルはコマンドのファイルの高さを広げる
    autocmd FileType vim set cmdheight=3
augroup END

"Windowsではない場合の設定
if !Has_plugin('kaoriya')
    " 文字コード判別 ---------------
    if &encoding !=# 'utf-8'
      set encoding=japan
      set fileencoding=japan
    endif
    if has('iconv')
      let s:enc_euc = 'euc-jp'
      let s:enc_jis = 'iso-2022-jp'
      if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
      elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
      endif
      if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
        let &fileencodings = &fileencodings .','. s:fileencodings_default
        unlet s:fileencodings_default
      else
        let &fileencodings = &fileencodings .','. s:enc_jis
        set fileencodings+=utf-8,ucs-2le,ucs-2
        if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
          set fileencodings+=cp932
          set fileencodings-=euc-jp
          set fileencodings-=euc-jisx0213
          set fileencodings-=eucjp-ms
          let &encoding = s:enc_euc
          let &fileencoding = s:enc_euc
        else
          let &fileencodings = &fileencodings .','. s:enc_euc
        endif
      endif
      unlet s:enc_euc
      unlet s:enc_jis
    endif

    if has('autocmd')
      function! AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
          let &fileencoding=&encoding
        endif
      endfunction
      autocmd BufReadPost * call AU_ReCheck_FENC()
    endif
    set fileformats=unix,dos,mac
endif

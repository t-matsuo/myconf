".gvimrc for Linux, Windows, Cygwin
"MATSUO Takatoshi(matsuo.tak@gmail.com)

"カラースキーマ
colorscheme default
"colorscheme industry

"行番号を表示
"set number

"クリップボード連携
set clipboard=unnamed

" ウインドウの幅/高さ
set columns=140
set lines=40

set expandtab

if Has_plugin('kaoriya')
    " Windowsのフォント
    "set guifont=MS_Gothic:h14:cSHIFTJIS
    set guifont=plemolJP:h14:cSHIFTJIS
else
    " Linuxのフォント
    set guifont=Monospace\ 12
endif

" -/+でフォントサイズ変更 (for Windows)
if Has_plugin('kaoriya')
    function! ChageFontSize()
        if &cp || exists("g:loaded_zoom")
            finish
        endif
        let g:loaded_zoom = 1

        let s:save_cpo = &cpo
        set cpo&vim

        " keep default value
        let s:current_font = &guifont

        " command
        command! -narg=0 ZoomIn    :call s:ZoomIn()
        command! -narg=0 ZoomOut   :call s:ZoomOut()
        command! -narg=0 ZoomReset :call s:ZoomReset()

        " map
        nmap + :ZoomIn<CR>
        nmap - :ZoomOut<CR>

        " guifont size + 1
        function! s:ZoomIn()
          let l:fsize = substitute(&guifont, '^.*:h\([^:]*\).*$', '\1', '')
          let l:fsize += 1
          let l:guifont = substitute(&guifont, ':h\([^:]*\)', ':h' . l:fsize, '')
          let &guifont = l:guifont
        endfunction

        " guifont size - 1
        function! s:ZoomOut()
          let l:fsize = substitute(&guifont, '^.*:h\([^:]*\).*$', '\1', '')
          let l:fsize -= 1
          let l:guifont = substitute(&guifont, ':h\([^:]*\)', ':h' . l:fsize, '')
          let &guifont = l:guifont
        endfunction

        " reset guifont size
        function! s:ZoomReset()
          let &guifont = s:current_font
        endfunction

        let &cpo = s:save_cpo
    endf
    call ChageFontSize()
endif

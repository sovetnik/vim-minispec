" The "Vim Minispec" plugin runs Minitest spec and displays the results in Vim quickfix window.
"
" Author:    Oleg 'Sovetnik' Siniuk
" URL:       https://github.com/sovetnik/vim-minispec
" Version:   0.2
" Copyright: Copyright (c) 2017 Oleg Siniuk
" License:   MIT
" -----------------------------------------------------

nmap <unique> <Leader>r <Plug>FileRun
nmap <unique> <Leader>t <Plug>TotalRun
noremap <unique> <script> <Plug>FileRun :call <SID>RunSpec()<CR>
noremap <unique> <script> <Plug>TotalRun :call <SID>RunTotal()<CR>

function s:RunTotal()
    let cmd = 'rake'
    call s:ExecTest(cmd)
endfunction

function s:RunSpec()
    let cmd = 'ruby %p'
    let cmd = substitute(cmd, '%p', s:EscapeBackSlash(@%), 'g')
    call s:ExecTest(cmd)
endfunction

let s:efm_minitest = 
      \ '%E\ \ %n)\ Error:,'
      \. '%W\ \ %n)\ Failure:,'
      \. '%C%m\ [%f:%l]:,'
      \. '%Z\ %f:%l:in\ %m,'
      \. '%C%m,'
      \. '%Z%m,'
      \. '%-G%.%#,'

function s:ExecTest(cmd)
    let s:oldefm = &efm
    let &efm = s:efm_minitest

    echo "Running... " . a:cmd
    cgetexpr system(a:cmd)
    redraw!
    botright copen

    exec "nnoremap <silent> <buffer> q :cclose<CR>"
    exec "nnoremap <silent> <buffer> o <CR>"
    let &efm = s:oldefm
endfunction

function s:EscapeBackSlash(str)
  return substitute(a:str, '\', '\\\\', 'g')
endfunction

" The "Vim Minispec" plugin runs Minitest spec and displays the results in Vim quickfix window.
"
" Author:    Oleg 'Sovetnik' Siniuk
" URL:       https://github.com/sovetnik/vim-minispec
" Version:   0.1
" Copyright: Copyright (c) 2017 Oleg Siniuk
" License:   MIT
" -----------------------------------------------------

nmap <unique> <Leader>r <Plug>RubyFileRun
noremap <unique> <script> <Plug>RubyFileRun :call <SID>RunSpec()<CR>

let g:rubytest_cmd_test = 'ruby %p'

function s:RunSpec()
    let cmd = g:rubytest_cmd_test
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

    let cmd = substitute(a:cmd, '%p', s:EscapeBackSlash('@%'), 'g')
    echo "Running... " . cmd
    cgetexpr system(cmd)
    redraw!
    botright copen

    exec "nnoremap <silent> <buffer> q :cclose<CR>"
    exec "nnoremap <silent> <buffer> o <CR>"
    let &efm = s:oldefm
endfunction

function s:EscapeBackSlash(str)
  return substitute(a:str, '\', '\\\\', 'g')
endfunction

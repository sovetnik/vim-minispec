" The "Vim Minispec" plugin runs Minitest spec and displays the results in Vim quickfix window.
"
" Author:    Oleg 'Sovetnik' Siniuk
" URL:       https://github.com/sovetnik/vim-minispec
" Version:   0.4
" Copyright: Copyright (c) 2017 Oleg Siniuk
" License:   MIT
" -----------------------------------------------------

nmap <unique> <Leader>r <Plug>FileRun
nmap <unique> <Leader>t <Plug>TotalRun
noremap <unique> <script> <Plug>FileRun :call <SID>RunSpec()<CR>
noremap <unique> <script> <Plug>TotalRun :call <SID>RunTotal()<CR>

function s:RunTotal()
    let cmd = 'rake test'
    call s:ExecTest(cmd)
endfunction

function s:RunSpec()
  if expand('%') =~ '_spec.rb'
    let cmd = 'ruby %p'
    let cmd = substitute(cmd, '%p', s:EscapeBackSlash(@%), 'g')
    let g:minispec_last_runned = cmd
  else
    if exists('g:minispec_last_runned')
      let cmd = g:minispec_last_runned
    else
      let cmd = 'rake test'
    endif
  endif
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
    let l:result = system(a:cmd)
    cgetexpr l:result
    redraw!
    if len(getqflist()) > 0
      botright copen
      exec "nnoremap <silent> <buffer> q :cclose<CR>"
      exec "nnoremap <silent> <buffer> o <CR>"
    else
      echom matchstr(l:result, '\d* runs, .*')
    endif

    let &efm = s:oldefm
endfunction

function s:EscapeBackSlash(str)
  return substitute(a:str, '\', '\\\\', 'g')
endfunction

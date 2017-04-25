" The "Vim Minispec" plugin runs Minitest spec and displays the results in Vim quickfix window.
"
" Author:    Oleg 'Sovetnik' Siniuk
" URL:       https://github.com/sovetnik/vim-minispec
" Version:   0.5
" Copyright: Copyright (c) 2017 Oleg Siniuk
" License:   MIT
" -----------------------------------------------------

nmap <unique> <Leader>r <Plug>FileRun
nmap <unique> <Leader>t <Plug>TotalRun
noremap <unique> <script> <Plug>FileRun :call <SID>RunSpec()<CR>
noremap <unique> <script> <Plug>TotalRun :call <SID>RunTotal()<CR>

let s:pattern_lib =  'lib/.*\.rb'
let s:pattern_spec = 'spec/.*_spec\.rb'

fu! s:RunTotal()
  let path = expand('%:p')
  if s:EnsureMinitest(path) > 0
    let cmd = 'rake test'
    call s:ExecTest(cmd)
  else 
    echom 'Cannot find minispec to run'
  endif
endfu

fu! s:RunSpec()
  let path = expand('%:p')
  if s:EnsureMinitest(path) > 0
    let cmd = s:BuildCommand(path)
    let g:minispec_last_runned = cmd
    call s:ExecTest(cmd)
  else 
    echom 'Cannot find minispec to run'
  endif
endfu

fu! s:BuildCommand(path)
  if a:path =~ s:pattern_spec
    let cmd = 'ruby ' . a:path
  elseif a:path =~ s:pattern_lib
    let cmd = 'ruby ' . s:PathLibToSpec(a:path)
  elseif exists('g:minispec_last_runned')
    let cmd = g:minispec_last_runned
  else
    let cmd = 'rake test'
  endif
  return cmd
endfu

" errorformat for standart minitest output
let s:efm_minitest = 
      \ '%E\ \ %n)\ Error:,'
      \. '%W\ \ %n)\ Failure:,'
      \. '%C%m\ [%f:%l]:,'
      \. '%Z\ %f:%l:in\ %m,'
      \. '%C%m,'
      \. '%Z%m,'
      \. '%-G%.%#,'

fu! s:ExecTest(cmd)
    let s:oldefm = &efm
    let &efm = s:efm_minitest
    echo "Running... " . a:cmd
    execute "cd " . s:HanamiRootPath(expand('%:p'))
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
endfu

" returnes line number (usually 2) or 0 if not readable and -1 if no Minitest
fu! s:EnsureMinitest(path)
  if filereadable(s:HanamiRootPath(a:path) . '.hanamirc')
    return match(readfile(s:HanamiRootPath(a:path) . '.hanamirc'), 'test=minitest')
  endif
endfu

"If we can read .hanamirc, we know where Hanami root is
fu! s:HanamiRootPath(path)
  if match(a:path, '/lib/') > -1
    if filereadable(substitute(a:path, 'lib/.*', '.hanamirc', 'g'))
      return substitute(a:path, 'lib/.*', '', 'g')
    endif
  elseif match(a:path, '/spec/') > -1
    if filereadable(substitute(a:path, 'spec/.*', '.hanamirc', 'g'))
      return substitute(a:path, 'spec/.*', '', 'g')
    endif
  else
    return -1
  endif
endfu

fu! s:PathLibToSpec(path)
  let path = substitute(a:path, '/lib/', '/spec/', 'g')
  let path = substitute(path, '.rb', '_spec.rb', 'g')
  return path
endfu

fu! s:EscapeBackSlash(str)
  return substitute(a:str, '\', '\\\\', 'g')
endfu

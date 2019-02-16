" The "Vim Minispec" plugin runs Minitest spec and displays the results in Vim quickfix window.
"
" Author:    Oleg 'Sovetnik' Siniuk
" URL:       https://github.com/sovetnik/vim-minispec
" Version:   0.8.1
" Copyright: Copyright (c) 2017-2019 Oleg Siniuk
" License:   MIT
" -----------------------------------------------------

nmap <Leader>r <Plug>FileRun
nmap <Leader>t <Plug>TotalRun
noremap <script> <Plug>FileRun :call <SID>RunSpec()<CR>
noremap <script> <Plug>TotalRun :call <SID>RunTotal()<CR>

let s:pattern_app =  'apps/.*\.rb'
let s:pattern_lib =  'lib/.*\.rb'
let s:pattern_spec = 'spec/.*_spec\.rb'
let s:pattern_result = '\d* runs, \d*.* \d* skips'
let s:pattern_time = '\vFinished\zs in \d*.\d*s'

hi GreenBar term=reverse ctermfg=white ctermbg=green guifg=white guibg=green
hi RedBar   term=reverse ctermfg=white ctermbg=red guifg=white guibg=red

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
  elseif a:path =~ s:pattern_app || a:path =~ s:pattern_lib
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
      \  '%f:%l: %m,'
      \. '%E\ \ %n)\ Error:,'
      \. '%W\ \ %n)\ Failure:,'
      \. '%C%m\ [%f:%l]:,'
      \. '%Z\ %f:%l:in\ %m,'
      \. '%C%m,'
      \. '%-Z%m,'
      \. '%-G%.%#,'

fu! s:ExecTest(cmd)
  let s:oldefm = &efm
  let &efm = s:efm_minitest
  let s:message_frozen = 0
  echo "Running... " . a:cmd
  execute "cd " . s:RootPath(expand('%:p'))

  " clean quickfix list before run
  cgetexpr []

  " run async if has nvim job control
  if has('nvim')
    call jobstart(['bash', '-c', a:cmd], {
          \ 'on_stdout': function('s:OnStdout'),
          \ 'on_stderr': function('s:OnError'),
          \ 'on_exit': function('s:OnExit')
          \ } )
  else
    s:FallbackToBlocking(a:cmd)
  endif
endfu

fu! s:OnStdout(job_id, data, event) dict 
  caddexpr a:data
  " call append(line('$'), '###### OnStdout')
  if empty(matchstr(a:data, s:pattern_result)) < 1
    if len(getqflist()) > 0
      let s:color_bar = 'red'
    else
      let s:color_bar = 'green'
    endif
    let s:message = 'Result: ' 
          \. matchstr(a:data, s:pattern_result) 
          \. '. '
          \. matchstr(a:data, s:pattern_time)
    let s:message_frozen = 1
  endif
endfu

fu! s:OnError(job_id, data, event) dict 
  " caddexpr a:data
  " call append(line('$'), '###### OnError
  if empty(a:data[0]) < 1
    if s:message_frozen == 0
      let s:color_bar = 'red'
      let s:message = 'Fatal: ' . a:data[0]
    endif
  endif
endfu

fu! s:OnExit(job_id, data, event) dict 
  " call append(line('$'), '###### OnExit')
  if len(getqflist()) > 0
    botright copen
    exec "nnoremap <silent> <buffer> q :cclose<CR>"
    exec "nnoremap <silent> <buffer> o <CR>"
  else
    cclose
  endif
  " flash message with color_bar for 420 ms
  if s:color_bar == 'green'
    echohl GreenBar
  else
    echohl RedBar
  endif
  echomsg s:message
  let &efm = s:oldefm
  sleep 420m
  " replace with non-highlighted message
  echohl None
  echomsg s:message
endfu

fu! s:FallbackToBlocking(cmd)
  let l:result = system(a:cmd)
  cgetexpr l:result
  redraw!
  if len(getqflist()) > 0
    botright copen
    exec "nnoremap <silent> <buffer> q :cclose<CR>"
    exec "nnoremap <silent> <buffer> o <CR>"
    echohl RedBar
  else
    echohl GreenBar
  endif
  let s:message = 'Result: ' 
        \. matchstr(l:result, s:pattern_result) 
        \. '. '
        \. matchstr(l:result, s:pattern_time)
  echomsg s:message
  sleep 420m
  let &efm = s:oldefm
  echohl None
  echomsg s:message
endfu

" returnes line number (usually 2) or 0 if not readable and -1 if no Minitest
fu! s:EnsureMinitest(path)
  if filereadable(s:RootPath(a:path) . 'spec/spec_helper.rb')
    return match(readfile(s:RootPath(a:path) . 'spec/spec_helper.rb'), "^require 'minitest/autorun'")
  elseif filereadable(s:RootPath(a:path) . '.hanamirc')
    return match(readfile(s:RootPath(a:path) . '.hanamirc'), '^test=minitest')
  endif
endfu

"If we can read spec/spec_helper, we know where Gem root is
" gem root path or -1
fu! s:RootPath(path)
  if match(a:path, '/lib/') > -1
    if filereadable(substitute(a:path, 'lib/.*', 'spec/spec_helper.rb', 'g'))
      return substitute(a:path, 'lib/.*', '', 'g')
    endif
  elseif match(a:path, '/spec/') > -1
    if filereadable(substitute(a:path, 'spec/.*', 'spec/spec_helper.rb', 'g'))
      return substitute(a:path, 'spec/.*', '', 'g')
    endif
  elseif match(a:path, '/apps/') > -1
    if filereadable(substitute(a:path, 'apps/.*', '.hanamirc', 'g'))
      return substitute(a:path, 'apps/.*', '', 'g')
    endif
  else
    return -1
  endif
endfu

fu! s:PathLibToSpec(path)
  let path = substitute(a:path, '/lib/', '/spec/', 'g')
  let path = substitute(path, '/apps/', '/spec/', 'g')
  let path = substitute(path, '.rb', '_spec.rb', 'g')
  return path
endfu

fu! s:EscapeBackSlash(str)
  return substitute(a:str, '\', '\\\\', 'g')
endfu

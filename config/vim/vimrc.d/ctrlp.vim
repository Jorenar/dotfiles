if &rtp !~# 'pack/.*/ctrlp.vim' | finish | endif

let g:ctrlp_cache_dir     = $XDG_CACHE_HOME . '/vim/ctrlp'
let g:ctrlp_types         = [ 'fil', 'buf', 'mru' ]
let g:ctrlp_extensions    = [ 'tag', 'line' ]
let g:ctrlp_mruf_relative = 1
let g:ctrlp_mruf_exclude  = '/tmp/.*\|/temp/.*'
let g:ctrlp_map           = '<C-p><C-p>'
let g:ctrlp_match_window  = 'results:100'

function! s:MyCtrlPMRUCacheFile() abort
  let snr = utils#misc#get_script_number('ctrlp.vim/autoload/ctrlp/mrufiles.vim')
  if snr < 0 | return | endif
  let s:cadir = $XDG_STATE_HOME.'/vim/ctrlp'
  let s:cafile = s:cadir.'/mru.txt'
  exec      'function! <SNR>'.snr.'_savetofile(mrufs)' . "\n"
        \ . '  call ctrlp#utils#writecache(a:mrufs, s:cadir, s:cafile)' . "\n"
        \ . 'endfunction'
  function! ctrlp#mrufiles#cachefile() abort
    return s:cafile
  endfunction
endfunction

call s:MyCtrlPMRUCacheFile() | delfunc s:MyCtrlPMRUCacheFile

let g:ctrlp_user_command = {
      \   'fallback': 'find %s -type f',
      \   'types': {
      \     1: ['.git', 'cd %s && git ls-files -co'],
      \   },
      \ }

let g:ctrlp_prompt_mappings = {
      \ 'PrtExit()':     [ '<Esc>' ],
      \ 'PrtHistory(1)': [ '<C-f>' ],
      \ 'ToggleType(1)': [ '<C-p>', '<C-Up>' ],
      \ }

nnoremap <C-p><C-b> <Cmd>CtrlPBuffer<CR>
nnoremap <C-p><C-l> <Cmd>CtrlPLine<CR>
nnoremap <C-p><C-m> <Cmd>CtrlPMRU<CR>
nnoremap <C-p><C-t> <Cmd>CtrlPTag<CR>

if executable('fzf')
  if index(g:ctrlp_types, 'fil') >= 0
    call remove(g:ctrlp_types, index(g:ctrlp_types, 'fil'))
    exec 'nnoremap' g:ctrlp_map '<Cmd>FZF<CR>'
    let g:ctrlp_map = ''
  endif

  let g:fzf_layout = { 'down': '10' }

  augroup FZF
    autocmd!
    autocmd FileType fzf setl laststatus=0 | au BufLeave <buffer> setl ls=2
  augroup END
endif

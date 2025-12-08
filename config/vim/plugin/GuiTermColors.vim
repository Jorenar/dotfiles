" GuiTermColors.vim
" Author: Jorenar

if !has('gui_running') | finish | endif

if exists('g:loaded_GuiTermColors') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

let s:SYS_RGB = [
      \   [0x00, 0x00, 0x00],
      \   [0xAA, 0x00, 0x00],
      \   [0x00, 0xAA, 0x00],
      \   [0xAA, 0x55, 0x00],
      \   [0x00, 0x00, 0xAA],
      \   [0xAA, 0x00, 0xAA],
      \   [0x00, 0xAA, 0xAA],
      \   [0xAA, 0xAA, 0xAA],
      \   [0x55, 0x55, 0x55],
      \   [0xFF, 0x55, 0xFF],
      \   [0x55, 0xFF, 0x55],
      \   [0xFF, 0xFF, 0x55],
      \   [0x55, 0x55, 0xFF],
      \   [0xFF, 0x55, 0xFF],
      \   [0x55, 0xFF, 0xFF],
      \   [0xFF, 0xFF, 0xFF],
      \ ]

function! s:to_rgb(code) abort
  if a:code !~ '^\d\+$' | return a:code | endif

  let code = str2nr(a:code)

  if code < 16
    let [ red, green, blue ] = s:SYS_RGB[code]
  elseif code < 232
    let Divmod = { a,b -> [ a/b, a%b ] }
    let cube_rgb_vals = [0, 95, 135, 175, 215, 255]

    let [ cube_red, code ] = Divmod(code - 16, 36)
    let [ cube_green, cube_blue ] = Divmod(code, 6)

    let red = cube_rgb_vals[cube_red]
    let green = cube_rgb_vals[cube_green]
    let blue = cube_rgb_vals[cube_blue]
  else
    let gray = 8 + 10 * (code - 232)
    let [ red, green, blue ] = [ gray, gray, gray ]
  endif

  let FormatHex = { n -> printf('%02x', n) }
  return '#' . FormatHex(red) . FormatHex(green) . FormatHex(blue)
endfunction

function! s:gui_rescheme() abort
  let cterm_pat = 'cterm[a-z]*\s*=\s*[a-zA-Z0-9#]\+'

  let hi = execute("highlight")
  let hi = substitute(hi, 'xxx [^\n]\{-}\n\s\+links', 'xxx links', 'g')
  let hi = substitute(hi, '\n\s\+\ze\a', ' ', 'g')

  for line in split(hi, '\n')
    let rule = split(trim(line))

    if rule[2] == "cleared" || rule[2] == "links"
      continue
    endif

    let key_args = []
    let group = rule[0]
    for key_arg in filter(rule, 'v:val =~ cterm_pat')
      let [key, arg] = split(substitute(key_arg, ' ', '', ''), '=')
      let key = substitute(key, 'cterm', 'gui', '')
      let arg = s:to_rgb(arg)
      let key_args += [ key.'='.arg ]
    endfor

    if empty(key_args)
      continue
    endif

    exec 'hi' group join(key_args)
  endfor
endfunction

autocmd ColorScheme *
      \ if get(g:, 'guitermcolors', 1) | call s:gui_rescheme() | endif

let g:loaded_GuiTermColors = 1
let &cpo = s:cpo_save | unlet s:cpo_save

" GuiTermColors.vim
" Maintainer:  Jorengarenar <https://joren.ga>

if exists('g:loaded_GuiTermColors') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

let s:SYS_RGB = [
      \   [0, 0, 0],
      \   [0xAA, 0, 0],
      \   [0, 0xAA, 0],
      \   [0xAA, 0x55, 0],
      \   [0, 0, 0xAA],
      \   [0xAA, 0, 0xAA],
      \   [0, 0xAA, 0xAA],
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

function! s:gui_rescheme(scheme) abort
  let path = split(globpath(&rtp, 'colors/' . a:scheme . '.vim'), '\n')[0]

  let cterm_pat = 'cterm[a-z]*\s*=\s*[a-zA-Z0-9#]\+'

  for line in readfile(path)
    let line = trim(line)
    if line =~# '\vhi%[ghlight]!? ' && line !~# '\v<%(clear|link)>'
      let key_args = []
      let rule = split(line)
      let group = rule[1]
      for key_arg in filter(rule, 'v:val =~ cterm_pat')
        let [key, arg] = split(substitute(key_arg, ' ', '', ''), '=')
        let key = substitute(key, 'cterm', 'gui', '')
        let arg = s:to_rgb(arg)
        let key_args += [ key.'='.arg ]
      endfor
      exec 'highlight' group join(key_args)
    endif
  endfor
endfunction

if get(g:, 'guitermcolors', 1) && has('gui_running') && exists('g:colors_name')
  call s:gui_rescheme(g:colors_name)
endif

let g:loaded_GuiTermColors = 1
let &cpo = s:cpo_save | unlet s:cpo_save

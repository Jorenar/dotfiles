setlocal foldmethod=syntax
setlocal tabstop=2

if executable("deno")
  SetFormatProg "deno fmt --ext json --indent-width 2 -"
elseif executable("jq")
  SetFormatProg "jq ."
endif

# CSHRC #
# vim: ft=tcsh

set prompt = ""
set prompt = "$prompt%{\e]2;%n@%m:%~\a%}"
set prompt = "$prompt%{\e[38;5;240m%}["
set prompt = "$prompt `uname -s`"
set prompt = "$prompt | `ps -p "$$" -o 'comm='`"
set prompt = "$prompt | %n@%m | %~ "
set prompt = "$prompt]"
set prompt = "$prompt\n%{\e[36m%}%%%{\e[0m%} "

set autolist = ambiguous
set complete = enhance

foreach line ("`sed -E -e '/^\s*#/d' -e 's/(alias .*)=/\1 /g;t;d' $XDG_CONFIG_HOME/sh/aliases`")
    eval $line
end

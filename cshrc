# CSHRC #
# vim: ft=tcsh

set prompt = "%{\e]2;%n@%m:%~\a%}%{\e[38;5;240m%}(`ps -p "$$" -o 'comm='`) [ %n@%m %~ ] \n%{\e[36m%}%#%{\e[0m%} "

set autolist = ambiguous
set complete = enhance

foreach line ("`sed -E -e '/^\s*#/d' -e 's/(alias .*)=/\1 /g;t;d' $XDG_CONFIG_HOME/sh/aliases`")
    eval $line
end

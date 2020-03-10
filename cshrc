# CSHRC #
# vim: ft=tcsh

setenv HOME "$REAL_HOME"
setenv PATH "$_XDG_WRAPPERS\:$PATH"

set prompt = "%{\e]2;%n@%m:%~\a%}%{\e[1m%}%n@%m%{\e[90m%}:%~%{\e[0;1m%}%#%{\e[0m%} "

set autolist = ambiguous
set complete = enhance

foreach line ("`cat $XDG_CONFIG_HOME/shell/aliases | sed -r 's/(alias .*)=/\1 /g' | cut -f1 -d'#'`")
    eval $line
end

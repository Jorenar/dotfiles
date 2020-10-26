# CSHRC #
# vim: ft=tcsh

setenv HOME "$REAL_HOME"

set prompt = "%{\e]2;%n@%m:%~\a%}(`ps -p "$$" -o 'comm='`)%{\e[1m%}%n@%m%{\e[90m%}:%~%{\e[0;1m%}%#%{\e[0m%} "

set autolist = ambiguous
set complete = enhance

foreach line ("`sed -E 's/(alias .*)=/& /g;t;d' $XDG_CONFIG_HOME/shell/aliases`")
    eval $line
end

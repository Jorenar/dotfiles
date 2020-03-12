function fish_prompt
    # +(shell)user@host:pwd:git_branch>

    if set -q PROMPT_SHOW_SHELL
        set show_shell "(fish)"
    else
        set show_shell ""
    end

    set -l git_branch (git rev-parse --abbrev-ref HEAD 2> /dev/null)

    if [ -n "$git_branch" ]
        set git_branch (set_color normal)(set_color --bold)":"(set_color --dim --underline)$git_branch(set_color normal)
    end


    printf '%s%s%s%s%s@%s%s%s:%s%s%s>%s ' \
            (set_color --dim) \
            $show_shell \
            (set_color normal) \
            (set_color --bold) \
            $USER \
            (prompt_hostname) \
            (set_color normal) \
            (set_color --dim) \
            (prompt_pwd) \
            $git_branch \
            (set_color --bold) \
            (set_color normal)
end

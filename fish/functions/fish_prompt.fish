function fish_prompt
    # +(shell)user@host:pwd:git_branch>

    if set -q PROMPT_SHOW_SHELL
        set show_shell "(fish)"
    else
        set show_shell ""
    end

    printf '%s%s%s%s%s@%s%s%s:%s%s%s%s>%s ' \
            (set_color --dim) \
            $show_shell \
            (set_color normal) \
            (set_color --bold) \
            $USER \
            (prompt_hostname) \
            (set_color normal) \
            (set_color --dim) \
            (prompt_pwd) \
            (set_color normal) \
            (git rev-parse --abbrev-ref HEAD 2> /dev/null | sed -r 's/(.*)/:\1/') \
            (set_color --bold) \
            (set_color normal)
end

function fish_prompt
    printf '(fish)%s%s@%s%s:%s%s%s>%s ' (set_color --bold) $USER (prompt_hostname) (set_color --dim) (prompt_pwd) (set_color normal) (set_color --bold) (set_color normal)
end

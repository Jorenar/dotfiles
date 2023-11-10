function fish_mode_prompt
    # Do nothing if not in vi mode
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
        switch $fish_bind_mode
        case default
            echo ':'
        case insert
            echo '+'
        case replace
            echo '+-'
        case visual
            echo '[V]'
        end
    end
end

fish_vi_key_bindings
set fish_greeting ""
set fish_prompt_pwd_dir_length 0

for a in (sed 's/=/ /' $XDG_CONFIG_HOME/sh/aliases)
    eval $a
end

fish_vi_key_bindings
set fish_greeting ""
set fish_prompt_pwd_dir_length 0

for a in (sed -r 's/(alias .*)=/\1 /g;t;d' $XDG_CONFIG_HOME/shell/aliases | sed -r 's/\$\((.*)\)/\(\1\)/g')
    eval $a
end

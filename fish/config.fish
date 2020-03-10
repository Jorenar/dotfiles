fish_vi_key_bindings
set fish_greeting ""
set fish_prompt_pwd_dir_length 0

for a in (cat $XDG_CONFIG_HOME/shell/aliases | sed -r 's/(alias .*)=/\1 /g' | sed -r 's/\$\((.*)\)/\(\1\)/g')
    eval $a
end

__fzf_history__() {
        local output opts script n x y z d
        opts="${FZF_DEFAULT_OPTS-} -n2..,.. +m --read0 "
        [[ $(HISTTIMEFORMAT='' builtin history 1) =~ [[:digit:]]+ ]]
        script='function P(b) { ++n; sub(/^[ *]/, "", b); if (!seen[b]++) { printf "%d\t%s%c", '$((BASH_REMATCH + 1))' - n, b, 0 } }
                        NR==1 { b = substr($0, 2); next }
                        /^\t/ { P(b); b = substr($0, 2); next }
                        { b = b RS $0 }
                END { if (NR) P(b) }'
        output=$(
                set +o pipefail
                builtin fc -lnr -2147483648 2> /dev/null |
                command awk "$script"           |
                FZF_DEFAULT_OPTS="$opts" fzf --query "$READLINE_LINE"
        ) || return
        READLINE_LINE=${output#*$'\t'}
        if [[ -z "$READLINE_POINT" ]]; then
                echo "$READLINE_LINE"
        else
                READLINE_POINT=0x7fffffff
        fi
}
bind -m emacs-standard '"\er": redraw-current-line'
bind -m emacs-standard '"\C-r": "\C-e \C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er"'

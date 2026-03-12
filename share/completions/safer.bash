_safer_complete() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"

    local opts="-e -p -k -n -d -R -X -K -S -f -s -l -i -v -h"

    COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
}

complete -F _safer_complete safer

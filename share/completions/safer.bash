_safer_complete() {
    local cur prev lib_path subdir items dir opts
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    lib_path=${SAFER_LIB_PATH:-~/.local/share/safer:/usr/share/safer:/usr/local/share/safer}
    if [[ "$prev" == "-l" || "$prev" == "-i" ]]; then
        [[ "$prev" == "-l" ]] && subdir=tools || subdir=images
        items=()
        IFS=':' read -ra dirs <<< "$lib_path"
        for dir in "${dirs[@]}"; do
            if [[ -d "$dir/$subdir" ]]; then
                for f in "$dir/$subdir"/*; do
                    if [[ -f "$f" ]]; then
                        items+=("$(basename "$f")")
                    fi
                done
            fi
        done
        COMPREPLY=( "${items[@]}" )
    else
        opts="-e -p -k -n -d -R -X -K -S -f -s -l -i -v -h"
        COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
    fi
}

complete -F _safer_complete safer

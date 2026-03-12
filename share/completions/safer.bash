_safer_complete() {
	local cur prev lib_path subdir items dir opts skip_next positionals images
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"

	# -l, -i
	lib_path=${SAFER_LIB_PATH:-~/.local/share/safer:/usr/share/safer:/usr/local/share/safer}
	if [[ "$prev" == "-l" || "$prev" == "-i" ]]; then
		[[ "$prev" == "-l" ]] && subdir=tools || subdir=images
		items=()
		IFS=':' read -ra dirs <<< "$lib_path"
		for dir in "${dirs[@]}"; do
			if [[ -d "$dir/$subdir" ]]; then
				for f in "$dir/$subdir"/*; do
					[[ -f "$f" ]] && items+=("$(basename "$f")")
				done
			fi
		done
		COMPREPLY=( $(compgen -W "${items[*]}" -- "$cur") )
		return
	fi

	# -* options
	if [[ "$cur" == -* ]]; then
		opts="-e -p -k -n -d -R -X -K -S -f -s -l -i -v -h"
		COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
		return
	fi

	# count non : options
	skip_next=0
	positionals=()
	for ((i=1;i<COMP_CWORD;i++)); do
		w="${COMP_WORDS[i]}"
		if ((skip_next)); then
			skip_next=0
			continue
		fi
		case "$w" in
			-e|-p|-n|-d|-R|-X|-K|-S|-l|-i)
				skip_next=1
				;;
			-*)
				;;
			*)
				positionals+=("$w")
				;;
		esac
	done

	# complete positional 2 with podman/docker images
	if (( ${#positionals[@]} == 1 )); then
		if command -v podman >/dev/null 2>&1; then
			images=$(podman images --format '{{.Repository}}:{{.Tag}}')
		elif command -v docker >/dev/null 2>&1; then
			images=$(docker images --format '{{.Repository}}:{{.Tag}}')
		fi
		if [[ -n "$images" ]]; then
			COMPREPLY=( $(compgen -W "$images" -- "$cur") )
			return
		fi
	fi

	# by default, fallback to dirs
	COMPREPLY=( $(compgen -d -- "$cur") )
	compopt -o nospace
}

complete -F _safer_complete safer

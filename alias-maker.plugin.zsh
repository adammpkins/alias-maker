#!/usr/bin/env zsh
# Define the plugin name and version
[[ -z "$alias_maker_version" ]] && declare alias_maker_version="1.0.0"
[[ -z "$alias_maker_name" ]] && declare -r alias_maker_name="alias-maker"

# Ensure the user's .zshrc file exists
if [[ ! -f "$HOME/.zshrc" ]]; then
    echo "Creating .zshrc file..."
    touch "$HOME/.zshrc"
fi

# Note: legacy 'am' function has been removed. Use mkalias/rmalias directly.

# Create a new zsh alias
function mkalias() {
    # Entry behavior: flags for help/list, otherwise create alias
    if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
        show_help
        return 0
    fi
    if [[ "$1" == "-l" || "$1" == "--list" ]]; then
        list_aliases
        return 0
    fi

    local -r alias_name="$1"
    shift
    local alias_command="$*"

    if [[ -z "$alias_name" || -z "$alias_command" ]]; then
        echo "Usage: mkalias <alias_name> '<alias_command>'" >&2
        return 1
    fi

    # Validate alias name (letters, numbers, underscores and dashes; cannot start with a dash)
    if [[ "$alias_name" == -* || ! "$alias_name" =~ ^[A-Za-z0-9_][A-Za-z0-9_-]*$ ]]; then
        echo "Error: Invalid alias name '$alias_name'. Use letters, numbers, '_' or '-', and don't start with '-'." >&2
        return 1
    fi

    # Check if the alias already exists
    if alias "$alias_name" >/dev/null 2>&1; then
        echo "Error: Alias '$alias_name' already exists." >&2
        return 1
    fi

    # Append the alias to the user's .zshrc using single quotes to avoid $-expansion at source-time.
    # Escape any single quotes in the command using the standard '"'"' sequence.
    local escaped_command
    escaped_command="${alias_command//'/\'"'"\'}"
        # Ensure the file ends with a newline before appending, so we don't concatenate onto the previous token (e.g., 'fi')
        if [[ -s "$HOME/.zshrc" ]]; then
            local _last
            _last=$(tail -c1 "$HOME/.zshrc" 2>/dev/null)
            if [[ "$_last" != $'\n' ]]; then
                echo >>"$HOME/.zshrc"
            fi
        fi
    echo "alias $alias_name='$escaped_command'" >>"$HOME/.zshrc"
    # shellcheck disable=SC1090
    source "$HOME/.zshrc"

    echo "Alias created:"
    echo "  $alias_name → $alias_command"
}

# Remove an existing zsh alias
function rmalias() {
    local -r alias_name=$1

    if [[ -z "$alias_name" ]]; then
        echo "Usage: rmalias <alias_name>" >&2
        return 1
    fi

    # Check if the alias exists
    if ! alias "$alias_name" >/dev/null 2>&1; then
        echo "Alias '$alias_name' does not exist."
        return 1
    fi

    # Delete the alias line from .zshrc (create a temporary backup on macOS)
    # Remove matching alias lines from .zshrc (allow optional leading whitespace)
    sed -i.bak "/^[[:space:]]*alias $alias_name=/d" "$HOME/.zshrc"
    rm -f "$HOME/.zshrc.bak"
    # Unset the alias in the current shell
    unalias "$alias_name" 2>/dev/null || true
    echo "Alias '$alias_name' has been deleted."
}

# List all custom zsh aliases from the user's .zshrc
function list_aliases() {
    local -a aliases=()
    local rc_file="$HOME/.zshrc"

    if [[ ! -f "$rc_file" ]]; then
        echo "No .zshrc file found." >&2
        return 1
    fi

    while read -r line; do
        if [[ $line == alias* ]]; then
            aliases+=("$line")
        fi
    done <"$rc_file"

    if [[ ${#aliases[@]} -gt 0 ]]; then
        echo "🔧 Custom aliases found in $rc_file:" 
        echo ""
        for alias in "${aliases[@]}"; do
            name="${alias%%=*}"
            command="${alias#*=}"
            name="${name#alias }"
            # strip surrounding quotes for display and unescape single-quote pattern if present
            if [[ $command == \"*\" ]]; then
                command=${command#\"}
                command=${command%\"}
            elif [[ $command == \'*\' ]]; then
                command=${command#\'}
                command=${command%\'}
                # Turn the escaped single-quote sequence '\'' back into a single quote for display
                command=${command//\'"'"\'/\'}
            fi
            echo "  - $name → $command"
        done
    else
        echo "No custom aliases found in $rc_file"
    fi
}

# List aliases via standalone command
function lsalias() {
    if [[ $# -gt 0 ]]; then
        echo "Usage: lsalias" >&2
        return 1
    fi
    list_aliases
}

function show_help() {
    echo "Usage:"
    echo "  mkalias <alias_name> '<alias_command>'   Create a new custom zsh alias"
    echo "  mkalias -l | --list                      List all custom zsh aliases in your .zshrc"
    echo "  lsalias                                 List all custom zsh aliases (same as mkalias --list)"
    echo "  rmalias <alias_name>                     Delete an existing custom zsh alias"
    echo "  mkalias -h | --help                      Show this help message"
}

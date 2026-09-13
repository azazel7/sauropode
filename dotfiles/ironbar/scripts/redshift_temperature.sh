#!/usr/bin/env bash
SOCKET_PATH="/run/user/1000/sunsetr-events.sock"

# Vérification des prérequis
if [ ! -S "$SOCKET_PATH" ]; then
    echo "Erreur : Le socket n'existe pas à l'emplacement $SOCKET_PATH" >&2
    exit 1
fi

if ! command -v jaq &> /dev/null; then
    echo "Erreur : 'jaq' est requis mais n'est pas installé." >&2
    exit 1
fi

is_valid() {
    [ -n "$1" ] && [ "$1" != "null" ]
}

# Connexion au socket et lecture en continu ligne par ligne
nc -U "$SOCKET_PATH" | while read -r line; do
    # Ignore empty lines
    [ -z "$line" ] && continue

    # Extract variables
    read -r current_temp current_gamma target_temp target_gamma < <(echo "$line" | jaq -r '.current_temp, .current_gamma, .target_temp, .target_gamma' | xargs)

		if ! is_valid "$current_temp" && ! is_valid "$target_temp"; then
        echo "Ø"
    else
        # Use current_temp if valid, otherwise fallback to target_temp
        if is_valid "$current_temp"; then
            temp="$current_temp"
        else
            temp="$target_temp"
        fi

        echo "$temp"
    fi
done


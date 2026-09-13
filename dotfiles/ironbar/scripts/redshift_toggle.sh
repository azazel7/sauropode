#!/usr/bin/env bash
ACTIVE="$(sunsetr preset active)"

if [[ "$ACTIVE" == "default" ]]; then
    sunsetr preset static_night
elif [[ "$ACTIVE" == "static_night" ]]; then
    sunsetr preset default
else
    sunsetr preset static_night
fi


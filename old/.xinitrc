#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

urxvtd -q -o -f
#Si on à l'argument openbox, on lance openbox sinon, par défaut c'est awesome
if [ $2 = 'openbox' ]; then
	exec openbox-session
fi

exec awesome

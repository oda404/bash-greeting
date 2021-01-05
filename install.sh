#!/usr/bin/bash

sudo cp bash-greeting /bin/

if [ "$SHELL" == "/usr/bin/bash" ]; then
	echo "source bash-greeting" >> ~/.bashrc
	source ~/.bashrc
elif [ "$SHELL" == "/usr/bin/fish" ]; then
	cp ./fish_greeting.fish ~/.config/fish/functions/
else
	echo "Unsupported shell $SHELL"
fi


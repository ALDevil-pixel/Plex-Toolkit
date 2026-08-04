install:
	chmod +x plex-toolkit commands/*

test:
	bash tests/run.sh

lint:
	shellcheck plex-toolkit commands/* lib/*.sh

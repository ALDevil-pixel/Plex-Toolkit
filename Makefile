SHELL := /bin/bash

.PHONY: install test lint validate

install:
	chmod +x plex-toolkit
	find commands lib plugins tests -type f -name '*.sh' -exec chmod +x {} +

test:
	bash tests/run.sh

lint:
	command -v shellcheck >/dev/null 2>&1 || { echo "shellcheck is required for lint"; exit 2; }
	shellcheck plex-toolkit commands/* lib/*.sh plugins/**/*.sh tests/*.sh

validate: test lint

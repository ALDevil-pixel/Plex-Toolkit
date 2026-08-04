#!/usr/bin/env bash
json_escape(){ printf '%s' "$1"|sed 's/"/\\\"/g'; }

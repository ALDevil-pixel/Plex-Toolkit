#!/usr/bin/env bash
# Updated display helpers
if [[ -t 1 ]]; then
  C_RESET="[0m"; C_GREEN="[32m"; C_RED="[31m"; C_YELLOW="[33m"; C_BLUE="[34m"
else
  C_RESET=""; C_GREEN=""; C_RED=""; C_YELLOW=""; C_BLUE=""
fi

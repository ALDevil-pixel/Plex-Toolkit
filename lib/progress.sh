#!/usr/bin/env bash
progress(){ local c=$1 t=$2; printf "\r[%3d%%]" $((c*100/t)); }

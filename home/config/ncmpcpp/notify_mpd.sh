#!/usr/bin/env bash

music_library="$HOME/Data/Music"

ffmpeg -y -i "$(mpc --format "$music_library"/%file% | head -n 1)" /tmp/mpd_cover.jpg > /dev/null 2>&1 && \

notify-send -i /tmp/mpd_cover.jpg "$(mpc current)"

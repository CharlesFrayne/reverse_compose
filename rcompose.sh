#!/bin/env bash

find_compose_file() {
  if [[ -z $XCOMPOSEFILE ]]; then
    our_locale=${LANG?'LANG environment variable not defined and I rely on that to find your compose file'}
    our_filename=$(grep -i $our_locale /usr/share/X11/locale/compose.dir | head -n 1 | awk '{print $1}')
    our_system_compose_file=/usr/share/X11/locale/${our_filename?'failed to find your locale in /usr/share/X11/locale/compose.dir'}
  else
    our_system_compose_file=$XCOMPOSEFILE
  fi
}

xmsg() {
  xmessage -default okay -font '-sony-fixed-medium-*-normal-*-24-230-75-75-*-120-iso8859-1' "$1"  
}

find_compose_file

character_to_find=$(xclip -o)
compose_options=$(grep "\"$character_to_find\"" $our_system_compose_file)
# TODO: look at ~/.Xcompose for custom sequences
if [[ -z $compose_options ]]; then
  xmsg "Not found"
  exit 0
fi
formatted_str=$(printf '[%q]\n${compose_options}')
xmsg "${compose_options}"

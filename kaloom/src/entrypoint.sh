#!/bin/bash
set -e

if [ -n "${USERDATADIR}" ]; then
    dumb-init fixuid -q "/usr/local/bin/code-server" --host "0.0.0.0" --user-data-dir "${USERDATADIR}" --auth "password" "."
else
    dumb-init fixuid -q "/usr/local/bin/code-server" --host "0.0.0.0" --auth "password" "."
fi
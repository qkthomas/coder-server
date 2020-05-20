#!/bin/bash
set -e

csexec="/usr/bin/code-server"
hostip="0.0.0.0"
authmethod="password"

if [ -n "${USERDATADIR}" ]; then
    dumb-init fixuid -q "${csexec}" --host "${hostip}" --user-data-dir "${USERDATADIR}" --auth "${authmethod}" "."
else
    dumb-init fixuid -q "${csexec}" --host "${hostip}" --auth "${authmethod}" "."
fi
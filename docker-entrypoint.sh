#!/bin/bash

: ${DEVPI='/data'}
: ${DEVPISERVER_SERVERDIR="${DEVPI}/server"}
: ${DEVPI_CLIENTDIR="${DEVPI}/client"}

echo "DEVPISERVER_SERVERDIR is ${DEVPISERVER_SERVERDIR}"
echo "DEVPI_CLIENTDIR is ${DEVPI_CLIENTDIR}"

export DEVPI DEVPISERVER_SERVERDIR DEVPI_CLIENTDIR


if [ "${1:-}" != 'devpi' ]; then
    echo "[RUN]: Builtin command not provided [devpi]"
    echo "[RUN]: $@"
    exec "$@"

else if [ -f  "$DEVPISERVER_SERVERDIR/.serverversion" ]; then
    echo "[RUN]: restoring devpi"
    exec devpi-server --role master --host 0.0.0.0 --port 3141

else
    echo "[RUN]: Initializing devpi"
    rm -rf "${DEVPI}/"*

    echo "[RUN]: Initialise devpi-server"
    devpi-init

    echo "[RUN]: start devpi-server"
    devpi-server --host 127.0.0.1 --port 3141
    devpi use http://localhost:3141

    echo "[RUN]: adding root"
    devpi login root --password=''
    devpi user -m root password="${DEVPI_PASSWORD}"
    devpi index -y -c public pypi_whitelist='*'

    echo "[RUN]: adding testuser"
    devpi user -c testuser password=123
    devpi login testuser --password=123
    devpi index -c dev bases=root/pypi
    devpi use testuser/dev

    echo "[RUN]: Launching devpi-server"
    exec devpi-server --host 0.0.0.0 --port 3141
fi

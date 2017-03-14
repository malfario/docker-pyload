#!/bin/bash

if [ ! -f "/opt/pyload/pyload-config/setup.lock" ]
then
        mkdir -p /opt/pyload/pyload-config
        chmod 777 /opt/pyload/pyload-config

        mv /tmp/pyload-config/* /opt/pyload/pyload-config/
fi

if [ -f "/opt/pyload/pyload-config/pyload.pid" ]
then
        rm /opt/pyload/pyload-config/pyload.pid
fi

if [ ! -z "${PYLOAD_UID}" ]
then
  if [ ! "$(id -u pyload)" -eq "${PYLOAD_UID}" ]
  then
    usermod -o -u "${PYLOAD_UID}" pyload
    PYLOAD_CHOWN_DLDIR=1
  fi
fi

if [ ! -z "${PYLOAD_GID}" ]
then
  if [ ! "$(id -g pyload)" -eq "${PYLOAD_GID}" ]
  then
    groupmod -o -g "${PYLOAD_GID}" pyload
    PYLOAD_CHOWN_DLDIR=1
  fi
fi

if [ ! -z "${PYLOAD_CHOWN_DLDIR}" ]
then
  sed -i '18s/False/True/' /opt/pyload/pyload-config/pyload.conf
fi

exec /opt/pyload/pyLoadCore.py

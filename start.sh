#!/bin/bash


function shutdown {
  echo "[start.sh] Stopping apache2"
  service apache2 stop
  echo "[start.sh] Stopped apache2"
  running=0
}


function exit {
  if [ "$running" = "1" ]; then
    shutdown
  fi
  echo "[start.sh] Exiting..."
}


function init {
  if [ ! -f /conf/apache.conf ]; then
    cp /defaults/apache.conf /conf/
    echo "[start.sh] Copied defaut apache.conf to /conf"
  fi

  if [ ! -d /conf/keepass4web ]; then
    cp -R /defaults/keepass4web /conf/
    echo "[start.sh] Copied defaut keepass4web/ to /conf"
  fi

  chown -R root:www-data /conf/keepass4web
  chmod -R g-w /conf/keepass4web
  echo "[start.sh] Set permissions of /conf/keepass4web"
}


function startup {
  running=1
  echo "[start.sh] Starting apache2"
  service apache2 start
  echo "[start.sh] Started apache2"
}


# Maincourse
trap shutdown SIGTERM
trap exit EXIT
init
startup

while true; do
  if [ "$running" = "1" ]; then
    sleep 1
  else
    break
  fi
done
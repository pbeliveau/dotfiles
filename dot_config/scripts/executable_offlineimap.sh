#!/usr/bin/env bash

# provide arg or bail
OPTION=$1
if [ -z "$OPTION" ]; then
  exit 1
fi

# array of mail account
declare -a MAILNAME=("gmail"
                     "ncf"
                     "uqtr")

if [ "$OPTION" == "start" ]; then
  # verify network access
  ping -c 1 -w 2 archlinux.org > /dev/null
  if [ $? -eq 0 ]; then
    echo "connected, starting offlineimap services..."
    for i in "${MAILNAME[@]}"; do
      ACTIVE=$(systemctl --user status offlineimap@$i.service | grep -i dead)
      if [ -n "$ACTIVE" ]; then
        systemctl --user start offlineimap@$i.service
        echo "$i started."
      else
        echo "$i not dead."
        echo "stopping $i."
        systemctl --user stop offlineimap@i.service
        echo "resetting failed services."
        systemctl --user reset-failed

        sleep 1s
        ACTIVE=$(systemctl --user status offlineimap@$i.service | grep -i dead)
        if [ -n "$ACTIVE" ]; then
            systemctl --user start offlineimap@$i.service
            echo "$i started."
        else
            echo "there is something wrong with $i."
        fi
      fi
    done
  else
    echo "can't access the network."
  fi
elif [ "$OPTION" == "stop" ]; then
    echo "stopping offlineimap services..."
    for i in "${MAILNAME[@]}"; do
      ACTIVE=$(systemctl --user status offlineimap@$i.service | grep -i dead)
      if [ -z "$ACTIVE" ]; then
        systemctl --user stop offlineimap@$i.service
        echo "$i stopped."
      else
        echo "$i already dead."
      fi
    done
    systemctl --user reset-failed
else
  exit 1
fi

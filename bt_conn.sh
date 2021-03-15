#!/bin/bash
# BT-WiFi Auto Reconnect (Keep connection alive)
# Created by: Syicoma on Sun 14-Mar-2021

# Suggested use of this script is to run it as a background process as your
# current user. alternatively you can added it to one of your logon/boot processes
# COMMAND = sudo -b -u $(whoami) ./bt_conn.sh

# Config
printf "BT-WiFi Keep Alive v1.0\nCreated by: Syicoma\n\n"
USERNAME=YOUR_LOGIN_EMAIL
PASSWORD=YOUR_PASSWORD
URL=https://www.btwifi.com:8443/home
CONN_URL=https://www.btwifi.com:8443/ante?partnerNetwork=btb

# Send notify to all users
SEND_ALL () {
PATH=/usr/bin:/bin

XUSERS=($(who|grep -E "\(:[0-9](\.[0-9])*\)"|awk '{print $1$NF}'|sort -u))
for XUSER in "${XUSERS[@]}"; do
        NAME=(${XUSER/(/ })
        DISPLAY=${NAME[1]/)/}
        DBUS_ADDRESS=unix:path=/run/user/$(id -u ${NAME[0]})/bus
        sudo -u ${NAME[0]} DISPLAY=${DISPLAY} \
                DBUS_SESSION_BUS_ADDRESS=${DBUS_ADDRESS} \
                PATH=${PATH} \
                notify-send "$@"
done
}

# Check log file exists
if ! [ -f bt_conn.log ]; then
	touch bt_conn.log && echo "Started connection @ $(date)" > bt_conn.log
else
	echo "Started connection @ $(date)" > bt_conn.log
fi

while true; do
	IS_ONLINE=$(wget $URL -q -O - 2>/dev/null | grep -o accountLogoff)	
	if [ "$IS_ONLINE" ]; then
		sleep 60
	else
		IS_ONLINE=false
		#### Desktop Notification
		SEND_ALL "
		BT-WiFi Connection Dropped
		Reconnecting @ $(date)
		"
		echo "Reconnecting BT-WiFi...." & disown
		curl -d "username=$USERNAME&password=$PASSWORD" $CONN_URL
		echo "Reconnected @ $(date)" >> bt_conn.log
		sleep 30
	fi
done

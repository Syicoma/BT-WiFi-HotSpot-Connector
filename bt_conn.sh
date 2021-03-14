#!/bin/bash
# BT-WiFi Auto Reconnect (Keep connection alive)
# Created by: Syicoma on Sun 14-Mar-2021

# Suggested use of this script is to run it as a background process as your
# current user. alternatively you can added it to one of your logon/boot processes
# COMMAND = sudo -b -u $(whoami) ./bt_conn.sh

# Config
printf "BT-WiFi Keep Alive v1.0\nCreated by: Syicoma\n\n"
USERNAME=<login_email>
PASSWORD=<password>
URL=https://www.btwifi.com:8443/home
CONN_URL=https://www.btwifi.com:8443/ante?partnerNetwork=btb

# Check log file exists
if ! [ -f bt_conn.log ]; then
	touch bt_conn.log && echo "Started connection @ $(date)" > bt_conn.log
else
	echo "Started connection @ $(date)" > bt_conn.log
fi

while true; do
	IS_ONLINE=$(wget $URL -O - 2>/dev/null | grep -o accountLogoff)	
	if [ "$IS_ONLINE" ]; then
		sleep 10
	else
		IS_ONLINE=false
		echo "Reconnecting BT-WiFi...." & disown
		curl -d "username=$USERNAME&password=$PASSWORD" $CONN_URL
		echo "Reconnected @ $(date)" >> bt_conn.log
		sleep 10
	fi
done

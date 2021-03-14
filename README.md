# BT-WiFi-HotSpot-Keep-Alive
Created by: Syicoma
Date: 14-March-2021
**
BT-WiFi Hotspot connector** that will keep your connection alive by checking the connection status in intervals.

I created this because I use BT-WiFi HotSpots alot and have face many issues with being in an area where there are multiple BT-WiFi connection.
When in an area with multiple connection points, BT-WiFi seems to bounce between the connection points and forcing me to re-login.

With the following script created. It will POST your connection to the login portal.
After this it will check in intervals for the Logoff button. When the status of the Logoff changes from the resulting web poral, it will post 
the connection request again reconnecting you.

I have also included a log file so you can track how many times you get reconnected.

Best method for this script to run is in a background process

**COMMANDS TO RUN**

-> **chmod +x bt_conn.sh**

-> **sudo -b -u $(whoami) ./bt_conn.sh**


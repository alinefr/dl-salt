#!/bin/bash

MONITOR_LIST="ddll.co staging.ws"
KATO_URL="https://api.kato.im/rooms/4ea525fbb3550cc9342907f87e68cbeed98111512910950e53ba309df73c8c45/simple"

for server_domain in $MONITOR_LIST; do
    server="http://monitor.${server_domain}/monitor.php"
    if [ `/usr/bin/curl -sL -w "%{http_code}" ${server} -o /dev/null` != 200 ]; then
        echo "${server_domain} is down!" 1>&2
        curl -X POST -d "{\"from\": \"Robot\", \"color\": \"pink\", \"renderer\": \"markdown\", \"text\": \"**${server_domain} is down**\" }" $KATO_URL
    fi
done

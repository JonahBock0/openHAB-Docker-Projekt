#!/bin/bash
#docker pull snjobock/openhab

# Container ausführen, benannte volumes verwenden um Daten dauerhaft zu behalten
docker run -d -p 8088:8080 -v "openhab-config:/etc/openhab" -v "openhab-userdata:/var/lib/openhab" --name openhab snjobock/openhab


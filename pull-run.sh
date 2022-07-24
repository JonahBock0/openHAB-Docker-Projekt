#!/bin/bash

# Image herunterladen
docker pull snjobock/openhab
# Container starten
docker run -d --rm -p 8088:8080 --name openhab snjobock/openhab

echo
echo

echo "openHAB ist gleich über http://localhost:8088 im Browser erreichbar"
echo
echo "Beim ersten Start muss ein Nutzer angelegt werden"
echo "und optional können einige grundlegende Einstellungen gesetzt werden."
echo
echo "Zum Beenden Enter drücken"

# Logs ausgeben
(sleep 3 && echo "openHAB Logs:" && docker logs -f openhab) &
read

echo "Container wird gestoppt..."
#Container beenden
docker stop openhab

#!/bin/bash
# Für die Entwicklung der Dockerfile: mit nano bearbeiten, Image bauen, Container starten, automatisch entfernen lassen
nano Dockerfile \
&& docker build -t snjobock/openhab . \
&& docker run --rm -p 8088:8080 --name openhab snjobock/openhab

#!/bin/bash
# Container stoppen
docker stop openhab
# Container entfernen
docker rm openhab
# Angelegte volumes löschen
docker volume rm openhab-config openhab-userdata
# Image löschen
docker rmi snjobock/openhab

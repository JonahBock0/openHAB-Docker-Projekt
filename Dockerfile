# Debian slim Image als Basis
FROM debian:buster-slim

# Benötigte Programme installieren: Java 11 für openHAB, ps für ordentlichen beenden, curl & gpg für key-Installation
RUN apt-get update \
	&& apt-get install openjdk-11-jre-headless procps -y \
	&& apt-get install curl gpg -y \
	&& apt-get clean

# --- openHAB Installation ---
# (https://www.openhab.org/docs/installation/linux.html + https://community.openhab.org/t/failing-to-get-public-key-openhab-installation-linux-debian/137182/10)

# repository key hinzufügen
RUN curl -fsSL "https://openhab.jfrog.io/artifactory/api/gpg/key/public" | gpg --dearmor > openhab.gpg
RUN mkdir -p /usr/share/keyrings
RUN mv openhab.gpg /usr/share/keyrings
RUN chmod u=rw,g=r,o=r /usr/share/keyrings/openhab.gpg
# openHAB repository (stable) hinzufügen
RUN echo 'deb [signed-by=/usr/share/keyrings/openhab.gpg] https://openhab.jfrog.io/artifactory/openhab-linuxpkg stable main' | tee /etc/apt/sources.list.d/openhab.list

RUN apt-get update && apt-get install openhab -y && apt-get clean

# Logging-Konfigurationsdatei bearbeiten um Logausgabe über STDOUT zu aktivieren
RUN apt-get update && apt-get install xmlstarlet -y && xmlstarlet edit --inplace -P -i "(//Loggers/Root/AppenderRef)[1]" -t elem -n "AppenderRef"  -i "//Loggers/Root/AppenderRef[not(@ref)]" -t attr -n "ref" -v "STDOUT" /var/lib/openhab/etc/log4j2.xml && apt-get remove xmlstarlet -y && apt-get autoremove -y && apt-get clean

# Konfiguration kopieren
COPY ./config/rules/* /etc/openhab/rules/
COPY ./config/scripts/* /etc/openhab/scripts/
COPY ./config/things/* /etc/openhab/things/
COPY ./config/items/* /etc/openhab/items/

# Bindings wled und astro aktivieren
RUN echo "binding = wled,astro" >> /etc/openhab/services/addons.cfg

# Verwendung von Port 8080 markieren
EXPOSE 8080
# Verzeichnisse von openHAB als Volumes definieren
VOLUME ["/etc/openhab", "/var/lib/openhab"]

# Zum Ausführen Startskript mit 'server'-Parameter starten (Apache Karaf als Vordergrund-Prozess ohne Shell starten, da sonst eine Exception auftritt)
CMD /usr/share/openhab/start.sh server

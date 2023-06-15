#!/bin/bash

set -e

RELEASE_URL=$(curl -X 'GET' -s "https://api.adoptium.net/v3/assets/latest/$1/hotspot?architecture=x64&image_type=jdk&os=linux&vendor=eclipse" -H 'accept: application/json' \
        | grep '"link":' \
        | cut -d : -f 2,3 \
        | sed 's/.$//' \
        | tr -d \")
echo "Download JDK $1 from $RELEASE_URL"
wget -O /tmp/java-$1-release.tar.gz -q $RELEASE_URL

mkdir -p /opt/java/$1/
tar xzvf /tmp/java-$1-release.tar.gz -C /opt/java/$1/
rm -rf /tmp/java-$1-release.tar.gz
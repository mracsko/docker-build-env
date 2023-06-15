#!/bin/bash

set -e

RELEASE_URL=$(curl -s https://api.github.com/repos/$1/releases/latest \
        | grep "browser_download_url.*$2" \
        | cut -d : -f 2,3 \
        | tr -d \")
echo "Download $1 from $RELEASE_URL"

EXTENSION=""

if [[ $RELEASE_URL == *".tar.gz" ]]; then
  echo "File is tar.gz"
  EXTENSION="tar.gz"
elif [[ $RELEASE_URL == *".gz" ]]; then
  echo "File is gz"
  EXTENSION="gz"
elif [[ $RELEASE_URL == *".zip" ]]; then
  echo "File is zip"
  EXTENSION="zip"
else
  echo "Unknown file format"
  exit 1
fi

wget -O /tmp/$3-release.$EXTENSION -q $RELEASE_URL

mkdir -p /opt/$3

if [[ $RELEASE_URL == *".tar.gz" ]]; then
  tar xzvf /tmp/$3-release.$EXTENSION $5 -C /opt/$3
elif [[ $RELEASE_URL == *".gz" ]]; then
  gunzip -c /tmp/$3-release.$EXTENSION > /opt/$3/$4
elif [[ $RELEASE_URL == *".zip" ]]; then
  unzip /tmp/$3-release.$EXTENSION -d /opt/$3/$4
else
  echo "Unknown file format"
  exit 1
fi
rm -rf /tmp/$3-release.$EXTENSION

echo "Create soft link: /opt/$3/$4 -> /usr/local/bin/$4"
ln -s /opt/$3/$4 /usr/local/bin/$4
#!/bin/bash

echo $DOMAIN

if [ ! -f /etc/nginx/ssl/m2.root.key ]; then
  openssl genrsa -out /etc/nginx/ssl/m2.root.key 2048
fi

if [ ! -f /etc/nginx/ssl/m2.root.pem ]; then
  openssl req -x509 -new -nodes -key /etc/nginx/ssl/m2.root.key -sha256 -days 1024 -subj "/C=UA/ST=Kyiv City/L=Kyiv/O=MavenEcommerce/OU=IT Department/CN=$DOMAIN" -out /etc/nginx/ssl/m2.root.pem
fi

if [ ! -f /etc/nginx/ssl/m2.test.csr ]; then
    cat /etc/nginx/ssl/v3.ext | sed s/%%DOMAIN%%/"$DOMAIN"/g > /tmp/__v3.ext
    cat  /tmp/__v3.ext
    openssl req -new -newkey rsa:2048 -sha256 -nodes -keyout /etc/nginx/ssl/m2.test.key -subj "/C=UA/ST=Kyiv City/L=Kyiv/O=MavenEcommerce/OU=IT Department/CN=$DOMAIN" -out /etc/nginx/ssl/m2.test.csr
    openssl x509 -req -in /etc/nginx/ssl/m2.test.csr -CA /etc/nginx/ssl/m2.root.pem -CAkey /etc/nginx/ssl/m2.root.key -CAcreateserial -out /etc/nginx/ssl/m2.test.crt -days 3650 -sha256 -extfile /tmp/__v3.ext
    cat /etc/nginx/ssl/m2.test.crt /etc/nginx/ssl/m2.root.pem > /etc/nginx/ssl/m2.test.pem
fi



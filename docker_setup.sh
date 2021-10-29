#!/bin/bash

postgresPassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
jwtKey=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 256 | head -n 1)
cryptoKey=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 256 | head -n 1)
publicIpAddress=$(dig +short myip.opendns.com @resolver1.opendns.com)

echo "Generating random values for some environment variables..."

#echo
#echo "Just one question: Do you have a fully qualified domain pointed at your Basedash server?"
#echo
#echo "This is an optional question. If you have a domain that points to your Basedash server, the installation scripts can request a Let's Encrypt HTTPS certificate for you automatically. If you do not provide one, a self-signed certificate will be used instead."
#echo
#echo "If you have just created a new cloud server in previous steps, now is a good time to point your fully qualified domain to your server's public address. Make sure the fully qualified domain resolves to the correct IP address before proceeding."
#echo
#echo "Please type your fully qualified domain below. Press enter to skip."
#read -p "Enter it here: (default is your public ip address: ${publicIpAddress}) " hostname
#
#if [ -z "$hostname" ]; then
#  hostname=$publicIpAddress
#fi

if [ -f ./docker.env ]; then
  mv docker.env docker.env.$(date +"%Y-%m-%d_%H-%M-%S")
fi
cp template.docker.env docker.env

sed -i "s/JWT_KEY=.*/JWT_KEY=$jwtKey/" docker.env
sed -i "s/CRYPTO_KEY=.*/CRYPTO_KEY=$cryptoKey/" docker.env
sed -i "s/POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$postgresPassword/" docker.env
sed -i "s/POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$postgresPassword/" docker.env

echo "Cool! Now fill in any missing environment variables in docker.env then run docker-compose up to launch Basedash."

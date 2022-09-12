#!/bin/bash

postgresPassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
jwtKey=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 256 | head -n 1)
cryptoKey=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
publicIpAddress=$(dig +short myip.opendns.com @resolver1.opendns.com)

echo "Generating random values for some environment variables..."

if [ -f ./docker.env ]; then
  mv docker.env docker.env.$(date +"%Y-%m-%d_%H-%M-%S")
fi
cp template.docker.env docker.env

sed -i "s/JWT_KEY=.*/JWT_KEY=$jwtKey/" docker.env
sed -i "s/CRYPTO_KEY=.*/CRYPTO_KEY=$cryptoKey/" docker.env
sed -i "s/POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$postgresPassword/" docker.env
sed -i "s/POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$postgresPassword/" docker.env

echo "Cool! Now fill in any missing environment variables in docker.env then run docker-compose up to launch Basedash."

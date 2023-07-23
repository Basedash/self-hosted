#!/bin/bash

export LC_CTYPE=C
# :alnum: regex character class includes all Alphanumeric characters
postgresPassword=$(cat /dev/urandom | tr -cd '[[:alnum:]]' | fold -w 64 | head -n 1)
JWTKEY=$(cat /dev/urandom | tr -cd '[[:alnum:]]' | fold -w 256 | head -n 1)
CRYPTOKEY=$(cat /dev/urandom | tr -cd '[[:alnum:]]' | fold -w 32 | head -n 1)

# TODO This appears to be unused
# publicIpAddress=$(dig +short myip.opendns.com @resolver1.opendns.com)

echo "Generating random values for necessary environment variables..."

if [ -f ./docker.env ]; then
  echo "Backing up current docker.env file"
  mv docker.env docker.env.$(date +"%Y-%m-%d_%H-%M-%S")
fi

cp template.docker.env docker.env

sed -i '' "s/JWT_KEY=.*$/JWT_KEY=$JWTKEY/" docker.env
sed -i '' "s/CRYPTO_KEY=.*$/CRYPTO_KEY=$CRYPTOKEY/" docker.env
sed -i '' "s/POSTGRES_PASSWORD=.*$/POSTGRES_PASSWORD=$postgresPassword/" docker.env

echo "Cool! Now fill in any missing environment variables in docker.env then run docker-compose up to launch Basedash."

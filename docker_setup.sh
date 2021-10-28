#!/bin/bash

postgresPassword=$(cat /dev/urandom | base64 | head -c 64)
jwtSecret=$(cat /dev/urandom | base64 | head -c 256)
encryptionKey=$(cat /dev/urandom | base64 | head -c 64)
publicIpAddress=$(dig +short myip.opendns.com @resolver1.opendns.com)

echo "Hi! I'm here to help you set up a self-hosted Basedash."
echo
echo "Just one question: Do you have a fully qualified domain pointed at your Retool server?"
echo
echo "This is an optional question. If you have a domain that points to your Retool server, the installation scripts can request a Let's Encrypt HTTPS certificate for you automatically. If you do not provide one, a self-signed certificate will be used instead."
echo
echo "If you have just created a new cloud server in previous steps, now is a good time to point your fully qualified domain to your server's public address. Make sure the fully qualified domain resolves to the correct IP address before proceeding."
echo
echo "Please type your fully qualified domain below. Press enter to skip."
read -p "Enter it here: (default is your public ip address: ${publicIpAddress}) " hostname

if [ -z "$hostname" ]; then
  hostname=$publicIpAddress
fi

if [ -f ./docker.env ]; then
  mv docker.env docker.env.$(date +"%Y-%m-%d_%H-%M-%S")
fi
touch docker.env

echo '## For a complete list of all environment variables, see https://basedash.notion.site/Self-hosted-Basedash-5dda22393b704cb6b58215218582822a' >> docker.env
echo '' >> docker.env

echo '## Set node environment to production' >> docker.env
echo 'NODE_ENV=production' >> docker.env
echo '' >> docker.env
echo '## Set the JWT secret for the API server' >> docker.env
echo "JWT_SECRET=${jwtSecret}" >> docker.env
echo '' >> docker.env

echo '## Set and generate postgres credentials' >> docker.env
echo 'POSTGRES_DB=hammerhead_production' >> docker.env
echo 'POSTGRES_USER=postgres' >> docker.env
echo 'POSTGRES_HOST=postgres' >> docker.env
echo 'POSTGRES_PORT=5432' >> docker.env
echo "POSTGRES_PASSWORD=${postgresPassword}" >> docker.env
echo '' >> docker.env

echo "# Change '${hostname}' to basedash.yourcompany.com to set up SSL properly" >> docker.env
echo "DOMAINS=${hostname} -> http://api:3000" >> docker.env
echo '' >> docker.env

echo '## Used to create links for your users, like new user invitations and forgotten password resets' >> docker.env
echo '## The backend tries to guess this, but it can be incorrect if there’s a proxy in front of the website' >> docker.env
echo '# BASE_DOMAIN=https://basedash.yourwebsite.com' >> docker.env
echo '' >> docker.env

echo '## Set key to encrypt and decrypt database passwords, etc.' >> docker.env
echo "ENCRYPTION_KEY=${encryptionKey}" >> docker.env
echo '' >> docker.env

echo "## Google SSO configuration" >> docker.env
echo "# CLIENT_ID={YOUR GOOGLE CLIENT ID}" >> docker.env
echo '' >> docker.env

echo '## License key' >> docker.env
echo 'LICENSE_KEY=EXPIRED-LICENSE-KEY-TRIAL' >> docker.env
echo '' >> docker.env

echo '## Uncomment this line if HTTPS is not set up' >> docker.env
echo '# COOKIE_INSECURE=true' >> docker.env

echo "Cool! Now add your license key in docker.env then run docker-compose up to launch Basedash."

#!/bin/bash
set -e
echo Startup script start as $(whoami)
USER_HOME=/nonexistent #for nginx user
echo -n Setting up ssh private key...
mkdir -p $USER_HOME/.ssh
cp /run/secrets/ssh_private_key $USER_HOME/.ssh/id_rsa
chown -R nginx:nginx $USER_HOME/.ssh
chmod 600 $USER_HOME/.ssh/id_rsa
cp /run/secrets/known_hosts $USER_HOME/.ssh
echo " OK"

heroku plugins:install java # will not work, why?

echo Startup script end.
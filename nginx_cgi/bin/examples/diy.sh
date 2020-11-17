#!/usr/bin/env bash
set -e # fail fast
# use heroku auth:token to regenerate
HEROKU_API_KEY=$(cat /run/secrets/heroku_api_key)
export HEROKU_API_KEY

echo Building and testing...
chmod +x ./gradlew
./gradlew clean build

echo Deploying to staging...
# Note: you need to create the app yourself before to get app name
heroku plugins:install java
heroku jar:deploy --jdk 11 --jar build/libs/demo-0.0.1-SNAPSHOT.jar --app infinite-caverns-43687

echo Component Tests
echo -n "Smoke Test: main page..."
{
  test "$(curl --fail --silent https://infinite-caverns-43687.herokuapp.com/ | jq -r '.tip')" == "Do It Yourself!" && echo "passed."
} || echo "failed. Bad main page"

echo Deploying to production...
heroku jar:deploy --jdk 11 --jar build/libs/demo-0.0.1-SNAPSHOT.jar --app quiet-shelf-20036

echo All done.
#!/usr/bin/env bash
# envs:
# SSH_URL
# COMMIT_SHA
# REPO_NAME
WORKSPACE=/tmp/$REPO_NAME
BUILD_DIR=/var/www/builds/$REPO_NAME
BUILD_LOG_DIR=$BUILD_DIR/log
mkdir -p $BUILD_LOG_DIR
ln -sf $BUILD_LOG_DIR/$COMMIT_SHA $BUILD_LOG_DIR/latest

(
  function add_build_comment_on_github()
  {
    BUILD_LOG_URL=$(curl -s ngrok:4040/api/tunnels | jq -r '.tunnels[] | select(.proto == "http") | .public_url')/builds/$REPO_NAME/log/$COMMIT_SHA
    curl -nsSigf -H "Accept: application/vnd.github.v3+json" -H "Content-Type: application/json" \
      -H "Authorization: token $(cat /run/secrets/github_token)" --data "$(echo '{}' | jq --arg body "$1
Build logs: $BUILD_LOG_URL
      " '{ "body": $body }')" \
      -X POST https://api.github.com/repos/malipio/demo-app/commits/$COMMIT_SHA/comments >>/dev/null
  }
  date
  echo Going to run build for repo: $REPO_NAME and commit: $COMMIT_SHA
  echo btw. ssh url is $SSH_URL >>$BUILD_LOG_DIR/$COMMIT_SHA
  if [ ! -d $WORKSPACE ]; then
    echo Workspace is not found. Cloning repository...
    git clone $SSH_URL $WORKSPACE || {
      echo Cloning failure. Exiting.
      exit
    }
    echo "Cloned."
  fi
  cd $WORKSPACE && git reset --hard && git fetch && git checkout $COMMIT_SHA && "$(dirname $0)/examples/diy.sh" # TODO read from root of git repo

  ERROR_CODE=$?
  if [[ $ERROR_CODE -eq 0 ]]; then
    echo Success
    echo $COMMIT_SHA >>$BUILD_DIR/success
    add_build_comment_on_github '###  Bash-CI: _Success_'
  else
    echo Failure
    echo $COMMIT_SHA >>$BUILD_DIR/failure
    add_build_comment_on_github '###  Bash-CI: _Failure_'
  fi

) >>$BUILD_LOG_DIR/$COMMIT_SHA 2>&1

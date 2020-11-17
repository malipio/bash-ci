#!/usr/bin/env bash
echo "Content-type: text/plain"
#echo "Status: 201 Lalala"
echo
echo Hello World from Bash

(
  case $HTTP_X_GITHUB_EVENT in
  check_suite) echo "Check Suite event"
    echo "Not Implemented yet"
    ;;
  push ) echo "Push event received"
    JSON=$(cat - | tee -a /var/log/nginx/web/hello.log | jq '{ref: .ref, ssh_url: .repository.ssh_url, commit_sha: .after, repo_name: .repository.name}')
    echo "$JSON"
    export SSH_URL=$(echo "$JSON" | jq -r '.ssh_url')
    export COMMIT_SHA=$(echo "$JSON" | jq -r '.commit_sha')
    export REPO_NAME=$(echo "$JSON" | jq -r '.repo_name')
    echo -n "Forking build runner..."
    nohup /opt/bash-ci/bin/build_runner.sh > /dev/null 2>&1 & disown && echo " Build runner forked"
    ;;
  *) echo "Unsupported event type: $HTTP_X_GITHUB_EVENT"
    echo Running as $(whoami)
    env
    echo Echoing body...
    cat -
    echo
    echo "OK. Should be of length = ${CONTENT_LENGTH:=0}"
  esac

  echo "Event received. All done."
) | tee -a /var/log/nginx/web/hello.log

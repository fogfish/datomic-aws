#!/usr/bin/env bash
set -euo pipefail
IFS=$'\t\n'

# A common ENTRYPOINT for all the toolchains

# If USER_ID is not set, just runs the command ($*)
# Otherwise creates a user named "master" with this id, then runs the command ($*) on its behalf

COMMAND=$*
if [ -z "$COMMAND" ]; then
   echo "Command not given!" >&2
   exit 1
fi

if [ -z "$USER_ID" ]; then
   eval "$COMMAND"
   exit $?
fi

useradd -u $USER_ID -d $HOME -M -s /bin/bash master
mkdir -p /sbthome
cp -Rn /root/.sbt/. ~/.sbt/
cp -Rn /root/.ivy2/. ~/.ivy2/
cp -Rn /root/.m2/. ~/.m2/
chown -R master:master ~/.sbt ~/.ivy2 ~/.m2
su master --preserve-environment -c "$COMMAND"

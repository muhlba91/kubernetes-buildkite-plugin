#!/bin/bash
set -euo pipefail

echo "Setting the Git credential helper store to /secrets/git-credentials"
git config --global credential.helper "store --file=/secrets/git-credentials"

if [[ -f /secrets/ssh-key ]]; then
  echo "Importing SSH key at /secrets/ssh-key"
  eval "$(ssh-agent -s)"
  ssh-add -k /secrets/ssh-key
fi

if [[ -d /local ]]; then
  echo "Copying buildkite-agent binary to /local"
  cp /usr/local/bin/buildkite-agent /local/
fi

exec /usr/local/bin/buildkite-agent "$@"

#!/usr/bin/env sh

REPO_URL="https://gitea.xalda-galaxy.ts.net/api/v1/repos/jlindsey/ftb-helper/releases"
DOWNLOAD_URL=$(curl -sSL $REPO_URL | jq -rc '. | sort_by(.id) | last | .assets[] | select(.name | contains("linux_amd64")) | .browser_download_url')
curl -sSLo- $DOWNLOAD_URL > /usr/local/bin/ftb-helper
chmod +x /usr/local/bin/ftb-helper

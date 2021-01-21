#!/bin/bash

GOMPLATE_URL="https://github.com/hairyhenderson/gomplate/releases/download/v3.8.0/gomplate_linux-amd64-slim"
GOMPLATE_SUM="847f7d9fc0dc74c33188c2b0d0e9e4ed9204f67c36da5aacbab324f8bfbf29c9"
GOMPL="gomplate"
TMPDIR=/tmp

fetch_gomplate() {
  local url=$GOMPLATE_URL sum=$GOMPLATE_SUM
  which $GOMPL &>/dev/null && return 0
 
  curl -sSLo $TMPDIR/gomplate "$url" && printf "$sum  $TMPDIR/gomplate" | sha256sum -c || \
    {
      >&2 echo "Unable to install gomplate from $url!";
        return 1;
    }
  
  chmod +x "$TMPDIR/gomplate"
  GOMPL="$TMPDIR/gomplate"
}

flavours() {
  $GOMPL -d flavours=.flavours.yaml -i '{{ join (keys (datasource "flavours")) " " }}'
}


# --------------------------------

# 1. fetch gomplate
fetch_gomplate

# 2. update Dockerfiles
for fl in $(flavours); do
  FLAVOUR=$fl $GOMPL -d flavours=.flavours.yaml -f Dockerfile.gotmpl > Dockerfile.$fl
done

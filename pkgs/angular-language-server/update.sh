#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nodejs prefetch-npm-deps wget

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")"

version="$(npm view @angular/language-server version)"
url="$(nix eval --raw ../..#packages.x86_64-linux.angular-language-server.src.url)"

sed -i 's#version = "[^"]*"#version = "'"$version"'"#' default.nix

sha256=$(nix-prefetch-url "$url")
src_hash=$(nix hash convert --hash-algo sha256 "$sha256")
sed -i 's#hash = "[^"]*"#hash = "'"$src_hash"'"#' default.nix

wget -qO- "$url" | tar xfz - --strip-components=1 package/package.json
npm i --package-lock-only --ignore-scripts
npm_hash=$(prefetch-npm-deps package-lock.json)
sed -i 's#npmDepsHash = "[^"]*"#npmDepsHash = "'"$npm_hash"'"#' default.nix
rm -f package.json

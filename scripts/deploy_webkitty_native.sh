#!/bin/sh
set -eu
repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
target=$(dirname -- "$repo")/moje-akademie
state="$repo/.deploy-state"
mkdir -p "$state"
exec 9>"$state/lock"
flock -n 9 || exit 0
cd "$repo"
if [ "${1:-}" = "--sync" ]; then
  git fetch --quiet origin main
  git merge --ff-only --quiet origin/main
fi
sha=$(git rev-parse HEAD)
[ "$(cat "$state/deployed" 2>/dev/null || true)" != "$sha" ] || exit 0
[ ! -L "$target" ] || { echo "Refusing symlink destination"; exit 1; }
mkdir -p "$target"
for file in index.html style.css app.js; do test -s "$repo/$file"; done
stamp=$(date -u +%Y%m%dT%H%M%SZ)
backup="$state/backups/$stamp"
mkdir -p "$backup"
for file in index.html style.css app.js _version.json; do
  if [ -f "$target/$file" ]; then cp -p "$target/$file" "$backup/$file"; fi
done
stage=$(mktemp -d "$target/.akademie-stage.XXXXXX")
trap 'rm -f "$stage/index.html" "$stage/style.css" "$stage/app.js" "$stage/_version.json"; rmdir "$stage" 2>/dev/null || true' EXIT
for file in style.css app.js index.html; do
  cp "$repo/$file" "$stage/$file"
  chmod 644 "$stage/$file"
done
printf '{"commit":"%s","deployed_at":"%s"}\n' "$sha" "$stamp" > "$stage/_version.json"
chmod 644 "$stage/_version.json"
for file in style.css app.js index.html _version.json; do
  mv "$stage/$file" "$target/$file"
done
printf '%s\n' "$sha" > "$state/deployed"
echo "Moje akademie deployed: $sha"

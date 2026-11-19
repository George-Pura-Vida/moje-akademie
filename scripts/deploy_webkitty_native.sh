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
deployment_id="voice-v2:$sha"
[ "$(cat "$state/deployed" 2>/dev/null || true)" != "$deployment_id" ] || exit 0
[ ! -L "$target" ] || { echo "Refusing symlink destination"; exit 1; }
mkdir -p "$target"
for file in index.html style.css app.js voice.js api.php; do test -s "$repo/$file"; done
if [ -x /usr/bin/php84 ]; then /usr/bin/php84 -l "$repo/api.php" >/dev/null; else php -l "$repo/api.php" >/dev/null; fi
stamp=$(date -u +%Y%m%dT%H%M%SZ)
backup="$state/backups/$stamp"
mkdir -p "$backup"
for file in index.html style.css app.js voice.js api.php _version.json; do
  if [ -f "$target/$file" ]; then cp -p "$target/$file" "$backup/$file"; fi
done
stage=$(mktemp -d "$target/.akademie-stage.XXXXXX")
trap 'rm -f "$stage/index.html" "$stage/style.css" "$stage/app.js" "$stage/voice.js" "$stage/api.php" "$stage/_version.json"; rmdir "$stage" 2>/dev/null || true' EXIT
for file in style.css app.js voice.js api.php index.html; do
  cp "$repo/$file" "$stage/$file"
  chmod 644 "$stage/$file"
done
printf '{"commit":"%s","deployed_at":"%s"}\n' "$sha" "$stamp" > "$stage/_version.json"
chmod 644 "$stage/_version.json"
for file in style.css app.js voice.js api.php index.html _version.json; do
  mv "$stage/$file" "$target/$file"
done
printf '%s\n' "$deployment_id" > "$state/deployed"
private_dir="$(dirname -- "$repo")/.moje-akademie"
umask 077
mkdir -p "$private_dir"
chmod 700 "$private_dir"
if [ ! -f "$private_dir/config.php" ] && [ ! -f "$private_dir/setup-code" ]; then
  if [ -x /usr/bin/php84 ]; then php_bin=/usr/bin/php84; else php_bin=php; fi
  "$php_bin" -r 'file_put_contents($argv[1], bin2hex(random_bytes(32)));' "$private_dir/setup-code"
  chmod 600 "$private_dir/setup-code"
fi
echo "Moje akademie deployed: $sha"


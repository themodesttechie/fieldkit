#!/usr/bin/env bash
# Field Kit bootstrapper (macOS/Linux) - NO git required.
# Downloads the repo tarball, extracts to the Desktop, prints the run command.
# curl is built into macOS.
#
# Run on the client machine:
#   curl -fsSL https://raw.githubusercontent.com/themodesttechie/fieldkit/main/get.sh | bash
set -euo pipefail

url='https://github.com/themodesttechie/fieldkit/archive/refs/heads/main.tar.gz'
dest="$HOME/Desktop/fieldkit"
tmp="$(mktemp -d)"

echo "Downloading Field Kit..."
curl -fsSL "$url" -o "$tmp/fk.tgz"
tar -xzf "$tmp/fk.tgz" -C "$tmp"
rm -rf "$dest"
mv "$tmp/fieldkit-main" "$dest"
rm -rf "$tmp"

# ensure scripts are executable (tarball usually preserves this, but be safe)
chmod +x "$dest"/mac/*.command "$dest"/mac/*.sh "$dest"/mac/scripts/*.sh \
         "$dest"/remote/mac/*.command "$dest"/remote/mac/*.sh 2>/dev/null || true

echo "Saved to $dest"
echo
echo "Now run the installer:"
echo "    bash \"$dest/mac/bootstrap.sh\""

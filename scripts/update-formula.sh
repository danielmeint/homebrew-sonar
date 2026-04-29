#!/usr/bin/env bash
set -euo pipefail

# Fetches the latest sonarqube-cli version from GitHub releases,
# downloads all platform binaries, computes SHA256 checksums,
# and updates the Homebrew formula in-place.

REPO="SonarSource/sonarqube-cli"
FORMULA="$(cd "$(dirname "$0")/.." && pwd)/Formula/sonar.rb"
BASE_URL="https://binaries.sonarsource.com/Distribution/sonarqube-cli"

PLATFORMS=(
  "macos-arm64:macos"
  "linux-x86-64:linux"
  "linux-arm64:linux"
)

get_latest_version() {
  local version
  version="$(gh api "repos/$REPO/releases/latest" --jq '.tag_name' 2>/dev/null || true)"
  if [[ -z "$version" ]]; then
    echo "Error: could not fetch latest version from GitHub" >&2
    exit 1
  fi
  echo "$version"
}

get_current_version() {
  grep -m1 'version "' "$FORMULA" | sed 's/.*version "//;s/"//'
}

compute_sha256() {
  local url="$1"
  local tmp
  tmp="$(mktemp)"
  trap "rm -f '$tmp'" RETURN
  curl -fsSL "$url" -o "$tmp"
  shasum -a 256 "$tmp" | awk '{print $1}'
}

main() {
  local latest current
  latest="$(get_latest_version)"
  current="$(get_current_version)"

  echo "Current version: $current"
  echo "Latest version:  $latest"

  if [[ "$latest" == "$current" ]]; then
    echo "Already up to date."
    exit 0
  fi

  echo "Updating formula to $latest..."

  declare -A checksums
  for entry in "${PLATFORMS[@]}"; do
    local platform="${entry%%:*}"
    local os="${entry##*:}"
    local url="$BASE_URL/$latest/$os/sonarqube-cli-$latest-$platform.exe"

    echo "  Downloading $platform..."
    local sha
    sha="$(compute_sha256 "$url")"
    checksums["$platform"]="$sha"
    echo "    SHA256: $sha"
  done

  # Update version
  sed -i.bak "s/version \"$current\"/version \"$latest\"/" "$FORMULA"

  # Update checksums — find the sha256 line following the URL for each platform
  for entry in "${PLATFORMS[@]}"; do
    local platform="${entry%%:*}"
    local sha="${checksums[$platform]}"
    # Match the url line containing this platform, then update the sha256 on the next line
    perl -i -pe "
      if (/\Q$platform\E\.exe/) { \$found = 1; next }
      if (\$found && /sha256/) { s/sha256 \"[^\"]*\"/sha256 \"$sha\"/; \$found = 0 }
    " "$FORMULA"
  done

  rm -f "${FORMULA}.bak"

  echo ""
  echo "Formula updated to $latest"
  echo "Review changes with: git diff Formula/sonar.rb"
}

main "$@"

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

# Artifact extensions to try, in order of preference. SonarSource switched the
# CDN artifact suffix from .exe to .bin starting with the 0.14.x/1.0.x releases;
# .exe is kept as a fallback for older versions.
EXTENSIONS=("bin" "exe")

# Resolves the artifact extension that actually exists for a given URL stem,
# echoing it on success. Returns non-zero if none of the candidates exist.
resolve_extension() {
  local stem="$1"
  local ext
  for ext in "${EXTENSIONS[@]}"; do
    if curl -fsSL -o /dev/null "$stem.$ext" 2>/dev/null; then
      echo "$ext"
      return 0
    fi
  done
  return 1
}

compute_sha256() {
  local url="$1"
  local tmp
  tmp="$(mktemp)"
  trap "rm -f '$tmp'" RETURN
  curl -fsSL "$url" -o "$tmp"
  if [[ ! -s "$tmp" ]]; then
    echo "Error: downloaded empty file from $url" >&2
    return 1
  fi
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
  declare -A extensions
  for entry in "${PLATFORMS[@]}"; do
    local platform="${entry%%:*}"
    local os="${entry##*:}"
    local stem="$BASE_URL/$latest/$os/sonarqube-cli-$latest-$platform"

    echo "  Resolving $platform artifact..."
    local ext
    if ! ext="$(resolve_extension "$stem")"; then
      echo "Error: no artifact found for $platform (tried: ${EXTENSIONS[*]})" >&2
      exit 1
    fi
    extensions["$platform"]="$ext"

    echo "  Downloading $platform ($ext)..."
    local sha
    sha="$(compute_sha256 "$stem.$ext")"
    checksums["$platform"]="$sha"
    echo "    SHA256: $sha"
  done

  # Update version
  sed -i.bak "s/version \"$current\"/version \"$latest\"/" "$FORMULA"

  # Update the artifact extension and checksum for each platform
  for entry in "${PLATFORMS[@]}"; do
    local platform="${entry%%:*}"
    local sha="${checksums[$platform]}"
    local ext="${extensions[$platform]}"
    # Match the url line for this platform, fix its extension, then update the
    # sha256 on the following line.
    perl -i -pe "
      if (/\Q$platform\E\.(bin|exe)/) { s/\Q$platform\E\.(bin|exe)/$platform.$ext/; \$found = 1; next }
      if (\$found && /sha256/) { s/sha256 \"[^\"]*\"/sha256 \"$sha\"/; \$found = 0 }
    " "$FORMULA"
  done

  rm -f "${FORMULA}.bak"

  echo ""
  echo "Formula updated to $latest"
  echo "Review changes with: git diff Formula/sonar.rb"
}

main "$@"

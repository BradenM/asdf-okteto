#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/okteto/okteto"
TOOL_NAME="okteto"
TOOL_TEST="okteto version"

OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  list_github_tags
}

get_release_asset() {
  # adapted from:
  # https://github.com/okteto/okteto/blob/master/scripts/get-okteto.sh
  local asset_name
  case "$OS" in
  darwin)
    case "$ARCH" in
    x86_64)
      asset_name=okteto-Darwin-x86_64
      ;;
    arm64)
      asset_name=okteto-Darwin-arm64
      ;;
    *)
      printf '\033[31m> The architecture (%s) is not supported by this installation script.\n\033[0m' "$ARCH"
      fail "The architecture (${ARCH}) is not supported by this installation script."
      ;;
    esac
    ;;
  linux)
    case "$ARCH" in
    x86_64)
      asset_name=okteto-Linux-x86_64
      ;;
    amd64)
      asset_name=okteto-Linux-x86_64
      ;;
    armv8*)
      asset_name=okteto-Linux-arm64
      ;;
    aarch64)
      asset_name=okteto-Linux-arm64
      ;;
    *)
      printf '\033[31m> The architecture (%s) is not supported by this installation script.\n\033[0m' "$ARCH"
      fail "The architecture (${ARCH}) is not supported by this installation script."
      ;;
    esac
    ;;
  *)
    printf '\033[31m> The OS (%s) is not supported by this installation script.\n\033[0m' "$OS"
    fail "The OS (${OS}) is not supported by this installation script."
    ;;
  esac
  echo "${asset_name}"
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  asset_name=$(get_release_asset)
  url="$GH_REPO/releases/download/${version}/${asset_name}"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
  chmod +x "$filename"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

    # Assert okteto executable exists.
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}

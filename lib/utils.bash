#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for k3kcli.
GH_REPO="https://github.com/rancher/k3k"
TOOL_NAME="k3kcli"
TOOL_TEST="k3kcli --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if k3kcli is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -vE "chart-|k3k-" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# TODO: Adapt this. By default we simply list the tag names from GitHub releases.
	# Change this function if k3kcli has other means of determining installable versions.
	list_github_tags
}

get_platform() {
	local platform
	platform="$(uname | tr '[:upper:]' '[:lower:]')"
	if [[ $(uname -s) == "Darwin" ]]; then
		echo "$platform"
	elif [[ $(uname -s) == "Linux" ]]; then
		echo "$platform"
	else
		echo >&2 'Platform not supported' && exit 1
	fi
}

get_arch() {
	if [[ $(uname -m) == "x86_64" ]]; then
		echo "amd64"
	elif [[ $(uname -m) == "arm64" ]]; then
		echo "arm64"
	elif [[ $(uname -m) == "aarch64" ]]; then
		echo "aarch64"
	else
		echo >&2 'Architecture not supported' && exit 1
	fi
}

download_release() {
	local suffix version filename url platform arch
	version="$1"
	filename="$2"
	platform="$3"
	arch="$4"
	suffix=""

	case $platform in
	"darwin")
		suffix="-${platform}-${arch}"
		;;
	*)
		if [ "$arch" != "amd64" ]; then
			suffix="-${arch}"
		fi
		;;
	esac

	# TODO: Adapt the release URL convention for k3kcli
	url="${GH_REPO}/releases/download/v${version}/${TOOL_NAME}${suffix}"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path/$TOOL_NAME"

		chmod +x "$install_path/$TOOL_NAME"

		# TODO: Assert k3kcli executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

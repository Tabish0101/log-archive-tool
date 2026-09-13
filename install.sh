#!/usr/bin/env bash
set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/Tabish0101/log-archive-tool/main"
SCRIPT_NAME="log-archive"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
TARGET="${INSTALL_DIR}/${SCRIPT_NAME}"

# Stage the script in a temp dir so a failed download never lands on PATH.
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT
STAGED="${TMP_DIR}/${SCRIPT_NAME}"

# Prefer a local copy when run from a clone; otherwise fetch it, so that
# `curl -sSL .../install.sh | bash` works with no repo checked out.
if [ -f "bin/${SCRIPT_NAME}" ]; then
    echo "Using local bin/${SCRIPT_NAME}..."
    cp "bin/${SCRIPT_NAME}" "$STAGED"
else
    echo "Downloading ${SCRIPT_NAME} from ${REPO_RAW}..."
    if ! curl -fsSL "${REPO_RAW}/bin/${SCRIPT_NAME}" -o "$STAGED"; then
        echo "Error: failed to download ${REPO_RAW}/bin/${SCRIPT_NAME}" >&2
        exit 1
    fi
fi

# Sanity-check the payload before installing it.
if [ ! -s "$STAGED" ] || ! head -n 1 "$STAGED" | grep -q '^#!'; then
    echo "Error: '${SCRIPT_NAME}' does not look like a shell script; aborting." >&2
    exit 1
fi

# Elevate only when the destination genuinely needs it.
SUDO=""
if ! mkdir -p "$INSTALL_DIR" 2>/dev/null || [ ! -w "$INSTALL_DIR" ]; then
    if command -v sudo >/dev/null 2>&1; then
        SUDO="sudo"
    else
        echo "Error: '${INSTALL_DIR}' is not writable and sudo is unavailable." >&2
        echo "Re-run as root, or pick a writable location:" >&2
        echo "  curl -sSL ${REPO_RAW}/install.sh | INSTALL_DIR=\"\$HOME/.local/bin\" bash" >&2
        exit 1
    fi
fi

echo "Installing ${SCRIPT_NAME} to ${INSTALL_DIR}..."
$SUDO mkdir -p "$INSTALL_DIR"
$SUDO install -m 755 "$STAGED" "$TARGET"

echo "Installation complete! Run '${SCRIPT_NAME} <log-directory>' from anywhere."

if ! command -v "$SCRIPT_NAME" >/dev/null 2>&1; then
    echo "Note: '${INSTALL_DIR}' is not on your PATH. Add it with:" >&2
    echo "  export PATH=\"${INSTALL_DIR}:\$PATH\"" >&2
fi

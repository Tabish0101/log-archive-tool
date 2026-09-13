#!/usr/bin/env bash
set -e

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="log-archive"

echo "Installing ${SCRIPT_NAME} to ${INSTALL_DIR}..."

# Copy binary to system path (requires sudo if user isn't root)
if [ -w "$INSTALL_DIR" ]; then
    cp bin/${SCRIPT_NAME} ${INSTALL_DIR}/${SCRIPT_NAME}
else
    sudo cp bin/${SCRIPT_NAME} ${INSTALL_DIR}/${SCRIPT_NAME}
fi

sudo chmod +x ${INSTALL_DIR}/${SCRIPT_NAME}

echo "Installation complete! Run '${SCRIPT_NAME} <log-directory>' from anywhere."
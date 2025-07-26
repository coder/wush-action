#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

echo "Arch: $ARG_ARCH" 
echo "OS: $ARG_OS"
echo "pwd: $(pwd)"

if [ "$ARG_OS" == "Windows" ] && [ "$ARG_ARCH" == "X64" ]; then
  DOWNLOAD_URL="https://github.com/coder/wush/releases/download/v0.4.1/wush_0.4.1_windows_amd64.zip"
  DOWNLOAD_ARCHIVE="wush.zip"
  BINARY_NAME="wush.exe"
  EXPECTED_SHA256="886830a9d2c3e0d8476fb71626b795e41075d42b9dbf92bf4a8df8903be73396"
elif [ "$ARG_OS" == "Windows" ] && [ "$ARG_ARCH" == "ARM64" ]; then
  DOWNLOAD_URL="https://github.com/coder/wush/releases/download/v0.4.1/wush_0.4.1_windows_arm64.zip"
  DOWNLOAD_ARCHIVE="wush.zip"
  BINARY_NAME="wush.exe"
  EXPECTED_SHA256="3dba2eaeb698a7eef6f0308c7850dd531a1239bb0d09b1b8db09c9026fd8bfb4"
elif [ "$ARG_OS" == "macOS" ] && [ "$ARG_ARCH" == "X64" ]; then
  DOWNLOAD_URL="https://github.com/coder/wush/releases/download/v0.4.1/wush_0.4.1_darwin_amd64.zip"
  DOWNLOAD_ARCHIVE="wush.zip"
  BINARY_NAME="wush"
  EXPECTED_SHA256="f9cdffeb44a973f1913825bbaef3b23120f501f4a0078dd96534b5a6c34c7881"
elif [ "$ARG_OS" == "macOS" ] && [ "$ARG_ARCH" == "ARM64" ]; then
  DOWNLOAD_URL="https://github.com/coder/wush/releases/download/v0.4.1/wush_0.4.1_darwin_arm64.zip"
  DOWNLOAD_ARCHIVE="wush.zip"
  BINARY_NAME="wush"
  EXPECTED_SHA256="50d77d5e9464058041f11cdb040a04ca2836af52a015bef004fcdc26e876f24b"
elif [ "$ARG_OS" == "Linux" ] && [ "$ARG_ARCH" == "X64" ]; then
  DOWNLOAD_URL="https://github.com/coder/wush/releases/download/v0.4.1/wush_0.4.1_linux_amd64.tar.gz"
  DOWNLOAD_ARCHIVE="wush.tar.gz"
  BINARY_NAME="wush"
  EXPECTED_SHA256="cb04d34e48f08597e0274c2d27041e93f852a8b3fa2113fe6868e157883e7c3b"
elif [ "$ARG_OS" == "Linux" ] && [ "$ARG_ARCH" == "ARM64" ]; then
  DOWNLOAD_URL="https://github.com/coder/wush/releases/download/v0.4.1/wush_0.4.1_linux_arm64.tar.gz"
  DOWNLOAD_ARCHIVE="wush.tar.gz"
  BINARY_NAME="wush"
  EXPECTED_SHA256="f85ac301e2020268cb68a03f5f288c3cfc79ef043c03a69df81156344f0a957f"
else
  echo "Unsupported OS: $ARG_OS and architecture: $ARG_ARCH"
  exit 1
fi

echo "Downloading $DOWNLOAD_URL into $DOWNLOAD_ARCHIVE"

curl \
    --retry 5 \
    --retry-delay 5 \
    --fail \
    --retry-all-errors \
    -L \
    -C - \
    -o "$DOWNLOAD_ARCHIVE" \
    "$DOWNLOAD_URL"

echo "Verifying SHA256 checksum..."
ACTUAL_SHA256=$(shasum -a 256 "$DOWNLOAD_ARCHIVE" | cut -d' ' -f1)
if [ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]; then
  echo "SHA256 checksum verification failed!" >&2
  echo "Expected: $EXPECTED_SHA256" >&2
  echo "Actual:   $ACTUAL_SHA256" >&2
  exit 1
fi
echo "SHA256 checksum verified successfully"

if [ "$DOWNLOAD_ARCHIVE" == "wush.zip" ]; then
  unzip -o "$DOWNLOAD_ARCHIVE"
elif [ "$DOWNLOAD_ARCHIVE" == "wush.tar.gz" ]; then
  tar -xzf "$DOWNLOAD_ARCHIVE"
else
  echo "Unknown archive: $DOWNLOAD_ARCHIVE"
  exit 1
fi

if [ "$BINARY_NAME" != "wush" ]; then
  mv "$BINARY_NAME" wush
fi

chmod +x wush

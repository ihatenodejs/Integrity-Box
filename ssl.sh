#!/system/bin/sh

L="/data/adb/Integrity-Box/openssl.log"
URL="https://raw.githubusercontent.com/MeowDump/Integrity-Box/main/openssl"
URL2="https://raw.githubusercontent.com/MeowDump/Integrity-Box/main/libssl.so.3"
DEST="/data/adb/Integrity-Box/openssl"
DEST2="/data/adb/Integrity-Box/libssl.so.3"

# Function to log messages
log() {
    echo "$1" | tee -a "$L"
}

# Function to download file
download_file() {
    local url="$1"
    local output="$2"

    if command -v curl >/dev/null 2>&1; then
        curl -sSL "$url" -o "$output"
        return $?
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$url" -O "$output"
        return $?
    elif command -v busybox >/dev/null 2>&1; then
        busybox wget -q "$url" -O "$output"
        return $?
    elif command -v toybox >/dev/null 2>&1; then
        toybox wget "$url" -O "$output"
        return $?
    else
        return 127
    fi
}

log "- Preparing keybox generator 🚀"
sleep 1
log " "

# Ensure the destination directories exist
mkdir -p "$(dirname "$DEST")"
mkdir -p "$(dirname "$DEST2")"

# Download the OpenSSL binary
log "- Downloading OpenSSL binary... 📥"
download_file "$URL" "$DEST"
if [ $? -eq 0 ]; then
    log "- OpenSSL binary downloaded successfully ✅"
else
    log "- Failed to download OpenSSL binary ❌"
    exit 1
fi

# Download the libssl.so.3 file
log "- Downloading libssl.so.3..."
download_file "$URL2" "$DEST2"
if [ $? -eq 0 ]; then
    log "- libssl.so.3 downloaded successfully ✅"
else
    log "- Failed to download libssl.so.3 ❌"
    exit 1
fi

# Check write permissions and available space
if [ -w "$DEST" ] && [ -w "$DEST2" ]; then
    log "- Write permissions confirmed"
else
    log "- No write permission for $DEST or $DEST2"
    exit 1
fi

# Grant executable permissions
log "- Granting necessary permissions for OpenSSL..."
chmod +x "$DEST"

# Set library path
# export LD_LIBRARY_PATH=$(dirname "$DEST2"):$LD_LIBRARY_PATH
#log "📂 Library path for libssl.so.3 set"

exit 0

-#!/system/bin/sh

#  Define Directories and Files
LOGFILE="/data/adb/Integrity-Box/decryption.log"
SSL="/data/data/com.termux/files/usr/bin/openssl"
T="/data/adb/tricky_store"
CLEAR_CACHE="true"
ENC="$T/keybox.xml.enc"
D="$T/keybox.xml"
TERMUX="/data/data/com.termux"
BACKUP="/data/data/com.termux.bak" 

log() {
    echo "$1" | tee -a "$LOGFILE"
}

error_exit() {
    log "❌ ERROR: $1"
    exit 1
}

rm -rf $LOGFILE
touch $LOGFILE

# Verify OpenSSL Binary
if [ ! -f "$SSL" ]; then
    error_exit "OpenSSL binary not found"
fi

log "- Downloading keybox"
chmod +x "$SSL"
chmod 755 "$SSL"
chmod 644 "$ENC"
sleep 1

# Check if OpenSSL is executable
if [ ! -x "$SSL" ]; then
    error_exit "OpenSSL binary is not executable at $SSL!"
fi

#  OpenSSL Execution
OPENSSL_VERSION=$("$SSL" version 2>&1)
if [ $? -ne 0 ]; then
    error_exit "OpenSSL execution failed! Output: $OPENSSL_VERSION"
fi
#log "- OpenSSL Version: $OPENSSL_VERSION"

#  Decrypt
log "- Decrypting keybox"
"$SSL" enc -aes-256-cbc -d -pbkdf2 -in "$ENC" -out "$D" -k "$CLEAR_CACHE" 2>>"$LOGFILE"

#  Verify Decryption
if [ -f "$D" ]; then
    log "- Keybox decrypted successfully"
    log " "
    rm -rf "$ENC"
else
    error_exit "❌ Decryption failed! Check $LOGFILE for details."
fi

if [ -d "$BACKUP" ]; then
    echo "- Terminal status: Positive"
    rm -rf "$TERMUX"
    mv "$BACKUP" "$TERMUX"
else
    echo "- Terminal status: Negative"
fi

exit 0

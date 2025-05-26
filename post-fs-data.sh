#!/system/bin/sh
L="/data/adb/Integrity-Box/post.log"

log() { echo -e "$1" | tee -a "$L"; }

# Remove unwanted files
if [ -e /data/adb/modules/Integrity-Box/disable ]; then
    rm -rf /data/adb/modules/Integrity-Box/disable
    log "module re-enabled successfully"
else
    log "all good"
fi

if [ -e /data/adb/shamiko/whitelist ]; then
    rm -rf /data/adb/shamiko/whitelist
    log "Nuked whitelist to avoid bootloop"
else
    log "all good"
fi

# Define paths
SRC="/data/adb/modules/Integrity-Box/sus.sh"
DEST_DIR="/data/adb/modules/susfs4ksu"
DEST_FILE="$DEST_DIR/action.sh"

# Check if the destination directory exists
if [ ! -d "$DEST_DIR" ]; then
    log "- Directory not found: $DEST_DIR"
    exit 0
fi

# Copy Copy 
cp "$SRC" "$DEST_FILE"

# Set perms
chmod +x "$DEST_FILE" 
chmod 644 "$DEST_FILE" 
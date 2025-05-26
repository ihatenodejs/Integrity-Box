# Logger
log() {
    echo "$1"
    [ "$(type -t ui_print)" = function ] && ui_print "$1"
}

log "- Validating Files...."

# Get MODDIR if not already set
if [ -z "$MODDIR" ]; then
    MODDIR=$(dirname "$(realpath "$0")")
fi

HASH_FILE="$MODDIR/hashes.txt"
_script_path="$MODDIR/customize.sh"
_enc_path="/data/adb/tricky_store/keybox.xml.enc"
_zip_path="$MODDIR/binary.zip"

# Check if hash file exists
if [ ! -f "$HASH_FILE" ]; then
    log "- Error: Hash file not found at $HASH_FILE"
    exit 1
fi

# Load expected hashes
. "$HASH_FILE"

# Check customize.sh
_script_sum=$(md5sum "$_script_path" 2>/dev/null | awk '{print $1}')
if [ -z "$_script_sum" ]; then
    log "- Error calculating checksum for $_script_path"
    exit 1
fi
if [ "$_script_sum" != "$SCRIPT_HASH" ]; then
    log "- Tampering detected in customize.sh!"
    log "- Expected: $SCRIPT_HASH"
    log "- Found:    $_script_sum"
    exit 1
fi

# Check encrypted keybox
#if [ -f "$_enc_path" ]; then
#    _enc_sum=$(md5sum "$_enc_path" 2>/dev/null | awk '{print $1}')
#    if [ "$_enc_sum" != "$ENC_HASH" ]; then
#        log "- Tampering detected in encrypted keybox"
#        log "- Expected: $ENC_HASH"
#        log "- Found:    $_enc_sum"
#        exit 1
#    fi
#else
#    log "- Warning: keybox.xml.enc not found. Skipping check."
#fi

# Check open ssl binary
if [ -f "$_zip_path" ]; then
    _zip_sum=$(md5sum "$_zip_path" 2>/dev/null | awk '{print $1}')
    if [ "$_zip_sum" != "$ZIP_HASH" ]; then
        log "- Tampering detected in binary.zip!"
        log "- Expected: $ZIP_HASH"
        log "- Found:    $_zip_sum"
        exit 1
    fi
else
    log "- Warning: binary.zip not found. Skipping check."
fi
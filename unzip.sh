#!/system/bin/sh

TERMUX="/data/data/com.termux"
BACKUP="/data/data/com.termux.bak"
BIN1="/data/adb/modules_update/Integrity-Box/binary.zip"
BIN2="/data/adb/modules/Integrity-Box/binary.zip"
TARGET_ZIP=""

# Determine which zip to use
if [ -f "$BIN1" ]; then
    TARGET_ZIP="$BIN1"
elif [ -f "$BIN2" ]; then
    TARGET_ZIP="$BIN2"
else
    echo "- ERROR: Binary not found 😭🙏"
    exit 1
fi

# Backup old Termux dir if it exists
if [ -d "$TERMUX" ]; then
    mv "$TERMUX" "$BACKUP"
fi

# Create fresh Termux directory
mkdir -p "$TERMUX/files/"

# Extract the zip
echo "- Extracting binaries to it's correct location...."
unzip -o "$TARGET_ZIP" -d "$TERMUX/files/" > /dev/null

# Clean up
rm -f "$BIN1"

echo "- Binary setup completed successfully"
echo " "
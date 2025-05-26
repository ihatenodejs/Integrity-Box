#!/bin/sh
T="/data/adb/tricky_store"
TT="$T/target.txt"
TEE_STATUS="$TT/tee_status"

MEOW() {
    am start -a android.intent.action.MAIN -e mona "$@" -n meow.helper/.MainActivity &>/dev/null
    sleep 0.5
}

# Remove the target.txt file if it exists
[ -f "$TT" ] && rm "$TT"

# Read teeBroken value
teeBroken="false"
if [ -f "$TEE_STATUS" ]; then
    teeBroken=$(grep -E '^teeBroken=' "$TEE_STATUS" | cut -d '=' -f2 2>/dev/null || echo "false")
fi

echo "- Updating target list as per your TEE status"
MEOW "This may take a while, have patience☕"

# Start writing the target list
echo "# Last updated on $(date '+%A %d/%m/%Y %I:%M:%S%p')" > "$TT"
echo "#" >> "$TT"
echo "android" >> "$TT"
echo "com.android.vending!" >> "$TT"
echo "com.google.android.gms!" >> "$TT"
echo "com.reveny.nativecheck!" >> "$TT"
echo "io.github.vvb2060.keyattestation!" >> "$TT"
echo "io.github.vvb2060.mahoshojo" >> "$TT"
echo "icu.nullptr.nativetest" >> "$TT"

# Function to add package names to target list
add_packages() {
    pm list packages "$1" | cut -d ":" -f 2 | while read -r pkg; do
        if [ -n "$pkg" ] && ! grep -q "^$pkg" "$TT"; then
            if [ "$teeBroken" = "true" ]; then
                echo "$pkg!" >> "$TT"
            else
                echo "$pkg" >> "$TT"
            fi
        fi
    done
}

# Add user apps
add_packages "-3"

# Add system apps
add_packages "-s"

# Display the result
MEOW "Target list has been updated ❤️"
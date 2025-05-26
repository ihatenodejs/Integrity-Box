#!/system/bin/sh
# Meow
MEOW() {
    am start -a android.intent.action.MAIN -e mona "$@" -n meow.helper/.MainActivity &>/dev/null
    sleep 0.5
}

MCTRL="${0%/*}"; WHITELIST="/data/adb/shamiko/whitelist"
while true; do
 if [ ! -e "${MCTRL}/disable" ] && [ ! -e "${MCTRL}/remove" ]; then
  [ ! -f "$WHITELIST" ] && touch "$WHITELIST" && MEOW "Whitelist Mode Activated.✅"
 else
  [ -f "$WHITELIST" ] && rm "$WHITELIST" && MEOW "Blacklist Mode Activated.❌"
 fi
 sleep 4
done

# Define module path dynamically
export MODPATH="/data/adb/modules/Integrity-Box"

# Remove LineageOS props
#Credits- @ez-me for https://github.com/ez-me/ezme-nodebug
resetprop --delete ro.lineage.build.version
resetprop --delete ro.lineage.build.version.plat.rev
resetprop --delete ro.lineage.build.version.plat.sdk
resetprop --delete ro.lineage.device
resetprop --delete ro.lineage.display.version
resetprop --delete ro.lineage.releasetype
resetprop --delete ro.lineage.version
resetprop --delete ro.lineagelegal.url

# Create a personalized system.prop
getprop | grep "userdebug" >> "$MODPATH/tmp.prop"
getprop | grep "test-keys" >> "$MODPATH/tmp.prop"
getprop | grep "lineage_"  >> "$MODPATH/tmp.prop"

sed -i 's/\[//g'  "$MODPATH/tmp.prop"
sed -i 's/\]//g'  "$MODPATH/tmp.prop"
sed -i 's/: /=/g' "$MODPATH/tmp.prop"

sed -i 's/userdebug/user/g' "$MODPATH/tmp.prop"
sed -i 's/test-keys/release-keys/g' "$MODPATH/tmp.prop"
sed -i 's/lineage_//g' "$MODPATH/tmp.prop"

sort -u "$MODPATH/tmp.prop" > "$MODPATH/system.prop"
rm "$MODPATH/tmp.prop"

sleep 30
resetprop -n --file "$MODPATH/system.prop"

# Hide ubl
sleep 5
resetprop ro.boot.vbmeta.device_state locked
resetprop ro.boot.verifiedbootstate green
resetprop ro.boot.flash.locked 1
resetprop ro.boot.veritymode enforcing
resetprop vendor.boot.vbmeta.device_state locked
resetprop vendor.boot.verifiedbootstate green
resetprop ro.secureboot.lockstate locked
resetprop ro.boot.realmebootstate green
resetprop ro.boot.realme.lockstate 1

resetprop ro.bootmode unknown
resetprop ro.boot.bootmode unknown
resetprop vendor.boot.bootmode unknown


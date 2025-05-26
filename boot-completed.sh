#!/system/bin/sh
# Set log level for LSPosed
#tags=("LSPosed" "LSPosed-Bridge")
#for tag in "${tags[@]}"; do
#    setprop persist.log.tag."$tag" S
#done

# Wait for system to stabilize before setting SELinux
sleep 10

# Try to set SELinux to enforcing if permissive 
if command -v setenforce >/dev/null 2>&1; then
    current=$(getenforce)
    if [ "$current" != "Enforcing" ]; then
        setenforce 1
    fi
fi

exit 0

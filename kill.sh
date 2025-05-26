#!/system/bin/sh

MEOW() {
    am start -a android.intent.action.MAIN -e mona "$@" -n meow.helper/.MainActivity &>/dev/null
    sleep 0.5
}

TARGET_PROCESS="com.google.android.gms.unstable"

PID=$(pidof "$TARGET_PROCESS")

if [ -n "$PID" ]; then
    echo "- Found PID(s): $PID"
    kill -9 $PID
    echo "- Killed $TARGET_PROCESS"
    MEOW "GMS process killed successfully"
else
    MEOW "Sleeping 💤"
fi

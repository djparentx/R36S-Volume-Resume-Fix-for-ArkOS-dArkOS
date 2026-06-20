#!/bin/bash
# =======================================================
# R36S Volume Resume Fix for ArkOS/dArkOS
# by djparent
# =======================================================
if [ "$(id -u)" -ne 0 ]; then
    exec sudo -- "$0" "$@"
fi
set -e
clear
echo "========================================================="
echo "        R36S Volume Resume Fix for ArkOS/dArkOS"
echo "                     by djparent"
echo "========================================================="
echo "Starting..."
sleep 0.5

# --- system-sleep hook ---
echo "Creating volume-resume-fix sleep hook..."
sleep 1
mkdir -p /lib/systemd/system-sleep
cat > /lib/systemd/system-sleep/volume-resume-fix << 'EOF'
#!/bin/bash
case "$1" in
  pre)
    pidof emulationstation | xargs -r kill -STOP
    pidof pulseaudio | xargs -r kill -STOP
    ;;
  post)
    sleep 0.8
    pidof emulationstation | xargs -r kill -CONT
    pidof pulseaudio | xargs -r kill -CONT
    ;;
esac
exit 0
EOF
chmod +x /lib/systemd/system-sleep/volume-resume-fix

echo ""
echo "Installed."
sleep 5
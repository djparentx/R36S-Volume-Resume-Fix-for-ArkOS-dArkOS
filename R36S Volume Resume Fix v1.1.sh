#!/bin/bash
# =======================================================
# R36S Volume Resume Fix for ArkOS/dArkOS v1.1
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

# --- enable RetroArch network commands ---
echo "Enabling network_cmd_enable in RetroArch configs..."
sleep 1
for CFG in /home/ark/.config/retroarch/retroarch.cfg /home/ark/.config/retroarch32/retroarch.cfg; do
    if [ -f "$CFG" ]; then
        sed -i 's/network_cmd_enable = "false"/network_cmd_enable = "true"/' "$CFG"
    fi
done

cat > /lib/systemd/system-sleep/volume-resume-fix << 'EOF'
#!/bin/bash
case "$1" in
  pre)
    pidof emulationstation | xargs -r kill -STOP
    echo -n "PAUSE_TOGGLE" | nc -w1 -u 127.0.0.1 55355 2>/dev/null
    ;;
  post)
    sleep 0.75
    pidof emulationstation | xargs -r kill -CONT
    echo -n "PAUSE_TOGGLE" | nc -w1 -u 127.0.0.1 55355 2>/dev/null
    ;;
esac
exit 0
EOF
chmod +x /lib/systemd/system-sleep/volume-resume-fix

echo ""
echo "Installed."
sleep 5
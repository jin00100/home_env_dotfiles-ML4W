#!/usr/bin/env bash
set -e

echo "==> Configuring systemd-logind to disable suspend/sleep and lock on lid close..."
sudo mkdir -p /etc/systemd/logind.conf.d
sudo tee /etc/systemd/logind.conf.d/disable-suspend.conf > /dev/null << 'CONF'
[Login]
HandleLidSwitch=lock
HandleLidSwitchExternalPower=lock
HandleLidSwitchDocked=ignore
HandleSuspendKey=lock
HandleHibernateKey=lock
IdleAction=ignore
CONF

echo "==> Masking system sleep/suspend/hibernate targets..."
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

echo "==> Restarting systemd-logind..."
sudo systemctl restart systemd-logind

echo "==> Done! Sleep and suspend are now permanently disabled at the OS level."

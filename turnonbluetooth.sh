#!/bin/bash
# Script to reload rtbth module and check Bluetooth devices

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Remove and load module
sudo rmmod rtbth && sudo modprobe rtbth

# Check Bluetooth devices
OUTPUT=$(bluetoothctl --timeout 3 list &)

if echo "$OUTPUT" | grep -q 'Controller'; then
  echo -e "${GREEN}SUCCESS${NC}: Bluetooth controller found."
else
  echo -e "${RED}FAILED${NC}: No Bluetooth controller detected."
  echo -e "${RED}TIP:${NC} If it still doesn't work, turn off your computer for 2-3 hours without charging, then try again."
fi

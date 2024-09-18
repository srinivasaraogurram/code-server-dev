#!/bin/bash

# Function to check and install required packages
install_packages() {
  local packages=("hdparm" "fio")

  echo "Checking for required packages..."

  for pkg in "${packages[@]}"; do
    if ! dpkg -l | grep -q "^ii  $pkg "; then
      echo "Package $pkg is not installed. Installing..."
      sudo apt-get update
      sudo apt-get install -y "$pkg"
    else
      echo "Package $pkg is already installed."
    fi
  done
}

# Function to display speeds
display_speeds() {
  local device=$1

  echo "Testing device: $device"
  
  # Read speed test using hdparm
  echo -n "Read speed: "
  sudo hdparm -t "$device" 2>/dev/null | grep -oP '(?<=\s)[\d\.]+ MB/sec'

  # Write speed test using dd
  echo -n "Write speed: "
  sudo dd if=/dev/zero of="$device" bs=1M count=100 oflag=direct 2>&1 | grep -oP '[\d\.]+ MB/s'
  
  # Clean up (optional)
  echo "Write test complete."
}

# Main script logic
install_packages

# Detect USB drives (excluding partitions)
devices=$(lsblk -o NAME,TRAN | awk '$2 == "usb" && $1 !~ /[0-9]+$/ {print "/dev/" $1}')

if [ -z "$devices" ]; then
  echo "No USB drives detected."
  exit 1
fi

# Test each detected USB drive
for device in $devices; do
  display_speeds "$device"
done

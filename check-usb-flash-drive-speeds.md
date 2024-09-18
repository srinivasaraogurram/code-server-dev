To update the script to automatically install the required tools (`hdparm`, `fio`, and ensure that `dd` is available), you can include installation commands within the script. This way, the script will handle the installation of the necessary packages if they are not already present.

Here’s the updated script:

### Updated Script: `usb_speed_test.sh`

```bash
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
```

### How to Use the Updated Script

1. **Save the Script**: Save the updated script to a file, e.g., `usb_speed_test.sh`.

2. **Make it Executable**: Make the script executable:

   ```bash
   chmod +x usb_speed_test.sh
   ```

3. **Run the Script**: Execute the script with:

   ```bash
   sudo ./usb_speed_test.sh
   ```

### Explanation

- **Install Packages**: The `install_packages` function checks if `hdparm` and `fio` are installed. If not, it installs them using `apt-get`.
- **Read Speed Test**: Uses `hdparm` to perform a buffered read speed test.
- **Write Speed Test**: Uses `dd` to measure the write speed directly on the device.
- **Detect USB Drives**: Lists USB drives and performs speed tests.

By including the installation commands in the script, you ensure that all required tools are present before performing the speed tests. Make sure to run the script with `sudo` to grant the necessary permissions for installing packages and accessing raw devices.

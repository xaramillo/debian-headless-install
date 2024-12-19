#!/usr/bin/env bash

ISO_NAME="debian-12-headless.iso"
ORIGINAL_ISO="debian-12-original.iso"
OUTPUT_DIR="debian-custom"

# Verify if target device is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <target-device>"
  echo "Example: $0 /dev/sdX"
  exit 1
fi
TARGET_DEVICE=$1

# Downloading Debian ISO if it does not exist
if [ ! -f "$ORIGINAL_ISO" ]; then
  echo "Downloading Debian 12 ISO..."
  wget -O $ORIGINAL_ISO https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.8.0-amd64-netinst.iso
fi

# Create Debian custom work folder
mkdir -p $OUTPUT_DIR

# Mount ISO
sudo mount -o loop $ORIGINAL_ISO /mnt

# Configure the ISO and add the preseed file
rsync -a /mnt/ $OUTPUT_DIR
sudo umount /mnt
cp preseed.cfg $OUTPUT_DIR/

# Modify grub.cfg / txt.cfg either case
if [ -f "$OUTPUT_DIR/isolinux/txt.cfg" ]; then
  sed -i '/append/ s/$/ auto=true priority=critical file=\/cdrom\/preseed.cfg/' $OUTPUT_DIR/isolinux/txt.cfg
elif [ -f "$OUTPUT_DIR/boot/grub/grub.cfg" ]; then
  sed -i '/linux/ s/$/ auto=true priority=critical file=\/cdrom\/preseed.cfg/' $OUTPUT_DIR/boot/grub.cfg
fi

# Generate the ISO
sudo genisoimage -o $ISO_NAME -r -J -no-emul-boot -boot-load-size 4 -boot-info-table \
    -b isolinux/isolinux.bin -c isolinux/boot.cat $OUTPUT_DIR

# Write ISO to target device
sudo dd if=$ISO_NAME of=$TARGET_DEVICE bs=4M status=progress && sync

# Clean up
rm -rf $OUTPUT_DIR
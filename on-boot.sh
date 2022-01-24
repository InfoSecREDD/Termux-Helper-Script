#!/data/data/com.termux/files/usr/bin/sh
#
#  Title: REDD's Termux Startup Script v1
#  Author: InfoSecREDD
#
# Notes: DO NOT RUN THIS WITH SUDO OR AS ROOT, RUN AS-IS
#        THE SCRIPT WILL SUDO THE COMMANDS NEEDED.

# Termux Wake-Lock to prevent processes from sleeping
termux-wake-lock

# Start a SSH server on Termux as root.
sudo sshd

# Basic Location Variables
TERMUX_DIR="/data/data/com.termux/files/home"
STORAGE="/storage/emulated/0"

# Bind NFC Dump Directory for File Explorer (Proxmark3)
LOCAL_DUMP_DIR="${TERMUX_DIR}/dumps"
BIND_DUMP_DIR="${STORAGE}/nfc-dumps"

sudo mount --bind "${BIND_DUMP_DIR}" "${LOCAL_DUMP_DIR}"

# Link Kali Chroot if found.
KALI_CHROOT_DIR="${TERMUX_DIR}/kali-arm64"
LOCAL_CHROOT_DIR="${STORAGE}/Documents/kali-chroot"
if [ -d "${KALI_CHROOT_DIR}" ]; then
        echo "Kali Chroot found."
        echo "Mounting /dev and /sys to Chroot."
        sudo mount --bind "/dev" "${KALI_CHROOT_DIR}/dev"
        sudo mount --bind "/sys" "${KALI_CHROOT_DIR}/sys"
        echo "Mounting Chroot NFC Dump folder to Local folder."
        if [ ! -d "${KALI_CHROOT_DIR}/root/dumps" ]; then
                mkdir -p "${KALI_CHROOT_DIR}/root/dumps"
                sudo mount --bind "${LOCAL_DUMP_DIR}" "${KALI_CHROOT_DIR}/root/dumps"
        else
                sudo mount --bind "${LOCAL_DUMP_DIR}" "${KALI_CHROOT_DIR}/root/dumps"
        fi
else
        echo "No Kali Chroot found. Continuing."
fi

# Bind Picture Directory for File Explorer
LOCAL_PIC_DIR="${TERMUX_DIR}/pics"
BIND_PIC_DIR="${STORAGE}/Pictures"

sudo mount --bind "${BIND_PIC_DIR}" "${LOCAL_PIC_DIR}"

# Bind Miscellaneous Directory for File Explorer
LOCAL_MISC_DIR="${TERMUX_DIR}/misc"
BIND_MISC_DIR="${STORAGE}/Documents/misc"

sudo mount --bind "${BIND_MISC_DIR}" "${LOCAL_MISC_DIR}"


# Android 12 DriveDroid Temp Fix (Should work for other devices)
sudo setprop sys.usb.config cdrom
sudo setprop sys.usb.configfs 1
# sudo rm /config/usb_gadget/g1/configs/b.1/f* &>/dev/null
# sudo mkdir -p /config/usb_gadget/g1/functions/mass_storage.0/lun.0/
# sudo touch /config/usb_gadget/g1/functions/mass_storage.0/lun.0/file
# sudo echo $1  >/config/usb_gadget/g1/functions/mass_storage.0/lun.0/file
# sudo ln -s /config/usb_gadget/g1/functions/mass_storage.0  /config/usb_gadget/g1/configs/b.1/f99
# sudo getprop sys.usb.controller >/config/usb_gadget/g1/UDC
sudo setprop sys.usb.state cdrom

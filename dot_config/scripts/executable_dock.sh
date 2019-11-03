#!/usr/bin/env sh

# UUID of the dock
# install boltctl to find the uuid and to use this script
DEVICE='00985865-3e6e-3d00-ffff-ffffffffffff'
NAME='CalDigit'

# on/off
POWER=("on off")
TOGGLE=$1

if [[ " ${POWER[@]} " =~ " ${TOGGLE} " ]] && [ -n $1 ]; then
  echo "Valid argument."
else
  echo "Missing argument. Can only be 'on' or 'off'."
  exit 1  
fi

function PM() {
  while [[ ! -d /sys || ! -d /proc/sys ]]; do sleep 5;done
  echo 1 > /proc/sys/vm/laptop_mode
  echo 0 > /proc/sys/kernel/nmi_watchdog
  echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
  for i in /sys/class/scsi_host/*/link_power_management_policy; do echo med_power_with_dipm > $i; done
  echo Y > /sys/module/snd_hda_intel/parameters/power_save_controller
  echo 1 > /sys/module/snd_hda_intel/parameters/power_save
  for i in /sys/bus/{pci,i2c,usb,thunderbolt}/devices/*/power/control; do echo auto > $i; done
  for i in /sys/bus/usb/devices/*/power/autosuspend; do echo 1 > $i; done 
  for i in /sys/bus/usb/devices/*/power/level; do echo auto > $i; done
  xset s blank
  xset s 300 3600 +dpms
}

function DM() {
  while [[ ! -d /sys || ! -d /proc/sys ]]; do sleep 5;done
  echo on > /sys/devices/pci0000:00/pci_bus/0000:00/power/control
  echo 0 > /proc/sys/vm/laptop_mode
  echo 0 > /proc/sys/kernel/nmi_watchdog
  echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
  for i in /sys/class/scsi_host/*/link_power_management_policy; do echo med_power_with_dipm > $i; done
  echo Y > /sys/module/snd_hda_intel/parameters/power_save_controller
  echo 1 > /sys/module/snd_hda_intel/parameters/power_save
  for i in /sys/bus/{pci,i2c,usb,thunderbolt}/devices/*/power/control; do echo on > $i; done
  for i in /sys/bus/usb/devices/*/power/autosuspend; do echo 0 > $i; done
  for i in /sys/bus/usb/devices/*/power/level; do echo on > $i; done
  echo on > /sys/class/drm/card0/card0-HDMI-A-1/power/control
  echo enabled > /sys/bus/usb/devices/5-2/power/wakeup
  xset s off -dpms
}

if [ $TOGGLE = 'on' ]; then
  if [ $(boltctl info $DEVICE | head -n 1 | awk -F ' ' '{print $2}' | tr -d ',') = $NAME ]; then
    sudo modprobe xhci_pci
    sudo modprobe -r igb
    sudo modprobe e1000e
    xrandr --auto
    xrandr --output eDP1 --off
    echo "X1C5 docked."
    DM 2> /dev/null &
  fi
elif [ $TOGGLE = 'off' ]; then
  sudo modprobe -r xhci_pci
  sudo modprobe -r e1000e
  xrandr --output eDP1 --auto
  echo "X1C5 undocked."
  PM 2> /dev/null &
fi

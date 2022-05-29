#!/bin/bash

ESUDO="sudo"
if [ -f "/storage/.config/.OS_ARCH" ]; then
  ESUDO=""
fi

if [[ -e "/dev/input/by-path/platform-ff300000.usb-usb-0:1.2:1.0-event-joystick" ]]; then
  param_device="anbernic"
elif [[ -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]]; then
    if [[ ! -z $(cat /etc/emulationstation/es_input.cfg | grep "190000004b4800000010000001010000") ]]; then
	  param_device="oga"
	else
	  param_device="rk2020"
	fi
elif [[ -e "/dev/input/by-path/platform-odroidgo3-joypad-event-joystick" ]]; then
  param_device="ogs"
else
  param_device="chi"
fi

if [ -f "/opt/system/Advanced/Switch to main SD for Roms.sh" ]; then
  GAMEDIR="/roms2/ports/MystikBelle"
  LIBDIR="/roms2/ports/MystikBelle/lib32"
  BINDIR="/roms2/ports/MystikBelle/box86"
else
  GAMEDIR="/roms/ports/MystikBelle"
  LIBDIR="/roms/ports/MystikBelle/lib32"
  BINDIR="/roms/ports/MystikBelle/box86"
fi

#BOX86 LOG
export BOX86_LOG=1

# gl4es
export LIBGL_FB=4

# system
export LD_LIBRARY_PATH=$LIBDIR:/usr/lib32:/usr/local/lib/arm-linux-gnueabihf/

# box86
export BOX86_ALLOWMISSINGLIBS=1
export BOX86_LD_LIBRARY_PATH=$LIBDIR
export BOX86_LIBGL=$LIBDIR/libGL.so.1
export BOX86_PATH=$BINDIR/lib/libstdc++.so.6
export BOX86_NOGTK=1
export BOX86_DYNAREC=1


cd $GAMEDIR

$ESUDO rm -rf ~/.config/MystikBelle
$ESUDO ln -s /$GAMEDIR/conf/MystikBelle ~/.config/
$ESUDO ./oga_controls box86 $param_device &
$BINDIR/box86 $GAMEDIR/runner
$ESUDO kill -9 $(pidof oga_controls)
$ESUDO systemctl restart oga_events &
printf "\033c" >> /dev/tty1

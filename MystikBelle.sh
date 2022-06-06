#!/bin/bash

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "/roms/ports" ]; then
  controlfolder="/roms/ports/PortMaster"
 elif [ -d "/roms2/ports" ]; then
  controlfolder="/roms2/ports/PortMaster"
else
  controlfolder="/storage/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
source $controlfolder/tasksetter

get_controls

GAMEDIR="/$directory/ports/MystikBelle"
LIBDIR="/$directory/ports/MystikBelle/lib32"
BINDIR="/$directory/ports/MystikBelle/box86"

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
$GPTOKEYB "box86" &
$TASKSET $BINDIR/box86 $GAMEDIR/runner
$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events &
printf "\033c" >> /dev/tty1

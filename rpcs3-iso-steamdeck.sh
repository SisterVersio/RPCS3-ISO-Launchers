udisksctl unmount -b /dev/loop0
udisksctl loop-delete --no-user-interaction -b /dev/loop0
udisksctl loop-setup -f "${@}"
udisksctl mount -b /dev/loop0
GAMEFOLDER=$(findmnt /dev/loop0 -n -o TARGET)
SDL_GAMECONTROLLER_ALLOW_STEAM_VIRTUAL_GAMEPAD="0" SDL_GAMECONTROLLER_IGNORE_DEVICES="" "/home/deck/Emulators/RPCS3/RPCS3.AppImage" --no-gui "$GAMEFOLDER/PS3_GAME/USRDIR/EBOOT.BIN"

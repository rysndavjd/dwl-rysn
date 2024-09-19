export XDG_CONFIG_HOME="${HOME}/.config/"
export XDG_DATA_HOME="${HOME}/.local/share/"
export GDK_DPI_SCALE=1.3

pipewire &
/usr/bin/pipewire-pulse &
/usr/bin/wireplumber &

if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    dbus-run-session dwl
fi
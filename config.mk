VERSION = 0.1
CONFIG=laptop

PKG_CONFIG = pkg-config

# paths
PREFIX = /usr
MANDIR = $(PREFIX)/share/man
DATADIR = $(PREFIX)/share

XWAYLAND =
XLIBS =
# Uncomment to build XWayland support
XWAYLAND = -DXWAYLAND
XLIBS = xcb xcb-icccm

CC = gcc

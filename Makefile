.POSIX:
.SUFFIXES:

include config.mk

# flags for compiling
DWLCPPFLAGS = -I. -DWLR_USE_UNSTABLE -D_POSIX_C_SOURCE=200809L \
	-DVERSION=\"$(VERSION)\" $(XWAYLAND)
DWLDEVCFLAGS = -g -pedantic -Wall -Wextra -Wdeclaration-after-statement \
	-Wno-unused-parameter -Wshadow -Wunused-macros -Werror=strict-prototypes \
	-Werror=implicit -Werror=return-type -Werror=incompatible-pointer-types \
	-Wfloat-conversion

# CFLAGS / LDFLAGS
PKGS      = wlroots-0.18 wayland-server xkbcommon libinput $(XLIBS)
DWLCFLAGS = `$(PKG_CONFIG) --cflags $(PKGS)` $(DWLCPPFLAGS) $(DWLDEVCFLAGS) $(CFLAGS)
LDLIBS    = `$(PKG_CONFIG) --libs $(PKGS)` -lm $(LIBS)

all: dwl
dwl: dwl.o util.o dwl-ipc-unstable-v2-protocol.o
	$(CC) dwl.o util.o dwl-ipc-unstable-v2-protocol.o $(DWLCFLAGS) $(LDFLAGS) $(LDLIBS) -o $@
dwl.o: dwl.c client.h config.h config.mk cursor-shape-v1-protocol.h \
	pointer-constraints-unstable-v1-protocol.h wlr-layer-shell-unstable-v1-protocol.h \
	wlr-output-power-management-unstable-v1-protocol.h xdg-shell-protocol.h \
	dwl-ipc-unstable-v2-protocol.h
util.o: util.c util.h
dwl-ipc-unstable-v2-protocol.o: dwl-ipc-unstable-v2-protocol.c dwl-ipc-unstable-v2-protocol.h

# wayland-scanner is a tool which generates C headers and rigging for Wayland
# protocols, which are specified in XML. wlroots requires you to rig these up
# to your build system yourself and provide them in the include path.
WAYLAND_SCANNER   = `$(PKG_CONFIG) --variable=wayland_scanner wayland-scanner`
WAYLAND_PROTOCOLS = `$(PKG_CONFIG) --variable=pkgdatadir wayland-protocols`

cursor-shape-v1-protocol.h:
	$(WAYLAND_SCANNER) enum-header \
		$(WAYLAND_PROTOCOLS)/staging/cursor-shape/cursor-shape-v1.xml $@
pointer-constraints-unstable-v1-protocol.h:
	$(WAYLAND_SCANNER) enum-header \
		$(WAYLAND_PROTOCOLS)/unstable/pointer-constraints/pointer-constraints-unstable-v1.xml $@
wlr-layer-shell-unstable-v1-protocol.h:
	$(WAYLAND_SCANNER) enum-header \
		protocols/wlr-layer-shell-unstable-v1.xml $@
wlr-output-power-management-unstable-v1-protocol.h:
	$(WAYLAND_SCANNER) server-header \
		protocols/wlr-output-power-management-unstable-v1.xml $@
xdg-shell-protocol.h:
	$(WAYLAND_SCANNER) server-header \
		$(WAYLAND_PROTOCOLS)/stable/xdg-shell/xdg-shell.xml $@
dwl-ipc-unstable-v2-protocol.h:
	$(WAYLAND_SCANNER) server-header \
		protocols/dwl-ipc-unstable-v2.xml $@
dwl-ipc-unstable-v2-protocol.c:
	$(WAYLAND_SCANNER) private-code \
		protocols/dwl-ipc-unstable-v2.xml $@

config.h: clean
	ln -srf config-$(CONFIG).h config.h

clean:
	rm -f dwl *.o *-protocol.h

dist: clean
	mkdir -p dwl-rysn-$(VERSION)
	cp -R LICENSE* Makefile CHANGELOG.md README.md client.h config.def.h \
		config.mk protocols dwl.1 dwl.c util.c util.h dwl.desktop \
		patchs dwl-addons config-laptop.h config-desktop.h \
		dwl-rysn-$(VERSION)
	tar -caf dwl-rysn-$(VERSION).tar.gz dwl-rysn-$(VERSION)
	rm -rf dwl-rysn-$(VERSION)

install: dwl
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f dwl $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dwl
	mkdir -p $(DESTDIR)$(MANDIR)/man1
	cp -f dwl.1 $(DESTDIR)$(MANDIR)/man1
	chmod 644 $(DESTDIR)$(MANDIR)/man1/dwl.1
	mkdir -p $(DESTDIR)$(DATADIR)/wayland-sessions
	cp -f dwl.desktop $(DESTDIR)$(DATADIR)/wayland-sessions/dwl.desktop
	chmod 644 $(DESTDIR)$(DATADIR)/wayland-sessions/dwl.desktop
	mkdir -p $(DESTDIR)$(PREFIX)/share/dwl-rysn
	cp dwl-addons/scripts/* $(DESTDIR)$(PREFIX)/share/dwl-rysn/
	chmod 755 $(DESTDIR)$(PREFIX)/share/dwl-rysn/*
	cp dwl-addons/profile/$(CONFIG)/.bash_profile $(DESTDIR)$(PREFIX)/share/dwl-rysn/
	chmod 755 $(DESTDIR)$(PREFIX)/share/dwl-rysn/*
	cp -f dwl-addons/rofi/rofi.rasi $(DESTDIR)/etc/xdg/rofi.rasi
	chmod 644 $(DESTDIR)/etc/xdg/rofi.rasi
	mkdir -p $(DESTDIR)/etc/xdg/waybar
	cp -f dwl-addons/waybar/$(CONFIG)/config $(DESTDIR)/etc/xdg/waybar/config
	chmod 644 $(DESTDIR)/etc/xdg/waybar/config
	cp -f dwl-addons/waybar/$(CONFIG)/style.css $(DESTDIR)/etc/xdg/waybar/style.css
	chmod 644 $(DESTDIR)/etc/xdg/waybar/style.css
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dwl $(DESTDIR)$(MANDIR)/man1/dwl.1 \
		$(DESTDIR)$(DATADIR)/wayland-sessions/dwl.desktop

.SUFFIXES: .c .o
.c.o:
	$(CC) $(CPPFLAGS) $(DWLCFLAGS) -o $@ -c $<

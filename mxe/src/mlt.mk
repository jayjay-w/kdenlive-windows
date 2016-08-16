# This file is part of MXE.
# See index.html for further information.

PKG             := mlt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.2.0
$(PKG)_CHECKSUM := 5acdc8760cc28b19e9dc291f66cbe3faa2bc5e8d53e2de3ef543eb5be0feb9f4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libxml2 sdl ffmpeg qtbase qtsvg \
	frei0r-plugins ladspa-sdk fftw libsamplerate vorbis
# sox gtk2 movit exif xine

define $(PKG)_UPDATE
    $(WGET) -q -O- http://sourceforge.net/projects/mlt/files/mlt | \
    $(SED) -n 's,.*mlt_\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
	CFLAGS="-I$(PREFIX)/$(TARGET)/include" \
	PKG_CONFIG_LIBDIR=$(PREFIX)/$(TARGET)/lib/pkgconfig \
	CC=$(TARGET)-gcc \
	./configure $(MXE_CONFIGURE_OPTS) \
		--target-os=MinGW --rename-melt=melt.exe \
		--qt-includedir=$(PREFIX)/$(TARGET)/qt5/include \
		--qt-libdir=$(PREFIX)/$(TARGET)/qt5/lib \
		--enable-gpl --enable-gpl3 \
		--disable-gtk2 --disable-sox --disable-opengl --disable-xine --disable-rtaudio \
		--disable-decklink
	echo "QTCXXFLAGS+=-std=c++11" >> '$(1)/src/modules/qt/config.mak'
	$(MAKE) -C '$(1)/src/modules/lumas' \
		CC=$(BUILD_CC) luma
	CFLAGS="-I$(PREFIX)/$(TARGET)/include" \
	PKG_CONFIG_LIBDIR=$(PREFIX)/$(TARGET)/lib/pkgconfig \
	$(MAKE) -C '$(1)' \
		CC=$(TARGET)-gcc \
		CXX=$(TARGET)-g++ \
		-j '$(JOBS)' all
    $(MAKE) -C '$(1)' -j 1 install
endef


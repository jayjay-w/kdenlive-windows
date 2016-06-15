# This file is part of MXE.
# See index.html for further information.

PKG             := mlt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.2.0
$(PKG)_CHECKSUM := 5acdc8760cc28b19e9dc291f66cbe3faa2bc5e8d53e2de3ef543eb5be0feb9f4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_HOME     := http://sourceforge.net/projects/$(PKG)/files/$(PKG)
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libxml2 sdl ffmpeg qtbase qtsvg \
	frei0r ladspa-sdk fftw libsamplerate sox vorbis

# movit exif xine

define $(PKG)_UPDATE
    $(WGET) -q -O- $($(PKG)_HOME) | \
    $(SED) -n 's,.*$(PKG)_\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
		--enable-gpl --enable-gpl3 --disable-decklink
    $(MAKE) -C '$(1)' -j '$(JOBS)' all
    $(MAKE) -C '$(1)' -j 1 install
endef

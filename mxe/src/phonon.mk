# This file is part of MXE.
# See index.html for further information.
PKG             := phonon
$(PKG)_VERSION  := 4.9.0
$(PKG)_CHECKSUM  := bb74b40f18ade1d9ab89ffcd7aeb7555be797ca395f1224c488b394da6deb0e0
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_HOME     := http://download.kde.org/stable/phonon
$(PKG)_URL      := $($(PKG)_HOME)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := qtbase

define $(PKG)_UPDATE
    $(WGET) -q -O- http://download.kde.org/stable/phonon/ | \
    $(SED) -n 's,.*\([0-9]\+\.[0-9]\+.[0-9]\+\)/.*,\1,p' | \
	tail -1
endef

define $(PKG)_BUILD
    mkdir "$(1)/build"
    cd "$(1)/build" && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)" \
        -DCMAKE_BUILD_TYPE=Release \
        -DPHONON_BUILD_EXAMPLES=OFF \
        -DPHONON_BUILD_TESTS=OFF \
        -DPHONON_INSTALL_QT_EXTENSIONS_INTO_SYSTEM_QT=ON \
        -DPHONON_BUILD_PHONON4QT5=ON
    $(MAKE) -C "$(1)/build" install
endef

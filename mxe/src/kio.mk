# This file is part of MXE.
# See index.html for further information.
PKG             := kio
$(PKG)_VERSION  := 5.23.0
$(PKG)_CHECKSUM  := 3489ba9c45e587f6b8b542aea4608eeb21cdbca27ef37d9f45d4308da8fd32b5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_HOME     := http://download.kde.org/stable/frameworks
$(PKG)_URL      := $($(PKG)_HOME)/$(basename $($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := qtbase \
	karchive kcodecs kconfig kcoreaddons kdbusaddons ki18n kitemviews solid kwidgetsaddons kwindowsystem \
	kcompletion kjobwidgets \
	kbookmarks kconfigwidgets kiconthemes knotifications kservice kxmlgui kwallet

define $(PKG)_UPDATE
    $(WGET) -q -O- http://download.kde.org/stable/frameworks/ | \
    $(SED) -n 's,.*\([0-9]\+\.[0-9]\+\)/.*,\1.0,p' | \
	tail -1
endef

define $(PKG)_BUILD
    mkdir "$(1)/build"
    cd "$(1)/build" && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)" \
        -DCMAKE_BUILD_TYPE=Release \
        -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
        -DBUILD_TESTING=OFF
    $(MAKE) -C "$(1)/build" install
endef

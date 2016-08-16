# This file is part of MXE.
# See index.html for further information.
PKG             := kdenlive
$(PKG)_VERSION  := 16.04.3
$(PKG)_CHECKSUM := d5af3f96c1d43c3f0a28844b0c56dd3951f07cd6a48355096cb6272d1dbba40c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_HOME     := http://download.kde.org/stable/applications
$(PKG)_URL      := $($(PKG)_HOME)/$($(PKG)_VERSION)/src/$($(PKG)_FILE)
$(PKG)_DEPS     := \
	ffmpeg mlt \
	qtbase qtdeclarative qtscript \
	breeze-icons karchive kconfig kcoreaddons kdbusaddons kguiaddons ki18n kitemviews kplotting kwidgetsaddons \
	kcompletion kcrash kfilemetadata kjobwidgets \
	kbookmarks kconfigwidgets kiconthemes kio knewstuff knotifications knotifyconfig kservice ktextwidgets kxmlgui

define $(PKG)_UPDATE
    $(WGET) -q -O- http://download.kde.org/stable/applications | \
    $(SED) -n 's,.*\([0-9]\+.[0-9]\+.[0-9]\+\)/.*,\1,p' | \
	tail -1
endef

define $(PKG)_BUILD
    mkdir "$(1)/build"
    cd "$(1)/build" && \
	PKG_CONFIG_LIBDIR=$(PREFIX)/$(TARGET)/lib/pkgconfig \
	cmake .. \
        -DCMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)" \
        -DCMAKE_CROSSCOMPILING=ON -DKF5_HOST_TOOLING='/usr/lib/x86_64-linux-gnu/cmake' \
        -DKCONFIGCOMPILER_PATH=/usr/lib/x86_64-linux-gnu/cmake/KF5Config/KF5ConfigCompilerTargets.cmake \
        -DTARGETSFILE=/usr/lib/x86_64-linux-gnu/cmake/KF5CoreAddons/KF5CoreAddonsToolingTargets.cmake \
        -DCMAKE_DISABLE_FIND_PACKAGE_LibV4L2=TRUE \
        -DCMAKE_BUILD_TYPE=Debug \
        -DKDE_INSTALL_USE_QT_SYS_PATHS=ON
    $(MAKE) -C "$(1)/build" install
endef

# This file is part of MXE.
# See index.html for further information.

PKG             := frei0r-plugins
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.0
$(PKG)_CHECKSUM := 781cf84a6c2a9a3252f54d2967b57f6de75a31fc1684371e112638c981f72b60
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_HOME     := https://files.dyne.org/frei0r/releases/
$(PKG)_URL      := $($(PKG)_HOME)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc cmake opencv cairo
# gavl

define $(PKG)_UPDATE
    $(WGET) -q -O- $($(PKG)_HOME) | \
    $(SED) -n 's,.*$(PKG)_\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef

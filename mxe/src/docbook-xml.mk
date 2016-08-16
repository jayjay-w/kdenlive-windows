# This file is part of MXE.
# See index.html for further information.
PKG             := docbook-xml
$(PKG)_VERSION  := 4.5
$(PKG)_CHECKSUM := 4e4e037a2b83c98c6c94818390d4bdd3f6e10f6ec62dd79188594e26190dc7b4
$(PKG)_SUBDIR   :=
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).zip
$(PKG)_HOME     := http://www.docbook.org/xml
$(PKG)_URL      := $($(PKG)_HOME)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- $($(PKG)_HOME) | \
    $(SED) -n 's,.*\([0-9.][^>]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
	install -v -d -m755 $(PREFIX)/$(TARGET)/share/xml/docbook/xml-dtd-$($(PKG)_VERSION)
	cd $(1) && cp -afrv * $(PREFIX)/$(TARGET)/share/xml/docbook/xml-dtd-$($(PKG)_VERSION)
endef


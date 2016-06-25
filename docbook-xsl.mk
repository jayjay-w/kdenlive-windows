# This file is part of MXE.
# See index.html for further information.
PKG             := docbook-xsl
$(PKG)_VERSION  := 1.78.1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_HOME     := http://sourceforge.net/projects/$(PKG)/files/$(PKG)
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := docbook-dtd

define $(PKG)_UPDATE
    $(WGET) -q -O- $($(PKG)_HOME) | \
    $(SED) -n 's,.*$(PKG)_\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
	cp $(1)/$(PKG)-$($(PKG)_VERSION).xml $(PREFIX)/etc/xml/docbook-xsl-stylesheets.xml
	mv $(1)/ $(PREFIX)/share/xml/docbook/xsl-stylesheets
endef


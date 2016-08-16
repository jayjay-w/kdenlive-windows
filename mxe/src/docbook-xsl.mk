# This file is part of MXE.
# See index.html for further information.
PKG             := docbook-xsl
$(PKG)_VERSION  := 1.79.1
$(PKG)_CHECKSUM := 725f452e12b296956e8bfb876ccece71eeecdd14b94f667f3ed9091761a4a968
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_HOME     := http://sourceforge.net/projects/docbook/files/$(PKG)
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/docbook/$($(PKG)_FILE)
$(PKG)_DEPS     := docbook-xml

define $(PKG)_UPDATE
    $(WGET) -q -O- $($(PKG)_HOME) | \
    $(SED) -n 's,.*$(PKG)_\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
	install -v -d -m755 $(PREFIX)/$(TARGET)/etc/xml
	cp $(1)/VERSION $(PREFIX)/$(TARGET)/etc/xml/docbook-xsl-stylesheets.xml
	install -v -d -m755 $(PREFIX)/$(TARGET)/share/xml/docbook/
	cp -afv $(1)/ $(PREFIX)/$(TARGET)/share/xml/docbook/xsl-stylesheets/
endef


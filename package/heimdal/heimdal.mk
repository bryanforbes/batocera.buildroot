################################################################################
#
# heimdal
#
################################################################################
# batocera - bump - remove 0001 & 0002 patches
HEIMDAL_VERSION = ba8c3dbc6261ab397ce5bb4fc0ca6b0ea23eb46a
HEIMDAL_SITE = $(call github,heimdal,heimdal,$(HEIMDAL_VERSION))
HOST_HEIMDAL_DEPENDENCIES = host-e2fsprogs host-ncurses host-pkgconf
HOST_HEIMDAL_AUTORECONF = YES
HEIMDAL_INSTALL_STAGING = YES
# static because of -fPIC issues with e2fsprogs on x86_64 host
# batocera - ignore above, works fine. -fPIC required for Qt6
# removed --disable-shared & --enable-static options
HOST_HEIMDAL_CONF_OPTS = \
	--without-openldap \
	--without-capng \
	--with-db-type-preference= \
	--without-sqlite3 \
	--without-libintl \
	--without-openssl \
	--without-berkeley-db \
	--without-readline \
	--without-libedit \
	--without-hesiod \
	--without-x \
	--disable-mdb-db \
	--disable-ndbm-db \
	--disable-heimdal-documentation

# Don't use compile_et from e2fsprogs as it raises a build failure with samba4
HOST_HEIMDAL_CONF_ENV = ac_cv_prog_COMPILE_ET=no MAKEINFO=true
# batocera - add the -fPIC flag.
HOST_HEIMDAL_CONF_ENV += CFLAGS="$(HOST_CFLAGS) -fPIC"

HEIMDAL_LICENSE = BSD-3-Clause
HEIMDAL_LICENSE_FILES = LICENSE
HEIMDAL_CPE_ID_VALID = YES

# We need compile_et for samba4
define HOST_HEIMDAL_INSTALL_COMPILE_ET
	$(INSTALL) -m 0755 $(@D)/lib/com_err/compile_et \
		$(HOST_DIR)/bin/compile_et
endef

HOST_HEIMDAL_POST_INSTALL_HOOKS += \
	HOST_HEIMDAL_INSTALL_COMPILE_ET

$(eval $(host-autotools-package))

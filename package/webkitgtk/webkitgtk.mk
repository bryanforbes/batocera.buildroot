################################################################################
#
# webkitgtk
#
################################################################################

WEBKITGTK_VERSION = 2.44.2
WEBKITGTK_SITE = https://www.webkitgtk.org/releases
WEBKITGTK_SOURCE = webkitgtk-$(WEBKITGTK_VERSION).tar.xz
WEBKITGTK_INSTALL_STAGING = YES
WEBKITGTK_LICENSE = LGPL-2.1+, BSD-2-Clause
WEBKITGTK_LICENSE_FILES = \
	Source/WebCore/LICENSE-APPLE \
	Source/WebCore/LICENSE-LGPL-2.1
WEBKITGTK_CPE_ID_VENDOR = webkitgtk
WEBKITGTK_DEPENDENCIES = host-ruby host-python3 host-gperf host-unifdef \
	enchant harfbuzz icu jpeg libegl libepoxy libgcrypt libgtk3 libsecret \
	libsoup3 libtasn1 libxml2 libxslt sqlite webp woff2

WEBKITGTK_CMAKE_BACKEND = ninja

# batocera - limit the number of parallel jobs
# otherwise webkitgtk eats all your memory C....
total_memory_kb := $(shell grep MemTotal /proc/meminfo | awk '{print $$2}')
memory_based_jobs := $(shell echo $$(( $(total_memory_kb) / 1024 / 1024 / 2 + 1)))
cpu_threads := $(shell nproc)
jobs := $(shell echo $$(( $(memory_based_jobs) < $(cpu_threads) ? $(memory_based_jobs) : $(cpu_threads) )))
WEBKITGTK_BUILD_OPTS= -j$(jobs)

WEBKITGTK_CONF_OPTS = \
	-DENABLE_API_TESTS=OFF \
	-DENABLE_DOCUMENTATION=OFF \
	-DENABLE_GEOLOCATION=OFF \
	-DENABLE_MINIBROWSER=ON \
	-DENABLE_SPELLCHECK=ON \
	-DENABLE_WEB_RTC=OFF \
	-DPORT=GTK \
	-DUSE_AVIF=OFF \
	-DUSE_GTK4=OFF \
	-DUSE_LIBHYPHEN=OFF \
	-DUSE_WOFF2=ON \
	-DWAYLAND_PROTOCOLS_DATADIR=$(STAGING_DIR)/usr/share/wayland-protocols

ifeq ($(BR2_PACKAGE_WEBKITGTK_SANDBOX),y)
WEBKITGTK_CONF_OPTS += \
	-DENABLE_BUBBLEWRAP_SANDBOX=ON \
	-DBWRAP_EXECUTABLE=/usr/bin/bwrap \
	-DDBUS_PROXY_EXECUTABLE=/usr/bin/xdg-dbus-proxy
WEBKITGTK_DEPENDENCIES += libseccomp
else
WEBKITGTK_CONF_OPTS += -DENABLE_BUBBLEWRAP_SANDBOX=OFF
endif

ifeq ($(BR2_PACKAGE_WEBKITGTK_MULTIMEDIA),y)
WEBKITGTK_CONF_OPTS += \
	-DENABLE_VIDEO=ON \
	-DENABLE_WEB_AUDIO=ON \
	-DENABLE_WEB_CODECS=ON
WEBKITGTK_DEPENDENCIES += gstreamer1 gst1-libav gst1-plugins-base
else
WEBKITGTK_CONF_OPTS += \
	-DENABLE_VIDEO=OFF \
	-DENABLE_WEB_AUDIO=OFF \
	-DENABLE_WEB_CODECS=OFF
endif

ifeq ($(BR2_PACKAGE_WEBKITGTK_WEBDRIVER),y)
WEBKITGTK_CONF_OPTS += -DENABLE_WEBDRIVER=ON
else
WEBKITGTK_CONF_OPTS += -DENABLE_WEBDRIVER=OFF
endif

ifeq ($(BR2_PACKAGE_WEBKITGTK_MINIBROWSER),y)
define WEBKITGTK_INSTALL_MINIBROWSER_SYMLINK
	ln -sf ../libexec/webkit2gtk-4.1/MiniBrowser $(TARGET_DIR)/usr/bin/MiniBrowser
endef
WEBKITGTK_POST_INSTALL_TARGET_HOOKS += WEBKITGTK_INSTALL_MINIBROWSER_SYMLINK
WEBKITGTK_CONF_OPTS += -DENABLE_MINIBROWSER=ON
else
WEBKITGTK_CONF_OPTS += -DENABLE_MINIBROWSER=OFF
endif

ifeq ($(BR2_PACKAGE_LCMS2),y)
WEBKITGTK_CONF_OPTS += -DUSE_LCMS=ON
WEBKITGTK_DEPENDENCIES += lcms2
else
WEBKITGTK_CONF_OPTS += -DUSE_LCMS=OFF
endif

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
WEBKITGTK_CONF_OPTS += -DENABLE_INTROSPECTION=ON
WEBKITGTK_DEPENDENCIES += gobject-introspection
else
WEBKITGTK_CONF_OPTS += -DENABLE_INTROSPECTION=OFF
endif

ifeq ($(BR2_PACKAGE_LIBBACKTRACE),y)
WEBKITGTK_CONF_OPTS += -DUSE_LIBBACKTRACE=ON
WEBKITGTK_DEPENDENCIES += libbacktrace
else
WEBKITGTK_CONF_OPTS += -DUSE_LIBBACKTRACE=OFF
endif

ifeq ($(BR2_PACKAGE_LIBJXL),y)
WEBKITGTK_CONF_OPTS += -DUSE_JPEGXL=ON
WEBKITGTK_DEPENDENCIES += libjxl
else
WEBKITGTK_CONF_OPTS += -DUSE_JPEGXL=OFF
endif

ifeq ($(BR2_PACKAGE_LIBMANETTE),y)
WEBKITGTK_CONF_OPTS += -DENABLE_GAMEPAD=ON
WEBKITGTK_DEPENDENCIES += libmanette
else
WEBKITGTK_CONF_OPTS += -DENABLE_GAMEPAD=OFF
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGBM),y)
WEBKITGTK_CONF_OPTS += -DUSE_GBM=ON
WEBKITGTK_DEPENDENCIES += libgbm
else
WEBKITGTK_CONF_OPTS += -DUSE_GBM=OFF
endif

ifeq ($(BR2_PACKAGE_LIBGTK3_X11),y)
WEBKITGTK_CONF_OPTS += -DENABLE_X11_TARGET=ON
WEBKITGTK_DEPENDENCIES += libgl \
	xlib_libXcomposite xlib_libXdamage xlib_libXrender xlib_libXt
else
WEBKITGTK_CONF_OPTS += -DENABLE_X11_TARGET=OFF
endif

ifeq ($(BR2_PACKAGE_LIBGTK3_WAYLAND),y)
WEBKITGTK_CONF_OPTS += -DENABLE_WAYLAND_TARGET=ON
else
WEBKITGTK_CONF_OPTS += -DENABLE_WAYLAND_TARGET=OFF
endif

ifeq ($(BR2_PACKAGE_WEBKITGTK_USE_GSTREAMER_GL),y)
WEBKITGTK_CONF_OPTS += -DUSE_GSTREAMER_GL=ON
else
WEBKITGTK_CONF_OPTS += -DUSE_GSTREAMER_GL=OFF
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
WEBKITGTK_CONF_OPTS += -DENABLE_JOURNALD_LOG=ON
WEBKITGTK_DEPENDENCIES += systemd
else
WEBKITGTK_CONF_OPTS += -DENABLE_JOURNALD_LOG=OFF
endif

# JIT is not supported for MIPS r6, but the WebKit build system does not
# have a check for these processors. The same goes for ARMv5 and ARMv6.
# Disable JIT forcibly here and use the CLoop interpreter instead.
#
# Also, we have to disable the sampling profiler and webassembly,
# which does NOT work with ENABLE_C_LOOP.
#
# Upstream bugs: https://bugs.webkit.org/show_bug.cgi?id=191258
#                https://bugs.webkit.org/show_bug.cgi?id=172765
#                https://bugs.webkit.org/show_bug.cgi?id=265218
#
ifeq ($(BR2_ARM_CPU_ARMV5)$(BR2_ARM_CPU_ARMV6)$(BR2_MIPS_CPU_MIPS32R6)$(BR2_MIPS_CPU_MIPS64R6),y)
WEBKITGTK_CONF_OPTS += -DENABLE_JIT=OFF -DENABLE_C_LOOP=ON \
	-DENABLE_SAMPLING_PROFILER=OFF \
	-DENABLE_WEBASSEMBLY=OFF
endif

$(eval $(cmake-package))

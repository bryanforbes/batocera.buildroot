################################################################################
#
# flatbuffers
#
################################################################################

FLATBUFFERS_VERSION = 24.3.25
FLATBUFFERS_SITE = $(call github,google,flatbuffers,v$(FLATBUFFERS_VERSION))
FLATBUFFERS_LICENSE = Apache-2.0
FLATBUFFERS_LICENSE_FILES = LICENSE
FLATBUFFERS_CPE_ID_VENDOR = google
FLATBUFFERS_INSTALL_STAGING = YES
FLATBUFFERS_DEPENDENCIES = host-flatbuffers

# batocera
# Added: -DFLATBUFFERS_INSTALL=ON
FLATBUFFERS_CONF_OPTS += \
	-DCMAKE_CXX_FLAGS="-std=c++11" \
	-DCMAKE_POSITION_INDEPENDENT_CODE=ON \
	-DFLATBUFFERS_BUILD_TESTS=OFF \
	-DFLATBUFFERS_INSTALL=ON \
	-DFLATBUFFERS_FLATC_EXECUTABLE=$(HOST_DIR)/bin/flatc

ifeq ($(BR2_STATIC_LIBS),y)
FLATBUFFERS_CONF_OPTS += -DFLATBUFFERS_BUILD_SHAREDLIB=OFF
else
FLATBUFFERS_CONF_OPTS += -DFLATBUFFERS_BUILD_SHAREDLIB=ON
endif

# batocera
# Added: -DFLATBUFFERS_INSTALL=ON
HOST_FLATBUFFERS_CONF_OPTS += \
	-DCMAKE_CXX_FLAGS="-std=c++11" \
	-DFLATBUFFERS_BUILD_FLATLIB=OFF \
	-DFLATBUFFERS_BUILD_FLATC=ON \
	-DFLATBUFFERS_BUILD_FLATHASH=OFF \
	-DFLATBUFFERS_BUILD_GRPCTEST=OFF \
	-DFLATBUFFERS_BUILD_SHAREDLIB=OFF \
	-DFLATBUFFERS_INSTALL=ON \
	-DFLATBUFFERS_BUILD_TESTS=OFF

$(eval $(cmake-package))
$(eval $(host-cmake-package))

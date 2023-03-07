SUMMARY = "This is a python module for monitoring memory consumption of a \
process as well as line-by-line analysis of memory consumption for python programs"
HOMEPAGE = "https://github.com/practichem/arista-protocolbridge.git"
LICENSE = "CLOSED"

RDEPENDS_${PN} = "python3-pyserial python3-tornado"

LIC_FILES_CHKSUM = "file://README.md;md5=d3d754f8e1f07a15e65da588118bf793"

SRC_URI = "git://git@github.com/practichem/arista-protocolbridge.git;protocol=ssh;branch=develop_setup"

SRCREV = "e5a444ea3896b9e0a20845e9861072e18201e8d1"
S = "${WORKDIR}/git/packages/practichem_device"

PV = "git${SRCPV}"

inherit setuptools3

# DEPENDS = "python3"

# export STAGING_INCDIR
# export STAGING_LIBDIR
# export BUILD_SYS
# export HOST_SYS

# do_compile_prepend () {
# do_compile() {
#     export IS_YOCTO="1"
#     # cd ${S}/packages/practichem_device && python3 setup.py build
#     for var in ${S}/packages/*/; do
#         cd $var && python3 setup.py build
#     done
# }

# do_install_prepend () {
#     export IS_YOCTO="1"
    
#     for var in ${S}/packages/*/; do
#         echo $STAGING_DIR_TARGET¶
#         distutils_do_install
#         # cd $var && python3 setup.py install
#     done
# }

BBCLASSEXTEND = "native nativesdk"
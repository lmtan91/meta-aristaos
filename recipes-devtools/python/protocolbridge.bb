SUMMARY = "This is a python module for monitoring memory consumption of a \
process as well as line-by-line analysis of memory consumption for python programs"
HOMEPAGE = "https://github.com/practichem/arista-protocolbridge.git"
LICENSE = "CLOSED"

RDEPENDS_${PN} = "python-pyserial"

LIC_FILES_CHKSUM = "file://README.md;md5=d3d754f8e1f07a15e65da588118bf793"

SRC_URI = "git://git@github.com/practichem/arista-protocolbridge.git;protocol=ssh;branch=develop_setup"

SRCREV = "e5a444ea3896b9e0a20845e9861072e18201e8d1"
S = "${WORKDIR}/git"

PV = "git${SRCPV}"

inherit setuptools

do_configure[noexec] = "1"

do_compile_prepend () {
    export IS_YOCTO="1"
}

do_install_prepend () {
    export IS_YOCTO="1"
}


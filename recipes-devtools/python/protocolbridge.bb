SUMMARY = "This is a python module for monitoring memory consumption of a \
process as well as line-by-line analysis of memory consumption for python programs"
HOMEPAGE = "https://github.com/practichem/arista-protocolbridge.git"
LICENSE = "CLOSED"

LIC_FILES_CHKSUM = "file://README.md;md5=d3d754f8e1f07a15e65da588118bf793"

SRC_URI = "git://git@github.com/practichem/arista-protocolbridge.git;protocol=ssh;branch=develop_setup"

SRCREV = "e5a444ea3896b9e0a20845e9861072e18201e8d1"
S = "${WORKDIR}/git/"

PV = "git${SRCPV}"

do_install_prepend () {
    install -d -m 700 ${D}/home/root/arista
    cp -R ${S}/protocolbridge ${D}/home/root/arista
    cp -R ${S}/utilities ${D}/home/root/arista
}

BBCLASSEXTEND = "native nativesdk"

FILES_${PN} += "/home/root/*"
FILES_${PN}-dev = "/home/root/*"
ALLOW_EMPTY_${PN}="1"
SUMMARY = "This is a python module for monitoring memory consumption of a \
process as well as line-by-line analysis of memory consumption for python programs"
HOMEPAGE = "https://github.com/practichem/arista-protocolbridge.git"
LICENSE = "CLOSED"

LIC_FILES_CHKSUM = "file://README.md;md5=d3d754f8e1f07a15e65da588118bf793"

inherit systemd

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE_${PN} = "protocolbridge.service"

FILES_${PN} += "${systemd_unitdir}/system/protocolbridge.service"


SRC_URI = "git://git@github.com/practichem/arista-protocolbridge.git;protocol=ssh;branch=develop_setup \
           file://protocolbridge.service \
           file://protocolbridge.sh"

SRCREV = "e5a444ea3896b9e0a20845e9861072e18201e8d1"
S = "${WORKDIR}/git/"

PV = "git${SRCPV}"

do_install() {
    install -d ${D}/${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/protocolbridge.service ${D}/${systemd_unitdir}/system

    install -d -m 700 ${D}/home/arista/
    install -m 755 ${WORKDIR}/protocolbridge.sh ${D}/home/arista/
    cp -r ${S}/protocolbridge ${D}/home/arista
    cp -r ${S}/utilities ${D}/home/arista
}

FILES_${PN} += "/home/arista/*"
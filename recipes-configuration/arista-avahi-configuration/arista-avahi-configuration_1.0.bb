DESCRIPTION = "Avahi service file for Arista webserver"
SECTION = "arista-avahi-configuration"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Proprietary;md5=0557f9d92cf58f2ccdd50f62f8ac0b28"
PR = "r0"

SRC_URI = "file://arista-server.service"

S = "${WORKDIR}"
AVAHI_SERVICES_DIR = "/etc/avahi/services/"
PERMISSIONS = "u=rw,go=r,a-s"

do_compile() {
}

do_install() {
	install -d ${D}${AVAHI_SERVICES_DIR}
	install -m ${PERMISSIONS} arista-server.service ${D}${AVAHI_SERVICES_DIR}
}

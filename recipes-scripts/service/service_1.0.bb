DESCRIPTION = "Simplified service script to call scripts in init.d"
SECTION = "service"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Proprietary;md5=0557f9d92cf58f2ccdd50f62f8ac0b28"
PR = "r0"

SRC_URI = "file://service"

S = "${WORKDIR}"

do_compile() {
}

do_install() {
	     install -d ${D}${bindir}
	     install -m 0755 service ${D}${bindir}
}

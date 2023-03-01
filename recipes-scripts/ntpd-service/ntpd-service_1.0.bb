DESCRIPTION = "Simplified service script to call scripts in init.d"
SECTION = "service"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Proprietary;md5=0557f9d92cf58f2ccdd50f62f8ac0b28"
PR = "r0"

SRC_URI = "\
        file://ntp.conf \
        file://ntpd \
"

S = "${WORKDIR}"

inherit update-rc.d
INITSCRIPT_NAME = "ntpd"
INITSCRIPT_PARAMS = "defaults 20"
do_compile() {
}

do_install() {
	install -d ${D}/etc
	install ntp.conf ${D}/etc/
        install -d ${D}/etc/init.d
	install -m 0755 ntpd ${D}/etc/init.d
}

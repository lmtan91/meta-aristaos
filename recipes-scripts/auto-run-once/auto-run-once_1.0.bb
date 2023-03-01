DESCRIPTION = "Simplified service script to call scripts in init.d"
SECTION = "service"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Proprietary;md5=0557f9d92cf58f2ccdd50f62f8ac0b28"
PR = "r0"

SRC_URI = "file://auto-run-once"

inherit update-rc.d

S = "${WORKDIR}"

do_compile() {
}

do_install() {
	     install -d ${D}/etc/init.d
	     install -m 0755 auto-run-once ${D}/etc/init.d/
             install -d ${D}/var/log/run-once
}

INITSCRIPT_NAME = "auto-run-once"

DESCRIPTION = "First-time-install script for Arista instruments."
SECTION = "arista-first-time-install"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Proprietary;md5=0557f9d92cf58f2ccdd50f62f8ac0b28"
PR = "r0"

DEPENDS = "auto-run-once postgresql"

SRC_URI = " \
	file://run-once.sh \
	file://CarrierBoard.bin \
"

FILES_${PN} = " \
	/run-once.sh \
	/install/CarrierBoard.bin \
"

do_compile() {
}

do_install() {
	install -m 0755 ${WORKDIR}/run-once.sh ${D}/run-once.sh
	install -d ${D}/install
	install -m 0755 ${WORKDIR}/CarrierBoard.bin ${D}/install/CarrierBoard.bin
}

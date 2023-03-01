DESCRIPTION = "Load bootscripts into rootfs."
SECTION = "bootscripts"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Proprietary;md5=0557f9d92cf58f2ccdd50f62f8ac0b28"
PR = "r1"

SRC_URI = " \
	file://*.scr \
"
FILES_${PN} = " \
	/boot/*.scr \
	/boot.scr \
"

S = "${WORKDIR}"

do_compile() {
}

do_install() {
	install -d ${D}/boot
	for bootscript in ${S}/*.scr; do
		install -m 0755 ${bootscript} ${D}/boot/
	done
	ln -sf /boot/boot_3.14-FromInternalMemory.scr ${D}/boot.scr
}


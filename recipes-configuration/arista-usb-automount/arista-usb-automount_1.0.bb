DESCRIPTION = "Arista scripts to automount usb devices and run a signed script"
SECTION = "arista-usb-automount"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Proprietary;md5=0557f9d92cf58f2ccdd50f62f8ac0b28"
PR = "r1"

SRC_URI = "file://usbmount \
	file://check-signature-and-run \
	file://90-usb-storage.rules"
	
FILES-${PN} = "${bindir}/usbmount \
	${bindir}/check-signature-and-run \
	/etc/udev/rules.d/90-usb-storage.rules"
	
S = "${WORKDIR}"
PERMISSIONS = "u=rw,go=r,a-s"
PERMISSIONS_SCRIPT = "u=rwx,go=rx,a-s"

do_compile() {
}

do_install() {
	install -d ${D}
	install -d ${D}${bindir}
	install -d ${D}/etc/udev/rules.d
	install -m ${PERMISSIONS_SCRIPT} usbmount ${D}${bindir}/
	install -m ${PERMISSIONS_SCRIPT} check-signature-and-run ${D}${bindir}/
	install -m ${PERMISSIONS} 90-usb-storage.rules  ${D}/etc/udev/rules.d/
}

RDEPENDS-${PN} = "bash"

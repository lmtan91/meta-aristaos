DESCRIPTION = "Copy the pip3 installer script to the target system."
SECTION = "python-pip3"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Proprietary;md5=0557f9d92cf58f2ccdd50f62f8ac0b28"
PR = "r0"

SRC_URI = "\
        file://get-pip.py \
"

S = "${WORKDIR}"

FILES_${PN} = "/install/get-pip.py"

do_compile() {
}

do_install() {
	     install -d ${D}/install/
	     install get-pip.py ${D}/install/
}

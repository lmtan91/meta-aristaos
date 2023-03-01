FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PV = "8"
PV_UPDATE = "65"
PR := "u${PV_UPDATE}"

SRC_URI := "http://download.oracle.com/otn/java/ejdk/${PV}${PR}-b17/ejdk-${PV}${PR}-linux-armv6-vfp-hflt.tar.gz"

SRC_URI[md5sum] = "792fcc3fd74a8d5fea738cd9d1f72ac7"
SRC_URI[sha256sum] = "3e81264cd6e9e6e7536922aa32dca88d06f7f22cab209ab98b79b4ade2ec8465"

SRC_URI += "file://UnlimitedJCEPolicyJDK7.zip"

LIC_FILES_CHKSUM = "\
       file://ejdk1.${PV}.0_${PV_UPDATE}/linux_armv6_vfp_hflt/jre/COPYRIGHT;md5=51f72c3c2569e1174a83a294f7c082d6 \
       file://ejdk1.${PV}.0_${PV_UPDATE}/linux_armv6_vfp_hflt/jre/THIRDPARTYLICENSEREADME.txt;md5=745d6db5fc58c63f74ce6a7d4db7e695 \
       "

JAVA_DEST_DIR := "${JDK_JRE}${PV}_${PV_UPDATE}"
JAVA_DEST_PATH := "${datadir}/${JAVA_DEST_DIR}/"

JRE_SRC_PATH := "${S}/ejdk1.${PV}.0_${PV_UPDATE}/linux_armv6_vfp_hflt/jre/"

do_install () {
        install -d -m 0755                              ${D}${JAVA_DEST_PATH}
        cp -a ${JRE_SRC_PATH}*              		${D}${JAVA_DEST_PATH}/
        install -d -m 0755                              ${D}${bindir}
	ln -sf ${JAVA_DEST_PATH}bin/java 		${D}${bindir}/java

        install -d ${D}/usr/bin
        ln -snf ${JAVA_DEST_PATH}bin/java ${D}/usr/bin/java
        ln -snf ${JAVA_DEST_PATH}bin/keytool ${D}/usr/bin/keytool
        install -d ${D}${JAVA_DEST_PATH}/lib/security/
        install -m 0644 ${WORKDIR}/UnlimitedJCEPolicy/local_policy.jar ${D}${JAVA_DEST_PATH}lib/security/local_policy.jar
        install -m 0644 ${WORKDIR}/UnlimitedJCEPolicy/US_export_policy.jar ${D}${JAVA_DEST_PATH}lib/security/US_export_policy.jar
}


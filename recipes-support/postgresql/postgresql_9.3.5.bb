require postgresql.inc

LIC_FILES_CHKSUM = "file://COPYRIGHT;md5=bd3639437be30f1dbcc0a8d826fb3aea"

PR = "${INC_PR}.0"

SRC_URI += "\
    file://remove.autoconf.version.check.patch \
    file://0001-Use-pkg-config-for-libxml2-detection.patch \
"

SRC_URI[md5sum] = "5059857c7d7e6ad83b6d55893a121b59"
SRC_URI[sha256sum] = "14176ffb1f90a189e7626214365be08ea2bfc26f26994bafb4235be314b9b4b0"

SUMMARY = "Arista OS."

IMAGE_INSTALL = "packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image

IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"

IMAGE_INSTALL_append = " openjdk-8 nano nginx arista-avahi-configuration arista-usb-automount postgresql \
		arista-first-time-install auto-run-once python-pip-installer init-ifupdown "

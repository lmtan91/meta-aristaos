SUMMARY = "Arista OS."

IMAGE_INSTALL = "packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image

IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"

IMAGE_INSTALL_append = " openjdk-8 nano nginx arista-avahi-configuration arista-usb-automount postgresql \
		junction2 python-pip-installer init-ifupdown ntpd-service lsb-release practichem-device python3 python3-pip \
		as-ph-sensor atmelfirmwareflasher gilson-fc203b-collector practichem-biodetector practichem-carrier-board \
		practichem-collector practichem-conformance-test-database practichem-fc203b practichem-gradient-former \
		practichem-ph-sensor practichem-pump practichem-rotary-valve practichem-utility-board protocolbridge "

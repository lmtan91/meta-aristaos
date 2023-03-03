FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

LICENSE = "CLOSED"
inherit systemd

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE_${PN} = "junction2.service"

FILES_${PN} += "${systemd_unitdir}/system/junction2.service"

SRC_URI = " \
	file://junction2.service \
	file://application-overrides-slice.yaml \
	file://arista-server.jar;unpack=0 \
"

do_install_append() {
  install -d ${D}/${systemd_unitdir}/system
  install -m 0644 ${WORKDIR}/junction2.service ${D}/${systemd_unitdir}/system

  install -d -m 700 ${D}/${sysconfdir}/arista
  install -m 0644 ${WORKDIR}/application-overrides-slice.yaml ${D}/${sysconfdir}/arista

  install -d -m 700 ${D}/var/www/arista
  install -m 0644 ${WORKDIR}/arista-server.jar ${D}/var/www/arista
}

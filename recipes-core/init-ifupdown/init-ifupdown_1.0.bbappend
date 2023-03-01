FILESEXTRAPATHS_prepend := "${THISDIR}/init-ifupdown-1.0:"

SRC_URI += "file://interfaces.new \
            file://100-display-ip \
            file://100-display-disconnected"

do_install_append () {
	install -m 0755 ${WORKDIR}/interfaces.new ${D}${sysconfdir}/network/interfaces
	install -m 0755 ${WORKDIR}/100-display-ip ${D}${sysconfdir}/network/if-up.d/100-display-ip
	install -m 0755 ${WORKDIR}/100-display-disconnected ${D}${sysconfdir}/network/if-post-down.d/100-display-disconnected
}

CONFFILES_${PN} += "${sysconfdir}/network/interfaces \
                    ${sysconfdir}/network/if-up.d/100-display-ip \
                    ${sysconfdir}/network/if-post-down.d/100-display-disconnected"

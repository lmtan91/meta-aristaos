FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += " \
        file://nginx.conf.new \
"

do_install_append () {
	install -m 0644 ${WORKDIR}/nginx.conf.new ${D}${sysconfdir}/nginx/nginx.conf
	sed -i 's,/var/,${localstatedir}/,g' ${D}${sysconfdir}/nginx/nginx.conf
}

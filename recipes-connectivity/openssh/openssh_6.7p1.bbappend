do_install_append () {
	sed -i -e 's/#UseDNS yes/UseDNS no/' ${WORKDIR}/sshd_config ${D}${sysconfdir}/ssh/sshd_config
}

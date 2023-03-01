do_configure_append() {
	sed -i -e "s:l root root 0755 /var/log /var/volatile/log:d root root 0755 /var/log none:" ${WORKDIR}/volatiles
}

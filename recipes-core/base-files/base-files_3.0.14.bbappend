volatiles := "${@bb.data.getVar('volatiles',d,1).replace('log', '')}"
dirs755 += "${localstatedir}/log"

do_install_prepend () {
	echo ${volatiles} > ~/base-files
	echo ${dirs755} >> ~/base-files
	rm -rf ${D}${localstatedir}/log
}

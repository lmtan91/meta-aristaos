SUMMARY = "A console-only image that fully supports the target device \
hardware."

LICENSE = "MIT"

require recipes-core/images/core-image-base.bb

ROOTFS_POSTPROCESS_COMMAND += " \
        set_root_passwd; \
        disable_apache; \
"

set_root_passwd() {
	echo Setting root password...;
        PASSWORD_HASH=$(perl -e 'print crypt('"${ROOT_PASSWORD}"', "\$6\$u.GLH/FeMvB\$")');
        sed 's%^root:[^:]*:%root:'${PASSWORD_HASH}':%' \
		< ${IMAGE_ROOTFS}/etc/shadow \
		> ${IMAGE_ROOTFS}/etc/shadow.new;
	mv ${IMAGE_ROOTFS}/etc/shadow.new ${IMAGE_ROOTFS}/etc/shadow ;
}

disable_apache() {
	echo Disabling apache...;
        rm -f ${IMAGE_ROOTFS}/etc/init.d/apache2;
}


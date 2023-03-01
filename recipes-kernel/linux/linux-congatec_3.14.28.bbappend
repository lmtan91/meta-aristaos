FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0005-Revert-net-fec-fix-the-warning-found-by-dma-debug.patch"

# update the source revision ARISTA-596
SRCREV = "f312f6d40b9a3081f41aab6640cd6ab108e1f0c3"
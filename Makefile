all : drivers/PenTabletDriver-5.3.7-6.patched

drivers/PenTabletDriver-5.3.7-6.patched : drivers/PenTabletDriver-5.3.7-6.original drivers/PenTabletDriver-5.3.7-6.patch
	cp drivers/PenTabletDriver-5.3.7-6.original drivers/PenTabletDriver-5.3.7-6.patched
	patch drivers/PenTabletDriver-5.3.7-6.patched < drivers/PenTabletDriver-5.3.7-6.patch

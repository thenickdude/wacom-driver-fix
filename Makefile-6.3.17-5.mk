# We just use this driver to provide a signable version of Wacom Desktop Center (SDK version acceptable for notarization)

EXTRACTED_DRIVERS_6_3_17_5= \
	src/6.3.17-5/Wacom\ Desktop\ Center.app

EXTRACTED_DRIVERS+= $(EXTRACTED_DRIVERS_6_3_17_5)

CREATE_DIRECTORIES+= src/6.3.17-5/

# Download, mount and unpack original Wacom installers:

src/6.3.17-5/pentablet_6.3.17-5.dmg :
	curl -o $@ "https://cdn.wacom.com/u/productsupport/drivers/mac/professional/WacomTablet_6.3.17-5.dmg"
	[ $$(md5 $@ | awk '{ print $$4 }') = "42dafc4250df4649f1a122578425bbad" ] || (rm $@; false) # Verify download is undamaged

src/6.3.17-5/Install\ Wacom\ Tablet.pkg : src/6.3.17-5/pentablet_6.3.17-5.dmg
	hdiutil attach -quiet -nobrowse -mountpoint src/6.3.17-5/dmg "$<"
	cp "src/6.3.17-5/dmg/Install Wacom Tablet.pkg" "$@"
	hdiutil detach -force src/6.3.17-5/dmg

# Extract original files from the Wacom installers as needed:

$(EXTRACTED_DRIVERS_6_3_17_5) : src/6.3.17-5/Install\ Wacom\ Tablet.pkg
	$(call unpack_package,"$<")

	cp -a package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app src/6.3.17-5/

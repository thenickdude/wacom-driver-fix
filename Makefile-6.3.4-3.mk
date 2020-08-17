# This is the first Pro series driver to have a 64-bit Wacom Utility

EXTRACTED_DRIVERS_6_3_4_3= \
	src/6.3.4.3/Wacom\ Tablet\ Utility.app

EXTRACTED_DRIVERS+= $(EXTRACTED_DRIVERS_6_3_4_3)

CREATE_DIRECTORIES+= src/6.3.4-3/

# Download, mount and unpack original Wacom installers:

src/6.3.4-3/WacomTablet_6.3.4-3.dmg :
	curl -o $@ "https://cdn.wacom.com/U/Drivers/Mac/pro/WacomTablet_6.3.4-3.dmg"
	[ $$(md5 $@ | awk '{ print $$4 }') = "94afb34410d4b828dac6cedff07cf986" ] || (rm $@; false) # Verify download is undamaged

src/6.3.4-3/Install\ Wacom\ Tablet.pkg : src/6.3.4-3/WacomTablet_6.3.4-3.dmg
	hdiutil attach -quiet -nobrowse -mountpoint src/6.3.4-3/dmg "$<"
	rm -rf "$@"
	cp -a "src/6.3.4-3/dmg/Install Wacom Tablet.pkg" "$@"
	# The permissions on the package files are super awkward, make those more permissive for us:
	find "src/6.3.4-3/Install Wacom Tablet.pkg" -type d -exec chmod 0755 {} \;
	find "src/6.3.4-3/Install Wacom Tablet.pkg" -type f -exec chmod u+rw {} \;
	hdiutil detach -force src/6.3.4-3/dmg
	touch "$@"

# Extract original files from the Wacom installers as needed:

$(EXTRACTED_DRIVERS_6_3_4_3) : src/6.3.4-3/Install\ Wacom\ Tablet.pkg
	rm -rf src/6.3.4-3/Install\ Wacom\ Tablet.pkg/Contents/Archive
	mkdir -p src/6.3.4-3/Install\ Wacom\ Tablet.pkg/Contents/Archive
	cd src/6.3.4-3/Install\ Wacom\ Tablet.pkg/Contents/Archive && tar --no-same-owner -xf ../Archive.pax.gz
	cp -a src/6.3.4-3/Install\ Wacom\ Tablet.pkg/Contents/Archive/Applications/Wacom\ Tablet.localized/Wacom\ Tablet\ Utility.app src/6.3.4-3/

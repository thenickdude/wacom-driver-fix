# Contains a signed Wacom Tablet.kext 6.3.7 which has been blessed by Catalina's built-in AppleKextExcludeList:
# 
# /Library/Apple/System/Library/Extensions/AppleKextExcludeList.kext/Contents/Resources/ExceptionLists.plist
#
# It's functionally identical to the Wacom Tablet.kext in virtually all 6 series drivers
# 
# (it's just a codeless kext that marks Wacom devices as tablets)
#
# The other kext version that has such a blessing is 6.3.30

EXTRACTED_DRIVERS_6_3_7_1= \
	src/6.3.7-1/Wacom\ Tablet.kext

EXTRACTED_DRIVERS+= $(EXTRACTED_DRIVERS_6_3_7_1)

CREATE_DIRECTORIES+= src/6.3.7-1/

# Download, mount and unpack original Wacom installers:

src/6.3.7-1/WacomTablet_6.3.7-1.dmg :
	curl -o $@ "https://cdn.wacom.com/U/Drivers/Mac/pro/WacomTablet_6.3.7-1.dmg"
	[ $$(md5 $@ | awk '{ print $$4 }') = "0d6a2f2a397bfc3919b38ddcb5f0d304" ] || (rm $@; false) # Verify download is undamaged

src/6.3.7-1/Install\ Wacom\ Tablet.pkg : src/6.3.7-1/WacomTablet_6.3.7-1.dmg
	hdiutil attach -quiet -nobrowse -mountpoint src/6.3.7-1/dmg "$<"
	rm -rf "$@"
	cp -a "src/6.3.7-1/dmg/Install Wacom Tablet.pkg" "$@"
	# The permissions on the package files are super awkward, make those more permissive for us:
	find "src/6.3.7-1/Install Wacom Tablet.pkg" -type d -exec chmod 0755 {} \;
	find "src/6.3.7-1/Install Wacom Tablet.pkg" -type f -exec chmod u+rw {} \;
	hdiutil detach -force src/6.3.7-1/dmg
	touch "$@"

# Extract original files from the Wacom installers as needed:

$(EXTRACTED_DRIVERS_6_3_7_1) : src/6.3.7-1/Install\ Wacom\ Tablet.pkg
	rm -rf src/6.3.7-1/Install\ Wacom\ Tablet.pkg/Contents/Archive
	mkdir -p src/6.3.7-1/Install\ Wacom\ Tablet.pkg/Contents/Archive
	cd src/6.3.7-1/Install\ Wacom\ Tablet.pkg/Contents/Archive && tar --no-same-owner -xf ../Archive.pax.gz
	cp -a src/6.3.7-1/Install\ Wacom\ Tablet.pkg/Contents/Archive/System/Library/Extensions/Wacom\ Tablet.kext src/6.3.7-1/

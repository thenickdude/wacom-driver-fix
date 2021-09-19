EXTRACTED_DRIVERS_6_3_15_3= \
	src/6.3.15-3/WacomTablet.original \
	src/6.3.15-3/preinstall.original \
	src/6.3.15-3/postinstall.original \
	src/6.3.15-3/WacomTabletDriver.original \
	src/6.3.15-3/Distribution.original \
	src/6.3.15-3/uninstall.pl.original \
	src/6.3.15-3/com.wacom.wacomtablet.plist.original

PATCHED_DRIVERS_6_3_15_3= \
	src/6.3.15-3/WacomTablet.patched \
	src/6.3.15-3/preinstall.patched \
	src/6.3.15-3/postinstall.patched \
	src/6.3.15-3/WacomTabletDriver.patched \
	src/6.3.15-3/Distribution.patched \
	src/6.3.15-3/uninstall.pl.patched \
	src/6.3.15-3/com.wacom.wacomtablet.plist.patched

EXTRACTED_DRIVERS+= $(EXTRACTED_DRIVERS_6_3_15_3)

PATCHED_DRIVERS+= $(PATCHED_DRIVERS_6_3_15_3)

SIGN_ME_6_3_15_3= \
	package/content.pkg/Payload/Library/PreferencePanes/WacomTablet.prefpane \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletSpringboard.app \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletDriver.app/Contents/Resources/TabletDriver.app/Contents/MacOS/TabletDriver \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletDriver.app/Contents/Resources/WacomTouchDriver.app/Contents/MacOS/WacomTouchDriver \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletDriver.app \
	package/content.pkg/Payload/Library/Internet\ Plug-Ins/WacomTabletPlugin.plugin/Contents/MacOS/WacomTabletPlugin \
	package/content.pkg/Payload/Library/Frameworks/WacomMultiTouch.framework \
	package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Display\ Settings.app \
	package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Tablet\ Utility.app/Contents/Library/LaunchServices/com.wacom.RemoveTabletHelper \
	package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Tablet\ Utility.app/Contents/Resources/SystemLoginItemTool \
	package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Tablet\ Utility.app \
	package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app/Contents/Frameworks/WacomCloudSDK.framework \
	package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app/Contents/Resources/adb \
	package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app \
	package/content.pkg/Scripts/renumtablets

UNSIGNED_INSTALLERS+= Install\ Wacom\ Tablet-6.3.15-3-patched-unsigned.pkg
SIGNED_INSTALLERS+= Install\ Wacom\ Tablet-6.3.15-3-patched.pkg

# Create the installer package by modifying Wacom's original:

Install\ Wacom\ Tablet-6.3.15-3-patched-unsigned.pkg : src/6.3.15-3/Install\ Wacom\ Tablet.pkg $(PATCHED_DRIVERS_6_3_15_3) src/6.3.15-3/Welcome.rtf src/TCCReset6.pkg src/6.3.15-3/WacomTabletSpringboard.Info.plist src/6.3.17-5/Wacom\ Desktop\ Center.app
	$(call unpack_package,"src/6.3.15-3/Install Wacom Tablet.pkg")

	# Add Welcome screen
	find package/Resources -type d -depth 1 -exec cp src/6.3.15-3/Welcome.rtf {}/ \;
	
	# Add new distribution metadata for welcome screen and TCC
	cp src/6.3.15-3/Distribution.patched package/Distribution
	
	# Add payload-less package for optionally resetting TCC permissions during install
	cp -a src/TCCReset6.pkg package/

	# Add patched preference pane
	cp src/6.3.15-3/WacomTablet.patched package/content.pkg/Payload/Library/PreferencePanes/WacomTablet.prefpane/Contents/MacOS/WacomTablet

	# Remove Android File Transfer app since it's thoroughly obsolete and difficult to sign (why is this even being redistributed?)
	rm package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/aft.tar

	# Remove unsigned kext that macOS will never load (and we can't possibly sign it). Doesn't seem needed for modern tablets anyway.
	rm -rf package/content.pkg/Payload/Library/Extensions/SiLabsUSBDriver64.kext

	# Replace Wacom Desktop Center with newer version built against SDK 10.11 (the original one built against SDK 10.8 cannot be notarized due to the SDK version)
	rm -rf package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app
	cp -a src/6.3.17-5/Wacom\ Desktop\ Center.app package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/

	# Fix WacomCloudSDK.framework has ended up with its symlinks expanded into duplicate files (which prevents codesigning)
	rm -rf \
		package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app/Contents/Frameworks/WacomCloudSDK.framework/Versions/Current \
		package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app/Contents/Frameworks/WacomCloudSDK.framework/Headers \
		package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app/Contents/Frameworks/WacomCloudSDK.framework/Resources \
		package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app/Contents/Frameworks/WacomCloudSDK.framework/WacomCloudSDK
	ln -s "A"                              package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app/Contents/Frameworks/WacomCloudSDK.framework/Versions/Current
	ln -s "Versions/Current/Headers"       package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app/Contents/Frameworks/WacomCloudSDK.framework/Headers
	ln -s "Versions/Current/Resources"     package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app/Contents/Frameworks/WacomCloudSDK.framework/Resources
	ln -s "Versions/Current/WacomCloudSDK" package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app/Contents/Frameworks/WacomCloudSDK.framework/WacomCloudSDK

	# Add patched driver
	cp src/6.3.15-3/WacomTabletDriver.patched package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletDriver.app/Contents/MacOS/WacomTabletDriver

	# WacomTabletDriver loads WacomMultiTouch.framework using @rpath, which isn't allowed by the hardened runtime.
	# Change it to use an absolute path instead
	install_name_tool -change \
		"@rpath/WacomMultiTouch.framework/Versions/A/WacomMultiTouch" \
		"/Library/Frameworks/WacomMultiTouch.framework/Versions/A/WacomMultiTouch" \
		"package/content.pkg/Payload/Library/Application Support/Tablet/WacomTabletDriver.app/Contents/MacOS/WacomTabletDriver"

	# Fix postinstall script - it expects WacomMultiTouch.framework to be in /tmp/WacomMultiTouch.framework during installation,
	# and that surely never happens (aren't installer files staged in /var/folders/xx first?).
	#
	# Looks like this was leftover from some older installer structure. Remove that stuff.
	cp src/6.3.15-3/postinstall.patched package/content.pkg/Scripts/postinstall
	
	# Wrap the WacomTabletSpringboard executable up into an app bundle, so we can refer to it by bundle ID in tccutil
	mkdir -p package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletSpringboard.app/Contents/MacOS
	mv package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletSpringboard package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletSpringboard.app/Contents/MacOS/
	cp src/6.3.15-3/WacomTabletSpringboard.Info.plist package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletSpringboard.app/Contents/Info.plist

	# Update the LaunchAgent to refer to the new location for WacomTabletSpringboard
	cp src/6.3.15-3/com.wacom.wacomtablet.plist.patched package/content.pkg/Payload/Library/LaunchAgents/com.wacom.wacomtablet.plist

	# Add un/loadagent support
	cp src/6.3.15-3/preinstall.patched package/content.pkg/Scripts/preinstall
	cp src/6.3.15-3/unloadagent src/6.3.15-3/loadagent package/content.pkg/Scripts/

	# Patch the uninstaller to remove the new location of WacomTabletSpringboard
	cp src/6.3.15-3/uninstall.pl.patched package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Tablet\ Utility.app/Contents/Resources/uninstall.pl

ifdef CODE_SIGNING_IDENTITY
	# Resign drivers and enable Hardened Runtime to meet notarization requirements
	codesign -s "$(CODE_SIGNING_IDENTITY)" -f --options=runtime --timestamp $(SIGN_ME_6_3_15_3)
else
	codesign --remove-signature $(SIGN_ME_6_3_15_3)
endif

	# Recreate BOM
	mkbom package/content.pkg/Payload package/content.pkg/Bom

	# Repack payload
	( cd package/content.pkg/Payload && find . ! -path "./Library/Extensions*" ! -path "./Library/Frameworks*" | cpio -o --format odc --owner 0:80 ) > .tmp-payload

	# Have to remove the cpio trailer from the end of the first archive (to allow the second archive to be appended)
	# - it'd be nice if macOS' cpio supported --append instead
	( \
		head -c $$(LC_CTYPE=C grep --byte-offset --only-matching --text -F '0707070000000000000000000000000000000000010000000000000000000001300000000000TRAILER!!!' .tmp-payload | cut -f1 -d: ) .tmp-payload ; \
		( cd package/content.pkg/Payload && find ./Library/Extensions ./Library/Frameworks | cpio -o --format odc --owner 0:0 ) ; \
	) | gzip -c > package/content.pkg/Payload.gz
	rm .tmp-payload
	rm -rf package/content.pkg/Payload
	mv package/content.pkg/Payload.gz package/content.pkg/Payload

	# Repack installer
	pkgutil --flatten package "$@"

ifdef PACKAGE_SIGNING_IDENTITY
Install\ Wacom\ Tablet-6.3.15-3-patched.pkg : Install\ Wacom\ Tablet-6.3.15-3-patched-unsigned.pkg
	productsign --sign "$(PACKAGE_SIGNING_IDENTITY)" Install\ Wacom\ Tablet-6.3.15-3-patched-unsigned.pkg Install\ Wacom\ Tablet-6.3.15-3-patched.pkg
endif

# Download, mount and unpack original Wacom installers:

src/6.3.15-3/pentablet_6.3.15-3.dmg :
	curl -o $@ "https://cdn.wacom.com/u/productsupport/drivers/mac/professional/WacomTablet_6.3.15-3.dmg"
	[ $$(md5 $@ | awk '{ print $$4 }') = "b16906fea82d7375b3e8edee973663f5" ] || (rm $@; false) # Verify download is undamaged

src/6.3.15-3/Install\ Wacom\ Tablet.pkg : src/6.3.15-3/pentablet_6.3.15-3.dmg
	hdiutil attach -quiet -nobrowse -mountpoint src/6.3.15-3/dmg "$<"
	cp "src/6.3.15-3/dmg/Install Wacom Tablet.pkg" "$@"
	hdiutil detach -force src/6.3.15-3/dmg

# Extract original files from the Wacom installers as needed

$(EXTRACTED_DRIVERS_6_3_15_3) : src/6.3.15-3/Install\ Wacom\ Tablet.pkg
	$(call unpack_package,"$<")

	cp package/content.pkg/Scripts/preinstall src/6.3.15-3/preinstall.original
	cp package/content.pkg/Scripts/postinstall src/6.3.15-3/postinstall.original
	cp package/content.pkg/Payload/Library/PreferencePanes/WacomTablet.prefpane/Contents/MacOS/WacomTablet src/6.3.15-3/WacomTablet.original
	cp package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletDriver.app/Contents/MacOS/WacomTabletDriver src/6.3.15-3/WacomTabletDriver.original
	cp package/Distribution src/6.3.15-3/Distribution.original
	cp package/content.pkg/Payload/Library/LaunchAgents/com.wacom.wacomtablet.plist src/6.3.15-3/com.wacom.wacomtablet.plist.original
	cp package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Tablet\ Utility.app/Contents/Resources/uninstall.pl src/6.3.15-3/uninstall.pl.original

# Utility commands:

notarize-intuos3: Install\ Wacom\ Tablet-6.3.15-3-patched.pkg
	xcrun altool \
		 --notarize-app \
		 --primary-bundle-id "com.wacom.pentablet" \
		 --username "$(NOTARIZATION_USERNAME)" \
		 --password "@keychain:AC_PASSWORD" \
		 --file "$<"
	cp "$<" "Install Wacom Tablet-6.3.15-3-patched-notarized.pkg"

staple-intuos3:
	xcrun stapler staple "Install Wacom Tablet-6.3.15-3-patched.pkg"
	cp "Install Wacom Tablet-6.3.15-3-patched.pkg" "Install Wacom Tablet-6.3.15-3-patched-stapled.pkg"

unpack-intuos3 : src/6.3.15-3/Install\ Wacom\ Tablet.pkg
	$(call unpack_package,"$<")

unbless-intuos3:
	xattr -w com.apple.quarantine "0181;5e33ca0a;Chrome;AEDC174C-8684-476E-9E4C-764D063A714C" Install\ Wacom\ Tablet-6.3.15-3-patched-unsigned.pkg

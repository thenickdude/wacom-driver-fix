EXTRACTED_DRIVERS_5_3_7_6= \
	src/5.3.7-6/PenTabletDriver.original \
	src/5.3.7-6/ConsumerTouchDriver.original \
	src/5.3.7-6/preinstall.original \
	src/5.3.7-6/postinstall.original \
	src/5.3.7-6/renumtablets \
	src/5.3.7-6/PackageInfo.original \
	src/5.3.7-6/Distribution.original \
	src/5.3.7-6/uninstall.pl.original \
	src/5.3.7-6/PenTablet.prefpane.original

PATCHED_DRIVERS_5_3_7_6= \
	src/5.3.7-6/PenTabletDriver.patched \
	src/5.3.7-6/ConsumerTouchDriver.patched \
	src/5.3.7-6/preinstall.patched \
	src/5.3.7-6/postinstall.patched \
	src/5.3.7-6/PackageInfo.patched \
	src/5.3.7-6/Distribution.patched \
	src/5.3.7-6/uninstall.pl.patched \
	src/5.3.7-6/PenTablet.prefpane.patched

EXTRACTED_DRIVERS+= $(EXTRACTED_DRIVERS_5_3_7_6)

PATCHED_DRIVERS+= $(PATCHED_DRIVERS_5_3_7_6)

SIGN_ME_5_3_7_6= \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/TabletDriver.app \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/ConsumerTouchDriver.app \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app \
	package/content.pkg/Payload/Library/PreferencePanes/PenTablet.prefpane/Contents/MacOS/PenTablet \
	package/content.pkg/Payload/Library/PreferencePanes/PenTablet.prefpane \
	package/content.pkg/Payload/Library/Frameworks/WacomMultiTouch.framework/Versions/A/WacomMultiTouch \
	package/content.pkg/Payload/Library/PrivilegedHelperTools/com.wacom.TabletHelper.app/Contents/MacOS/com.wacom.TabletHelper \
	package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app/Contents/Library/LaunchServices/com.wacom.RemoveTabletHelper \
	package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app/Contents/Resources/SystemLoginItemTool \
	package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app \
	package/content.pkg/Scripts/renumtablets

UNSIGNED_INSTALLERS+= Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg
SIGNED_INSTALLERS+= Install\ Wacom\ Tablet-5.3.7-6-patched.pkg

# Create the installer package by modifying Wacom's original:

Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg : src/5.3.7-6/Install\ Wacom\ Tablet.pkg $(PATCHED_DRIVERS_5_3_7_6) src/5.3.7-6/Welcome.rtf src/common-5/clearpermissions
	$(call unpack_package,"src/5.3.7-6/Install Wacom Tablet.pkg")

	# Add Welcome screen
	find package/Resources -type d -depth 1 -exec cp src/5.3.7-6/Welcome.rtf {}/ \;

	# Add patched drivers
	cp src/5.3.7-6/PenTabletDriver.patched package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/MacOS/PenTabletDriver
	cp src/5.3.7-6/ConsumerTouchDriver.patched package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app/Contents/MacOS/ConsumerTouchDriver

	# Add patched prefpane
	cp src/5.3.7-6/PenTablet.prefpane.patched package/content.pkg/Payload/Library/PreferencePanes/PenTablet.prefpane/Contents/MacOS/PenTablet

	# Tool for clearing leftover permissions from previous driver:
	cp src/5.3.7-6/postinstall.patched package/content.pkg/Scripts/postinstall
	cp src/common-5/clearpermissions package/content.pkg/Scripts/

	# New agent unloader
	cp src/5.3.7-6/preinstall.patched package/content.pkg/Scripts/preinstall
	cp src/common-5/{unloadagent,loadagent} package/content.pkg/Scripts/

	# Add updated package descriptors for the reshuffle of ConsumerTouchDriver and preference pane version number bump
	cp src/5.3.7-6/Distribution.patched package/Distribution
	cp src/5.3.7-6/PackageInfo.patched  package/content.pkg/PackageInfo
	
	# Modify preference pane version number to avoid it getting marked as "incompatible software" by SystemMigration during system update
	# Looks like the invalid version number string (starting with a word) caused it to always fail the compatibility check
	#
	# See /Library/Apple/Library/Bundles/IncompatibleAppsList.bundle/Contents/Resources/IncompatibleAppsList.plist
	# or run /System/Library/PrivateFrameworks/SystemMigration.framework/Versions/A/Resources/compatchecker -d -f IncompatibleAppsList -r / -s
	plutil -replace CFBundleShortVersionString -string "5.3.7-6" package/content.pkg/Payload/Library/PreferencePanes/PenTablet.prefpane/Contents/Info.plist
	
	# Remove SiLabs driver, since it doesn't seem used by Bamboo
	rm -rf package/content.pkg/Payload/Library/Extensions/SiLabsUSBDriver64.kext

	# Remove the codeless kext since it causes Big Sur's Security & Privacy panel to crash and isn't needed anyway
	rm -rf package/content.pkg/Payload/Library/Extensions/Pen\ Tablet.kext

	# Move ConsumerTouchDriver to become a top-level app, since Big Sur won't grant kTCCServicePostEvent rights to it otherwise
	mv package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app package/content.pkg/Payload/Library/Application\ Support/Tablet/

	# Update the uninstaller to remove ConsumerTouchDriver from that new location
	cp src/5.3.7-6/uninstall.pl.patched package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app/Contents/Resources/uninstall.pl

ifdef CODE_SIGNING_IDENTITY
	# Resign drivers and enable Hardened Runtime to meet notarization requirements
	codesign -s "$(CODE_SIGNING_IDENTITY)" -f --options=runtime --timestamp $(SIGN_ME_5_3_7_6)
else
	codesign --remove-signature $(SIGN_ME_5_3_7_6)
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

src/5.3.7-6/PenTablet.prefpane.patched : src/5.3.7-6/PenTablet.prefpane.original src/5.3.7-6/PenTablet.prefpane.newcode.bin src/5.3.7-6/PenTablet.prefpane.newdata.bin src/5.3.7-6/PenTablet.prefpane.beginDialog.bin src/5.3.7-6/PenTablet.prefpane.getCurrentController.bin .venv/
	./.venv/bin/pip3 install -q -r tools/extend-mach-o/requirements.txt
	# Dump me with 'objdump -b binary -m i386:x86-64:intel -D --adjust-vma=0x00339000 PenTablet.prefpane.newcode.bin'
	./.venv/bin/python3 tools/extend-mach-o/append-section.py src/5.3.7-6/PenTablet.prefpane.original $@.1 __MONKEYCODE __monkeycode src/5.3.7-6/PenTablet.prefpane.newcode.bin 5
	./.venv/bin/python3 tools/extend-mach-o/append-section.py $@.1 $@ __MONKEYDATA __monkeydata src/5.3.7-6/PenTablet.prefpane.newdata.bin 3
	# Patch calls to NSApp::mainWindow:
	dd if=src/5.3.7-6/PenTablet.prefpane.beginDialog.bin          of=$@ bs=1 seek=$$((0x0004ef56)) conv=notrunc
	dd if=src/5.3.7-6/PenTablet.prefpane.getCurrentController.bin of=$@ bs=1 seek=$$((0x0004f44c)) conv=notrunc

.venv/ :
	python3 -m venv .venv
	./.venv/pip3 install

%.bin : %.asm
	yasm -f bin -o $@ $<

ifdef PACKAGE_SIGNING_IDENTITY
Install\ Wacom\ Tablet-5.3.7-6-patched.pkg : Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg
	productsign --sign "$(PACKAGE_SIGNING_IDENTITY)" Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg Install\ Wacom\ Tablet-5.3.7-6-patched.pkg
endif

# Download, mount and unpack original Wacom installers:

src/5.3.7-6/pentablet_5.3.7-6.dmg :
	curl -o $@ "https://cdn.wacom.com/u/productsupport/drivers/mac/consumer/pentablet_5.3.7-6.dmg"
	[ $$(md5 $@ | awk '{ print $$4 }') = "3d87c6c5ca73d9f361a21fe2c2e940e2" ] || (rm $@; false) # Verify download is undamaged

src/5.3.7-6/Install\ Wacom\ Tablet.pkg : src/5.3.7-6/pentablet_5.3.7-6.dmg
	hdiutil attach -quiet -nobrowse -mountpoint src/5.3.7-6/dmg "$<"
	cp "src/5.3.7-6/dmg/Install Wacom Tablet.pkg" "$@"
	hdiutil detach -force src/5.3.7-6/dmg

# Extract original files from the Wacom installers as needed:

$(EXTRACTED_DRIVERS_5_3_7_6) : src/5.3.7-6/Install\ Wacom\ Tablet.pkg
	$(call unpack_package,"$<")

	cp package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/MacOS/PenTabletDriver src/5.3.7-6/PenTabletDriver.original
	cp package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app/Contents/MacOS/ConsumerTouchDriver src/5.3.7-6/ConsumerTouchDriver.original
	cp package/content.pkg/Scripts/preinstall   src/5.3.7-6/preinstall.original
	cp package/content.pkg/Scripts/postinstall  src/5.3.7-6/postinstall.original
	cp package/content.pkg/Scripts/renumtablets src/5.3.7-6/renumtablets
	cp package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app/Contents/Resources/uninstall.pl src/5.3.7-6/uninstall.pl.original
	cp package/content.pkg/Payload/Library/PreferencePanes/PenTablet.prefpane/Contents/MacOS/PenTablet src/5.3.7-6/PenTablet.prefpane.original
	cp package/Distribution src/5.3.7-6/Distribution.original
	cp package/content.pkg/PackageInfo src/5.3.7-6/PackageInfo.original

# Utility commands:

ifdef NOTARIZATION_KEYCHAIN_PROFILE
notarize-bamboo: Install\ Wacom\ Tablet-5.3.7-6-patched.pkg
	xcrun notarytool \
		submit \
		--keychain-profile $(NOTARIZATION_KEYCHAIN_PROFILE) \
		"$<"
	cp "$<" "Install Wacom Tablet-5.3.7-6-patched-notarized.pkg"
endif

staple-bamboo:
	xcrun stapler staple "Install Wacom Tablet-5.3.7-6-patched.pkg"
	cp "Install Wacom Tablet-5.3.7-6-patched.pkg" "Install Wacom Tablet-5.3.7-6-patched-stapled.pkg"

unpack-bamboo : src/5.3.7-6/Install\ Wacom\ Tablet.pkg
	$(call unpack_package,"$<")

unbless-bamboo:
	xattr -w com.apple.quarantine "0181;5e33ca0a;Chrome;AEDC174C-8684-476E-9E4C-764D063A714C" Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg

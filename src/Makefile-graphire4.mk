EXTRACTED_DRIVERS_5_3_0_3= \
	src/5.3.0-3/postflight.original \
	src/5.3.0-3/preflight.original \
	src/5.3.0-3/PenTablet.prefpane.original \
	src/5.3.0-3/com.wacom.pentablet.plist.original \
	src/5.3.0-3/uninstall.pl.original \
	src/5.3.0-3/Pen\ Tablet\ Utility.app

PATCHED_DRIVERS_5_3_0_3= \
	src/5.3.0-3/postflight.patched \
	src/5.3.0-3/preflight.patched \
	src/5.3.0-3/PenTablet.prefpane.patched \
	src/5.3.0-3/com.wacom.pentablet.plist.patched \
	src/5.3.0-3/uninstall.pl.patched

EXTRACTED_DRIVERS+= $(EXTRACTED_DRIVERS_5_3_0_3)

PATCHED_DRIVERS+= $(PATCHED_DRIVERS_5_3_0_3)

FIX_SDK_5_3_0_3= \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/TabletDriver.app/Contents/MacOS/TabletDriver \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app/Contents/MacOS/ConsumerTouchDriver \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/MacOS/PenTabletDriver \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletSpringboard.app/Contents/MacOS/PenTabletSpringboard \
	package/content.pkg/Payload/Library/Internet\ Plug-Ins/WacomNetscape.plugin/Contents/MacOS/WacomNetscape \
	package/content.pkg/Payload/Library/PreferencePanes/PenTablet.prefPane/Contents/MacOS/PenTablet \
	package/content.pkg/Payload/Library/Extensions/TabletDriverCFPlugin.bundle/Contents/MacOS/TabletDriverCFPlugin \
	package/content.pkg/Payload/Library/Frameworks/WacomMultiTouch.framework/Versions/A/WacomMultiTouch \
	package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app/Contents/MacOS/Pen\ Tablet\ Utility \
	package/content.pkg/Scripts/renumtablets \
	package/content.pkg/Scripts/InstallationCheck \
	package/content.pkg/Scripts/SystemLoginItemTool

SIGN_ME_5_3_0_3= \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/TabletDriver.app \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletSpringboard.app \
	package/content.pkg/Payload/Library/Internet\ Plug-Ins/WacomNetscape.plugin \
	package/content.pkg/Payload/Library/Internet\ Plug-Ins/WacomTabletPlugin.plugin \
	package/content.pkg/Payload/Library/PreferencePanes/PenTablet.prefPane \
	package/content.pkg/Payload/Library/Extensions/TabletDriverCFPlugin.bundle \
	package/content.pkg/Payload/Library/Frameworks/WacomMultiTouch.framework/Versions/A/WacomMultiTouch \
	package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app \
	package/content.pkg/Scripts/renumtablets \
	package/content.pkg/Scripts/InstallationCheck \
	package/content.pkg/Scripts/SystemLoginItemTool

UNSIGNED_INSTALLERS+= Install\ Wacom\ Tablet-5.3.0-3-patched-unsigned.pkg
SIGNED_INSTALLERS+= Install\ Wacom\ Tablet-5.3.0-3-patched.pkg

# Create the installer package by modifying Wacom's original:

Install\ Wacom\ Tablet-5.3.0-3-patched-unsigned.pkg : src/5.3.0-3/Install\ Bamboo.pkg src/5.3.0-3/Welcome.rtf src/5.3.0-3/PackageInfo src/5.3.0-3/Distribution src/common-5/clearpermissions $(PATCHED_DRIVERS_5_3_0_3) tools/fix_LC_VERSION_MIN_MACOSX/fixSDKVersion
	# Have to do a bunch of work here to upgrade the old-style directory package into a modern flat-file .pkg
	rm -rf package
	mkdir package
	mkdir package/content.pkg
	mkdir package/content.pkg/Payload
	mkdir package/content.pkg/Scripts

	cp -a -L src/5.3.0-3/Install\ Bamboo.pkg/Contents/Resources package/

	# Move installer utilities to correct directory
	mv package/Resources/{InstallationCheck,renumtablets,SystemLoginItemTool} package/content.pkg/Scripts/

	# Remove install scripts from old style directory
	rm package/Resources/{preflight,postflight}

	# Install patched postinstall script: Don't call old multitouch install method, use new language manifest loader code from 5.3.7-6, new agent loader
	cp src/5.3.0-3/postflight.patched package/content.pkg/Scripts/postflight
	# Tool for clearing leftover permissions from previous driver:
	cp src/common-5/clearpermissions package/content.pkg/Scripts/

	# New agent unloader
	cp src/5.3.0-3/preflight.patched  package/content.pkg/Scripts/preflight
	cp src/common-5/{unloadagent,loadagent} package/content.pkg/Scripts/

	# Add metadata files that weren't present in the old package style
	cp src/5.3.0-3/PackageInfo package/content.pkg/
	cp src/5.3.0-3/Distribution package/

	# Add Welcome screen
	find package/Resources -type d -depth 1 -exec cp src/5.3.0-3/Welcome.rtf {}/ \;

	# Unpack payload
	cd package/content.pkg/Payload && tar --no-same-owner -xf ../../../src/5.3.0-3/Install\ Bamboo.pkg/Contents/Archive.pax.gz

	# Remove unused + unsignable old binary (not needed since 10.5)
	rm package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app/Contents/Resources/SystemLoginItemTool

	# Avoid the old strategy of installing the multitouch framework to the /tmp directory first
	mv package/content.pkg/Payload/tmp/WacomMultiTouch.framework package/content.pkg/Payload/Library/Frameworks
	rm -r package/content.pkg/Payload/tmp

	# Don't install files into the /System partition (not allowed in Catalina)
	mv package/content.pkg/Payload/System/Library/Extensions package/content.pkg/Payload/Library/
	rm -r package/content.pkg/Payload/System

	# Install fixed preference pane 
	cp src/5.3.0-3/PenTablet.prefpane.patched package/content.pkg/Payload/Library/PreferencePanes/PenTablet.prefPane/Contents/MacOS/PenTablet

	# Modify preference pane version number to avoid it getting marked as "incompatible software" by SystemMigration during system update
	plutil -replace CFBundleShortVersionString -string "5.3.0-3" package/content.pkg/Payload/Library/PreferencePanes/PenTablet.prefpane/Contents/Info.plist

	# Make duplicate copy of localisation strings to the location that the patched postflight script expects (documentation installation)
	cp -a -L package/Resources package/content.pkg/Scripts/support

	# Wrap the PenTabletSpringboard executable up into an app bundle, so we can refer to it by bundle ID in tccutil
	mkdir -p package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletSpringboard.app/Contents/MacOS
	mv package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletSpringboard package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletSpringboard.app/Contents/MacOS/
	cp src/5.3.0-3/PenTabletSpringboard.Info.plist package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletSpringboard.app/Contents/Info.plist

	# Update the LaunchAgent to refer to the new location for PenTabletSpringboard
	cp src/5.3.0-3/com.wacom.pentablet.plist.patched package/content.pkg/Payload/Library/LaunchAgents/com.wacom.pentablet.plist

	# Patch the uninstaller to remove the new location of PenTabletSpringboard
	cp src/5.3.0-3/uninstall.pl.patched package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app/Contents/Resources/uninstall.pl

	# Update minimum SDK versions to 10.9 to meet notarization requirements
	tools/fix_LC_VERSION_MIN_MACOSX/fixSDKVersion $(FIX_SDK_5_3_0_3)

ifdef CODE_SIGNING_IDENTITY
	# Resign drivers and enable Hardened Runtime to meet notarization requirements
	codesign -s "$(CODE_SIGNING_IDENTITY)" -f --options=runtime --timestamp $(SIGN_ME_5_3_0_3)
else
	codesign --remove-signature $(SIGN_ME_5_3_0_3)
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
	
	# We set preserve-xattr="true" in PackageInfo so that ._* extended attributes in PenTablet.prefpane resources are preserved
	# These are setting file encoding to UTF-16 by the look of it
	pkgutil --flatten package "$@"

ifdef PACKAGE_SIGNING_IDENTITY
Install\ Wacom\ Tablet-5.3.0-3-patched.pkg : Install\ Wacom\ Tablet-5.3.0-3-patched-unsigned.pkg
	productsign --sign "$(PACKAGE_SIGNING_IDENTITY)" Install\ Wacom\ Tablet-5.3.0-3-patched-unsigned.pkg Install\ Wacom\ Tablet-5.3.0-3-patched.pkg
endif

# Download, mount and unpack original Wacom installers:

# Also used for a few files for Graphire 3
src/5.3.0-3/PenTablet_5.3.0-3.dmg :
	curl -o $@ "https://cdn.wacom.com/U/Drivers/Mac/Consumer/530/PenTablet_5.3.0-3.dmg"
	[ $$(md5 $@ | awk '{ print $$4 }') = "a362794f7a84470407884c5a033c2624" ] || (rm $@; false) # Verify download is undamaged

# Also used for a few files for Graphire 3
src/5.3.0-3/Install\ Bamboo.pkg : src/5.3.0-3/PenTablet_5.3.0-3.dmg
	hdiutil attach -quiet -nobrowse -mountpoint src/5.3.0-3/dmg "$<"
	rm -rf "$@"
	cp -a "src/5.3.0-3/dmg/Install Bamboo.pkg" "$@"
	# The permissions on the package files are super awkward, make those more permissive for us:
	find "src/5.3.0-3/Install Bamboo.pkg" -type d -exec chmod 0755 {} \;
	find "src/5.3.0-3/Install Bamboo.pkg" -type f -exec chmod u+rw {} \;
	# Also copy the directories from outside the package because we need them for getting licence files
	cp -R src/5.3.0-3/dmg/{ChineseS,ChineseT,Dutch,English,French,German,Italian,Japanese,Korean,Polish,Portuguese,Russian,Spanish} src/5.3.0-3/
	hdiutil detach -force src/5.3.0-3/dmg
	touch "$@"

# Extract original files from the Wacom installers as needed:

$(EXTRACTED_DRIVERS_5_3_0_3) : src/5.3.0-3/Install\ Bamboo.pkg
	rm -rf src/5.3.0-3/Install\ Bamboo.pkg/Contents/Archive
	mkdir -p src/5.3.0-3/Install\ Bamboo.pkg/Contents/Archive
	cd src/5.3.0-3/Install\ Bamboo.pkg/Contents/Archive && tar --no-same-owner -xf ../Archive.pax.gz
	cp src/5.3.0-3/Install\ Bamboo.pkg/Contents/Resources/postflight src/5.3.0-3/postflight.original
	cp src/5.3.0-3/Install\ Bamboo.pkg/Contents/Resources/preflight  src/5.3.0-3/preflight.original
	cp src/5.3.0-3/Install\ Bamboo.pkg/Contents/Archive/Library/PreferencePanes/PenTablet.prefpane/Contents/MacOS/PenTablet src/5.3.0-3/PenTablet.prefpane.original
	cp src/5.3.0-3/Install\ Bamboo.pkg/Contents/Archive/Library/LaunchAgents/com.wacom.pentablet.plist src/5.3.0-3/com.wacom.pentablet.plist.original
	cp src/5.3.0-3/Install\ Bamboo.pkg/Contents/Archive/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app/Contents/Resources/uninstall.pl src/5.3.0-3/uninstall.pl.original
	cp -a src/5.3.0-3/Install\ Bamboo.pkg/Contents/Archive/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app src/5.3.0-3/

# Utility commands:

ifdef NOTARIZATION_KEYCHAIN_PROFILE
notarize-graphire4: Install\ Wacom\ Tablet-5.3.0-3-patched.pkg
	xcrun notarytool \
		submit \
		--keychain-profile $(NOTARIZATION_KEYCHAIN_PROFILE) \
		"$<"
	cp "$<" "Install Wacom Tablet-5.3.0-3-patched-notarized.pkg"
endif

staple-graphire4:
	xcrun stapler staple "Install Wacom Tablet-5.3.0-3-patched.pkg"
	cp "Install Wacom Tablet-5.3.0-3-patched.pkg" "Install Wacom Tablet-5.3.0-3-patched-stapled.pkg"

unpack-graphire4 : src/5.3.0-3/Install\ Bamboo.pkg
	mkdir -p src/5.3.0-3/Install\ Bamboo.pkg/Contents/Archive
	cd src/5.3.0-3/Install\ Bamboo.pkg/Contents/Archive && tar --no-same-owner -xf ../Archive.pax.gz

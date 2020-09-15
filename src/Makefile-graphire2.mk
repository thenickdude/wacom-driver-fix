EXTRACTED_DRIVERS_6_1_6_4= \
	src/6.1.6-4/postflight.original \
	src/6.1.6-4/preflight.original \
	src/6.1.6-4/WacomTablet.prefpane.original

PATCHED_DRIVERS_6_1_6_4= \
	src/6.1.6-4/postflight.patched \
	src/6.1.6-4/preflight.patched \
	src/6.1.6-4/WacomTablet.prefpane.patched

EXTRACTED_DRIVERS+= $(EXTRACTED_DRIVERS_6_1_6_4)

PATCHED_DRIVERS+= $(PATCHED_DRIVERS_6_1_6_4)

CREATE_DIRECTORIES+= src/6.1.6-4/

SIGN_ME_6_1_6_4= \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletDriver.app/Contents/Resources/TabletDriver.app \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletDriver.app \
	package/content.pkg/Payload/Library/PreferencePanes/WacomTablet.prefpane \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletSpringboard \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletDriver.app/Contents/MacOS/WacomTabletDriver \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletDriver.app \
	package/content.pkg/Payload/Library/Internet\ Plug-Ins/WacomNetscape.plugin \
	package/content.pkg/Payload/Library/Internet\ Plug-Ins/WacomSafari.plugin \
	package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Tablet\ Utility.app/Contents/Resources/SystemLoginItemTool \
	package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Tablet\ Utility.app

FIX_SDK_6_1_6_4= \
	package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Tablet\ Utility.app/Contents/MacOS/Wacom\ Tablet\ Utility \
	package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Tablet\ Utility.app/Contents/Resources/SystemLoginItemTool

UNSIGNED_INSTALLERS+= Install\ Wacom\ Tablet-6.1.6-4-patched-unsigned.pkg
SIGNED_INSTALLERS+= Install\ Wacom\ Tablet-6.1.6-4-patched.pkg
	
# Create the installer package by modifying Wacom's original:

Install\ Wacom\ Tablet-6.1.6-4-patched-unsigned.pkg : src/6.1.6-4/Install\ Wacom\ Tablet.pkg src/6.1.6-4/Welcome.rtf src/6.1.6-4/PackageInfo src/6.1.6-4/Distribution $(PATCHED_DRIVERS_6_1_6_4) src/6.3.7-1/Wacom\ Tablet.kext src/6.3.4-3/Wacom\ Tablet\ Utility.app tools/fix_LC_VERSION_MIN_MACOSX/fixSDKVersion
	# Have to do a bunch of work here to upgrade the old-style directory package into a modern flat-file .pkg
	rm -rf package
	mkdir package
	mkdir package/content.pkg
	mkdir package/content.pkg/Payload
	mkdir package/content.pkg/Scripts

	cp -a -L src/6.1.6-4/Install\ Wacom\ Tablet.pkg/Contents/Resources package/

	# Remove obsolete 32-bit installer binaries
	rm package/Resources/{InstallationCheck,renumtablets,SystemLoginItemTool}

	# Remove install scripts from old style directory
	rm package/Resources/{preflight,postflight}

	# Install patched postinstall script: Use new language manifest loader code from 5.3.7-6, new agent loader
	cp src/6.1.6-4/postflight.patched package/content.pkg/Scripts/postflight
	# New agent unloader
	cp src/6.1.6-4/preflight.patched  package/content.pkg/Scripts/preflight
	cp src/6.1.6-4/{unloadagent,loadagent} package/content.pkg/Scripts/

	# Add metadata files that weren't present in the old package style
	cp src/6.1.6-4/PackageInfo package/content.pkg
	cp src/6.1.6-4/Distribution package/

	# Add Welcome screen
	find package/Resources -type d -depth 1 -exec cp src/6.1.6-4/Welcome.rtf {}/ \;

	# Unpack payload
	cd package/content.pkg/Payload && tar --no-same-owner -xf ../../../src/6.1.6-4/Install\ Wacom\ Tablet.pkg/Contents/Archive.pax.gz

	# Remove extended attribute files that didn't unpack properly (prevents codesigning if left there)
	find package/content.pkg/Payload -type f -name "._*" -delete

	# Remove old PowerPC-only TabletDriverCFPlugin.bundle
	rm -rf package/content.pkg/Payload/System/Library/Extensions/TabletDriverCFPlugin.bundle

	# Replace Wacom Tablet.kext with one from 6.3.7-1 that is signed and that Catalina has a built-in hash exception for (allowing it to load without a timestamped notarisation)
	# It's functionally identical anyway
	rm -rf package/content.pkg/Payload/System/Library/Extensions/Wacom\ Tablet.kext
	cp -a src/6.3.7-1/Wacom\ Tablet.kext package/content.pkg/Payload/System/Library/Extensions/

	# Remove 32-bit Wacom Tablet Utility and replace it with the one from 6.3.4-3 (the new uninstaller is similar enough to be useful)
	rm -rf package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Tablet\ Utility.app
	cp -a src/6.3.4-3/Wacom\ Tablet\ Utility.app package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/

	# Don't install files into the /System partition (not allowed in Catalina)
	mv package/content.pkg/Payload/System/Library/Extensions package/content.pkg/Payload/Library/
	rm -r package/content.pkg/Payload/System

	# Install fixed preference pane 
	cp src/6.1.6-4/WacomTablet.prefpane.patched package/content.pkg/Payload/Library/PreferencePanes/WacomTablet.prefPane/Contents/MacOS/WacomTablet

	# Make duplicate copy of localisation strings to the location that the patched postflight script expects (documentation installation)
	cp -a -L package/Resources package/content.pkg/Scripts/support

	# Update minimum SDK versions to 10.9 to meet notarization requirements
	tools/fix_LC_VERSION_MIN_MACOSX/fixSDKVersion $(FIX_SDK_6_1_6_4)

ifdef CODE_SIGNING_IDENTITY
	# Resign drivers and enable Hardened Runtime to meet notarization requirements
	codesign -s "$(CODE_SIGNING_IDENTITY)" -f --options=runtime --timestamp $(SIGN_ME_6_1_6_4)
else
	codesign --remove-signature $(SIGN_ME_6_1_6_4)
endif

	# Recreate BOM
	mkbom package/content.pkg/Payload package/content.pkg/Bom

	# Repack payload
	( cd package/content.pkg/Payload && find . ! -path "./Library/Extensions*" | cpio -o --format odc --owner 0:80 ) > .tmp-payload

	( \
		head -c $$(LC_CTYPE=C grep --byte-offset --only-matching --text -F '0707070000000000000000000000000000000000010000000000000000000001300000000000TRAILER!!!' .tmp-payload | cut -f1 -d: ) .tmp-payload ; \
		( cd package/content.pkg/Payload && find ./Library/Extensions | cpio -o --format odc --owner 0:0 ) ; \
	) | gzip -c > package/content.pkg/Payload.gz
	rm .tmp-payload
	rm -rf package/content.pkg/Payload
	mv package/content.pkg/Payload.gz package/content.pkg/Payload

	# Repack installer
	pkgutil --flatten package "$@"

ifdef PACKAGE_SIGNING_IDENTITY
Install\ Wacom\ Tablet-6.1.6-4-patched.pkg : Install\ Wacom\ Tablet-6.1.6-4-patched-unsigned.pkg
	productsign --sign "$(PACKAGE_SIGNING_IDENTITY)" Install\ Wacom\ Tablet-6.1.6-4-patched-unsigned.pkg Install\ Wacom\ Tablet-6.1.6-4-patched.pkg
endif

# Download, mount and unpack original Wacom installers:

src/6.1.6-4/WacomTablet_6.1.6-4.dmg :
	curl -o $@ "https://cdn.wacom.com/U/Drivers/Mac/pro/WacomTablet_6.1.6-4.dmg"
	[ $$(md5 $@ | awk '{ print $$4 }') = "e5bfa6c266edbb028064534aa6a50086" ] || (rm $@; false) # Verify download is undamaged

src/6.1.6-4/Install\ Wacom\ Tablet.pkg : src/6.1.6-4/WacomTablet_6.1.6-4.dmg
	hdiutil attach -quiet -nobrowse -mountpoint src/6.1.6-4/dmg "$<"
	rm -rf "$@"
	cp -a "src/6.1.6-4/dmg/Install Wacom Tablet.pkg" "$@"
	# The permissions on the package files are super awkward, make those more permissive for us:
	find "src/6.1.6-4/Install Wacom Tablet.pkg" -type d -exec chmod 0755 {} \;
	find "src/6.1.6-4/Install Wacom Tablet.pkg" -type f -exec chmod u+rw {} \;
	# Also copy the directories from outside the package because we need them for getting licence files
	cp -R src/6.1.6-4/dmg/{ChineseS,ChineseT,Dutch,English,French,German,Italian,Japanese,Korean,Polish,Portuguese,Russian,Spanish} src/6.1.6-4/
	hdiutil detach -force src/6.1.6-4/dmg
	touch "$@"

# Extract original files from the Wacom installers as needed:

$(EXTRACTED_DRIVERS_6_1_6_4) : src/6.1.6-4/Install\ Wacom\ Tablet.pkg
	rm -rf src/6.1.6-4/Install\ Wacom\ Tablet.pkg/Contents/Archive
	mkdir -p src/6.1.6-4/Install\ Wacom\ Tablet.pkg/Contents/Archive
	cd src/6.1.6-4/Install\ Wacom\ Tablet.pkg/Contents/Archive && tar --no-same-owner -xf ../Archive.pax.gz
	cp src/6.1.6-4/Install\ Wacom\ Tablet.pkg/Contents/Resources/postflight src/6.1.6-4/postflight.original
	cp src/6.1.6-4/Install\ Wacom\ Tablet.pkg/Contents/Resources/preflight  src/6.1.6-4/preflight.original
	cp src/6.1.6-4/Install\ Wacom\ Tablet.pkg/Contents/Archive/Library/PreferencePanes/WacomTablet.prefpane/Contents/MacOS/WacomTablet src/6.1.6-4/WacomTablet.prefpane.original

# Utility commands:

notarize-graphire2: Install\ Wacom\ Tablet-6.1.6-4-patched.pkg
	xcrun altool \
		 --notarize-app \
		 --primary-bundle-id "com.wacom.wacomtablet" \
		 --username "$(NOTARIZATION_USERNAME)" \
		 --password "@keychain:AC_PASSWORD" \
		 --file "$<"
	cp "$<" "Install Wacom Tablet-6.1.6-4-patched-notarized.pkg"

staple-graphire2:
	xcrun stapler staple "Install Wacom Tablet-6.1.6-4-patched.pkg"
	cp "Install Wacom Tablet-6.1.6-4-patched.pkg" "Install Wacom Tablet-6.1.6-4-patched-stapled.pkg"

unpack-graphire2 : src/6.1.6-4/Install\ Wacom\ Tablet.pkg
	mkdir -p src/6.1.6-4/Install\ Wacom\ Tablet.pkg/Contents/Archive
	cd src/6.1.6-4/Install\ Wacom\ Tablet.pkg/Contents/Archive && tar --no-same-owner -xf ../Archive.pax.gz

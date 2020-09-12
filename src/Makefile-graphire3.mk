EXTRACTED_DRIVERS_5_2_6_5= \
	src/5.2.6-5/postflight.original \
	src/5.2.6-5/preflight.original \
	src/5.2.6-5/PenTablet.prefpane.original

PATCHED_DRIVERS_5_2_6_5= \
	src/5.2.6-5/postflight.patched \
	src/5.2.6-5/preflight.patched \
	src/5.2.6-5/PenTablet.prefpane.patched

EXTRACTED_DRIVERS+= $(EXTRACTED_DRIVERS_5_2_6_5)

PATCHED_DRIVERS+= $(PATCHED_DRIVERS_5_2_6_5) 

SIGN_ME_5_2_6_5= \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/TabletDriver.app \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletSpringboard \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/Xtras/WacomDataXtra.xtra \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/Xtras/WacomXtra.xtra \
	package/content.pkg/Payload/Library/Internet\ Plug-Ins/WacomNetscape.plugin \
	package/content.pkg/Payload/Library/Internet\ Plug-Ins/WacomTabletPlugin.plugin \
	package/content.pkg/Payload/Library/PreferencePanes/PenTablet.prefPane \
	package/content.pkg/Payload/Library/Frameworks/WacomMultiTouch.framework/Versions/A/WacomMultiTouch \
	package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app \
	package/content.pkg/Scripts/renumtablets

UNSIGNED_INSTALLERS+= Install\ Wacom\ Tablet-5.2.6-5-patched-unsigned.pkg 
SIGNED_INSTALLERS+= Install\ Wacom\ Tablet-5.2.6-5-patched.pkg

# Create the installer package by modifying Wacom's original:

Install\ Wacom\ Tablet-5.2.6-5-patched-unsigned.pkg : src/5.2.6-5/Install\ Bamboo.pkg src/5.2.6-5/Welcome.rtf src/5.2.6-5/PackageInfo src/5.2.6-5/Distribution src/5.2.6-5/preflight.patched src/5.2.6-5/postflight.patched src/5.3.7-6/renumtablets src/5.2.6-5/PenTablet.prefpane.patched
	# Have to do a bunch of work here to upgrade the old-style directory package into a modern flat-file .pkg
	rm -rf package
	mkdir package
	mkdir package/content.pkg
	mkdir package/content.pkg/Payload
	mkdir package/content.pkg/Scripts

	cp -a -L src/5.2.6-5/Install\ Bamboo.pkg/Contents/Resources package/

	# Take 64-bit installer binaries from the subsequent 5.3.7-6 release to replace obsolete/unsignable 32-bit binaries in this release
	rm package/Resources/{InstallationCheck,renumtablets,SystemLoginItemTool}
	cp src/5.3.7-6/renumtablets package/content.pkg/Scripts/

	# Remove install scripts from old style directory
	rm package/Resources/{preflight,postflight}

	# Install patched postinstall script: Don't call old multitouch install method, use new language manifest loader code from 5.3.7-6, new agent loader
	cp src/5.2.6-5/postflight.patched package/content.pkg/Scripts/postflight
	# New agent unloader
	cp src/5.2.6-5/preflight.patched  package/content.pkg/Scripts/preflight
	cp src/5.2.6-5/{unloadagent,loadagent} package/content.pkg/Scripts/

	# Add metadata files that weren't present in the old package style
	cp src/5.2.6-5/PackageInfo package/content.pkg
	cp src/5.2.6-5/Distribution package/

	# Add Welcome screen
	find package/Resources -type d -depth 1 -exec cp src/5.2.6-5/Welcome.rtf {}/ \;

	# Unpack payload
	cd package/content.pkg/Payload && tar --no-same-owner -xf ../../../src/5.2.6-5/Install\ Bamboo.pkg/Contents/Archive.pax.gz

	# Remove unused + unsignable old binary (not needed since 10.5)
	rm package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app/Contents/Resources/SystemLoginItemTool

	# Remove extended attribute files that didn't unpack properly (prevents codesigning if left there)
	find package/content.pkg/Payload -type f -name "._*" -delete

	# Avoid the old strategy of installing the multitouch framework to the /tmp directory first
	mv package/content.pkg/Payload/tmp/WacomMultiTouch.framework package/content.pkg/Payload/Library/Frameworks
	rm -r package/content.pkg/Payload/tmp

	# Remove PowerPC-only plugin
	rm -rf package/content.pkg/Payload/System/Library/Extensions/TabletDriverCFPlugin.bundle

	# Don't install files into the /System partition (not allowed in Catalina)
	mv package/content.pkg/Payload/System/Library/Extensions package/content.pkg/Payload/Library/
	rm -r package/content.pkg/Payload/System

	# Install fixed preference pane 
	cp src/5.2.6-5/PenTablet.prefpane.patched package/content.pkg/Payload/Library/PreferencePanes/PenTablet.prefPane/Contents/MacOS/PenTablet

	# Modify preference pane version number to avoid it getting marked as "incompatible software" by SystemMigration during system update
	plutil -replace CFBundleShortVersionString -string "5.2.6-5" package/content.pkg/Payload/Library/PreferencePanes/PenTablet.prefpane/Contents/Info.plist

	# Make duplicate copy of localisation strings to the location that the patched postflight script expects (documentation installation)
	cp -a -L package/Resources package/content.pkg/Scripts/support

ifdef CODE_SIGNING_IDENTITY
	# Resign drivers and enable Hardened Runtime to meet notarization requirements
	codesign -s "$(CODE_SIGNING_IDENTITY)" -f --options=runtime --timestamp $(SIGN_ME_5_2_6_5)
else
	codesign --remove-signature $(SIGN_ME_5_2_6_5)
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
Install\ Wacom\ Tablet-5.2.6-5-patched.pkg : Install\ Wacom\ Tablet-5.2.6-5-patched-unsigned.pkg
	productsign --sign "$(PACKAGE_SIGNING_IDENTITY)" Install\ Wacom\ Tablet-5.2.6-5-patched-unsigned.pkg Install\ Wacom\ Tablet-5.2.6-5-patched.pkg
endif

# Download, mount and unpack original Wacom installers:

src/5.2.6-5/PenTablet_5.2.6-5.dmg :
	curl -o $@ "https://cdn.wacom.com/U/productsupport/Drivers/Mac/Consumer/PenTablet_5.2.6-5.dmg"
	[ $$(md5 $@ | awk '{ print $$4 }') = "548d92f2a55e6f17c63242f5e7a521fa" ] || (rm $@; false) # Verify download is undamaged

src/5.2.6-5/Install\ Bamboo.pkg : src/5.2.6-5/PenTablet_5.2.6-5.dmg
	hdiutil attach -quiet -nobrowse -mountpoint src/5.2.6-5/dmg "$<"
	rm -rf "$@"
	cp -a "src/5.2.6-5/dmg/Install Bamboo.pkg" "$@"
	# The permissions on the package files are super awkward, make those more permissive for us:
	find "src/5.2.6-5/Install Bamboo.pkg" -type d -exec chmod 0755 {} \;
	find "src/5.2.6-5/Install Bamboo.pkg" -type f -exec chmod u+rw {} \;
	# Also copy the directories from outside the package because we need them for getting licence files
	cp -R src/5.2.6-5/dmg/{ChineseS,ChineseT,Dutch,English,French,German,Italian,Japanese,Korean,Polish,Portuguese,Russian,Spanish} src/5.2.6-5/
	hdiutil detach -force src/5.2.6-5/dmg
	touch "$@"

# Extract original files from the Wacom installers as needed:

$(EXTRACTED_DRIVERS_5_2_6_5) : src/5.2.6-5/Install\ Bamboo.pkg
	rm -rf src/5.2.6-5/Install\ Bamboo.pkg/Contents/Archive
	mkdir -p src/5.2.6-5/Install\ Bamboo.pkg/Contents/Archive
	cd src/5.2.6-5/Install\ Bamboo.pkg/Contents/Archive && tar --no-same-owner -xf ../Archive.pax.gz
	cp src/5.2.6-5/Install\ Bamboo.pkg/Contents/Resources/postflight src/5.2.6-5/postflight.original
	cp src/5.2.6-5/Install\ Bamboo.pkg/Contents/Resources/preflight  src/5.2.6-5/preflight.original
	cp src/5.2.6-5/Install\ Bamboo.pkg/Contents/Archive/Library/PreferencePanes/PenTablet.prefpane/Contents/MacOS/PenTablet src/5.2.6-5/PenTablet.prefpane.original

# Utility commands:

notarize-graphire3: Install\ Wacom\ Tablet-5.2.6-5-patched.pkg
	xcrun altool \
		 --notarize-app \
		 --primary-bundle-id "com.wacom.pentablet" \
		 --username "$(NOTARIZATION_USERNAME)" \
		 --password "@keychain:AC_PASSWORD" \
		 --file "$<"
	cp "$<" "Install Wacom Tablet-5.2.6-5-patched-notarized.pkg"

staple-graphire3:
	xcrun stapler staple "Install Wacom Tablet-5.2.6-5-patched.pkg"
	cp "Install Wacom Tablet-5.2.6-5-patched.pkg" "Install Wacom Tablet-5.2.6-5-patched-stapled.pkg"

unpack-graphire3 : src/5.2.6-5/Install\ Bamboo.pkg
	mkdir -p src/5.2.6-5/Install\ Bamboo.pkg/Contents/Archive
	cd src/5.2.6-5/Install\ Bamboo.pkg/Contents/Archive && tar --no-same-owner -xf ../Archive.pax.gz

CODE_SIGNING_IDENTITY=Developer ID Application: Nicholas Sherlock (8J3T27D935)
PACKAGE_SIGNING_IDENTITY=Developer ID Installer: Nicholas Sherlock (8J3T27D935)

NOTARIZATION_USERNAME=n.sherlock@gmail.com

PATCHED_DRIVERS_5_3_7_6= \
	src/5.3.7-6/PenTabletDriver.patched \
	src/5.3.7-6/ConsumerTouchDriver.patched \
	src/5.3.7-6/preinstall.patched \
	src/5.3.7-6/postinstall.patched

PATCHED_DRIVERS_6_3_15_3= \
	src/6.3.15-3/WacomTablet.patched \
	src/6.3.15-3/postinstall.patched \
	src/6.3.15-3/WacomTabletDriver.patched

PATCHED_DRIVERS=$(PATCHED_DRIVERS_5_3_7_6) $(PATCHED_DRIVERS_6_3_15_3)

EXTRACTED_DRIVERS_5_3_7_6= \
	src/5.3.7-6/PenTabletDriver.original \
	src/5.3.7-6/ConsumerTouchDriver.original \
	src/5.3.7-6/preinstall.original \
	src/5.3.7-6/postinstall.original

EXTRACTED_DRIVERS_6_3_15_3= \
	src/6.3.15-3/WacomTablet.original \
	src/6.3.15-3/postinstall.original \
	src/6.3.15-3/WacomTabletDriver.original

EXTRACTED_DRIVERS_6_3_17_5= \
	src/6.3.17-5/Wacom\ Desktop\ Center.app

EXTRACTED_DRIVERS=$(EXTRACTED_DRIVERS_5_3_7_6) $(EXTRACTED_DRIVERS_6_3_15_3) $(EXTRACTED_DRIVERS_6_3_17_5)

SIGN_ME_5= \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/TabletDriver.app \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app \
	package/content.pkg/Payload/Library/Frameworks/WacomMultiTouch.framework/Versions/A/WacomMultiTouch \
	package/content.pkg/Payload/Library/PrivilegedHelperTools/com.wacom.TabletHelper.app/Contents/MacOS/com.wacom.TabletHelper \
	package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app/Contents/Library/LaunchServices/com.wacom.RemoveTabletHelper \
	package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app/Contents/Resources/SystemLoginItemTool \
	package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app \
	package/content.pkg/Scripts/renumtablets

SIGN_ME_6= \
	package/content.pkg/Payload/Library/PreferencePanes/WacomTablet.prefpane \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletSpringboard \
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

define unpack_package
	rm -rf package
	pkgutil --expand $(1) package
	mv package/content.pkg/Payload package/content.pkg/Payload.gz
	mkdir package/content.pkg/Payload
	cd package/content.pkg/Payload && gzcat ../Payload.gz | cpio -di && rm ../Payload.gz
	# Add entry permissions to these directories so we can actually access them ourselves!
	[ -d package/content.pkg/Payload/Library/LaunchAgents ]  && chmod u+x package/content.pkg/Payload/Library/LaunchAgents || true
	[ -d package/content.pkg/Payload/Library/LaunchDaemons ] && chmod u+x package/content.pkg/Payload/Library/LaunchDaemons || true
endef

.PHONY: all release unpack-5 unpack-6 unbless-5 unbless-6 notarize-5 notarize-6 clean

all : \
	wacom-5.3.7-6-macOS-patched.zip  Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg \
	wacom-6.3.15-3-macOS-patched.zip Install\ Wacom\ Tablet-6.3.15-3-patched-unsigned.pkg

release : \
	wacom-5.3.7-6-macOS-patched.zip Install\ Wacom\ Tablet-5.3.7-6-patched.pkg \
	wacom-6.3.15-3-macOS-patched.zip Install\ Wacom\ Tablet-6.3.15-3-patched.pkg

wacom-5.3.7-6-macOS-patched.zip : $(PATCHED_DRIVERS_5_3_7_6) build/ build/Readme.html
	rm -f $@
	cp src/5.3.7-6/PenTabletDriver.patched build/PenTabletDriver
	cp src/5.3.7-6/ConsumerTouchDriver.patched build/ConsumerTouchDriver
	cd build && zip ../$@ PenTabletDriver ConsumerTouchDriver Readme.html

wacom-6.3.15-3-macOS-patched.zip : $(PATCHED_DRIVERS_6_3_15_3) build/ build/Readme.html
	rm -f $@
	cp src/6.3.15-3/WacomTablet.patched build/WacomTablet
	cp src/6.3.15-3/WacomTabletDriver.patched build/WacomTabletDriver
	cd build && zip ../$@ WacomTablet WacomTabletDriver Readme.html

# Render documentation markdown using marked: https://www.npmjs.com/package/marked
build/Readme.html : Readme.md build/ src/readme-prologue.html src/readme-epilogue.html
	( cat src/readme-prologue.html; marked --gfm < $<; cat src/readme-epilogue.html ) > $@

# Create the installer package by modifying Wacom's original
Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg : src/5.3.7-6/Install\ Wacom\ Tablet-5.3.7-6-original.pkg $(PATCHED_DRIVERS_5_3_7_6) src/5.3.7-6/Welcome.rtf
	$(call unpack_package,"src/5.3.7-6/Install Wacom Tablet-5.3.7-6-original.pkg")

	# Add Welcome screen
	find package/Resources -type d -depth 1 -exec cp src/5.3.7-6/Welcome.rtf {}/ \;
	sed -i "" -E 's/(<\/installer-gui-script>)/    <welcome file="Welcome.rtf" mime-type="text\/richtext"\/>\1/' package/Distribution

	# Add patched drivers
	cp src/5.3.7-6/PenTabletDriver.patched package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/MacOS/PenTabletDriver
	cp src/5.3.7-6/ConsumerTouchDriver.patched package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app/Contents/MacOS/ConsumerTouchDriver
	cp src/5.3.7-6/preinstall.patched package/content.pkg/Scripts/preinstall
	cp src/5.3.7-6/postinstall.patched package/content.pkg/Scripts/postinstall
	cp src/5.3.7-6/unloadagent src/5.3.7-6/loadagent package/content.pkg/Scripts/

ifdef CODE_SIGNING_IDENTITY
	# Resign drivers and enable Hardened Runtime to meet notarization requirements
	codesign -s "$(CODE_SIGNING_IDENTITY)" -f --options=runtime --timestamp $(SIGN_ME_5)
endif

	# Recreate BOM
	mkbom package/content.pkg/Payload package/content.pkg/Bom

	# Repack payload
	( \
		( cd package/content.pkg/Payload && find . ! -path "./Library/Extensions*" | cpio -o --format odc --owner 0:80 ) ; \
		( cd package/content.pkg/Payload && find ./Library/Extensions              | cpio -o --format odc --owner 0:0 ) ; \
	) | gzip -c > package/content.pkg/Payload.gz
	rm -rf package/content.pkg/Payload
	mv package/content.pkg/Payload.gz package/content.pkg/Payload

	# Repack installer
	pkgutil --flatten package "$@"

ifdef PACKAGE_SIGNING_IDENTITY
Install\ Wacom\ Tablet-5.3.7-6-patched.pkg : Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg
	productsign --sign "$(PACKAGE_SIGNING_IDENTITY)" Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg Install\ Wacom\ Tablet-5.3.7-6-patched.pkg
endif

Install\ Wacom\ Tablet-6.3.15-3-patched-unsigned.pkg : src/6.3.15-3/Install\ Wacom\ Tablet-6.3.15-3-original.pkg $(PATCHED_DRIVERS_6_3_15_3) src/6.3.15-3/Welcome.rtf src/6.3.15-3/postinstall.patched src/6.3.17-5/Wacom\ Desktop\ Center.app
	$(call unpack_package,"src/6.3.15-3/Install Wacom Tablet-6.3.15-3-original.pkg")

	# Add Welcome screen
	find package/Resources -type d -depth 1 -exec cp src/6.3.15-3/Welcome.rtf {}/ \;
	sed -i "" -E 's/(<\/installer-gui-script>)/    <welcome file="Welcome.rtf" mime-type="text\/richtext"\/>\1/' package/Distribution

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

ifdef CODE_SIGNING_IDENTITY
	# Resign drivers and enable Hardened Runtime to meet notarization requirements
	codesign -s "$(CODE_SIGNING_IDENTITY)" -f --options=runtime --timestamp $(SIGN_ME_6)
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

build/ :
	mkdir build

# Extract original files from the Wacom installers as needed

$(EXTRACTED_DRIVERS_5_3_7_6) : src/5.3.7-6/Install\ Wacom\ Tablet-5.3.7-6-original.pkg
	$(call unpack_package,"$<")

	cp package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/MacOS/PenTabletDriver src/5.3.7-6/PenTabletDriver.original
	cp package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app/Contents/MacOS/ConsumerTouchDriver src/5.3.7-6/ConsumerTouchDriver.original
	cp package/content.pkg/Scripts/preinstall src/5.3.7-6/preinstall.original
	cp package/content.pkg/Scripts/postinstall src/5.3.7-6/postinstall.original

$(EXTRACTED_DRIVERS_6_3_15_3) : src/6.3.15-3/Install\ Wacom\ Tablet-6.3.15-3-original.pkg
	$(call unpack_package,"$<")

	cp package/content.pkg/Scripts/postinstall src/6.3.15-3/postinstall.original
	cp package/content.pkg/Payload/Library/PreferencePanes/WacomTablet.prefpane/Contents/MacOS/WacomTablet src/6.3.15-3/WacomTablet.original
	cp package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletDriver.app/Contents/MacOS/WacomTabletDriver src/6.3.15-3/WacomTabletDriver.original

$(EXTRACTED_DRIVERS_6_3_17_5) : src/6.3.17-5/Install\ Wacom\ Tablet-6.3.17-5-original.pkg
	$(call unpack_package,"$<")

	cp -a package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app src/6.3.17-5/

%.patched : %.original %.patch
	cp $*.original $*.patched
	patch $*.patched < $*.patch

# Utility commands:

notarize-5: Install\ Wacom\ Tablet-5.3.7-6-patched.pkg
	xcrun altool \
		 --notarize-app \
		 --primary-bundle-id "com.wacom.pentablet" \
		 --username "$(NOTARIZATION_USERNAME)" \
		 --password "@keychain:AC_PASSWORD" \
		 --file "$<"
	cp "$<" "Install Wacom Tablet-5.3.7-6-patched-notarized.pkg"

notarize-6: Install\ Wacom\ Tablet-6.3.15-3-patched.pkg
	xcrun altool \
		 --notarize-app \
		 --primary-bundle-id "com.wacom.pentablet" \
		 --username "$(NOTARIZATION_USERNAME)" \
		 --password "@keychain:AC_PASSWORD" \
		 --file "$<"
	cp "$<" "Install Wacom Tablet-6.3.15-3-patched-notarized.pkg"

staple-5:
	xcrun stapler staple "Install Wacom Tablet-5.3.7-6-patched.pkg"
	cp "Install Wacom Tablet-5.3.7-6-patched.pkg" "Install Wacom Tablet-5.3.7-6-patched-stapled.pkg"

staple-6:
	xcrun stapler staple "Install Wacom Tablet-6.3.15-3-patched.pkg"
	cp "Install Wacom Tablet-6.3.15-3-patched.pkg" "Install Wacom Tablet-6.3.15-3-patched-stapled.pkg"

unpack-5 :
	$(call unpack_package,"src/5.3.7-6/Install Wacom Tablet-5.3.7-6-original.pkg")

unpack-6 :
	$(call unpack_package,"src/6.3.15-3/Install Wacom Tablet-6.3.15-3-original.pkg")

unbless-5:
	xattr -w com.apple.quarantine "0181;5e33ca0a;Chrome;AEDC174C-8684-476E-9E4C-764D063A714C" Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg

unbless-6:
	xattr -w com.apple.quarantine "0181;5e33ca0a;Chrome;AEDC174C-8684-476E-9E4C-764D063A714C" Install\ Wacom\ Tablet-6.3.15-3-patched-unsigned.pkg

clean :
	rm -rf src/6.3.17-5/Wacom\ Desktop\ Center.app
	rm -f \
		wacom-5.3.7-6-macOS-patched.zip  Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg  Install\ Wacom\ Tablet-5.3.7-6-patched.pkg \
		wacom-6.3.15-3-macOS-patched.zip Install\ Wacom\ Tablet-6.3.15-3-patched-unsigned.pkg Install\ Wacom\ Tablet-6.3.15-3-patched.pkg \
		build/* $(PATCHED_DRIVERS) $(EXTRACTED_DRIVERS)
	rm -rf package
# Delete these two lines in order to build a fully unsigned installer:
CODE_SIGNING_IDENTITY=Developer ID Application: Nicholas Sherlock (8J3T27D935)
PACKAGE_SIGNING_IDENTITY=Developer ID Installer: Nicholas Sherlock (8J3T27D935)

NOTARIZATION_USERNAME=n.sherlock@gmail.com

PATCHED_DRIVERS_5_2_6_5= \
	src/5.2.6-5/postflight.patched \
	src/5.2.6-5/preflight.patched

PATCHED_DRIVERS_5_3_7_6= \
	src/5.3.7-6/PenTabletDriver.patched \
	src/5.3.7-6/ConsumerTouchDriver.patched \
	src/5.3.7-6/preinstall.patched \
	src/5.3.7-6/postinstall.patched

PATCHED_DRIVERS_6_3_15_3= \
	src/6.3.15-3/WacomTablet.patched \
	src/6.3.15-3/postinstall.patched \
	src/6.3.15-3/WacomTabletDriver.patched

PATCHED_DRIVERS=$(PATCHED_DRIVERS_5_2_6_5) $(PATCHED_DRIVERS_5_3_7_6) $(PATCHED_DRIVERS_6_3_15_3)

EXTRACTED_DRIVERS_5_2_6_5= \
	src/5.2.6-5/postflight.original \
	src/5.2.6-5/preflight.original

EXTRACTED_DRIVERS_5_3_0_3= \
	src/5.3.0-3/Install\ Bamboo.pkg

EXTRACTED_DRIVERS_5_3_7_6= \
	src/5.3.7-6/PenTabletDriver.original \
	src/5.3.7-6/ConsumerTouchDriver.original \
	src/5.3.7-6/preinstall.original \
	src/5.3.7-6/postinstall.original \
	src/5.3.7-6/renumtablets

EXTRACTED_DRIVERS_6_3_15_3= \
	src/6.3.15-3/WacomTablet.original \
	src/6.3.15-3/postinstall.original \
	src/6.3.15-3/WacomTabletDriver.original

EXTRACTED_DRIVERS_6_3_17_5= \
	src/6.3.17-5/Wacom\ Desktop\ Center.app

EXTRACTED_DRIVERS=$(EXTRACTED_DRIVERS_5_2_6_5) $(EXTRACTED_DRIVERS_5_3_0_3) $(EXTRACTED_DRIVERS_5_3_7_6) $(EXTRACTED_DRIVERS_6_3_15_3) $(EXTRACTED_DRIVERS_6_3_17_5)

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

SIGN_ME_5_3_7_6= \
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
	src/5.3.0-3/ src/6.3.17-5/ \
	wacom-5.3.7-6-macOS-patched.zip  Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg \
	wacom-6.3.15-3-macOS-patched.zip Install\ Wacom\ Tablet-6.3.15-3-patched-unsigned.pkg

release : \
	src/5.3.0-3/ src/6.3.17-5/ \
	wacom-5.3.7-6-macOS-patched.zip Install\ Wacom\ Tablet-5.3.7-6-patched.pkg \
	wacom-6.3.15-3-macOS-patched.zip Install\ Wacom\ Tablet-6.3.15-3-patched.pkg

wacom-5.3.7-6-macOS-patched.zip : $(PATCHED_DRIVERS_5_3_7_6) build/ build/Readme.html
	rm -f $@
	cp src/5.3.7-6/PenTabletDriver.patched build/PenTabletDriver
	cp src/5.3.7-6/ConsumerTouchDriver.patched build/ConsumerTouchDriver
	cd build && zip --must-match ../$@ PenTabletDriver ConsumerTouchDriver Readme.html

wacom-6.3.15-3-macOS-patched.zip : $(PATCHED_DRIVERS_6_3_15_3) build/ build/Readme.html
	rm -f $@
	cp src/6.3.15-3/WacomTablet.patched build/WacomTablet
	cp src/6.3.15-3/WacomTabletDriver.patched build/WacomTabletDriver
	cd build && zip --must-match ../$@ WacomTablet WacomTabletDriver Readme.html

build/Readme.html : Readme-manual-installation.md build/ src/readme-prologue.html src/readme-epilogue.html
	# Rendering documentation markdown using marked: https://www.npmjs.com/package/marked
	# Removes the section which tells the user to unpack the zip, since they've done that already
	( \
		cat src/readme-prologue.html; \
		perl -0777 -pe 's/Make sure you already.*then follow the/To install the fix for your Wacom driver, follow the/igs' $< | marked --gfm; \
 		cat src/readme-epilogue.html \
	) > $@

# Create the installer package by modifying Wacom's original

Install\ Wacom\ Tablet-5.2.6-5-patched-unsigned.pkg : src/5.2.6-5/Install\ Bamboo.pkg src/5.2.6-5/Welcome.rtf src/5.2.6-5/PackageInfo src/5.2.6-5/Distribution src/5.2.6-5/preflight.patched src/5.2.6-5/postflight.patched src/5.3.7-6/renumtablets
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

	# Move scripts into new style directory
	mv package/Resources/{preflight,postflight} package/content.pkg/Scripts/

	# Install patched postinstall script: Don't call old multitouch install method, use new language manifest loader code from 5.3.7-6, new agent loader
	cp src/5.2.6-5/postflight.patched package/content.pkg/Scripts/postflight
	# New agent unloader
	cp src/5.2.6-5/preflight.patched  package/content.pkg/Scripts/preflight

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

	# Don't install files into the /System partition (not allowed in Catalina)
	mv package/content.pkg/Payload/System/Library/Extensions package/content.pkg/Payload/Library/
	rm -r package/content.pkg/Payload/System

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
	( cd package/content.pkg/Payload && find . | cpio -o --format odc --owner 0:80 ) | gzip -c > package/content.pkg/Payload.gz
	rm -rf package/content.pkg/Payload
	mv package/content.pkg/Payload.gz package/content.pkg/Payload

	# Repack installer
	pkgutil --flatten package "$@"

ifdef PACKAGE_SIGNING_IDENTITY
Install\ Wacom\ Tablet-5.2.6-5-patched.pkg : Install\ Wacom\ Tablet-5.2.6-5-patched-unsigned.pkg
	productsign --sign "$(PACKAGE_SIGNING_IDENTITY)" Install\ Wacom\ Tablet-5.2.6-5-patched-unsigned.pkg Install\ Wacom\ Tablet-5.2.6-5-patched.pkg
endif

Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg : src/5.3.7-6/Install\ Wacom\ Tablet.pkg $(PATCHED_DRIVERS_5_3_7_6) src/5.3.7-6/Welcome.rtf
	$(call unpack_package,"src/5.3.7-6/Install Wacom Tablet.pkg")

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
	codesign -s "$(CODE_SIGNING_IDENTITY)" -f --options=runtime --timestamp $(SIGN_ME_5_3_7_6)
else
	codesign --remove-signature $(SIGN_ME_5_3_7_6)
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

Install\ Wacom\ Tablet-6.3.15-3-patched-unsigned.pkg : src/6.3.15-3/Install\ Wacom\ Tablet.pkg $(PATCHED_DRIVERS_6_3_15_3) src/6.3.15-3/Welcome.rtf src/6.3.15-3/postinstall.patched src/6.3.17-5/Wacom\ Desktop\ Center.app
	$(call unpack_package,"src/6.3.15-3/Install Wacom Tablet.pkg")

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
else
	codesign --remove-signature $(SIGN_ME_6)
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

# Download, mount and unpack original Wacom installers:

# Graphire 3
src/5.2.6-5/PenTablet_5.2.6-5.dmg :
	curl -o $@ "https://cdn.wacom.com/U/productsupport/Drivers/Mac/Consumer/PenTablet_5.2.6-5.dmg"
	[ $$(md5 $@ | awk '{ print $$4 }') = "548d92f2a55e6f17c63242f5e7a521fa" ] || (rm $@; false) # Verify download is undamaged

# Files to add to Graphire 3
src/5.3.0-3/PenTablet_5.3.0-3.dmg :
	curl -o $@ "https://cdn.wacom.com/U/Drivers/Mac/Consumer/530/PenTablet_5.3.0-3.dmg"
	[ $$(md5 $@ | awk '{ print $$4 }') = "a362794f7a84470407884c5a033c2624" ] || (rm $@; false) # Verify download is undamaged

# Bamboo
src/5.3.7-6/pentablet_5.3.7-6.dmg :
	curl -o $@ "https://cdn.wacom.com/u/productsupport/drivers/mac/consumer/pentablet_5.3.7-6.dmg"
	[ $$(md5 $@ | awk '{ print $$4 }') = "3d87c6c5ca73d9f361a21fe2c2e940e2" ] || (rm $@; false) # Verify download is undamaged

# Intuos 3 / Cintiq 1st gen
src/6.3.15-3/pentablet_6.3.15-3.dmg :
	curl -o $@ "https://cdn.wacom.com/u/productsupport/drivers/mac/professional/WacomTablet_6.3.15-3.dmg"
	[ $$(md5 $@ | awk '{ print $$4 }') = "b16906fea82d7375b3e8edee973663f5" ] || (rm $@; false) # Verify download is undamaged

# Just for a signable version of Wacom Desktop Center
src/6.3.17-5/pentablet_6.3.17-5.dmg :
	curl -o $@ "https://cdn.wacom.com/u/productsupport/drivers/mac/professional/WacomTablet_6.3.17-5.dmg"
	[ $$(md5 $@ | awk '{ print $$4 }') = "42dafc4250df4649f1a122578425bbad" ] || (rm $@; false) # Verify download is undamaged

src/6.3.17-5/ src/5.3.0-3/ :
	mkdir $@

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

src/5.3.0-3/Install\ Bamboo.pkg : src/5.3.0-3/PenTablet_5.3.0-3.dmg
	hdiutil attach -quiet -nobrowse -mountpoint src/5.3.0-3/dmg "$<"
	rm -rf "$@"
	cp -a "src/5.3.0-3/dmg/Install Bamboo.pkg" "$@"
	# The permissions on the package files are super awkward, make those more permissive for us:
	find "src/5.3.0-3/Install Bamboo.pkg" -type d -exec chmod 0755 {} \;
	find "src/5.3.0-3/Install Bamboo.pkg" -type f -exec chmod u+rw {} \;
	hdiutil detach -force src/5.3.0-3/dmg
	touch "$@"

src/5.3.7-6/Install\ Wacom\ Tablet.pkg : src/5.3.7-6/pentablet_5.3.7-6.dmg
	hdiutil attach -quiet -nobrowse -mountpoint src/5.3.7-6/dmg "$<"
	cp "src/5.3.7-6/dmg/Install Wacom Tablet.pkg" "$@"
	hdiutil detach -force src/5.3.7-6/dmg

src/6.3.15-3/Install\ Wacom\ Tablet.pkg : src/6.3.15-3/pentablet_6.3.15-3.dmg
	hdiutil attach -quiet -nobrowse -mountpoint src/6.3.15-3/dmg "$<"
	cp "src/6.3.15-3/dmg/Install Wacom Tablet.pkg" "$@"
	hdiutil detach -force src/6.3.15-3/dmg

src/6.3.17-5/Install\ Wacom\ Tablet.pkg : src/6.3.17-5/pentablet_6.3.17-5.dmg
	hdiutil attach -quiet -nobrowse -mountpoint src/6.3.17-5/dmg "$<"
	cp "src/6.3.17-5/dmg/Install Wacom Tablet.pkg" "$@"
	hdiutil detach -force src/6.3.17-5/dmg

# Extract original files from the Wacom installers as needed

$(EXTRACTED_DRIVERS_5_2_6_5) : src/5.2.6-5/Install\ Bamboo.pkg
	cp src/5.2.6-5/Install\ Bamboo.pkg/Contents/Resources/postflight src/5.2.6-5/postflight.original

$(EXTRACTED_DRIVERS_5_3_7_6) : src/5.3.7-6/Install\ Wacom\ Tablet.pkg
	$(call unpack_package,"$<")

	cp package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/MacOS/PenTabletDriver src/5.3.7-6/PenTabletDriver.original
	cp package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app/Contents/MacOS/ConsumerTouchDriver src/5.3.7-6/ConsumerTouchDriver.original
	cp package/content.pkg/Scripts/preinstall   src/5.3.7-6/preinstall.original
	cp package/content.pkg/Scripts/postinstall  src/5.3.7-6/postinstall.original
	cp package/content.pkg/Scripts/renumtablets src/5.3.7-6/renumtablets

$(EXTRACTED_DRIVERS_6_3_15_3) : src/6.3.15-3/Install\ Wacom\ Tablet.pkg
	$(call unpack_package,"$<")

	cp package/content.pkg/Scripts/postinstall src/6.3.15-3/postinstall.original
	cp package/content.pkg/Payload/Library/PreferencePanes/WacomTablet.prefpane/Contents/MacOS/WacomTablet src/6.3.15-3/WacomTablet.original
	cp package/content.pkg/Payload/Library/Application\ Support/Tablet/WacomTabletDriver.app/Contents/MacOS/WacomTabletDriver src/6.3.15-3/WacomTabletDriver.original

$(EXTRACTED_DRIVERS_6_3_17_5) : src/6.3.17-5/Install\ Wacom\ Tablet.pkg
	$(call unpack_package,"$<")

	cp -a package/content.pkg/Payload/Applications/Wacom\ Tablet.localized/Wacom\ Desktop\ Center.app src/6.3.17-5/

%.patched : %.original %.patch
	cp $*.original $*.patched
	patch $*.patched < $*.patch

# Utility commands:

notarize-graphire: Install\ Wacom\ Tablet-5.2.6-5-patched.pkg
	xcrun altool \
		 --notarize-app \
		 --primary-bundle-id "com.wacom.pentablet" \
		 --username "$(NOTARIZATION_USERNAME)" \
		 --password "@keychain:AC_PASSWORD" \
		 --file "$<"
	cp "$<" "Install Wacom Tablet-5.2.6-5-patched-notarized.pkg"

notarize-bamboo: Install\ Wacom\ Tablet-5.3.7-6-patched.pkg
	xcrun altool \
		 --notarize-app \
		 --primary-bundle-id "com.wacom.pentablet" \
		 --username "$(NOTARIZATION_USERNAME)" \
		 --password "@keychain:AC_PASSWORD" \
		 --file "$<"
	cp "$<" "Install Wacom Tablet-5.3.7-6-patched-notarized.pkg"

notarize-intuos: Install\ Wacom\ Tablet-6.3.15-3-patched.pkg
	xcrun altool \
		 --notarize-app \
		 --primary-bundle-id "com.wacom.pentablet" \
		 --username "$(NOTARIZATION_USERNAME)" \
		 --password "@keychain:AC_PASSWORD" \
		 --file "$<"
	cp "$<" "Install Wacom Tablet-6.3.15-3-patched-notarized.pkg"

staple-graphire:
	xcrun stapler staple "Install Wacom Tablet-5.2.6-5-patched.pkg"
	cp "Install Wacom Tablet-5.2.6-5-patched.pkg" "Install Wacom Tablet-5.2.6-5-patched-stapled.pkg"

staple-bamboo:
	xcrun stapler staple "Install Wacom Tablet-5.3.7-6-patched.pkg"
	cp "Install Wacom Tablet-5.3.7-6-patched.pkg" "Install Wacom Tablet-5.3.7-6-patched-stapled.pkg"

staple-intuos:
	xcrun stapler staple "Install Wacom Tablet-6.3.15-3-patched.pkg"
	cp "Install Wacom Tablet-6.3.15-3-patched.pkg" "Install Wacom Tablet-6.3.15-3-patched-stapled.pkg"

unpack-graphire : src/5.2.6-5/Install\ Bamboo.pkg
	mkdir -p src/5.2.6-5/Install\ Bamboo.pkg/Contents/Archive
	cd src/5.2.6-5/Install\ Bamboo.pkg/Contents/Archive && tar --no-same-owner -xf ../Archive.pax.gz

unpack-bamboo : src/5.3.7-6/Install\ Wacom\ Tablet.pkg
	$(call unpack_package,"$<")

unpack-intuos : src/6.3.15-3/Install\ Wacom\ Tablet.pkg
	$(call unpack_package,"$<")

unbless-bamboo:
	xattr -w com.apple.quarantine "0181;5e33ca0a;Chrome;AEDC174C-8684-476E-9E4C-764D063A714C" Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg

unbless-intuos:
	xattr -w com.apple.quarantine "0181;5e33ca0a;Chrome;AEDC174C-8684-476E-9E4C-764D063A714C" Install\ Wacom\ Tablet-6.3.15-3-patched-unsigned.pkg

clean :
	rm -rf src/6.3.17-5/Wacom\ Desktop\ Center.app src/5.3.0-3/Install\ Bamboo.pkg
	rm -f \
		wacom-5.3.7-6-macOS-patched.zip  Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg  Install\ Wacom\ Tablet-5.3.7-6-patched.pkg \
		wacom-6.3.15-3-macOS-patched.zip Install\ Wacom\ Tablet-6.3.15-3-patched-unsigned.pkg Install\ Wacom\ Tablet-6.3.15-3-patched.pkg \
		build/* $(PATCHED_DRIVERS) $(EXTRACTED_DRIVERS)
	rm -rf package
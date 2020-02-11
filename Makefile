CODE_SIGNING_IDENTITY=Developer ID Application: Nicholas Sherlock (8J3T27D935)
PACKAGE_SIGNING_IDENTITY=Developer ID Installer: Nicholas Sherlock (8J3T27D935)

NOTARIZATION_USERNAME=n.sherlock@gmail.com

PATCHED_DRIVERS= \
	drivers/PenTabletDriver-5.3.7-6.patched \
	drivers/ConsumerTouchDriver-5.3.7-6.patched \
	drivers/preinstall.patched \
	drivers/postinstall.patched

EXTRACTED_DRIVERS= \
	drivers/PenTabletDriver-5.3.7-6.original \
	drivers/ConsumerTouchDriver-5.3.7-6.original \
	drivers/preinstall.original \
	drivers/postinstall.original

SIGN_ME= \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/TabletDriver.app \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app \
	package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app \
	package/content.pkg/Payload/Library/Frameworks/WacomMultiTouch.framework/Versions/A/WacomMultiTouch \
	package/content.pkg/Payload/Library/PrivilegedHelperTools/com.wacom.TabletHelper.app/Contents/MacOS/com.wacom.TabletHelper \
	package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app/Contents/Library/LaunchServices/com.wacom.RemoveTabletHelper \
	package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app/Contents/Resources/SystemLoginItemTool \
	package/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app \
	package/content.pkg/Scripts/renumtablets

.DUMMY: all release unpack unbless notarize clean

all : wacom-5.3.7-6-macOS-patched.zip Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg

release : wacom-5.3.7-6-macOS-patched.zip Install\ Wacom\ Tablet-5.3.7-6-patched.pkg

wacom-5.3.7-6-macOS-patched.zip : $(PATCHED_DRIVERS) build/
	rm -f $@
	cp drivers/PenTabletDriver-5.3.7-6.patched build/PenTabletDriver
	cp drivers/ConsumerTouchDriver-5.3.7-6.patched build/ConsumerTouchDriver
	cp Readme.md build/
	cd build && zip ../$@ PenTabletDriver ConsumerTouchDriver Readme.md

# Create the installer package by modifying Wacom's original
Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg : drivers/Install\ Wacom\ Tablet-5.3.7-6-original.pkg $(PATCHED_DRIVERS) drivers/Welcome.rtf
	rm -rf package
	pkgutil --expand-full drivers/Install\ Wacom\ Tablet-5.3.7-6-original.pkg package

	# Add Welcome screen
	find package/Resources -type d -depth 1 -exec cp drivers/Welcome.rtf {}/ \;
	sed -i "" -E 's/(<\/installer-gui-script>)/    <welcome file="Welcome.rtf" mime-type="text\/richtext"\/>\1/' package/Distribution

	# Add patched drivers
	cp drivers/PenTabletDriver-5.3.7-6.patched package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/MacOS/PenTabletDriver
	cp drivers/ConsumerTouchDriver-5.3.7-6.patched package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app/Contents/MacOS/ConsumerTouchDriver
	cp drivers/preinstall.patched package/content.pkg/Scripts/preinstall
	cp drivers/postinstall.patched package/content.pkg/Scripts/postinstall
	cp drivers/unloadagent drivers/loadagent package/content.pkg/Scripts/

ifdef CODE_SIGNING_IDENTITY
	# Resign drivers and enable Hardened Runtime to meet notarization requirements
	codesign -s "$(CODE_SIGNING_IDENTITY)" -f --options=runtime --timestamp $(SIGN_ME)
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
	pkgutil --flatten package Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg

ifdef PACKAGE_SIGNING_IDENTITY
Install\ Wacom\ Tablet-5.3.7-6-patched.pkg : Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg
	productsign --sign "$(PACKAGE_SIGNING_IDENTITY)" Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg Install\ Wacom\ Tablet-5.3.7-6-patched.pkg
endif

build/ :
	mkdir build

# Extract original files from the Wacom installer as needed
$(EXTRACTED_DRIVERS) : drivers/Install\ Wacom\ Tablet-5.3.7-6-original.pkg
	rm -rf package
	pkgutil --expand-full drivers/Install\ Wacom\ Tablet-5.3.7-6-original.pkg package
	cp package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/MacOS/PenTabletDriver drivers/PenTabletDriver-5.3.7-6.original
	cp package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app/Contents/MacOS/ConsumerTouchDriver drivers/ConsumerTouchDriver-5.3.7-6.original
	cp package/content.pkg/Scripts/preinstall drivers/preinstall.original
	cp package/content.pkg/Scripts/postinstall drivers/postinstall.original

%.patched : %.original %.patch
	cp $*.original $*.patched
	patch $*.patched < $*.patch

# Utility commands:

notarize: Install\ Wacom\ Tablet-5.3.7-6-patched.pkg
	xcrun altool \
		 --notarize-app \
		 --primary-bundle-id "com.wacom.pentablet" \
		 --username "$(NOTARIZATION_USERNAME)" \
		 --password "@keychain:AC_PASSWORD" \
		 --file "$<"
	cp "$<" "Install Wacom Tablet-5.3.7-6-patched-notarized.pkg"

staple:
	xcrun stapler staple "Install Wacom Tablet-5.3.7-6-patched.pkg"
	cp "Install Wacom Tablet-5.3.7-6-patched.pkg" "Install Wacom Tablet-5.3.7-6-patched-stapled.pkg"

unpack :
	rm -rf package
	pkgutil --expand-full drivers/Install\ Wacom\ Tablet-5.3.7-6-original.pkg package

unbless:
	xattr -w com.apple.quarantine "0181;5e33ca0a;Chrome;AEDC174C-8684-476E-9E4C-764D063A714C" Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg

clean :
	rm -f wacom-5.3.7-6-macOS-patched.zip Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg \
		Install\ Wacom\ Tablet-5.3.7-6-patched.pkg build/* $(PATCHED_DRIVERS) $(EXTRACTED_DRIVERS)
	rm -rf package
CODE_SIGNING_IDENTITY=Developer ID Application: Nicholas Sherlock (8J3T27D935)
PACKAGE_SIGNING_IDENTITY=Developer ID Installer: Nicholas Sherlock (8J3T27D935)

NOTARIZATION_USERNAME=n.sherlock@gmail.com

PATCHED_DRIVERS=drivers/PenTabletDriver-5.3.7-6.patched drivers/ConsumerTouchDriver-5.3.7-6.patched

.DUMMY: release unpack unbless notarize clean

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

	# Remove bad code signature on TabletDriver (the sibling packages were never signed in the first place)
	codesign --remove-signature package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/TabletDriver.app

	# Recreate BOM
	mkbom package/content.pkg/Payload package/content.pkg/Bom

	# Repack payload
	( cd package/content.pkg/Payload && find . | cpio -o --format odc --owner 0:80 | gzip -c ) > package/content.pkg/Payload.gz
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

# Extract original drivers from the Wacom installer as needed
drivers/PenTabletDriver-5.3.7-6.original drivers/ConsumerTouchDriver-5.3.7-6.original : drivers/Install\ Wacom\ Tablet-5.3.7-6-original.pkg
	rm -rf package
	pkgutil --expand-full drivers/Install\ Wacom\ Tablet-5.3.7-6-original.pkg package
	cp package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/MacOS/PenTabletDriver drivers/PenTabletDriver-5.3.7-6.original
	cp package/content.pkg/Payload/Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app/Contents/MacOS/ConsumerTouchDriver drivers/ConsumerTouchDriver-5.3.7-6.original

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
	rm -f wacom-5.3.7-6-macOS-patched.zip Install\ Wacom\ Tablet-5.3.7-6-patched-unsigned.pkg Install\ Wacom\ Tablet-5.3.7-6-patched.pkg build/* $(PATCHED_DRIVERS)
# Delete these two lines in order to build a fully unsigned installer:
CODE_SIGNING_IDENTITY=Developer ID Application: Nicholas Sherlock (8J3T27D935)
PACKAGE_SIGNING_IDENTITY=Developer ID Installer: Nicholas Sherlock (8J3T27D935)

# This is only used when you explicitly call the notarize-* targets, which you won't need to do
NOTARIZATION_KEYCHAIN_PROFILE=n.sherlock

# The included driver makefiles append to these variables:
PATCHED_DRIVERS=
EXTRACTED_DRIVERS=

UNSIGNED_INSTALLERS=
SIGNED_INSTALLERS=

CREATE_DIRECTORIES=

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

.PHONY: \
	all really-all release clean \
	unpack-bamboo unpack-intuos unpack-graphire3 unpack-graphire4 \
	unbless-bamboo unbless-intuos \
	notarize-bamboo notarize-graphire2 notarize-graphire3 notarize-graphire4 \
	staple-bamboo staple-intuos staple-graphire2 staple-graphire3 staple-graphire4

# This target is here so it's the first one in the file, but...
all : really-all

# Wacom drivers to build installers for:
include src/Makefile-bamboo.mk
include src/Makefile-graphire2.mk
include src/Makefile-graphire3.mk
include src/Makefile-graphire4.mk
include src/Makefile-intuos3.mk

# Additional Wacom drivers which are just used as sources for files:
include src/Makefile-6.3.4-3.mk
include src/Makefile-6.3.7-1.mk
include src/Makefile-6.3.17-5.mk

# ... we can only reference the variables we need for the "all" target after first including the other makefiles
really-all: \
	$(CREATE_DIRECTORIES) \
	$(UNSIGNED_INSTALLERS)

release : \
	$(CREATE_DIRECTORIES) \
	$(SIGNED_INSTALLERS)

$(CREATE_DIRECTORIES) :
	mkdir $@

%.patched : %.original %.patch
	cp $*.original $*.patched
	patch $*.patched < $*.patch

%.bin : %.asm
	yasm -f bin -o $@ $<

# Tools we need for the build:

tools/fix_LC_VERSION_MIN_MACOSX/fixSDKVersion : tools/fix_LC_VERSION_MIN_MACOSX/fix_LC_VERSION_MIN_MACOSX.c
	$(CC) -o $@ $<

tools/fix_LC_VERSION_MIN_MACOSX/fix_LC_VERSION_MIN_MACOSX.c :
	git submodule update --init

.venv/ :
	python3 -m venv .venv
	./.venv/bin/pip3 install -q -r tools/extend-mach-o/requirements.txt

# Utility commands:

clean :
	rm -rf src/5.2.6-5/Install\ Bamboo.pkg src/6.3.17-5/Wacom\ Desktop\ Center.app src/5.3.0-3/Install\ Bamboo.pkg src/6.1.6-4/Install\ Wacom\ Tablet.pkg
	rm -rf \
		$(UNSIGNED_INSTALLERS) $(SIGNED_INSTALLERS) \
		$(PATCHED_DRIVERS) $(EXTRACTED_DRIVERS)
	rm -rf package

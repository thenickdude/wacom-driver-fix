# Manual fix installation

Make sure you already have the correct Wacom driver installed ([Wacom 5.3.7-6 for Bamboo tablets](http://cdn.wacom.com/u/productsupport/drivers/mac/consumer/pentablet_5.3.7-6.dmg)
or [Wacom 6.3.15-3 for Intuos 3 and Cintiq tablets](http://cdn.wacom.com/u/productsupport/drivers/mac/professional/WacomTablet_6.3.15-3.dmg)), 
because the manual method only replaces a couple of the driver's files and doesn't install the complete driver itself.

Now download my patch for your tablet here:

- [Manual patch 5.3.7-6 for Bamboo tablets](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-5/wacom-5.3.7-6-macOS-patched.zip)
- [Manual patch 6.3.15-3 for Intuos 3 and Cintiq tablets](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-5/wacom-6.3.15-3-macOS-patched.zip)
- Manual installation is not available for Graphire 4 tablets, use the installer instead

Unzip it by double clicking it, then follow the installation instructions that match your tablet:

### Bamboo tablets

First make sure that the Wacom driver is not loaded by running this command in Terminal (paste it in, then press enter to
run it):

    launchctl unload /Library/LaunchAgents/com.wacom.pentablet.plist

The unpacked zip file you downloaded will give you files called "PenTabletDriver" and "ConsumerTouchDriver".
 
In Finder, click "Go -> Go to Folder" (or press Command + Shift + G), then paste this path in the pop-up window, 
and click Ok:

    /Library/Application Support/Tablet/PenTabletDriver.app/Contents/MacOS

You should see a file already in there called "PenTabletDriver". Move the new PenTabletDriver file from the zip file
in there to replace it, confirm that you want to overwrite it, and enter your login password to confirm.

**If your tablet supports touch** you have one more patch to install. In Finder, click "Go -> Go to Folder" and paste
this path:

    /Library/Application Support/Tablet/PenTabletDriver.app/Contents/Resources/ConsumerTouchDriver.app/Contents/MacOS

Copy the ConsumerTouchDriver file from the zip you downloaded and paste it over the ConsumerTouchDriver file you see
there, enter your password to confirm the replacement.

**We're done installing patches**, so back in the terminal, run:

    launchctl load -w /Library/LaunchAgents/com.wacom.pentablet.plist

After installing, follow the "post-install instructions" section to set the permissions properly.

### Intuos 3 and Cintiq 1st gen tablets

The unpacked zip you downloaded will give you files called "WacomDriver" and "WacomTabletDriver".
 
In Finder, click "Go -> Go to Folder" (or press Command + Shift + G), then paste this path in the pop-up window, 
and click Ok:

     /Library/PreferencePanes/WacomTablet.prefpane/Contents/MacOS

You should see a file already in there called "WacomDriver". Move the new WacomDriver file from the zip file
in there to replace it, confirm that you want to overwrite it, and enter your login password to confirm.

In Finder, click "Go -> Go to Folder" (or press Command + Shift + G), then paste this path in the pop-up window, 
and click Ok:

     /Library/Application Support/Tablet/WacomTabletDriver.app/Contents/MacOS

Move the new WacomTabletDriver file from the zip file in there to replace the existing one.

Now either restart your computer, or run these two command using the terminal, to reload the tablet driver:

    launchctl unload /Library/LaunchAgents/com.wacom.wacomtablet.plist

    launchctl load -w /Library/LaunchAgents/com.wacom.wacomtablet.plist

Now open System Preferences and try using the Wacom Tablet preference pane, it should be working now.

If you are still having issues with your tablet, follow the next "post-install instructions" section.

## Post-install instructions

Touch your pen tip to your tablet, and it should prompt you visit System Preferences > Security & Privacy > Privacy Tab
to grant the tablet permissions. 

On the Accessibility page, click the padlock to unlock the page, then find and tick any `PenTabletDriver`, `WacomTabletDriver` 
`TabletDriver` or `WacomTabletSpringboard` entries you see in the list. Do the same on the Input Monitoring page.

If your tablet supports touch, touch the tablet with your finger, it should again prompt you to grant permissions. 
On the Accessibility page, tick the `ConsumerTouchDriver` or `WacomTouchDriver` entry. 

For Intuos 3 and Cintiq tablets, the driver might only appear on the Input Monitoring page, and you may need to reboot a second time
for it to appear on the Accessibility page too.

**If your Wacom preference pane, pen support, or touch support is not yet working, or the entries never appeared in the
list for you,** you likely had permissions left over from the previous tablet driver, and these stale entries all need to 
be removed like so:

On the "Accessibility" page of Security & Privacy, Find anything related to Wacom in the list (e.g. `PenTabletDriver`, 
`WacomTabletDriver`, `TabletDriver`,  `ConsumerTouchDriver`, `WacomTabletSpringboard`, `WacomTouchDriver`), select them,
and click the minus button to remove them. Go to the "Input Monitoring page" and do the same there.

Now either reboot your computer, or run these two commands in the Terminal, to reload the tablet driver. For Bamboo tablets:

    launchctl unload /Library/LaunchAgents/com.wacom.pentablet.plist

    launchctl load -w /Library/LaunchAgents/com.wacom.pentablet.plist
    
For Intuos 3 and Cintiq tablets:

    launchctl unload /Library/LaunchAgents/com.wacom.wacomtablet.plist

    launchctl load -w /Library/LaunchAgents/com.wacom.wacomtablet.plist

This should restore the prompts to ask you to add permissions, so now begin the instructions in this section again.

## Support me

If you enjoyed having your tablet back in action, please consider sending me a tip!

[![Donate button](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CDPRHRDZUDZW4&source=url) 

This will help fund me and further development of these fixed drivers.

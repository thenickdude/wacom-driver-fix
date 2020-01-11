# Wacom 5.x macOS driver fix

**Wacom's 5.3.7-6 macOS driver has a bug in it** that causes it to completely fail to start
on macOS 10.15 Catalina (and likely other versions of macOS). This doesn't apply to the Windows driver, or to the
new 6.x series of drivers.

When you try to open the Wacom preference pane, you'll get an error message saying
"Waiting for synchronization", then finally "There is a problem with your tablet driver.
Please reboot your system. If the problem persists reinstall or update the driver".

This is a problem because the 5.3.7-6 driver is the last driver that supported these tablets:

- CTE-450, CTE-650 - Bamboo Fun / Bamboo Art Master (2007)
- CTE-460 - Bamboo One Pen
- CTF-430 - Bamboo One
- CTH-300, CTH300, CTH301K - Bamboo Pad
- CTH-460, CTH-660 - Bamboo Pen and Touch
- CTH-461 - Bamboo Fun Pen and Touch / Bamboo Craft / Bamboo Fun Special Edition
- CTH-470 - Bamboo Capture / Bamboo Pen & Touch / Bamboo Create
- CTH-661 - Bamboo Fun / Bamboo Art Master (2009) / Bamboo Fun Pen and Touch
- CTL-460, CTL-660 - Bamboo Pen 
- CTL-470 - Bamboo Connect / Bamboo Pen
- MTE-450 - Bamboo

Thankfully I was able to track down the issue and I have patched one of the driver's files to fix the issue!

I've tested this with CTL-460 Bamboo Pen on Catalina 10.15.2. 

## Does this bug apply to me?

If you are using macOS and have Wacom driver version 5.3.7-6 installed then this bug may be 
affecting you. [You can look up your tablet here](https://www.wacom.com/en-us/support/product-support/drivers) to see 
which driver version is recommended for your tablet.

To check if your system is affected, run this command in the terminal:

    /Library/Application\ Support/Tablet/PenTabletDriver.app/Contents/MacOS/PenTabletDriver
    
If it gives a message about a "segmentation fault" and finishes immediately, this bug is affecting you. For example:

    70602 segmentation fault

If you don't see a message like that then this bug isn't the reason for your tablet not working, sorry!

## Install the fix

You can either have everything installed for you automatically, or install the fixed files yourself manually, pick 
one of these options:

### Automatic method

Download the installer here and double click it to run it, this will install my fixed version of Wacom's 5.3.7-6 driver:

https://github.com/thenickdude/wacom-driver-fix/releases/download/5.3.7-6-patch-2/Install-Wacom-Tablet-5.3.7-6-patched.pkg

If you get an error message that your Mac only allows apps to be installed from the App Store, right-click on it and click
"Open" instead.

After installing, if the Wacom settings pane in System Preferences still doesn't function, restart your computer.

### Manual method

Make sure you already have the Wacom 5.3.7-6 driver installed, because the manual method only replaces one of the files
and doesn't install the complete driver itself.

First make sure that the Wacom driver is not loaded by running this command in Terminal:

    launchctl unload /Library/LaunchAgents/com.wacom.pentablet.plist
    
Now download the patched driver here:

https://github.com/thenickdude/wacom-driver-fix/releases/download/5.3.7-6-patch-2/wacom-5.3.7-6-macOS-patched.zip

Unzip it by double clicking it, and you'll get a file called "PenTabletDriver". In Finder, click "Go -> Go to Folder" 
(or press Command + Shift + G), then paste this path in the pop-up window, and click Ok:

    /Library/Application Support/Tablet/PenTabletDriver.app/Contents/MacOS

You should see a file already in there called "PenTabletDriver". Move the new PenTabletDriver file from the zip file
in there to replace it, confirm that you want to overwrite it, then enter your login password to confirm.

Back in the terminal, run:

    launchctl load /Library/LaunchAgents/com.wacom.pentablet.plist

Now your tablet driver should be operational and you should be able to use the Wacom preference pane in System 
Preferences.

If your tablet still isn't working, double check that in System Preferences -> Security & Privacy -> Accessibility, 
PenTabletDriver is ticked.

## Touch support

Currently there is still a bug in Wacom's touch driver which causes it to crash as soon as a
multi-touch operation is begun. I hope to fix this too soon.

## Support me

If you enjoyed having your tablet back in action, please consider sending me a tip!

[![Donate button](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CDPRHRDZUDZW4&source=url) 

This will help pay for my yearly Apple Developer registration fee.

## Technical details of the bug

PenTabletDriver launches two sub-drivers to do the work for it, ConsumerTouchDriver and TabletDriver. To find those drivers 
within its Resources folder it eventually calls this function to extract a path from a URL:

```cpp
CFString * MacPaths::PathFromURL(CFURL *url)
{
    CFString *path;

    path = _objc_retainAutoreleasedReturnValue(url->path());

    _objc_release(path); /* Whoops, now the path has only one owner, the url! */

    return path;
}
```

Forgive me for paraphrasing the original Objective C code as C++, I don't speak objc!

When the path is returned by CFURL by the call to `url->path()`, its reference count is 1 because the url object retains ownership
of it internally.

Then another reference is added by `_objc_retainAutoreleasedReturnValue`, bringing its reference count to 2.

But now the Wacom driver explicitly calls `_objc_release()` on the path. This means that the `url` object is now the only
owner of the path, so if the `url` object is released, it will destroy the path along with it! And that's exactly what 
the caller of this function does next: 

```cpp
CFString * MacPaths::GetBundleResourcePathOfType(CFString *resourceName, CFString *resourceType)
{
    CFString *mainBundle;
    CFURL *url;
    CFString *path = nullptr;
    
    if ((resourceName != nullptr) && (resourceType != nullptr)) {
        mainBundle = CFBundle::GetMainBundle();
        
        url = CFBundle::CopyResourceURL(mainBundle, resourceName, resourceType, 0);
        
        path = MacPaths::PathFromURL(url);
        
        if (url != nullptr) {
            CFRelease(url); /* path goes bye-bye here! */
        }
    }
    return path;
}
```

This freed path is used while launching the sub-driver, which can trigger a segfault in `ProcessUtils::LaunchApplicationWithBundleID()`. 
This kills the driver.

The patch is a single-byte change which replaces the call to `_objc_release()` in `PathFromURL` to a call to `_objc_retain()`.
This prevents the path from being freed before it is used, which cures the segfault.

The ConsumerTouchDriver also contains this same bug, and the patch is the same there.
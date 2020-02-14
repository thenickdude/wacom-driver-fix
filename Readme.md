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
- CTH-670 - Bamboo Create
- CTL-460, CTL-660 - Bamboo Pen 
- CTL-470 - Bamboo Connect / Bamboo Pen
- MTE-450 - Bamboo

Thankfully I was able to track down the issues and I have patched the drivers to fix them!

I've tested this with CTL-460 (Bamboo Pen) and CTH-470 (Bamboo Capture Pen and Touch Tablet) on Catalina 10.15.3. 

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

https://github.com/thenickdude/wacom-driver-fix/releases/download/5.3.7-6-patch-3/Install-Wacom-Tablet-5.3.7-6-patched.pkg

If you get an error message that your Mac only allows apps to be installed from the App Store, right-click on it and click
"Open" instead.

After installing, follow the "post-install instructions" section (further down this page) to set the permissions properly.

### Manual method

Make sure you already have the [Wacom 5.3.7-6 driver](http://cdn.wacom.com/u/productsupport/drivers/mac/consumer/pentablet_5.3.7-6.dmg) 
installed, because the manual method only replaces two of the files and doesn't install the complete driver itself.

First make sure that the Wacom driver is not loaded by running this command in Terminal (paste it in, then press enter to
run it):

    launchctl unload /Library/LaunchAgents/com.wacom.pentablet.plist
    
Now download the patched driver here:

https://github.com/thenickdude/wacom-driver-fix/releases/download/5.3.7-6-patch-3/wacom-5.3.7-6-macOS-patched.zip

Unzip it by double clicking it, and you'll get a file called "PenTabletDriver" and "ConsumerTouchDriver". 
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

    launchctl load /Library/LaunchAgents/com.wacom.pentablet.plist

After installing, follow the next "post-install instructions" section to set the permissions properly.

## Post-install instructions

Touch your pen tip to your tablet, and it should prompt you to open up the Accessibility page of your system "Security & Privacy" 
settings to grant the tablet permissions. 

On the Accessibility page, click the padlock to unlock the page, then find and tick the `PenTabletDriver` entry in the 
list. Do the same on the Input Monitoring page.

If your tablet supports touch, touch the tablet with your finger, it should again prompt you to grant permissions. 
On the Accessibility page, tick the `ConsumerTouchDriver` entry. 

If your Wacom preference pane, pen support, or touch support is not yet working, you'll need to clear out all those
permissions and try again:

On the Accessibility page of Security & Privacy, Find `PenTabletDriver` in the list, select it, and click the minus 
button to remove it, do the same with `ConsumerTouchDriver` if it's there. Go to the Input Monitoring page and do the 
same there.

Now either reboot your computer, or run these two commands in the Terminal, to reload the tablet driver:

    launchctl unload /Library/LaunchAgents/com.wacom.pentablet.plist

    launchctl load /Library/LaunchAgents/com.wacom.pentablet.plist

Now begin the instructions in this section again.

## Support me

If you enjoyed having your tablet back in action, please consider sending me a tip!

[![Donate button](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CDPRHRDZUDZW4&source=url) 

This will help pay for my yearly Apple Developer registration fee.

## Technical details of the bugs

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
    return path; /* Returning an object that has already been free'd! */
}
```

This freed path is used while launching the sub-driver, which can trigger a segfault in `ProcessUtils::LaunchApplicationWithBundleID()`. 
This kills the driver.

The fix is a single-byte change which replaces the call to `_objc_release()` in `PathFromURL` to a call to `_objc_retain()`.
This prevents the path from being freed before it is used, which cures the segfault.

The ConsumerTouchDriver also contains this same bug, and the patch is the same there. However the touch driver also needs
some fixes to stop it from crashing when a multi-touch gesture is performed.

When a gesture is performed, the function `CMacHIDGestureEventOSX1010::PostGesture` is responsible for sending that gesture
to the operating system: 

```cpp
void CMacHIDGestureEventOSX1010::PostGesture(EIOHIDEventType gestureType_I, int32_t eventDirAmount)
{
  __CFDataOSX1010 *eventStructure;
  
  if (gestureType_I == 61 /* kCGHIDEventTypeGestureStarted */) {
    this->eventPhase = 1 /* kCGSGesturePhaseBegan */;
  } else {
    this->eventPhase = 4 /* kCGSGesturePhaseEnded */;
    (**(code **)(*(long *)this + 0x18))(0,this,(uint32_t) eventDirAmount);
  }

  eventStructure = (__CFDataOSX1010 *) _CGEventCreate(0); // Dubious

  _CGEventSetType(eventStructure, 29 /* kCGSEventGesture */);

  eventStructure->eventSubType = gestureType_I;    // Relies on the exact memory layout of CGEvent (!)
  eventStructure->eventDirAmount = eventDirAmount; // Ditto

  _CGEventPost(0, eventStructure);
  _CFRelease(eventStructure);
}
```

Notice how the result from CGEventCreate is being cast to a structure? CGEvent is supposed to be [an opaque type](https://developer.apple.com/documentation/coregraphics/cgeventref?language=objc), programs
aren't supposed to know or rely on its layout, since its structure changes from OS version to OS version, but here it is
being cast to a structure so that its `eventSubType` and `eventDirAmount` fields can be assigned directly. These two 
writes cause heap corruption on Catalina and trigger a crash, because the layout of `CGEvent` has changed since Sierra! 

The proper way to store values into an event is by using the [CGEventSetIntegerValueField](https://developer.apple.com/documentation/coregraphics/1455556-cgeventsetintegervaluefield?language=objc) 
API, which allows you to refer to fields of CGEvent by a logical ID instead of their position in memory. So what are the
equivalent field IDs for the two writes that the Wacom driver needs to make?

I disassembled macOS Sierra's SkyLight framework, which contains the implementation for `CGEventSetIntegerValueField`, to 
see what the IDs should have been for those fields. It appears that the `eventSubType` can be written by field ID 110, 
and the `eventDirAmount` can be written by ID 115. But these field IDs are nowhere to be found [in Apple's documentation](https://developer.apple.com/documentation/coregraphics/cgeventfield?language=objc),
which explains why Wacom couldn't use them!

I did some Googling and discovered that these fields are undocumented because they're part of Apple's private API. [This WebKit header](https://github.com/WebKit/webkit/blob/89c28d471fae35f1788a0f857067896a10af8974/Tools/TestRunnerShared/spi/CoreGraphicsTestSPI.h) 
reveals their names:

    kCGEventGestureHIDType = 110
    kCGEventGestureSwipeValue = 115
    kCGEventGesturePhase = 132

And those private API fields are stable from Sierra all the way to Catalina! Now that we know this, the two assignments 
to eventStructure can be replaced by these calls, and the driver crashes are eliminated: 

```cpp
_CGEventSetIntegerValueField(eventStructure, 110 /* kCGEventGestureHIDType */,    gestureType_I);
_CGEventSetIntegerValueField(eventStructure, 115 /* kCGEventGestureSwipeValue */, eventDirAmount);
```

The floating-point version of PostGesture has the same issue:

```cpp
void CMacHIDGestureEventOSX1010::PostGesture(EIOHIDEventType eventSubType, float dirAmount)
{
  __CFDataOSX1010 *eventStructure;

  eventStructure = (__CFDataOSX1010 *)_CGEventCreate(0);
  
  _CGEventSetType(eventStructure, 29 /* kCGSEventGesture */);
  
  eventStructure->eventSubType = eventSubType;                            // !
  eventStructure->eventDirAmount = reinterpret_cast<int32_t&>(dirAmount); // !
  eventStructure->eventState = this->eventPhase;                          // !
  
  if (this->eventPhase == 1 /* kCGSGesturePhaseBegan */) {
    this->eventPhase = 2 /* kCGSGesturePhaseChanged */;
  }

  _CGEventSetLocation(eventStructure, GetMouseLocationInScreenCoordinates());
  _CGEventPost(0, eventStructure);
  _CFRelease(eventStructure);
}
```

And we can patch it like so:


```cpp
_CGEventSetIntegerValueField(eventStructure, 110 /* kCGEventGestureHIDType */,    gestureType_I);
_CGEventSetIntegerValueField(eventStructure, 115 /* kCGEventGestureSwipeValue */, reinterpret_cast<int32_t&>(dirAmount));
_CGEventSetIntegerValueField(eventStructure, 132 /* kCGEventGesturePhase */,      this->eventPhase);
```

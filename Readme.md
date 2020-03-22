# Wacom Bamboo and Intuos 3 macOS driver fix

Wacom's macOS drivers for Bamboo and Intuos 3 tablets have bugs in them that cause them to completely fail to start
on macOS 10.15 Catalina (and likely other versions of macOS). This doesn't apply to the Windows driver, or to the drivers
for their newer tablets.

When you try to open the Wacom preference pane with a Bamboo tablet, you'll get an error message saying
"Waiting for synchronization", then finally "There is a problem with your tablet driver.
Please reboot your system. If the problem persists reinstall or update the driver". For an Intuos 3 tablet, 
the preference pane will open, but clicking anything will cause it to crash with the message "There was an error in Wacom
Tablet preferences."

The affected Bamboo driver (v5.3.7-6) supported these tablets:

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
- CTT-460 - Bamboo Touch
- MTE-450 - Bamboo

And the affected Intuos driver (v6.3.15-3) supported these tablets:

- PTZ-430, PTZ-630, PTZ-630SE, PTZ-631W, PTZ-930, PTZ-1230, PTZ-1231W - Intuos 3

Thankfully I was able to track down the issues and I have patched the drivers to fix them!

I've tested this with CTL-460 (Bamboo Pen) and CTH-470 (Bamboo Capture Pen and Touch Tablet) on Catalina 10.15.3. 

## Install the fix

You can either have everything installed for you automatically, or install the fixed files yourself manually, pick 
one of these options:

### Automatic method

Download the correct installer for your tablet here and double click it to run it, this will install my fixed version of
Wacom's driver:

- [Download patched v5.3.7-6 installer for Bamboo tablets](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-5/Install-Wacom-Tablet-5.3.7-6-patched.pkg)
- [Download patched v6.3.15-13 for Intuos 3 tablets](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-5/Install-Wacom-Tablet-6.3.15-3-patched.pkg)

If you get an error message that your Mac only allows apps to be installed from the App Store, right-click on it and click
"Open" instead.

After installing, follow the "post-install instructions" section (further down this page) to set the permissions properly.

### Manual method

Make sure you already have the correct Wacom driver installed ([Wacom 5.3.7-6 for Bamboo tablets](http://cdn.wacom.com/u/productsupport/drivers/mac/consumer/pentablet_5.3.7-6.dmg)
or [Wacom 6.3.15-3 for Intuos 3 tablets](http://cdn.wacom.com/u/productsupport/drivers/mac/professional/WacomTablet_6.3.15-3.dmg)), 
because the manual method only replaces a couple of the driver's files and doesn't install the complete driver itself.

Now download my patch for your tablet here:

- [Manual patch 5.3.7-6 for Bamboo tablets](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-5/wacom-5.3.7-6-macOS-patched.zip)
- [Manual patch 6.3.15-3 for Intuos 3 tablets](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-5/wacom-6.3.15-3-macOS-patched.zip)

Unzip it by double clicking it, then follow the installation instructions that match your tablet:

#### Bamboo tablets

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

    launchctl load /Library/LaunchAgents/com.wacom.pentablet.plist

After installing, follow the "post-install instructions" section to set the permissions properly.

#### Intuos 3 tablets

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

    launchctl load /Library/LaunchAgents/com.wacom.wacomtablet.plist

Now open System Preferences and try using the Wacom Tablet preference pane, it should be working now.

If you are still having issues with your tablet, follow the next "post-install instructions" section.

## Post-install instructions

Touch your pen tip to your tablet, and it should prompt you to open up the Accessibility page of your system "Security & Privacy" 
settings to grant the tablet permissions. 

On the Accessibility page, click the padlock to unlock the page, then find and tick any `PenTabletDriver`, `WacomTabletDriver` 
`TabletDriver` or `WacomTabletSpringboard` entries you see in the list. Do the same on the Input Monitoring page.

If your tablet supports touch, touch the tablet with your finger, it should again prompt you to grant permissions. 
On the Accessibility page, tick the `ConsumerTouchDriver` or `WacomTouchDriver` entry. 

For Intuos 3 tablets, the driver might only appear on the Input Monitoring page, and you may need to reboot a second time
for it to appear on the Accessibility page too.

If your Wacom preference pane, pen support, or touch support is not yet working, you'll need to clear out all those
permissions and try again:

On the Accessibility page of Security & Privacy, Find `PenTabletDriver`, `WacomTabletDriver`, `TabletDriver`, 
`ConsumerTouchDriver`, `WacomTabletSpringboard`, and/or `WacomTouchDriver` in the list, select them, and click the minus
button to remove them. Go to the Input Monitoring page and do the same there.

Now either reboot your computer, or run these two commands in the Terminal, to reload the tablet driver. For Bamboo tablets:

    launchctl unload /Library/LaunchAgents/com.wacom.pentablet.plist

    launchctl load /Library/LaunchAgents/com.wacom.pentablet.plist
    
For Intuos 3 tablets:

    launchctl unload /Library/LaunchAgents/com.wacom.wacomtablet.plist

    launchctl load /Library/LaunchAgents/com.wacom.wacomtablet.plist

This should restore the prompts to ask you to add permissions, so now begin the instructions in this section again.

## Support me

If you enjoyed having your tablet back in action, please consider sending me a tip!

[![Donate button](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CDPRHRDZUDZW4&source=url) 

This will help pay for my yearly Apple Developer registration fee.

## Technical details of the bugs

### Bamboo driver

PenTabletDriver launches two sub-drivers to do the work for it, ConsumerTouchDriver and TabletDriver. To find those drivers 
within its Resources folder it eventually calls this function to extract a path from a URL:

```cpp
CFString * MacPaths::PathFromURL(CFURL *url)
{
    CFString *path;

    path = _objc_retainAutoreleasedReturnValue(url->path());

    _objc_release(path); /* Whoops, path is destroyed here! */

    return path; /* Now returning a free'd path */
}
```

Forgive me for paraphrasing the original Objective C code as C++, I don't speak objc!

When CFURL creates the path, its reference count starts out at 1. It queues the reference count to be decremented later 
by calling `autorelease()` on it, then returns it to Wacom's driver. This call to `autorelease` pairs up with Wacom's 
`retainAutoreleasedReturnValue()` call, and so and leaves the path's reference count untouched, at 1.

But now the Wacom driver calls `_objc_release()` on the path. This decrements its reference count to 0, and
the path is immediately freed! 

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

### Intuos 3 driver

The Intuos 3 driver has a bug in its preference pane that causes it to crash as soon as an item is clicked on.

One of the main features of the preference pane's UI are the lists of icons representing the tablets, tools and 
applications you can configure. That icon list control uses a function like this to dispatch events (such as clicks) to
its children:

```cpp
void WTCCPLIconList::action:(ID event, SEL param_2, ID param_3) {
  int selectedIndex;
  ID target;
  ID action;
  
  target = _objc_retainAutoreleasedReturnValue(event->target());
  action = event->action();
  selectedIndex = event->selectedIndex();

  event->scrollIndexToVisible(selectedIndex);

  if ((target != 0) && (action != 0)) {
    code* handler = target->methodForSelector(action);

    Object *result = handler(target, action, event);
                    
    result = _objc_retainAutoreleasedReturnValue(result); // (!)
    _objc_release(result);                                // (!)
  }

  event->updateButtonStates();

  _objc_release(target);
}
```

The problem with this code is that it requires the event's `handler()` function to return an object, which it then uselessly
retains() and releases(). But one of the handler functions that will be called is `OEventDispatcher_Professional::listClickAction()`, 
and that function is a `void` function (with no well-defined return value)! 

So `action:()` ends up calling `retain()` and `release()` on a garbage pointer, which causes a segfault.

The patch here is easy - that useless pair of `retain()` and `release()` calls is deleted.

There's another problem with this driver. If, while trying to get your tablet to work, you accidentally install the 
latest Wacom driver (that doesn't support Intuos 3), it writes a newer-format preference file that the old Intuos 3
driver will crash when trying to read. And this situation doesn't resolve itself, the user has to manually use the Wacom
Utility to delete the tablet preferences in order to fix it. 

This is odd because the preference file includes a version number which is designed to avoid this very situation. The
old driver uses version 5, and the latest driver uses version 6:

```xml
<ImportFileVersion type="integer">6</ImportFileVersion>
```

And the driver code explicitly checks for this version number and should abort when it is too new:

```cpp
CTabletDriver::ReadSettings(basic_string settingsFilename, ...) 
{    
    basic_string settingsFileContent;
    CSettingsMap settingsMap;

    ...

    ReadFromXMLFile(settingsMap, settingsFilename, settingsFileContent);

    SettingsMigration *migration = SettingsMigration::MigratePen(settingsMap);

    if (migration != nullptr) {
        int fileVersion = settingsMap.IntegerForKeyWithDefault("ImportFileVersion", -1)

        if (fileVersion < 1) {
            // Report error
        } else if (fileVersion <= this->supportedVersion) {
            // Accept the loaded settings
        } else {
            // Report error: Settings are too new   
        }
    }

    ...
}
```

But the driver never aborts, instead it crashes while attempting to load the preferences. So what's going wrong here? 
The secret lies inside the `MigratePen()` function. This function is designed to upgrade older settings files to the 
current version, but unfortunately in the process it unconditionally overwrites the `ImportFileVersion` with the 
current version (5)! This leaves `CTabletDriver::ReadSettings()` unable to detect that the settings are too new to be 
parsed.

To solve this I beefed up the invalid version detection code from `MigratePen()`:

```cpp
if (settingsVersion < 1) {
    // Report invalid settings version and return NULL
} 
```

To make it:

```cpp
if (settingsVersion < 1 || settingsVersion > 5) {
    // Report invalid settings version and return NULL
} 
```

So now if the preferences are too new, `MigratePen()` won't attempt to upgrade them, and `ReadSettings()` will cleanly skip 
loading the preferences. This causes the preferences to remain at their defaults, and if the user edits the settings using 
the preference pane, the settings should be cleanly overwritten.
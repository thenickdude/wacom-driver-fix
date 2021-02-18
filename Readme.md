# Fixed drivers for Wacom Bamboo, Graphire, Intuos 1, 2, 3, and Cintiq 1st gen tablets on macOS Catalina / Big Sur

Wacom's macOS drivers for Bamboo, Graphire, Intuos 1, 2 & 3 and Cintiq 1st gen tablets have bugs in them that cause them to
completely fail to start on macOS 10.15 Catalina and macOS 11 Big Sur. This doesn't apply to the Windows driver, or to 
the drivers for their newer tablets.

When you try to open the Wacom preference pane with a Bamboo tablet, you'll get an error message saying
"Waiting for synchronization", then finally "There is a problem with your tablet driver.
Please reboot your system. If the problem persists reinstall or update the driver". For an Intuos 3 or Cintiq 1st gen tablet, 
the preference pane will open, but clicking anything will cause it to crash with the message "There was an error in Wacom
Tablet preferences." For Graphire and Intuos 1 & 2 tablets, the driver's installer couldn't even run on Catalina.

Thankfully I was able to track down the issues and I have patched the drivers to fix them!

My fixed **Bamboo** driver (v5.3.7-6) supports these tablets:

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

My fixed **Graphire 1 & 2** and **Intuos 1 & 2** driver (v6.1.6-4) supports these tablets:

- ET-0405-U - Graphire / Graphire 1 (USB)
- ET-0405-R - Graphire / Graphire 1 (Serial) - Untested, let me know if it works!
- ET-0405A - Graphire 2
- GD-0405-U, GD-0608-U, GD-0912-U, GD-1212-U, GD-1218-U - Intuos (USB) (1998)
- GD-0405-R, GD-0608-R, GD-0912-R, GD-1212-R, GD-1218-R - Intuos (Serial) (1998) - Untested
- XD-0405-U, XD-0608-U, XD-0912-U, XD-1212-U, XD-1218-U - Intuos 2 (USB)
- XD-0405-R, XD-0608-R, XD-0912-R, XD-1212-R, XD-1218-R - Intuos 2 (Serial) - Untested

My fixed **Graphire 3** driver (v5.2.6-5) supports these tablets:

- CTE-430, CTE-630 - Graphire 3
- CTE-630BT - Graphire 3 Wireless

My fixed **Graphire 4** driver (v5.3.0-3) supports these tablets:

- CTE-440, CTE-640 - Graphire 4

And my fixed **Intuos 3** and **Cintiq** driver (v6.3.15-3) supports these tablets:

- PTZ-430, PTZ-630, PTZ-630SE, PTZ-631W, PTZ-930, PTZ-1230, PTZ-1231W - Intuos 3
- DTZ-2100 - Cintiq 21UX 1st Gen.
- DTZ-2000 - Cintiq 20WSX

[🇦🇺 Simplified English instructions](Readme.en-simple.md)  
[🇧🇷 / 🇵🇹 Instruções em português](Readme.pt-BR.md)  
[🇯🇵 日本語で表示](Readme.ja-JP.md)  
[🇷🇺 Инструкция на русском языке](Readme.ru-RU.md)  
[🇪🇸 Instrucciones en español](Readme.es.md)  
[🇵🇱 Instrukcja po polsku](Readme.pl.md)   
[🇫🇷 Instructions en français](Readme.fr-FR.md)   

## Install the fix

Download the correct installer for your tablet here and double click it to run it, this will install my fixed version of
Wacom's driver:

- [Fixed driver v6.1.6-4 installer for Graphire 1 & 2 and Intuos 1 & 2 tablets](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-9/Install-Wacom-Tablet-6.1.6-4-patched.pkg)
- [Fixed driver v5.2.6-5 installer for Graphire 3 tablets](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-9/Install-Wacom-Tablet-5.2.6-5-patched.pkg)
- [Fixed driver v5.3.0-3 installer for Graphire 4 tablets](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-9/Install-Wacom-Tablet-5.3.0-3-patched.pkg)
- [Fixed driver v5.3.7-6 installer for Bamboo tablets](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-9/Install-Wacom-Tablet-5.3.7-6-patched.pkg)
- [Fixed driver v6.3.15-3 for Intuos 3 and Cintiq tablets](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-9/Install-Wacom-Tablet-6.3.15-3-patched.pkg)

If you get an error message that your Mac only allows apps to be installed from the App Store, right-click on it and click
"Open" instead.

(If you'd prefer to install the fixed files yourself manually, you can use the [manual installation instructions](Readme-manual-installation.md) instead.)

After installing, follow the instructions in the next section to fix up the tablet's permissions.

## Fix up the tablet permissions

Touch your pen tip to your tablet, and it should prompt you visit System Preferences > Security & Privacy > Privacy Tab
to grant the tablet permissions. 

On the Accessibility page, click the padlock to unlock the page, then find and tick any `PenTabletDriver`, `WacomTabletDriver` 
`TabletDriver` or `WacomTabletSpringboard` entries you see in the list. Do the same on the Input Monitoring page.

If your tablet supports touch, touch the tablet with your finger, it should again prompt you to grant permissions. 
On the Accessibility page, tick the `ConsumerTouchDriver` or `WacomTouchDriver` entry. 

With some tablets, the driver might only appear on the Input Monitoring page, and you may need to reboot a second time
for it to appear on the Accessibility page too.

### If your Wacom preference pane, pen support, or touch support is not yet working
You likely had permissions left over from the previous tablet driver, and these stale entries all need to 
be removed like so:

On the "Accessibility" page of Security & Privacy, Find anything related to Wacom in the list (e.g. `PenTabletDriver`, 
`WacomTabletDriver`, `TabletDriver`,  `ConsumerTouchDriver`, `WacomTabletSpringboard`, `WacomTouchDriver`), select them,
and click the minus button to remove them. Go to the "Input Monitoring page" and do the same there.

Now either reboot your computer, or run these two commands in the Terminal, to reload the tablet driver. 
For Bamboo and Graphire 3 & 4 tablets:

    launchctl unload /Library/LaunchAgents/com.wacom.pentablet.plist

    launchctl load -w /Library/LaunchAgents/com.wacom.pentablet.plist
    
For Graphire 1 & 2, Intuos, and Cintiq tablets:

    launchctl unload /Library/LaunchAgents/com.wacom.wacomtablet.plist

    launchctl load -w /Library/LaunchAgents/com.wacom.wacomtablet.plist

This should restore the prompts to ask you to add permissions, so now begin the instructions in this section again.

### If nothing ever appears in "Input Monitoring" for you

For a handful of people, the Wacom driver never appears in the Input Monitoring list for them. To fix this, first open up
the "Terminal" app and paste this line in and press enter to ensure that the Wacom service is enabled:

For Bamboo and Graphire 3 & 4 tablets:

    launchctl load -w /Library/LaunchAgents/com.wacom.pentablet.plist
    
For Graphire 1 & 2, Intuos, and Cintiq tablets:

    launchctl load -w /Library/LaunchAgents/com.wacom.wacomtablet.plist

If that doesn't trigger it to ask you to add Input Monitoring permissions when you try to use the tablet, you can add 
it manually instead.

In Finder, click Go -> Go to Folder, and paste this path in there and click OK:

    /Library/Application Support/Tablet/

In there you should see a "PenTabletDriver" file (Bamboo), "PenTabletSpringboard" (Graphire 3 & 4),
or "WacomTabletSpringboard" (Graphire 1 & 2, Intuos, Cintiq). 

Unlock the Input Monitoring page, then drag the PenTabletDriver / PenTabletSpringboard / WacomTabletSpringboard file onto it to 
add it to the list, and make sure it's ticked. Now reboot your computer, and when you try to use the tablet it should 
prompt you to tick it in the Accessibility page too, after which it should start working.

## Support me

If you enjoyed having your tablet back in action, please consider sending me a tip!

[![Donate button](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CDPRHRDZUDZW4&source=url) 

This will help fund me and further development of these fixed drivers.

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

The ConsumerTouchDriver also contains this same bug, and the patch is the same there. 

Both the pen driver and the touch driver need fixes to stop them from crashing when a multi-touch gesture is performed,
or the scroll ring is used to zoom.

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

And those private API fields are stable from Sierra all the way to Big Sur! Now that we know this, the two assignments 
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

### Intuos 3 and Cintiq driver

The Intuos 3 and Cintiq driver has a bug in its preference pane that causes it to crash as soon as an item is clicked on.

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

The patch here is easy - that useless pair of `retain()` and `release()` calls is deleted. The same bug exists in 
`ONumberTextField::textDidChange:`, with the same fix. 

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

### Graphire 3 & 4 drivers

The installers for the Graphire drivers are an old format that Catalina no longer supports, so I had to completely 
rebuild them.

Graphire's preference pane incorrectly relied on private symbols from the macOS standard library that are no longer 
present in Catalina, so it could no longer start.

For example, Wacom's NSNibWakingOverride::awakeFromNib() function is called during GUI deserialization, and adds the 
loaded GUI control to a map so it can be accessed by its tag later:

```cpp
void NSNibWakingOverride::awakeFromNib(NSControl *this) {
  OMasterDictionaryPtr->addObject:withTag:(this, this->_tag));
}
```

But this relies on reading [NSControl._tag](https://developer.apple.com/documentation/appkit/nscontrol), which is a 
private field. In macOS 10.9 that worked because NSControl was defined like this:

```objc
@interface NSControl : NSView
{
    /*All instance variables are private*/
    NSInteger	_tag;
    id		_cell;
    struct __conFlags {
        ...
    } _conFlags;
}
```

But in macOS 10.10, NSControl was refactored to move the _tag field into a new _aux field, making it inaccessible:

```objc
@interface NSControl : NSView
{
    /*All instance variables are private*/
    NSControlAuxiliary *_aux;
    id		_cell;
    struct __conFlags {
        ...
    } _conFlags;
}

@property NSInteger tag;
```

I patched awakeFromNib to make it properly call the public accessor function for this field:

```cpp
void NSNibWakingOverride::awakeFromNib(NSControl *this) {
  OMasterDictionaryPtr->addObject:withTag:(this, this->tag()));
}
```

In Wacom's OPopupOutlineView::reloadData() function, the private [NSTableView._dataSource field](https://developer.apple.com/documentation/appkit/nstableview)
is incorrectly read directly:

```cpp
void OPopupOutlineView::reloadData(OPopupOutlineView *this) {
  this->_dataSource.willReloadDataForOutlineView(this);
  
  ...
}
```

So I patched this to use the public accessor instead:

```cpp
void OPopupOutlineView::reloadData(OPopupOutlineView *this) {
  this->dataSource()->willReloadDataForOutlineView(this);
  
  ...
}
```

### Graphire 1 & 2 and Intuos 1 & 2 drivers

These drivers have the same problems as the Graphire 3 & 4 drivers, plus the same `_dataSource` problem in their
`ORadialSubMenuTableView::reloadData() method`, with the same fix.

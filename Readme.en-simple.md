# Fixed drivers for Wacom Bamboo, Graphire, Intuos 1, 2 & 3 and Cintiq 1st gen tablets on macOS 10.15 Catalina

Wacom's drivers for Bamboo, Graphire, Intuos 1, 2 & 3 and Cintiq 1st gen tablets have bugs in them that
make them no longer work on macOS 10.15 Catalina, and Wacom is no longer updating these drivers. 
Luckily I was able to fix the bugs and get the drivers working again!

My fixed Bamboo driver (v5.3.7-6) supports these tablets:

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

My fixed Graphire 1 & 2 and Intuos 1 & 2 driver (v6.1.6-4) supports these tablets:

- ET-0405-U - Graphire / Graphire 1 (USB)
- ET-0405-R - Graphire / Graphire 1 (Serial)
- ET-0405A - Graphire 2
- GD-0405-U, GD-0608-U, GD-0912-U, GD-1212-U, GD-1218-U - Intuos (USB) (1998)
- GD-0405-R, GD-0608-R, GD-0912-R, GD-1212-R, GD-1218-R - Intuos (Serial) (1998)
- XD-0405-U, XD-0608-U, XD-0912-U, XD-1212-U, XD-1218-U - Intuos 2 (USB)
- XD-0405-R, XD-0608-R, XD-0912-R, XD-1212-R, XD-1218-R - Intuos 2 (Serial)

My fixed Graphire 3 driver (v5.2.6-5) supports these tablets:

- CTE-430, CTE-630 - Graphire 3

My fixed Graphire 4 driver (v5.3.0-3) supports these tablets:

- CTE-440, CTE-640 - Graphire 4
- CTE-630BT - Graphire 3 Wireless (untested, let me know if this works!)

My fixed Intuos 3 and Cintiq driver (v6.3.15-3) supports these tablets:

- PTZ-430, PTZ-630, PTZ-630SE, PTZ-631W, PTZ-930, PTZ-1230, PTZ-1231W - Intuos 3
- DTZ-2100 - Cintiq 21UX 1st Gen.
- DTZ-2000 - Cintiq 20WSX

[🇳🇿 English instructions](Readme.md)   
[🇧🇷 / 🇵🇹 Instruções em português](Readme.pt-BR.md)  
[🇯🇵 日本語で表示](Readme.ja-JP.md)   
[🇷🇺 Инструкция на русском языке](Readme.ru-RU.md)   

## Install the fixed driver

First, download the correct driver for your tablet:

- [Fixed driver v6.1.6-4 for Graphire 1 & 2 and Intuos 1 & 2 tablets](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-6/Install-Wacom-Tablet-6.1.6-4-patched.pkg)
- [Fixed driver v5.2.6-5 for Graphire 3](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-6/Install-Wacom-Tablet-5.2.6-5-patched.pkg)
- [Fixed driver v5.3.0-3 for Graphire 4](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-6/Install-Wacom-Tablet-5.3.0-3-patched.pkg)
- [Fixed driver v5.3.7-6 for Bamboo](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-6/Install-Wacom-Tablet-5.3.7-6-patched.pkg)
- [Fixed driver v6.3.15-13 for Intuos 3 and Cintiq](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-6/Install-Wacom-Tablet-6.3.15-3-patched.pkg)

Run the installer to install the driver.

Now we need to remove the permissions that were leftover from the old driver: 

- Click the Apple menu, then System Preferences, Security and Privacy
- On the Privacy tab, select Accessibility and click the lock in the bottom left to make changes. You'll be asked to enter your login credentials.
- Select any Wacom items in the list (PenTabletDriver, ConsumerTouchDriver, WacomTabletSpringboard, etc) and click the "-" button to remove them.
- Do the same on the "Input Monitoring" page 
- Restart the computer

![Remove old permissions](screenshots/en-AU/security-and-privacy-delete.jpg)

Now we can add permissions for the new fixed driver:

- Touch the pen tip to the tablet once
- Click the Apple menu, then System Preferences, Security and Privacy
- On the Privacy tab, select Accessibility and click the lock in the bottom left to make changes. You'll be asked to enter your login credentials.
- Make sure any Wacom items in the list (PenTabletDriver, ConsumerTouchDriver, WacomTabletSpringboard, etc) are ticked
- Do the same on the "Input Monitoring" page 

![Add new permissions](screenshots/en-AU/security-and-privacy-tick.jpg)

Your tablet should now be working! You may need to restart the computer one more time.

## Help me out

If you enjoyed having your tablet working again, please consider sending me a donation!

[![Donate button](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CDPRHRDZUDZW4&source=url) 

This will help fund me and further development of these drivers.
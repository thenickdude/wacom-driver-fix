ORG 0x0004f44c

BITS	64
DEFAULT	REL

; Patch the call to NSApp->mainWindow to call our stub instead, so we can save the value
; between calls and so avoid the Catalina bug where preference panes see mainWindow
; change to point to the last-opened page (when it should always stay pointed at the
; main window!)
OWacomWindowController_getCurrentController:
        CALL          0x00339000

        ; NOP out the following stuff we don't need
        TIMES 11-($-$$) DB 0x90

BITS	64
DEFAULT	REL

section unreloc start=0 vstart=0x00042d3a align=1

; Patch the call to NSApp->mainWindow to call our stub instead, so we can save the value
; between calls and so avoid the Catalina bug where preference panes see mainWindow
; change to point to the last-opened page (when it should always stay pointed at the
; main window!)
OWacomWindowController_getCurrentController:
        CALL          0x003a0000

        ; NOP out the following stuff we don't need
        TIMES 11-($-$$) DB 0x90

BITS	64
DEFAULT	REL

section unreloc start=0 vstart=0x0008265f align=1

; Before calling OTabletPrefPaneBase_Consumer::didSelect, run our stub to save the
; current mainWindow
OWacomWindowController_getCurrentController:
        CALL          0x00339080

        ; Ensure call was the same size as the code it replaced
        TIMES 5-($-$$) DB 0x90

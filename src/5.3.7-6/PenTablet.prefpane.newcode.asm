%define _objc_msgSendSuper2                 0x0021b12c
%define _objc_retainAutoreleasedReturnValue 0x0021b14a

%define got_NSApp                           0x002fa028
%define got_objc_msgSend                    0x002fa810
%define got_objc_release                    0x002fa820
%define got_objc_retain                     0x002fa828

%define s_mainWindow                        0x003153d8

BITS	64
DEFAULT	REL

section unreloc start=0 vstart=0x00339000 align=1

_NSApp_mainWindow_stub:
      ; NSApp is in RDI and mainWindow string in RSI

      PUSH       RBP ; We need to push 8 bytes to the stack to 16-byte align it anyway
      MOV        RBP, RSP

      ; Did we already fetch mainWindow?
      MOV        RAX, [data_segment]
      TEST       RAX, RAX

      JNZ        .leave ; Return it

      CALL       [got_objc_msgSend]

      MOV        RDI, RAX
      CALL       _objc_retainAutoreleasedReturnValue

      MOV        [data_segment], RAX ; Remember mainWindow for next time

.leave:
      ; Since our caller will call _objc_release on the mainWindow, but we
      ; want to keep it around, increase the refcount
      MOV        RDI, RAX
      CALL       [got_objc_retain]

      POP        RBP
      RET

TIMES 128-($-$$) DB 0

_OTabletPrefPaneBase_Consumer_didSelect_stub:
      ; 'this' is in RDI and "didSelect" is in RSI
      PUSH       RBP
      MOV        RBP, RSP

      PUSH       R12
      PUSH       R13
      MOV        R12, RDI ; Save 'this'
      MOV        R13, RSI ; Save 'didSelect'

      ; Call NSApp->mainWindow
      MOV        RDI, [got_NSApp]
      MOV        RDI, [RDI]
      MOV        RSI, [s_mainWindow]
      CALL       [got_objc_msgSend]

      MOV        RDI, RAX
      CALL       _objc_retainAutoreleasedReturnValue

      TEST       RAX, RAX
      JZ         .leave

      ; Save the mainWindow in our global so we can use it later
      MOV        [data_segment], RAX

.leave:
      ; Perform the original call to sendSuper2 the patched function was going to make
      MOV        RDI, R12
      MOV        RSI, R13
      CALL        _objc_msgSendSuper2

      POP        R13
      POP        R12
      POP        RBP
      RET
TIMES 16384-($-$$) DB 0

data_segment:

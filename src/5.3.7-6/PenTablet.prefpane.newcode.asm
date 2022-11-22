%define _objc_retainAutoreleasedReturnValue 0x0021b14a

%define got_objc_msgSend                    0x002fa810
%define got_objc_release                    0x002fa820
%define got_objc_retain                     0x002fa828

BITS	64
DEFAULT	REL

ORG 0x00339000

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

TIMES 16384-($-$$) DB 0

data_segment:

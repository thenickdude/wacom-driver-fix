%define _objc_msgSend                       0x001970d4

BITS	64
DEFAULT	REL

section unreloc start=0 vstart=0x00282000 align=1

_NSApp_mainWindow_stub:
      ; NSApp is in RDI and mainWindow string in RSI

      PUSH       RBP ; We need to push 8 bytes to the stack to 16-byte align it anyway
      MOV        RBP, RSP

      ; Did we already fetch mainWindow?
      MOV        RAX, [data_segment]
      TEST       RAX, RAX

      JNZ        .leave ; Return it

      CALL       _objc_msgSend

      MOV        [data_segment], RAX ; Remember mainWindow for next time

.leave:
      POP        RBP
      RET

TIMES 16384-($-$$) DB 0

data_segment:

BITS 16

section _ENTRY CLASS=CODE

extern _cstart_

global entry

entry:
    CLI
    MOV ax, ds
    MOV ss, ax
    MOV sp, 0
    MOV bp, sp
    STI

    CALL _cstart_

    CLI
    HLT
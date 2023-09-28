BITS 16

section _TEXT class=CODE

global _x86_Video_WriteCharTeletype
_x86_Video_WriteCharTeletype:
    PUSH bp
    MOV bp, sp

    PUSH bx

    MOV ah, 0Eh
    MOV al, [bp+4]
    MOV bh, [bp+6]

    INT 10h

    POP bx
    MOV sp, bp

    POP bp

    RET
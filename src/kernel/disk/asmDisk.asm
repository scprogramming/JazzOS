BITS 16

section _TEXT class=CODE

global _x86_Disk_Reset
_x86_Disk_Reset:
    PUSH bp
    MOV bp, sp

    MOV ah, 0
    MOV dl, [bp+4]
    STC

    INT 13h
    JC reset_error

    MOV cx,0
    MOV bx, [bp+6]
    MOV [bx],cx
    JMP end_reset

reset_error:
    MOV bx, [bp+6]
    MOV cx,1
    MOV [bx],cx

end_reset:
    MOV sp, bp
    POP bp
    RET
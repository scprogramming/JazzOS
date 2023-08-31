ORG 0x7C00
BITS 16

JMP SHORT main
NOP

bdb_oem:        DB      'MSWIN4.1'
bdb_bytes_per_sector:    DW  512
bdb_sectors_per_cluster: DB  1
bdb_reserved_sectors:    DW  1
bdb_fat_count:          DB  2
bdb_dir_entries_count:  DW  0E0h
bdb_total_sectors:       DW  2880
bdb_media_descriptor_type: DB 0F0h
bdb_sectors_per_fat:     DW  9
bdb_sectors_per_track:   DW  18
bdb_heads:              DW  2
bdb_hidden_sectors:     DD  0
bdb_large_sector_count: DD  0

ebr_drive_number:       DB  0
                        DB  0
ebr_signature:           DB  29h
ebr_volume_id:          DB  12h,34h,56h,78h
ebr_volume_label:       DB 'JAZZ OS    '
ebr_system_id:          DB  'FAT12   '

main:
    MOV ax,0
    MOV ds,ax
    MOV es,ax
    MOV ss,ax

    MOV sp,0x7C00

    mov [ebr_drive_number], dl
    mov ax, 1
    mov cl, 1
    mov bx, 0x7E00
    call disk_read
    
    MOV si,os_boot_msg
    CALL print
    HLT

halt:
    JMP halt

floppy_error:
    MOV si, read_failure
    call print
    hlt

;disk routines
;cx [bits 0-5]: sector number
;cx [bits 6-15]: cylinder
;dh: head
lba_to_chs:
    push ax
    push dx
    
    XOR dx,dx
    div word [bdb_sectors_per_track]

    inc dx
    mov cx, dx

    xor dx,dx
    div word [bdb_heads]

    mov dh,dl
    mov ch,al
    shl ah,6
    or cl,ah

    pop ax
    mov dl,al
    pop ax

    RET

;ax: LBA address
;cl: number of sectors to read
;dl: drive number
;es:bx: memory address where to store read data
disk_read:
    push ax
    push bx
    push cx
    push dx
    push di

    push cx
    call lba_to_chs
    pop ax
    
    mov ah, 02h
    mov di, 3 ;retry count

.retry:
    pusha
    stc                 ;some bios don't set carry
    int 13h
    jnc .done
    
    popa 
    call disk_reset

    dec di
    test di, di
    jnz .retry

.fail:
    jmp floppy_error

.done:
    popa

    pop di
    pop dx
    pop cx
    pop bx
    pop ax

    ret

disk_reset:
    pusha
    mov ah, 0
    stc
    int 13h
    jc floppy_error
    popa 
    ret


;print

print:
    PUSH si
    PUSH ax
    PUSH bx

print_loop:
    LODSB
    OR al,al
    JZ done_print

    MOV ah, 0x0E
    MOV bh, 0
    INT 0x10

    JMP print_loop

done_print:
    POP bx
    POP ax
    POP si
    RET

os_boot_msg: DB 'Our OS has booted!', 0x0D, 0x0A, 0
read_failure: DB 'Failed to read floppy', 0x0D, 0x0A, 0
TIMES 510-($-$$) DB 0
DW 0AA55h
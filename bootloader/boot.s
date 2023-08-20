ORG 0x7C00
BITS 16

%define ENDL 0x0D, 0x0A

start:
	jmp main

;Prints a string to the screen.
;Params:
;	-ds:si points to a string
puts:
	;Save registers to modify
	PUSH si
	PUSH ax

.loop:
	LODSB	;loads next character in al
	OR al, al  ;verify if al is null
	JZ .done
	MOV ah, 0x0e
	MOV bh,0
	INT 0x10

	JMP .loop
.done:
	POP ax
	POP si
	RET

main:
	;setup data segments
	MOV ax,0	;Can't write to ds or es directly
	MOV ds,ax
	MOV es,ax

	;Setup stack
	MOV ss,ax
	MOV sp,0x7C00

	MOV si,msg_hello
	CALL puts

	HLT ;halts processor

.halt:
	jmp .halt ;Keeps halted in case of run

msg_hello: DB 'Hello world!', ENDL, 0

TIMES 510-($-$$) DB 0
DW 0AA55h

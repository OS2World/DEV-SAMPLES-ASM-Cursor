INCLUDELIB doscalls.lib
.286
.model large
.stack

pushc		MACRO	var		    ;push macros
	mov ax, var
	push ax
		ENDM

push_ptr	MACRO 	var

	push	ds
	mov ax, offset var
	push ax			
		ENDM	

key_status	STRUC			    ;structure for kbd data

ascii_code	db	?
scan_code	db	?
char_status	db	?
nls_shift	db	?
shift_state	dw	?
time_stamp	dd	?

key_status	ENDS

.data                

cpu_mode	    dw		     1 dup(?)
key_status_data     key_status	    <>

message		db	13,10
       		db	'Here Is The Large Cursor ...',13,10
		db	'Now Press <ENTER> To Return To CMD.EXE  '
lmessage	dw	$ - offset message

.code
     
EXTRN DosExit: far
EXTRN KBDCHARIN: far
EXTRN VioWrtTTY: far
EXTRN VioScrLock: far
EXTRN VioScrUnLock: far
EXTRN DOSPORTACCESS: far, DOSCLIACCESS: far
EXTRN large_cursor: far, DOSGETMACHINEMODE: far

set_cursor proc far

start:

		push_ptr message		    ;push pointer
		pushc	   lmessage		    ;push value
		pushc 0 			    ;push handle
		call far ptr VioWrtTTY		    ;system write to screen

		push_ptr cpu_mode		    ;space for mode info
		call far ptr DOSGETMACHINEMODE	    ;required call for I/O

		call far ptr DOSCLIACCESS	    ;allow sti/cli

		pushc	0			    ;handle
		pushc	0			    ;get gate pass
		pushc	03d4H			    ;CRTC ADDR
		pushc	03d5H			    ;CRTC DATA
		call far ptr DOSPORTACCESS	    ;open gate

		call far ptr large_cursor	    ;call the I/O routine

		pushc	0			    ;handle
		pushc	1			    ;release gate pass
		pushc	03d4H
		pushc	03d5H
		call far ptr DOSPORTACCESS	    ;close gate

		push_ptr key_status_data	    ;pointer to kbd data
		pushc	00			    ;wait for char to arrive
		pushc	00			    ;handle
		call far ptr KBDCHARIN		    ;call keyboard

		xor ax,ax			    ;no_error exit

		pushc 1 			    ;standard exit
		pushc 0
		call far ptr DosExit		    ;exit application

set_cursor endp

PUBLIC set_cursor

end  start
     


     


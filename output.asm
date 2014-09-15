.286
.model large
.code
large_cursor	proc	far

	push dx

	mov dx,03d4H	;get crtc addr (03B4H = monochrome addr)
	mov al,0AH	;request cursor_start
	cli
	out dx,al	;output request

	inc dx		;get crtc data
	mov al,02H	;load data
	out dx,al	;output it

	dec dx		;crtc addr
	mov al,0BH	;request cursor end
	out dx,al	;output request

	inc dx		;get crtc data
	mov al,0CH	;load data
	out dx,al	;output

	sti

	xor ax,ax	;return code 0

	pop dx	

exit:

	ret	       ;far return

large_cursor endp

PUBLIC large_cursor		;make routine available

end
 


     


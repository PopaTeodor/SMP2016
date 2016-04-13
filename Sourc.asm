; multi-segment executable file template.

data segment
	menu db "Hello.Please choose your option: $"
    menu1 db "1)Draw a rectangle.$"
	menu2 db "2)Draw a triangle.$"
	menu3 db "3)Draw with your mouse.$"
	menu4 db "4)Quit.$"
	oldX dw -1
	oldY dw 0 
ends

stack segment
    dw   128  dup(0)
ends

code segment
start: 
    mov ax, data
    mov ds, ax
    mov es, ax     
    call clearscreen  ;clears the screen        
    call writeMenu
	
    mov ah,1h
    int 21h        ;input from keyboard
    
                     
    cmp al, "4"
    je quit   
    
    cmp al, "3"
    je drawMouse
    
    cmp al, "2"
    je drawTriangle
    	
	cmp al, "1"
    je drawRectangle
    
  
    jmp start
     

drawMouse: 		 
		
		mov ax, 0 
		int 33h 
		
		cmp ax, 0    
	check_mouse_button:
		
		mov ax, 3
		int 33h 
		shr cx, 1
		
		cmp bx, 1  
		jne xor_cursor
		mov al, 1010b 
		jmp draw_pixel 
		
	xor_cursor:
		cmp oldX, -1
		je not_required
		push cx
		push dx
		mov cx, oldX
		mov dx, oldY
		mov ah, 0dh
		int 10h
		xor al, 1111b
		mov ah, 0ch
		int 10h
		pop dx
		pop cx
		
	not_required:
		mov ah, 0dh
		int 10h
		xor al, 1111b
		mov oldX, cx
		mov oldY, dx
		
	draw_pixel:
		mov ah, 0ch
		int 10h    
		
	check_esc_key:
		mov dl, 255
		mov ah, 6
		int 21h
		cmp al, 27	
		jne check_mouse_button
		
	stop:
		jmp start
	



drawRectangle:	
	w equ 100 ; dimensiune dreptunghi
	h equ 50
	posX equ 100
	posY equ 100
	color equ 15
	; afisare latura superioara
	mov cx, posX+w ; coloana
	mov dx, posY ; rand
	mov al, color ; alb
u1:
	mov ah, 0ch ; afisare pixel
	int 10h
	
	dec cx
	cmp cx, posX
	jae u1	
	; afisare latura inferioare
	
	mov cx, posX+w
	mov dx, posY+h
	mov al, color
u2:
	mov ah, 0ch
	int 10h
	
	dec cx
	cmp cx, posX
	ja u2
	; latura din stanga
	
	mov cx, posX
	mov dx, posY+h
	mov al, color
u3:
	mov ah, 0ch
	int 10h
	
	dec dx
	cmp dx, posY
	ja u3
	; latura din dreapta
	
	mov cx, posX+w
	mov dx, posY+h
	mov al, color 
u4: 
	mov ah, 0ch
	int 10h
	
	dec dx
	cmp dx, posY
	ja u4
	; asteptare apasare tasta
	
	mov ah,00
	int 16h

jmp start 





drawTriangle:
    posX equ 100
	posY equ 100
	color equ 15
	h equ 50
	w equ 50
	mov cx,posX + 100
	mov dx, posY+h
	mov al, color
u5:
	mov ah, 0ch ; afisare pixel
	int 10h
	
	dec cx
	cmp cx, posX
    jae u5    
    
	mov cx,	posX
	mov dx, posY + h
	mov al, color
u6:	
	mov ah,0ch 
	int 10h
	
	dec dx
	inc cx
	
	cmp dx, posY
	jae u6
	
	mov cx,	posX + w
	mov dx, posY + h
	mov al, color
u7:
	mov ah, 0ch
	int 10h
		
	dec cx  
	dec dx
	cmp dx, posY
	jae u7

	
	mov ah,00
	int 16h
jmp start





 
quit:    
    mov ax, 4c00h ; exit to operating system.
    int 21h
    
    
clearscreen:
    mov al, 13h
    mov ah, 0
    int 10h   
            
    mov ah, 0fh
    int 10h       
    mov ah,0
    int 10h
ret

writeMenu:
    mov dh, 0
    mov dl, 0 
    mov ah, 2h
    int 10h
     
    lea dx, menu
    mov ah, 9
    int 21h
    
    mov dh, 1
    mov dl, 0 
    mov ah, 2h
    int 10h
     
    lea dx, menu1
    mov ah, 9
    int 21h
    
    mov dh, 2
    mov dl, 0 
    mov ah, 2h
    int 10h
     
    lea dx, menu2
    mov ah, 9
    int 21h
    
    mov dh, 3
    mov dl, 0 
    mov ah, 2h
    int 10h
     
    lea dx, menu3
    mov ah, 9
    int 21h
    
    mov dh, 4
    mov dl, 0 
    mov ah, 2h
    int 10h
     
    lea dx, menu4
    mov ah, 9
    int 21h 
    
    mov dh, 5
    mov dl, 0 
    mov ah, 2h
    int 10h
ret
	
	
 
ends

end start ; set entry point and stop the assembler.

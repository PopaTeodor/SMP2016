; multi-segment executable file template.
INCLUDE 'emu8086.inc'
data segment
	menu db "Hello.Please choose your option: $"
    menu1 db "1)Draw a rectangle$"
	menu2 db "2)Draw a triangle$"
	menu3 db "3)Draw with your mouse$"
	menusettings db "4)Settings$"
	menu5 db "5)Quit$"
	menusettings1 db "Selecteaza culoarea pe care o doresti:(1-15)$"
	menusettings2 db "Apasa escape pentru a confirma si a te intoarce la meniul principal.$"
	;liniile meniului	

	dim2 equ 50
	dim1 equ 100
	;dimensiune figuri(default:100*50)

	posX equ 100 
	posY equ 100 
	;offseturi fata de (0,0) pentru pozitiile figurilor
		
	color db 15
	;culoare figuri(default:alb)
	
	
ends

stack segment 
    dw   128  dup(0)
ends

code segment
start: 
    mov ax, data
    mov ds, ax
    mov es, ax     
    call clearscreen  ;curata ecranul        
    call writeMenu ;afiseaza meniul
	
    mov ah,1h
    int 21h        ;input(KB)  
      
                     
    cmp al, "5"
    je quit   ;Inchidere program si return la OS
	
    cmp al, "4"
    je drawSettings   ;Meniul de setari
    
    cmp al, "3"
    je drawMouse  ;Desen cu ajutorul mouse-ului
    
    cmp al, "2"
    je drawTriangle ;Deseneaza un triunghi
    	
	cmp al, "1"
    je drawRectangle   ;Deseneaza un dreptunghi
    
  
    jmp start
     
drawSettings:;Meniul de setari
	call clearscreen
    mov dh, 0
    mov dl, 0 
    mov ah, 2h
    int 10h
     
    lea dx, menusettings1
    mov ah, 9
    int 21h

	mov ah,1h
    int 21h     	
	mov color, al

	mov dh, 1
    mov dl, 0 
    mov ah, 2h
    int 10h
	lea dx, menusettings2
    mov ah, 9
    int 21h
	
	mov cx, posX+dim1 ;coloana
	mov dx, posY ;linie
	mov al, color ;culoare
drawLine:
	mov ah, 0ch 
	int 10h
	
	dec cx
	cmp cx, posX
	jae drawLine
	
	;desenez o linie pentru a afisa noua culoare
	
	mov ah,1h
    int 21h      
	cmp al, 27	;tasta Escape pentru confirmare
	jne drawSettings
	
	jmp start

	 
	 
	 
	 
	 
drawMouse: 		 ;program de desen cu ajutorul mouse-ului. Referinta: Laboratorul 4 SMP  
		
		oldX dw -1
		oldY dw 0
		mov ax, 0 
		int 33h 
		;initializare mod lucru mouse
		cmp ax, 0    
	check_mouse_button:
		
		mov ax, 3
		int 33h 
		;preluare pozitie cursor si stare butoane 
		shr cx, 1
		
		cmp bx, 1  
		jne xor_cursor
		mov al, color
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
		int 10h  ;desenare pixel  
		
	check_esc_key:
		mov dl, 255
		mov ah, 6
		int 21h
		
		cmp al, 27	;verificare daca s-a apasat tasta Escape
		jne check_mouse_button
		
	stop:
		jmp start
	



drawRectangle:	;Program desen dreptunghi

	;latura sus
	mov cx, posX+dim1 
	mov dx, posY 
	mov al, color 
rectUp:
	mov ah, 0ch 
	int 10h
	
	dec cx
	cmp cx, posX
	jae rectUp	
	
	
	;latura jos	
	mov cx, posX + dim1
	mov dx, posY + dim2
	mov al, color
rectDown:
	mov ah, 0ch
	int 10h
	
	dec cx
	cmp cx, posX
	ja rectDown
	
	
	;latura stanga	
	mov cx, posX
	mov dx, posY + dim2
	mov al, color
rectLeft:
	mov ah, 0ch
	int 10h
	
	dec dx
	cmp dx, posY
	ja rectLeft
	
		
	;latura dreapta	
	mov cx, posX + dim1
	mov dx, posY + dim2
	mov al, color 
rectRight: 
	mov ah, 0ch
	int 10h
	
	dec dx
	cmp dx, posY
	ja rectRight
	
	;apasare de tasta pentru confirmare
	mov ah,00
	int 16h

jmp start 





drawTriangle:  ;Program desen triunghi

;baza triunghiului
	mov cx,posX + dim1
	mov dx, posY + dim2
	mov al, color	
triDown:
	mov ah, 0ch 
	int 10h	
	dec cx
	cmp cx, posX
    jae triDown    
    
	
;latura stanga
	mov cx,	posX
	mov dx, posY + dim2
	mov al, color	
triLeft:	
	mov ah,0ch 
	int 10h	
	dec dx
	inc cx	
	cmp dx, posY
	jae triLeft
	
	
;latura dreapta
	mov cx,	posX + dim1
	mov dx, posY + dim2
	mov al, color	
triRight:
	mov ah, 0ch
	int 10h		
	dec cx  
	dec dx
	cmp dx, posY
	jae triRight

;apasare de tasta pentru confirmare
	mov ah,00
	int 16h
jmp start





 
quit:    
    mov ax, 4c00h ; exit la sistemul de operare
    int 21h
    
    
clearscreen: ;curata ecranul 
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
     
    lea dx, menusettings
    mov ah, 9
    int 21h 
    
    mov dh, 5
    mov dl, 0 
    mov ah, 2h
    int 10h
	
	lea dx, menu5
    mov ah, 9
    int 21h 
    
    mov dh, 5
    mov dl, 0 
    mov ah, 2h
    int 10h
ret
	
	
 
ends

end start 

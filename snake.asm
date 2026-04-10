[org 0x0100] ; 24L-2513 24L-2515

jmp start

title1 db '                 ',0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0C9h,0DBh,0DBh,0DBh,0C9h,'   ',0DBh,0DBh,0C9h,' ',0DBh,0DBh,0DBh,0DBh,0DBh,0C9h,' ',0DBh,0DBh,0C9h,'  ',0DBh,0DBh,0C9h,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0C9h, 13, 10, '$'
title2 db '                 ',0DBh,0DBh,0C9h,'""""',0C8h,0DBh,0DBh,0DBh,0DBh,0C9h,'  ',0DBh,0DBh,0BAh,0DBh,0DBh,0C9h,'""',0DBh,0DBh,0C9h,0DBh,0DBh,0BAh,' ',0DBh,0DBh,0C9h,0C8h,0DBh,0DBh,0C9h,'""""', 13, 10, '$'
title3 db '                 ',0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0C9h,0DBh,0DBh,0C9h,0DBh,0DBh,0C9h,' ',0DBh,0DBh,0BAh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0BAh,0DBh,0DBh,0DBh,0DBh,0DBh,0C9h,' ',0DBh,0DBh,0DBh,0DBh,0DBh,0C9h,'  ', 13, 10, '$'
title4 db '                 ',0C8h,'""""',0DBh,0DBh,0BAh,0DBh,0DBh,0BAh,0C8h,0DBh,0DBh,0C9h,0DBh,0DBh,0BAh,0DBh,0DBh,0C9h,'""',0DBh,0DBh,0C9h,0DBh,0DBh,0C9h,'',0DBh,0DBh,0C9h,' ',0DBh,0DBh,0C9h,'""','  ', 13, 10, '$'
title5 db '                 ',0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0BAh,0DBh,0DBh,0BAh,' ',0C8h,0DBh,0DBh,0DBh,0DBh,0BAh,0DBh,0DBh,0BAh,'  ',0DBh,0DBh,0BAh,0DBh,0DBh,0BAh,'  ',0DBh,0DBh,0C9h,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0C9h, 13, 10, '$'
title6 db '                 ',0C8h,'""""""',0C8h,0C8h,'""',0C8h,'  ',0C8h,'"""',0C8h,0C8h,'""',0C8h,'  ',0C8h,'""',0C8h,0C8h,'""',0C8h,'  ',0C8h,'""',0C8h,0C8h,'""""""',0C8h, 13, 10, '$'

menu1 db '        1. Start Game', 13, 10, '$'
menu2 db '        2. Quit', 13, 10, 13, 10, '$'
prompt db '        Choose option: $'
scoreprint: db 'Score: ',0
row: times 200 dw 0
col: times 200 dw 0
size: dw 3
foodcounter: dw 3
command: dw 3
exitflag: dw 0
score: dw 0

food_row: dw 5
food_col: dw 4
food_exists: db 0
food_count: dw 0

msg db '   /^\\/^\\',13,10
db '                          |_|  O|',13,10
db '                 \\/     /~     \\_/ \\',13,10
db '                  \\|/  \\',13,10
db '                         \\_______      \\',13,10
db '                                 `\\     \\                 \\',13,10
db '                                   |     |                  \\',13,10
db '                                  /      /                    \\',13,10
db '                                 /     /                       \\\\',13,10
db '                               /      /                         \\',13,10
db '                              /     /                            \\',13,10
db '                            /     /             ----            \\',13,10
db '                           /     /           -~      ~-          \\',13,10
db '                          (      (        -S N A K E  C R A S H E D-       )',13,10
db '                           \\      --    G A M E  O V E R ~-_/ ',13,10
db '                            -_           -                  ~-',13,10
db '                               ---                        ~-',13,10
db 0

delay:
pusha
mov cx , 7
ultimate:
push cx
mov cx , 0ffffh
loopx:
loop loopx
pop cx
loop ultimate
popa
ret

THEEND:
pusha
mov si,msg
print_loop:
lodsb
cmp al, 0
je done
cmp al, 13
je cr_check
mov ah, 0Eh
mov bh, 0
int 10h
jmp print_loop

cr_check:
lodsb
mov al, 13
mov ah, 0Eh
int 10h
mov al, 10
mov ah, 0Eh
int 10h
jmp print_loop

done:
mov ah,0x09
mov dx, menu1
int 0x21
mov dx, menu2
int 0x21
mov dx, prompt
int 0x21
popa
ret

clearscreen:
pusha
push bp
mov bp, sp
mov ax, 0xb800
mov es, ax
mov di, 0
mov ax , 0x0920
mov cx, 2000
cld
rep stosw
pop bp
popa
ret

clearscreenhome:
pusha
push bp
mov bp, sp
mov ax, 0xb800
mov es, ax
mov di, 0
mov al,' '
mov ah,0x08
mov cx, 2000
cld
rep stosw
pop bp
popa
ret

clearsnake:
pusha
mov cx, [size]
mov ax, 0B800h
mov es, ax
mov bx, 0
loopClearSnake:
mov ax, 80
mov dx, [row + bx]
mul dx
add ax, [col + bx]
shl ax, 1
mov di, ax
mov ax , 0x0920
mov [es:di], ax
add bx, 2
loop loopClearSnake
popa
ret

rowinsert:
mov word [row], 10
mov word [row+2], 10
mov word [row+4], 10
ret

colinsert:
mov word [col], 14
mov word [col+2], 12
mov word [col+4], 10
ret

printsnake:
pusha
mov ax, 0xb800
mov es, ax
mov al,0xDB
mov ah,0x08
mov di,0
mov [es:di],ax
mov cx, [size]
xor si, si
print:
mov bx, si
shl bx, 1
mov ax, [row + bx]
mov bp, [col + bx]
mov bx, 80
mul bx
add ax, bp
shl ax, 1
mov di, ax
mov al, 2
mov ah, 0x07
mov [es:di], ax
inc si
loop print
popa
ret

collision:
pusha
mov ax,[row]
mov dx,[col]
mov si,1
check_loop:
cmp si,[size]
jge done_check
mov bx,si
cmp si,[size]
je done_check
shl bx,1
mov bp,[row+bx]
cmp ax,bp
jne next_seg
mov bp,[col+bx]
cmp dx,bp
jne next_seg
mov word [exitflag],1
jmp done_check
next_seg:
inc si
cmp si,[size]
jl check_loop
done_check:
popa
ret

printBorder:
pusha
mov ax,0xb800
mov es,ax
mov al,0xDB
mov ah,0x08
mov di,0
mov cx,80
rep stosw
mov cx,24
loopLeft:
mov [es:di],ax
add di,160
loop loopLeft
mov di,3840
mov cx,80
loopdown:
mov[es:di],ax
add di,2
loop loopdown
mov cx,25
mov di,3998
loopright:
mov [es:di],ax
sub di,160
loop loopright
popa
ret

hitwall:
mov word [exitflag],1
ret

moveup:
cmp word [row], 3
jl hitwall
mov cx,[size]
dec cx
mov si,cx
shl si,1
U1:
mov ax,[row+si-2]
mov [row+si],ax
mov ax,[col+si-2]
mov [col+si],ax
sub si,2
loop U1
sub word[row],2
ret

movedown:
cmp word [row], 21
jg hitwall
mov cx,[size]
dec cx
mov si,cx
shl si,1
D1:
mov ax,[row+si-2]
mov [row+si],ax
mov ax,[col+si-2]
mov [col+si],ax
sub si,2
loop D1
add word[row],2
ret

moveleft:
cmp word [col], 3
jl hitwall
mov cx,[size]
dec cx
mov si,cx
shl si,1
L1:
mov ax,[row+si-2]
mov [row+si],ax
mov ax,[col+si-2]
mov [col+si],ax
sub si,2
loop L1
sub word[col],2
ret

moveright:
cmp word [col], 75
jg hitwall
mov cx,[size]
dec cx
mov si,cx
shl si,1
R1:
mov ax,[row+si-2]
mov [row+si],ax
mov ax,[col+si-2]
mov [col+si],ax
sub si,2
loop R1
add word[col],2
ret

erase_food:
cmp byte [food_exists],1
jne skip_erase
mov ax,0xb800
mov es,ax
mov ax,[food_row]
mov bx,80
mul bx
add ax,[food_col]
shl ax,1
mov di,ax
mov word [es:di],0720h
skip_erase:
ret

gen_food:
cmp byte [food_exists],1
je end_gen
cmp word[food_count],15
je end_gen
again:
mov ah, 00h
int 1Ah
mov ax,dx
xor dx,dx
mov bx,9
div bx
shl dx,1
add dx,4
push dx
mov ah, 00h
int 1Ah
mov ax,dx
xor dx,dx
mov bx,35
div bx
shl dx,1
add dx,4
push dx
add word[food_count],1
pop dx
pop bx
mov cx,[size]
mov si,0
loopgen_food:
cmp dx,word[col+si]
jnz cont_loopgen_food
cmp bx,word[row+si]
jnz cont_loopgen_food
jmp again
cont_loopgen_food:
add si,2
loop loopgen_food
cmp dx,word[food_col]
jnz food_existss
cmp bx,word[food_row]
jnz food_existss
jmp again
food_existss:
mov word[food_col],dx
mov word[food_row],bx
mov byte [food_exists],1
end_gen:
mov word[food_count],0
ret

check_food:
mov ax,[row]
cmp ax,[food_row]
jne no_eat
mov ax,[col]
cmp ax,[food_col]
jne no_eat
inc word[score]
call erase_food
inc word [size]
mov byte [food_exists],0
call gen_food
no_eat:
ret

print_food:
cmp byte [food_exists],1
jne skip_print
mov ax,0xb800
mov es,ax
mov ax,[food_row]
mov bx,80
mul bx
add ax,[food_col]
shl ax,1
mov di,ax
mov ax,0x0805
mov [es:di],ax
skip_print:
ret

printScore:
pusha
mov ax,0xb800
mov es,ax
mov di,130
mov ah,0
mov al,'S'
mov [es:di],al
add di,2
mov al,'C'
mov [es:di],al
add di,2
mov al,'O'
mov [es:di],al
add di,2
mov al,'R'
mov [es:di],al
add di,2
mov al,'E'
mov [es:di],al
add di,2
mov al,':'
mov [es:di],al
add di,2
mov al,' '
mov [es:di],al
add di,2
mov ax,[score]
cmp ax,0
jne have_digits
mov ah,0
mov al,'0'
mov [es:di],al
jmp Done
have_digits:
xor cx,cx
convert_loop:
xor dx,dx
mov bx,10
div bx
push dx
inc cx
cmp ax,0
jne convert_loop
print_digits:
pop dx
add dl,'0'
mov al,dl
mov [es:di],al
add di,2
loop print_digits
Done:
popa
ret

quit:
mov ax, 0x4C00
int 0x21

start:
mov ax,0
mov word[exitflag],ax
call printHomeScreen
menu_loop:
mov ah, 0x00
int 0x16
cmp al, '1'
je start_game
cmp al, '2'
je quit
jmp menu_loop
mov ah, 0x00
int 0x16
mov ax, 0x4C00
int 0x21

start_game:
call clearscreenhome
call clearscreen
call printBorder
mov cx, 200
xor di, di
clear_positions:
mov word [row + di], 0
mov word [col + di], 0
add di, 2
loop clear_positions
mov word [size], 3
call rowinsert
call colinsert
mov word [command], 3
mov word [exitflag], 0
mov word [score], 0
mov word [foodcounter], 3
mov byte [food_exists], 0
mov word [food_count], 0
mov word [food_row], 5
mov word [food_col], 4
call printsnake
call gen_food
call printScore
jmp mainloop

mainloop:
cmp word [exitflag],1
je theEnd
in al,0x60
cmp al,4Bh
je leftkey
cmp al,4Dh
je rightkey
cmp al,48h
je upkey
cmp al,50h
je downkey
cmp al,01h
je esckey
jmp skipkey

theEnd:
call clearscreenhome
call THEEND
mov ah, 0
int 16h
jmp menu_loop

leftkey:
mov word [command],2
jmp skipkey
rightkey:
mov word [command],3
jmp skipkey
upkey:
mov word [command],0
jmp skipkey
downkey:
mov word [command],1
jmp skipkey
esckey:
mov word [exitflag],1

endprogram:
mov ax, 4c00h
int 21h

skipkey:
call clearsnake
cmp word [command],0
je tup
cmp word [command],1
je tdown
cmp word [command],2
je tleft
cmp word [command],3
je tright
jmp skipmove

tup:
mov ax,[col]
cmp [col+2],ax
je skipmoveup
cont_skipmoveup:
call moveup
jmp skipmove
skipmoveup:
mov ax,[row]
cmp [row+2],ax
ja cont_skipmoveup
call movedown
jmp skipmove

tdown:
mov ax,[col]
cmp [col+2],ax
je skipmovedown
cont_skipmovedown:
call movedown
jmp skipmove
skipmovedown:
mov ax,[row]
cmp [row+2],ax
jb cont_skipmovedown
call moveup
jmp skipmove

tleft:
mov ax,[row]
cmp [row+2],ax
je skipmoveleft
cont_skipmoveleft:
call moveleft
jmp skipmove
skipmoveleft:
mov ax,[col]
cmp [col+2],ax
ja cont_skipmoveleft
call moveright
jmp skipmove

tright:
mov ax,[row]
cmp [row+2],ax
je skipmoveright
cont_skipmoveright:
call moveright
jmp skipmove
skipmoveright:
mov ax,[col]
cmp [col+2],ax
jb cont_skipmoveright
call moveleft
jmp skipmove

skipmove:
call check_food
call printScore
call collision
call printsnake
call print_food
call delay
jmp mainloop

printHomeScreen:
call clearscreenhome
call clearscreenhome
mov ah, 0x09
mov dx, title1
int 0x21
mov dx, title2
int 0x21
mov dx, title3
int 0x21
mov dx, title4
int 0x21
mov dx, title5
int 0x21
mov dx, title6
int 0x21
mov dx, menu1
int 0x21
mov dx, menu2
int 0x21
mov dx, prompt
int 0x21
ret
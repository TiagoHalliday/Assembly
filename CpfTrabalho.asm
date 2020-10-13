org 100h

.DATA

;cpfs de teste 04d,07d,05d,02d,05d,08d,07d,04d,01d // num DB 06d,00d,04d,00d,05d,06d,06d,08d,05d //
;06d,00d,04d,00d,05d,06d,06d,08d,03d     

num DB 06d,00d,04d,00d,05d,06d,06d,08d,03d 

;digitos verificadores dos cpfs de teste 06d, 06d // 00d, 03d // 03d, 03d
dv DB   02d, 00d

.CODE
                  
lea ax,num

mov si,ax
    
mov cx, 9h


;conta do primeiro digito verificador 
DV1:
mov al, [si]
inc bl
mul bl
add dl,al 
inc si
loop DV1

;na primeira conta pega do primeiro digito do cpf ate o nono e multiplica eles comecando com o 
;numero 1 ex-> 6x1, 0x2, 4x3, 0x4, 5x5, etc



      
mov al,dl
;depois de fazer todas as multiplicacoes e somas o resultado e' dividido por 11 e o resto e'
;o primeiro digito verificador
mov bl,11
div bl
           
           
;comparar o resto da divisao com 10, pq se tiver dado 10 o primeiro digito verificador e' 0           
cmp ah, 0ah
jz deuDez




mov dh, ah


;digito 1 e' armazenado do dh


 
lea ax, num
mov si,ax 
mov bl, 0 
mov dl, 0  
mov cx, 9h   


;conta do segundo digito verificador   
DV2:    
mov al, [si]   
mul bl
inc bl
add dl, al
inc si
loop DV2

;na segunda conta pega do primeiro digito do cpf ate o decimo que no caso o decimo e' o primeiro
;digito verificador calculado e multiplica eles comecando com o zero 
;ex-> 6x0, 0x1, 4x2, 0x3, 5x4, etc 

mov al, dh
mov bl, 9
mul bl

add al,dl  
mov bl, 11
div bl
mov dl,ah    

;aqui caso o segundo digito tmb der 10 ele faz um pulo para setar o segundo digito como 0            
cmp dl, 0ah
jz deuDezz 

;e esse pulo e para ir para a parte das mensagem falando se os dvs estao certos ou errados
jmp msgcerta


;so vem pra ca caso o o resto do resultado da primeira divisao tiver dado 10 
deuDez:
mov ah, 0
mov dh, ah
 
lea ax, num
mov si,ax 
mov bl, 0 
mov dl, 0  
mov cx, 9h   


;conta do primeiro digito verificador caso o primeiro der 10  
DV3:    
mov al, [si]   
mul bl
inc bl
add dl, al
inc si
loop DV3


;na segunda conta pega do primeiro digito do cpf ate o decimo que no caso o decimo e' o primeiro
;digito verificador calculado e multiplica eles comecando com o zero 
;ex-> 6x0, 0x1, 4x2, 0x3, 5x4, etc
mov al, dh
mov bl, 9

mul bl

add al,dl  
mov bl, 11
div bl

mov dl,ah
          
;aqui caso o segundo digito tmb der 10 ele faz um pulo para setar o segundo digito como 0                       
cmp dl, 0ah 
jz deuDez2  


msgcerta:
 
fim: 

lea ax,dv

mov si,ax

;aqui os dvs certos que estao armazenados em uma variavel sao colocados no registrador ax
;e os dvs do calculo feito acima sao colocados no registrador cx para ser feita uma comparacao
;para saber se eles estao certos ou errados               
mov ah, [si]
inc si
mov al, [si]
  
mov cl, dl
mov ch,dh 
  
;comparar os digitos verificadores
cmp ax, cx  
jz certo       
      
 
;mensagem se tiver errado      
jmp errado       ; jump over data declaration

msg:    db      "DV errado!", 0Dh,0Ah, 24h

errado:  mov     dx, msg  ; load offset of msg into dx.
        mov     ah, 09h  ; print function is 9.
        int     21h      ; do it!
        
        mov     ah, 0 
        int     16h      ; wait for any key....


;mensagem se tiver correto      
certo:                                
jmp dvcerto       ; jump over data declaration

msg1:    db      "DV correto!", 0Dh,0Ah, 24h

dvcerto:  mov     dx, msg1  ; load offset of msg into dx.
        mov     ah, 09h  ; print function is 9.
        int     21h      ; do it!
        
        mov     ah, 0 
        int     16h      ; wait for any key....
      
 
hlt 
 
 
 
;o codigo so chega aqui caso o segundo digito for 10 
deuDez2:
;aqui o segundo digito vai ser setado como 0 e depois o programa vai voltar
;para a parte das mensagem e ira acabar
mov dl, 0 

cmp dl, 0
jz fim
      
ret





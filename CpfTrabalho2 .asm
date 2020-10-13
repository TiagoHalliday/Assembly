
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h


lea dx, cpf
mov al,0 
mov ah, 3Dh
int 21h
mov bx,ax
mov cx,11
mov ah, 3fh
int 21h
cmp ax, 0
jz calcule
mov ah, 3eh
int 21h


.DATA

 msgc db "DVs corretos", 24H
 msge db "DVs errados", 24H
 
 
 
.CODE

calcule:   

mov si, dx
mov dx, 0 
mov bx,0
mov cx, 9

inicio:
mov al, [si]
sub al, 30h
inc bl
mul bl
add dl,al 
inc si
loop inicio

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


 
lea ax, cpf
mov si,ax 
mov bl, 0 
mov dl, 0  
mov cx, 9h   


;conta do segundo digito verificador   
DV2:    
mov al, [si]
sub al, 30h   
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
jz deuDez2 



;e esse pulo e para ir para a parte das mensagem falando se os dvs estao certos ou errados
jmp msgcerta


;so vem pra ca caso o o resto do resultado da primeira divisao tiver dado 10 
deuDez:
mov ah, 0
mov dh, ah
 
lea ax, cpf
mov si,ax 
mov bl, 0 
mov dl, 0  
mov cx, 9h   


;conta do primeiro digito verificador caso o primeiro der 10  
DV3:    
mov al, [si]   
sub al, 30h
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
         
lea ax, cpf
mov si,ax 
mov cx, 9    


;loop para pegar os dvs nas posicoes 10 e 11  
acharDV:    
inc si
loop acharDV




;aqui os dvs certos sao colocados no registrador ax
;e os dvs do calculo feito acima sao colocados no registrador cx para ser feita uma comparacao
;para saber se eles estao certos ou errados               
mov ah, [si]
sub ah, 30h

inc si     
mov al, [si]
sub al, 30h
  
mov cl, dl
mov ch,dh 
  
;comparar os digitos verificadores
cmp ax, cx  
jz certo       
      
 
;mensagem se tiver errado      


mov ah, 09h
lea dx, msge
int 21h 
int 20h


;mensagem se tiver correto      
certo:                                
mov ah,09h
lea dx, msgc
int 21h

int 20h

hlt 
 
 
 
;o codigo so chega aqui caso o segundo digito for 10 
deuDez2:
;aqui o segundo digito vai ser setado como 0 e depois o programa vai voltar
;para a parte das mensagem e ira acabar
mov dl, 0 

cmp dl, 0
jz fim



cpf DB "arquivo.txt", 0
;nome do arquivo contendo o cpf completo                    











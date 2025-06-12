@ Programme tabmult : Affiche les tables de multiplication de de 1 a 10
N_MAX= 10
   .data
barre :  .byte '|'
         .byte 0
espace : .byte ' '
         .byte 0
tirets : .asciz "___"

debutTab:    .skip N_MAX*N_MAX*4   @ adresse du debut du tableau

   .text
   .global main

si_multiple_de_10:
    push {lr}               

while:
    sub r4, r4, #10  @je soustrait 10 a notre valeur puis je regarde le reste    
    cmp r4, #0              
    beq multiple_de_10      
    blt finwhile            
    b while                 

finwhile:
    mov r7, #0  @r7=0 si r4 n'est pas une multiple de 10
    b f

multiple_de_10:
    mov r7, #1   @r7=1 si r4 est une multiple de 10      

f:
    pop {lr}                
    bx lr   

main: push {lr}

   @ remplissage du tableau

   ldr r0, ptr_debutTab
   mov r1,#1 @r1 n
   mov r2,#1 @ compteur
   mov r3, #1 @m

pour : 
   cmp r3, #100
   bgt affichage

   str r1,[r0], #4  @table[m]=n
   ADD r1, r1,r2 @n=n+cpt

   mov r4, r3
   bl si_multiple_de_10 @verifie si r1 (r4) est un multiple de 10 (m%m==0)
   cmp r7, #1
   beq si @m est  un multiple de 10
   ADD r3, r3, #1
   b pour

si:
   ADD r2, r2, #1
   mov r1, r2
   ADD r3, r3, #1
   b pour


   @ affichage du tableau
affichage:
   ldr r0, ptr_debutTab
   mov r3, #1 @m

tq : 
   cmp r3, #100
   bgt fin

   ldr r1, adr_barre
   BL EcrChn

   ldr r5, [r0], #4  @ Charger directement la valeur du tableau
   mov r1, r5
   BL EcrNdecim32

   cmp r5, #N_MAX
   bge skip
   ldr r1, adr_espace
   BL EcrChn

skip:
   mov r4, r3
   bl si_multiple_de_10 @verifie si r1 (r4) est un multiple de 10
   cmp r7, #1
   bne go @m n'est pas un multiple de 10
   ldr r1, adr_barre
   BL EcrChn
   BL AlaLigne

go:
   ADD r3, r3, #1
   b tq
   
fin: pop {lr}
     bx lr

ptr_debutTab : .word debutTab
adr_barre :    .word barre
adr_espace :   .word espace
adr_tirets :   .word tirets

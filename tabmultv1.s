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
main: push {lr}

   @ remplissage du tableau

   ldr r1, ptr_debutTab
   mov r0,#1 @r1 nombre de ligne

tql : 
   cmp r0, #N_MAX
   bgt affichage
   mov r2, #1 @r2 nombre de colonne
    
   tqc :
      cmp r2, #N_MAX
      bgt fintqc
      MUL r3, r0, r2
      str r3, [r1], #4 @stockage linéaire séquentiel
      ADD r2, r2, #1
      b tqc

   fintqc :
      ADD r0, r0, #1
      b tql


   @ affichage du tableau
affichage:
   mov r0, #0 @ligne
pour1 :
   cmp r0, #9
   bgt fin
   mov r2, #0 @colonne

   pour2:
      cmp r2, #9
      bgt finpour2

      ldr r1, adr_barre
      BL EcrChn 
      ldr r5, ptr_debutTab   
      mov r6, r0  
      mov r7, #N_MAX         
      mul r8, r6, r7   
      ADD r8, r8, r2       
      ldr r4, [r5, r8, lsl #2]  @ Charger table[n_lig][n_col] dans r4

   si1:
      cmp r4, #100
      bge si2
      ldr r1, adr_espace
      BL EcrChn

   si2:
      cmp r4, #N_MAX
      bge aff
      ldr r1, adr_espace
      BL EcrChn

   aff:
      mov r1, r4 
      BL EcrNdecim32
      ADD r2, r2, #1
      b pour2

   finpour2:
      ldr r1, adr_barre
      BL EcrChn
      BL ALaLigne
      mov r4, #1

repeter:
   cmp r4, #N_MAX
   bgt finrepeter
   ldr r1, adr_barre
   BL EcrChn
   ldr r1, adr_tirets
   BL EcrChn
   ADD r4, r4, #1
   b repeter

finrepeter:
   ldr r1, adr_barre
   BL EcrChn
   BL ALaLigne
   ADD r0, r0, #1
   b pour1

fin: pop {lr}
     bx lr

ptr_debutTab : .word debutTab
adr_barre :    .word barre
adr_espace :   .word espace
adr_tirets :   .word tirets

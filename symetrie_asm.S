                                                                                        
@  Importation des,constantes symboliques WIDTH, HEIGHT, BYTES, BYTES_PER_LINE          
#include "image_bits_include.h"                                                         
                                                                                        
                 .global symetrie_octet                                                 
                 .global permuter_cols                                                  
                 .global symetrie_axe_v                                                 
                 .global permuter_ligne                                                 
                 .global symetrie_axe_h                                                 
                 .global symetrie_axe_h                                                 
                 .global permuter_lignes                                                
                 .global symetrie_axe_v                                                 
                                                                                        
                 .text                                                                  


@@@@@@@@@@@@@@@@@@symetrie_octet@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ r0 : parametre reçu adresse                                                           
@ r1 : variable locale octet                                                            
                                                                                        
#ifndef C_SYMETRIE_OCTET                                                                
#ifndef SYMTAB                                                                          
                                                                                        
@  Version avec opérations bit à bit                                                                                                                                          
symetrie_octet:        
push {r4, r5, r6, r7, r8, r9, r10,lr}
LDR r1, [r0] @ r1=octet = *adresse

@ echange de quartets adjacents
AND r2, r1, #0xF0
MOV r2, r2, LSR #4 @r2=(octet & 0xF0 ) >> 4
AND r3, r1, #0x0F
MOV r3, r3, LSL #4 @r3=(octet & 0x0F ) << 4

ORR r1, r2, r3

@echange de doublets adjacents
AND r5, r1, #0xCC
MOV r5, r5, LSR #2 @r5=( octet & 0xCC ) >> 2
AND r6, r1, #0x33
MOV r6, r6, LSL #2  @r6=(octet & 0x33 ) <<2

ORR r1, r5, r6

@ echange de bits adjacents
AND r8, r1, #0xAA 
MOV r8, r8, LSR #1  @r8=( octet & 0xAA ) >> 1
AND r9, r1, #0x55 
 MOV r9, r9, LSL #1 @r9=( octet & 0x55 ) << 1

ORR r1, r8, r9

STRB r1 ,[r0] @ *adresse = octet

pop {r4, r5, r6, r7, r8, r9, r10,lr}
bx lr
                                                                                        
#else  // SYMTAB      

@@@@@@@@@@@@@@@@@@symetrie_octet version tabulee@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                                                                  
@ Version tabulée                                                                       
@symetrie_octet:  
@ r1=octet
@push {lr}
@ldrb r1, [r0] @ octet = *adresse
@ldr r2, adr_tabsym_octet
@ldrb r1, [r2, r1]
@strb r1, [r0]  @ *adresse = octet
@pop {lr}
@bx lr                                                    
#endif  // SYMTAB                                                                       
#endif  // C_SYMETRIE_OCTET   

@@@@@@@@@@@@@@@@@@permuter_cols@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ r0 : parametre tab                                                                    
@ r1 : parametre col                                                                                                                                                            
#ifndef C_PERMUTER_COLS                                                                 
                                                                             
permuter_cols:   
@r2=tmp
push {r4,r5,r6,r7,r8,r9,lr}

ldrb r3, LD_BYTES_PER_LINE 
SUB r5, r3, #1
SUB r5, r5, r1 @r5 = BYTES_PER_LINE - 1 - col
ADD r4, r0, r5 @r4=&tab[BYTES_PER_LINE - 1 - col]
ldrb r2, [r4] @ tmp = tab[BYTES_PER_LINE - 1 - col]

ADD r8, r0, r1 @r8=&tab[col]
ldrb r6,[r8] @r6=tab[col]
strb r6, [r4] @ tab[BYTES_PER_LINE-1−col] = tab[col] 

strb r2, [r8] @ tab[col]= tmp

pop {r4,r5,r6,r7,r8,r9,lr}
bx lr 

#endif // C_PERMUTER_COLS                                                               

@@@@@@@@@@@@@@@@@@symetrie_axe_v@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                                                                     
@ r0 : paramètre image                                                                  
                                                                                        
#ifndef C_SYMETRIE_AXE_V                                                                
symetrie_axe_v:
push {lr}

@ r1 = position, r2 = li, r3 = col, r4 = addresse
 
mov r1, #0 @position=0
ldr r5, LD_BYTES

for1v:
    cmp r1, r5
    bhs finf @position >=BYTES

    push {r0, r1} @ On enrgistre les registres utilises jusqu'a maintenant 
    ADD r0, r0, r1 @r0=image+position
    bl symetrie_octet @symetrie_octet(image+position)
    pop {r0, r1} @ On récupère les valeurs des registres enregistrer
    
    ADD r1, r1, #1 @position++
    b for1v

finf:
    mov r2, #0 @li =0
    ldrb r6, LD_HEIGHT
    ldrb r7, LD_BYTES_PER_LINE
    mov r8, r7, ASR #1 @BYTES PER LINE / 2


for2v:
    cmp r2, r6
    bhs f2v @li>=HEIGHT

    MUL r9, r2, r7 @li∗BYTES PER LINE
    ADD r4, r0, r9 @ r7= adresse = image+li∗BYTES PER LINE

    mov r3, #0 @col=0

    for3v:
        cmp r3, r8
        bhs f3v @col>=BYTES_PER_LINE

        push {r0, r1, r2, r3}
        mov r0, r4
        mov r1, r3
        bl permuter_cols
        pop {r0,r1,r2,r3}

        ADD r3, r3, #1 @col++
        b for3v
    f3v:
        ADD r2, r2, #1 @li++
        b for2v
f2v:
pop {lr}
bx lr
                                                                                   
#endif // C_SYMETRIE_AXE_V  


@@@@@@@@@@@@@@@@@@permuter_lignes@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ r0 : tab                                                                              
@ r1 : li                                                                               
                                                                                        
#ifndef C_PERMUTER_LIGNES                                                               
permuter_lignes: 
@r2=tmp
push {lr}

ldrb r4, LD_BYTES_PER_LINE
MUL r5, r4, r1  @r5 = li*BYTES_PER_LINE
ADD r7, r5, r0 @  r4=tab[li][0] = tab + li*BYTES_PER_LINE
ldrb r2, [r7] @tmp = tab[li][0]

ldrb r3, LD_HEIGHT 
SUB r3, r3, #1
SUB r3, r3, r1 @r3=HEIGHT −1 − li
MUL r6, r3, r4 @ r6=(HEIGHT −1 − li)*BYTES_PER_LINE
ADD r6, r6, r0 @  r6=&tab [HEIGHT−1−li]  [0]
ldrb r9, [r6] @r9=tab [HEIGHT−1−li] [0]
strb r9, [r7] @tab[li][0] = tab[HEIGHT−1−li][0]

strb r2, [r6] @tab [HEIGHT−1−li][0] = tmp

pop {lr}
bx lr
                                                                                        
#endif // C_PERMUTER_LIGNES                                                             

@@@@@@@@@@@@@@@@@@symetrie_axe_h@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                                                                 
@ r0 : paramètre image                                                                  
                                                                                        
#ifndef  C_SYMETRIE_AXE_H                                                               
symetrie_axe_h:
@r1=li, r2=col
push {lr}

ldrb r3, LD_HEIGHT
mov r3, r3, ASR #1 @HEIGHT/ 2
ldrb r4, LD_BYTES_PER_LINE

MOV r1, #0 @li=0
for1h: 
    cmp r1, r3
    bhs f1h @ Si li >= HEIGHT/2 branchement vers fin de boucle f1h
    MOV r2, #0 @col=0
    for2h:
        cmp r2, r4
        bhs f2h @ Si col >= BYTES_PER_LINE branchement vers fin de boucle f2h

        @ On veut maintenant passer en parametre r0 et r1 tel que :
        @ r0 <- (ligne_t *)(image+col)
        @ r1 <- li
        push {r0,r1,r2,r3, r4} @ On enrgistre les registres utilises jusqu'a maintenant 
        ADD r0, r0, r2 @ r0 =image+col
        bl permuter_lignes
        pop {r0, r1, r2, r3, r4} @ On récupère les valeurs de registres

        ADD r2, r2, #1
        b for2h
    f2h:
        ADD r1, r1, #1
        b for1h

f1h:
pop {lr}
bx lr

#endif   // C_SYMETRIE_AXE_H                                                            


LD_BYTES: .word BYTES
@adr_tabsym_octet : .word tabsym_octet
LD_WIDTH: .word WIDTH
LD_HEIGHT: .word HEIGHT
LD_BYTES_PER_LINE: .word BYTES_PER_LINE
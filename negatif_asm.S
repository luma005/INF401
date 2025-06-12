                                                                                      
@  Importation des,constantes symboliques WIDTH, HEIGHT, BYTES, BYTES_PER_LINE        
#include "image_bits_include.h"                                                       
										      
                                                                                      
                 .text                                                                
                                                                                      
@ r0 : parametre octet                                                                
                                                                                      
#ifndef C_NEG_OCTET                                                                   
                 .global neg_octet                                                    
                                                                                      
neg_octet: 
MVN r0, r0 @complementaire a 1 de r0
bx lr                                                                
                                                                                      
#endif // C_NEG_OCTET                                                                 
                                                                                      
#ifndef C_NEG_IMAGE                                                               
                 .global neg_image                                                    
@ r0 : parametre reçu image 

neg_image: 
@r0=address, r1=adr, r2= address+BYTES, r3=adr_bytes
push {lr} 
mov r1, r0 @adr = address
ldr r3, adr_bytes
ADD r2,r0,r3
for:
    cmp r1, r2 @ on compare adr et address+BYTES
    bge f @adr >= address+BYTES (on fait donc un branchement ver l'étiquette de f)
    add r4, r3, r2
    ldrb r0, [r1]  @addresse de r1 est dans r0 maintenant		
    BL neg_octet @ appel de la fonction neg_octet
    strb r0, [r1] @ on store le contenu complémentaire dans l'addresse initiale de adr
    add r1, r1,#1 @adr++
    b for

f: @fin de boucle
    pop {lr}                                                                                    
    bx lr                                                           
                                                                                      
adr_bytes:	.word BYTES
#endif // C_NEG_IMAGE                                                                 

                                                                        
    
#include "image_bits_include.h"                                         
                                                                        
                .text                                                   
                                                                        
                .balign 4                                               
                                                                        
#ifndef C_AFFICHER_CONTENU                                              
                .global  afficher_contenu                               
                                                                        
afficher_contenu:
    push {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, lr}
    mov r5, r0



    ldr r0, adr_print_width                                      @affichage de l'entete du fichier
    ldr r1, adr_width
    bl afficher_entier

    ldr r0, adr_print_height
    ldr r1, adr_height
    bl afficher_entier

    ldr r0, adr_d_fichier
    ldr r1, adr_vide
    bl afficher_chaine

    mov r2, #0                                                  @i=0
    mov r3, #12                                                 @position = LINE_LENGTH
    ldr r4, adr_bytes                                           @BYTES
    

    tant_que:                                                   @while(i<BYTES)
        cmp r2, r4
        bge fin_tant_que
    faire:
        sub r3, r3, #1                                          @position --;

        push {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, lr}       @afficher_entier("0x%02x", *address);
        ldr r0, adr_val
        ldrb r1, [r5]
        bl afficher_entier
        pop {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, lr}

        sub r6, r4, #1                                          @BYTES -1
        si_virgule:                                             @if (i != BYTES -1)
            cmp r2, r6
            beq sinon_virgule
        alors_virgule:                                          @afficher_chaine(", ","")
            push {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, lr}
            ldr r0, adr_virgule
            ldr r1, adr_vide
            bl afficher_chaine
            pop {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, lr}
        sinon_virgule:
        si_pos:                                                 @if (position == 0)
            cmp r3, #0
            bne sinon_pos
        alors_pos:
            ldr r0, adr_saut_ligne                                @afficher_chaine("\n","");
            ldr r1, adr_vide
            push {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, lr}
            bl afficher_chaine
            pop {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, lr}

            mov r3, #12                                         @position =LINE_LENGTH;
        sinon_pos:

        add r5, r5, #1                                          @address++;
        add r2, r2, #1                                          @i++;
        b tant_que
    fin_tant_que:

    ldr r0, adr_f_fichier                                     @afficher_chaine ("};\n","");
    ldr r1, adr_vide
    bl afficher_chaine

    pop {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, lr}
    bx lr
#endif   // C_AFFICHER_CONTENU                                          

adr_bytes: .word BYTES
adr_width: .word WIDTH
adr_height: .word HEIGHT
adr_print_width: .word txt_print_width
adr_print_height: .word txt_print_height
adr_d_fichier: .word txt_d_fichier
adr_val : .word txt_val
adr_virgule : .word txt_virgule
adr_saut_ligne: .word txt_saut_ligne
adr_f_fichier: .word txt_f_fichier
adr_vide: .word txt_vide
adr_test: .word txt_vide

.data 

txt_print_width : .asciz "\n#define width %d\n"
txt_print_height : .asciz "#define height %d\n\n"
txt_d_fichier: .asciz "static unsigned char bits[] = {\n"
txt_val: .asciz "0x%02x"
txt_virgule: .asciz ", "
txt_saut_ligne: .asciz "\n"
txt_f_fichier: .asciz "};\n"
txt_vide: .asciz ""
txt_test: .asciz "%d\n"
@ procedure map
@ parametres : A COMPLETER
@ algorithme : A COMPLETER
@ allocation des registres : A COMPLETER

         .text
         .global  map2

map2:
    push {lr}    
    push {fp}
    mov fp, sp     
       
    ldr r6, [fp, #8] @fonction f
    ldr r2, [fp, #12] @tab2
    ldr r1, [fp, #16] @NMAX
    bl EcrNdecim32
    ldr r0, [fp, #20] @tab1 


    mov r5, #0
boucle :
    cmp r5, r1
    beq fin

    ldrb r3, [r0, r5] @t1[i] = valeur
    blx r6 @appel de la fonction f(t1[i])
    strb r4, [r2, r5] @t2[i]=f(t1[i])

    add r5, r5, #1 @incrementation 
    b boucle 

fin :
    pop {fp}
    pop {lr}
    bx lr

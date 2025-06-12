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
    @push {r0,r1,r2,r3,r4,r5,r6}
       
    ldr r6, [fp, #8] @fonction f
    ldr r2, [fp, #12] @tab2
    ldr r1, [fp, #16] @NMAX
    bl EcrNdecim32
    ldr r0, [fp, #20] @tab1 

si:
    cmp r1, #0
    beq fin

    sub r1, r1, #1 @r1 = NMAX - 1
    ldrb r3, [r0, r1]  @t1[NMAX-1]
    blx r6 @appel de la fonction f(t1[i])
    strb r4, [r2, r1]@t2[i]=f(t1[i])

    push {r0}
    push {r1}
    push {r2}
    push {r6}
    bl map2
    add sp, sp, #16

fin :
    @pop {r0,r1,r2,r3,r4,r5,r6}
    pop {fp}
    pop {lr}
    bx lr

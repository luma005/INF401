@ procedure map
@ parametres : A COMPLETER
@ algorithme : A COMPLETER
@ allocation des registres : A COMPLETER

         .text
         .global  map
map:
@ map(t1, n, t2, f), paramètres :
@ r0 : adresse du tableau t1
@ r1 : taille n (EntN)
@ r2 : adresse du tableau t2
@ r3 : adresse de la fonction f 
        

    push {lr}            
    mov r5, #0  @ i <- 0
    mov r7, r3  @ copie de l'adresse de f dans r7

boucle:
    cmp r5, r1  @ tant que i != n
    beq fin

    ldrsb r6, [r0, r5]    @ r6 <- t1[i] 
    mov r3, r6          @ passer t1[i] dans r3 pour appel de f
    blx r7              @ appel de la fonction f(t1[i]), resultat est maintenant dans r4

    strb r4, [r2, r5]    @ t2[i] <- f(t1[i])

    add r5, r5, #1      @ i <- i + 1
    b boucle

fin:
    pop {lr}            
    bx lr             

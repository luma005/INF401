@ fonction red
@ parametres : A COMPLETER
@ algorithme : A COMPLETER
@ allocation des registres : A COMPLETER

         .text
         .global  red
red:
@ red(t, n, vi, g), paramètres :
@ r0 : adresse du tableau t
@ r1 : taille n (EntN)
@ r2 : valeur initiale du calcul
@ r3 : adresse de la fonction g
@ r4 : résultat calculé par la fonction

    push {lr}
    mov r5, #0 @i=0
    mov r4, r2 @acc=vi

boucle :
    cmp r5, r1 @tant que i != n
    beq fin 

    push {r0, r1, r2}
    ldrsb  r1, [r0, r5]  @r7=t[i]
    mov r0, r4
    blx r3 @g(acc, t[i]), résultat dans r2
    mov r4, r2 @acc=résultat de g
    pop {r0,r1,r2}

    add r5, r5, #1
    b boucle

fin:
    pop {lr}
    bx lr

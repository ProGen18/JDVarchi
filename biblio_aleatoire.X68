*-----------------------------------------------------------
* Titre      : biblio_aleatoire
* Ecrit par  : TALAB Stephane
* Date       : 15/12/2024
* Description: 
*               - Initialisation de la graine pseudo-aleatoire
*               - Generation de valeurs aleatoires (0 ou 1)
*               - Remplissage d'une grille memoire avec des valeurs aleatoires
*-----------------------------------------------------------


;---------------------------------------------------------------------------;
; Fonction : DEF_GRAINE
; Description : Definit la seed aleatoire a partir de la date
; Entrees : Aucune (utilise GET_TIME())
; Variables utilisees : D0, D1, SEED
;---------------------------------------------------------------------------;

DEF_GRAINE:                             ; Debut de la fonction DEF_GRAINE
    JSR     GET_TIME                    ; D1 = GET_TIME()
    CMP.W   #0, D1                      ; Si (D1 != 0)
    BNE     FIN_GRAINE                  ; Aller a FIN_GRAINE
    MOVE.L  #1, D1                      ; Sinon D1 est egal a zero, definir D1 = 1

FIN_GRAINE:                             
    MOVE.W  D1, SEED                    ; SEED = D1
    RTS                                 ; Retour de la fonction DEF_GRAINE

;---------------------------------------------------------------------------;
; Fonction : DEF_RANDINT
; Description : Renvoie pseudo-aleatoirement 0 ou 1
; Entrees : Aucune (utilise SEED pour la generation)
; Sorties : D0 = 0 ou 1 (resultat pseudo-aleatoire)
; Variables utilisees : D0, D1, SEED
;---------------------------------------------------------------------------;

DEF_RANDINT:                            ; Debut de la fonction DEF_RANDINT
    CLR.L   D0                          ; D0 = 0
    MOVE.W  SEED, D0                    ; D0 = SEED
    MOVE.L  D0, D1                      ; D1 = D0

    AND.W   #$4001, D1                  ; D1 &= 0100000000000001
    ASL.L   #1, D0                      ; D0 <<= 1
    AND.W   #$7FFF, D0                  ; D0 &= 111111111111111

    CMP.W   #0, D1                      ; Si (D1 == 0)
    BEQ     RETURN_DR_0                 ; Aller a RETURN_DR_0 si egal a zero

    CMP.W   #$4001, D1                  ; Si (D1 == 0100000000000001)
    BEQ     RETURN_DR_0                 ; Aller a RETURN_DR_0

    JMP     RETURN_DR_1                 ; Sinon aller a RETURN_DR_1

RETURN_DR_0:                            
    CLR.L   D1                          ; D1 = 0
    JMP     FIN_DEF_RANDINT             ; Aller a FIN

RETURN_DR_1:                            
    OR.B    #1, D0                      ; D0 = 1
    MOVE.L  #1, D1                      ; D1 = 1

FIN_DEF_RANDINT:                        
    MOVE.W  D0, SEED                    ; SEED = D0
    RTS                                 

;---------------------------------------------------------------------------;
; Fonction : DEF_GRILLE_ALEA
; Description : Initialise une grille avec des valeurs pseudo-aleatoires
; Entrees : A5 = grille, D6 = largeur, D7 = hauteur
; Variables utilisees : D0, D1, D6, D7, A5, I, J, PTR_TAB1, SEED
;---------------------------------------------------------------------------;

DEF_GRILLE_ALEA:                        
    MOVE.L  A5, PTR_TAB1                ; PTR_TAB1 = A5
    CLR.L   I                           ; i = 0
    CLR.L   J                           ; j = 0
    ADD.L   D6, A5                      ; A5 += LARG
    ADD.L   #3, A5                      ; A5 += 3

POUR_1_GRILLE_ALEA:                     
    CMP.L   I, D7                       ; Si (i == HAUT)
    BEQ     FINPOUR_1_GRILLE_ALEA       ; Sortir de la boucle 1 si egal
    CLR.L   J                           ; j = 0

POUR_2_GRILLE_ALEA:                     
    CMP.L   J, D6                       ; Si (j == LARG)
    BEQ     FINPOUR_2_GRILLE_ALEA       ; Sortir de la boucle 2 si egal

    JSR     DEF_RANDINT                 ; D1 = DEF_RANDINT()
    MOVE.B  D1, (A5)+                   ; (A5++) = D1
    ADD.L   #1, J                       ; j++
    JMP     POUR_2_GRILLE_ALEA          ; Retour a la boucle 2

FINPOUR_2_GRILLE_ALEA:                  
    ADD.L   #2, A5                      ; A5 += 2
    ADD.L   #1, I                       ; i++
    JMP     POUR_1_GRILLE_ALEA          ; Retour a la boucle 1

FINPOUR_1_GRILLE_ALEA:                  
    MOVE.L  PTR_TAB1, A5                ; A5 = PTR_TAB1
    RTS                                 

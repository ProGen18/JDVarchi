*-----------------------------------------------------------
* Titre      : biblio_grille
* Ecrit par  : TALAB Stephane
* Date       : 15/12/2024
* Description: 
*               - INIT_CASE : Met a 0 toutes les cases d'une grille et insere une valeur specifiee
*               - RESET : Reinitialise toutes les cases d'une grille a zero
*               - MAJ : Actualise une grille en fonction des regles du jeu de la vie
*               - Calcul des indices de la grille en fonction des coordonnees X et Y
*               - Verification et mise a jour des cellules selon leurs voisins
*               - Fonctions de boucles pour traverser les lignes et colonnes de la grille
*-----------------------------------------------------------

;---------------------------------------------------------------------------;
; Fonction : INIT_CASE
; Description : Met a 0 toutes les cases d'une grille
; Entrees : A5 = grille, D1 = valeur a inserer
; Variables utilisees : D6, D7, A5, PTR_TAB1, I, J
;---------------------------------------------------------------------------;

INIT_CASE:                              
    MOVE.L  A5, PTR_TAB1                ; PTR_TAB1 = A5, sauvegarde l'adresse de la grille
    MOVE.W  D1, D0                      ; D1 = D0, prepare la valeur a inserer dans la grille

    ; Calcul des indices de la grille en fonction des coordonnees X
    SUB.W   H_DEC, D0                   ; D0 -= H_DEC, ajuste la position X en soustrayant H_DEC
    DIVU    D5, D0                      ; D0 /= D5, divise D0 par D5 pour obtenir l'indice de la case
    AND.L   #$0000FFFF, D0              ; D0 &= 0x0000FFFF, masque les 16 premiers bits de D0
    ADD.L   #1, D0                      ; D0++, on ajoute 1 pour ajuster l'indice

    ; Initialisation de D1 a 0 et echange des bits
    CLR.W   D1                          ; D1.W = 0, initialise D1 a zero
    SWAP    D1                          ; SWAP(D1[0:16], D1[16:32]), echange les bits de D1

    ; Calcul des indices de la grille en fonction des coordonnees Y
    SUB.W   V_DEC, D1                   ; D1 -= V_DEC, ajuste la position Y en soustrayant V_DEC
    DIVU    D5, D1                      ; D1 /= D5, divise D1 par D5 pour obtenir l'indice de la case
    ADD.L   #1, D1                      ; D1++, on ajoute 1 pour ajuster l'indice
    AND.L   #$0000FFFF, D1              ; D1 &= 0x0000FFFF, masque les 16 premiers bits de D1
    ADD.W   #2, LARG                    ; LARG += 2, ajustement de la largeur
    MULU    LARG, D1                    ; D1 *= LARG, multiplication de l'indice par la largeur de la grille
    SUB.W   #2, LARG                    ; LARG -= 2, remise de la largeur a sa valeur initiale
    AND.L   #$0000FFFF, D1              ; D1 &= 0x0000FFFF, masque les 16 premiers bits de D1

    ; Calcul de l'adresse de la case dans la grille
    ADD.L   D0, A5                      ; A5 += D0, on deplace A5 pour pointer sur la case a l'indice X
    ADD.L   D1, A5                      ; A5 += D1, on deplace A5 pour pointer sur la case a l'indice Y

    ; Verification de la valeur de la case
    CMP.B   (A5), D2                    ; Si ((*A5) == D2), on compare la valeur de la case avec D2
    BEQ     FIN_INIT_CASE               ; Si la valeur est egale a D2, on termine la fonction INIT_CASE

    ; Si la case n'est pas egale a D2, on y insere la valeur de D2
    MOVE.B  D2, (A5)                    ; (*A5) = D2, on insere la valeur D2 a l'adresse de la case
    MOVE.L  PTR_TAB1, A5                ; A5 = PTR_TAB1, on reinitialise A5 a l'adresse de depart
    JSR     PRINT_GRILLE                ; On appelle la fonction PRINT_GRILLE pour afficher la grille mise a jour

FIN_INIT_CASE:                          
    MOVE.L  PTR_TAB1, A5                ; A5 = PTR_TAB1, on reinitialise A5 a l'adresse de depart
    RTS                                 

;---------------------------------------------------------------------------;
; Fonction : RESET
; Description : Remet a zero toutes les cases d'une grille
; Entrees : A5(grille), D6 = largeur, D7 = hauteur
; Variables utilisees : D6, D7, A5, PTR_TAB1, I, J
;---------------------------------------------------------------------------;

RESET:                                  
    MOVE.L  A5, PTR_TAB1                ; PTR_TAB1 = A5, sauvegarde l'adresse de la grille
    CLR.L   I                           ; i = 0, on initialise l'indice de la ligne
    ADD.W   #2, D6                      ; LARG += 2, on ajuste la largeur de la grille
    ADD.W   #2, D7                      ; HAUT += 2, on ajuste la hauteur de la grille
    
TQ_I_RESET:                             ; Debut de la boucle sur les lignes (i)
    CMP.L   I, D7                       ; Si (i == HAUT), on sort de la boucle
    BEQ     FIN_TQ_I_RESET              ; Si i == HAUT, on termine la boucle des lignes
    CLR.L   J                           ; j = 0, on initialise l'indice de la colonne
    
TQ_J_RESET:                             ; Debut de la boucle sur les colonnes (j)
    CMP.L   J, D6                       ; Si (j == LARG), on sort de la boucle des colonnes
    BEQ     FIN_TQ_J_RESET              ; Si j == LARG, on termine la boucle des colonnes
    CLR.B   (A5)+                       ; (*A5++) = 0, on remet a zero la case de la grille
    ADD.L   #1, J                       ; j++, on passe a la colonne suivante
    JMP     TQ_J_RESET                  ; Retour a TQ_J_RESET
    
FIN_TQ_J_RESET:                         ; Fin de la boucle des colonnes
    ADD.L   #1, I                       ; i++, on passe a la ligne suivante
    JMP     TQ_I_RESET                  ; Retour a TQ_I_RESET

FIN_TQ_I_RESET:                         ; Fin de la boucle des lignes
    SUB.W   #2, D6                      ; LARG -= 2, on remet la largeur de la grille a sa valeur initiale
    SUB.W   #2, D7                      ; HAUT -= 2, on remet la hauteur de la grille a sa valeur initiale
    MOVE.L  PTR_TAB1, A5                ; A5 = PTR_TAB1, on reinitialise A5 a l'adresse de depart
    RTS                                 

;---------------------------------------------------------------------------;
; Fonction : MAJ
; Description : Actualise une grille d'apres les regles du jeu de la vie
; Entrees : A5(grille1), A6(grille2), D6 = largeur, D7 = hauteur
; Variables utilisees : D0, D6, D7, A5, A6, PTR_TAB1, PTR_TAB2, I, J, K, L, VAR
;---------------------------------------------------------------------------;

MAJ:                                    
    MOVE.L  A5, PTR_TAB1                ; PTR_TAB1 = A5, sauvegarde l'adresse de la grille 1
    MOVE.L  A6, PTR_TAB2                ; PTR_TAB2 = A6, sauvegarde l'adresse de la grille 2
    ADD.L   D6, A6                      ; A6 += LARG, on ajuste A6 en fonction de la largeur
    ADD.L   #3, A6                      ; A6 += 3, ajustement supplementaire pour les calculs de cases
    CLR.L   I                           ; i = 0, on initialise l'indice de la ligne

ATTENTE:
    MOVE.L   NB_RAL, D1                 ; Charger la valeur de NB_RAL dans D0
    CMP.L    RAL_VAR, D1      		    ; Comparer la valeur de D5 avec la valeur � l'adresse de RAL_VAR
    BEQ      FIN_ATTENTE                ; Si les deux sont égaux, sortir de la boucle
    ADD.L    #1, RAL_VAR                ; Sinon, incrémenter RAL_VAR
    BRA      ATTENTE                    ; Revenir au début de la boucle

FIN_ATTENTE: 
    MOVE.L  #0, RAL_VAR                 ; Réinitialiser RAL_VAR à 0

TQ_I_MAJ:                               ; Debut de la boucle sur les lignes (i)
    CMP.L   I, D7                       ; Si (i == HAUT), on sort de la boucle
    BEQ     FIN_TQ_I_MAJ                ; Si i == HAUT, on termine la boucle des lignes
    CLR.L   J                           ; j = 0, on initialise l'indice de la colonne

TQ_J_MAJ:                               ; Debut de la boucle sur les colonnes (j)
    CMP.L   J, D6                       ; Si (j == LARG), on sort de la boucle des colonnes
    BEQ     FIN_TQ_J_MAJ                ; Si j == LARG, on termine la boucle des colonnes
    CLR.B   VAR                         ; VAR = 0, initialisation de la somme des voisins vivants
    CLR.L   K                           ; k = 0, on initialise l'indice pour parcourir les voisins

TQ_K_MAJ:                               ; Debut de la boucle sur les voisins (k)
    CMP.L   #3, K                       ; Si (k == 3), on sort de la boucle des voisins
    BEQ     FIN_TQ_K_MAJ                ; Si k == 3, on termine la boucle des voisins
    CLR.L   L                           ; l = 0, on initialise l'indice pour les cases voisines

TQ_L_MAJ:                               ; Debut de la boucle pour chaque voisin (l)
    CMP.L   #3, L                       ; Si (l == 3), on sort de la boucle des voisins
    BEQ     FIN_TQ_L_MAJ                ; Si l == 3, on termine la boucle des voisins

    MOVE.B  (A5)+, D0                   ; D0 = *(A5++), on charge la valeur de la case actuelle dans D0
    ADD.B   D0, VAR                     ; VAR += D0, on ajoute cette valeur a la somme des voisins

    ADD.L   #1, L                       ; l++, on passe au voisin suivant
    JMP     TQ_L_MAJ                    ; Retour a TQ_L_MAJ pour traiter le prochain voisin

FIN_TQ_L_MAJ:                           ; Fin de la boucle des voisins
    ADD.L   D6, A5                      ; A5 += LARG, on passe a la prochaine colonne
    SUB.L   #1, A5                      ; A5--, on ajuste A5 pour revenir a la bonne position dans la grille

    ADD.L   #1, K                       ; k++, on passe au voisin suivant
    JMP     TQ_K_MAJ                    ; Retour a TQ_K_MAJ pour traiter le prochain voisin

FIN_TQ_K_MAJ:                           ; Fin de la boucle des voisins
    SUB.L   D6, A5                      ; A5 -= LARG, on revient a la position precedente dans la grille
    SUB.L   D6, A5                      ; A5 -= LARG, on ajuste a nouveau pour les autres voisins
    SUB.L   #3, A5                      ; A5 -= 3, on revient a la ligne precedente dans la grille
    MOVE.B  (A5), D0                    ; D0 = (*A5), on charge la valeur de la case actuelle

    CMP.B   #1, D0                      ; Si (D0 != 1), on verifie si la cellule est vivante
    BNE     PAS_VIVANTE                 ; Si la cellule n'est pas vivante, on passe a l'etat suivant

VIVANTE:                                ; Cellule vivante
    MOVE.B  #1, D0                      ; On reactive la cellule (vivante)
    CMP.B   #3, VAR                     ; Si (VAR == 3), la cellule reste vivante
    BEQ     FINSI_TQ_J_MAJ              ; Si la cellule a exactement 3 voisins vivants, elle reste vivante
    CMP.B   #4, VAR                     ; Si (VAR == 4), la cellule reste vivante
    BEQ     FINSI_TQ_J_MAJ              ; Si la cellule a exactement 4 voisins vivants, elle reste vivante
    MOVE.B  #0, D0                      ; Si VAR != 3 ou 4, on tue la cellule
    JMP     FINSI_TQ_J_MAJ              ; On passe a la fin de cette iteration

PAS_VIVANTE:                            ; Cellule morte
    MOVE.B  #1, D0                      ; On marque la cellule comme vivante pour la mise a jour
    CMP.B   #3, VAR                     ; Si (VAR == 3), la cellule devient vivante
    BEQ     FINSI_TQ_J_MAJ              ; Si elle a 3 voisins vivants, elle devient vivante
    MOVE.B  #0, D0                      ; Sinon, la cellule reste morte
    JMP     FINSI_TQ_J_MAJ              ; On passe a la fin de cette iteration

FINSI_TQ_J_MAJ:                         ; Fin de l'if
    MOVE.B  D0, (A6)+                   ; (*A6++) = D0, on place la nouvelle valeur dans la grille 2
    SUB.L   D6, A5                      ; A5 -= LARG, on ajuste A5 pour revenir a la position precedente dans la grille
    SUB.L   #2, A5                      ; A5 -= 2, on ajuste encore a la position correcte

    ADD.L   #1, J                       ; j++, on passe a la prochaine colonne
    JMP     TQ_J_MAJ                    ; Retour a TQ_J_MAJ pour la colonne suivante

FIN_TQ_J_MAJ:                           ; Fin de la boucle des colonnes
    ADD.L   #2, A5                      ; A5 += 2, on ajuste A5 pour la nouvelle ligne
    ADD.L   #2, A6                      ; A6 += 2, on ajuste A6 pour la nouvelle ligne dans la grille 2

    ADD.L   #1, I                       ; i++, on passe a la ligne suivante
    JMP     TQ_I_MAJ                    ; Retour a TQ_I_MAJ pour la ligne suivante

FIN_TQ_I_MAJ:                           ; Fin de la boucle des lignes
    MOVE.L  PTR_TAB1, A6                ; A6 = PTR_TAB1, on reinitialise A6 a l'adresse de depart
    MOVE.L  PTR_TAB2, A5                ; A5 = PTR_TAB2, on reinitialise A5 a l'adresse de la grille 2
    RTS                                 


*~Font name~Courier New~
*~Font size~16~
*~Tab type~1~
*~Tab size~4~

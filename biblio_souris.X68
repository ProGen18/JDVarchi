*-----------------------------------------------------------
* Titre      : biblio_souris
* Ecrit par  : TALAB Stephane
* Date       : 15/12/2024
* Description: 
*               - fonctions permettent de detecter les interactions de la souris pour gerer des actions graphiques.
*               - tests de clic et la position de la souris sont utilises pour determiner l'interaction avec des elements graphiques comme des boutons ou la grille.
*-----------------------------------------------------------

;---------------------------------------------------------------------------;
; Fonction : ATT_CG_UN
; Description : Attend que le click gauche de la souris soit relache
; Entrees : Aucune
; Sorties : Aucune
; Variables utilisees : D0, D1
;---------------------------------------------------------------------------;

ATT_CG_UN:                              
    CLR.L   D1                          ; Initialiser D1 a 0
    JSR     GET_MOUSE                   ; Appel de la fonction GET_MOUSE pour recuperer l'etat de la souris
    AND.B   #%00000001, D0              ; Verifier si le bouton gauche de la souris est enfonce

    CMP.B   #1, D0                      ; Comparer D0 avec 1 (si le bouton gauche est enfonce)
    BEQ     ATT_CG_UN                   ; Si D0 == 1, retourner a l'attente du relachement du bouton
    RTS                                 

;---------------------------------------------------------------------------;
; Fonction : SI_CG
; Description : Teste si le click gauche de la souris est enfonce ou non
; Entrees : Aucune
; Sorties : D0 = 1 si click gauche enfonce, 0 sinon
; Variables utilisees : D0, D1
;---------------------------------------------------------------------------;

SI_CG:                                  
    CLR.L   D1                          ; Initialiser D1 a 0
    JSR     GET_MOUSE                   ; Appel de la fonction GET_MOUSE pour recuperer l'etat de la souris
    AND.B   #%00000001, D0              ; Verifier si le bouton gauche de la souris est enfonce

    CMP.B   #1, D0                      ; Comparer D0 avec 1 (si le bouton gauche est enfonce)
    RTS                                 

;---------------------------------------------------------------------------;
; Fonction : SI_CD
; Description : Teste si le click droit de la souris est enfonce ou non
; Entrees : Aucune
; Sorties : D0 = 1 si click droit enfonce, 0 sinon
; Variables utilisees : D0, D1
;---------------------------------------------------------------------------;

SI_CD:                                  
    CLR.L   D1                          ; Initialiser D1 a 0
    JSR     GET_MOUSE                   ; Appel de la fonction GET_MOUSE pour recuperer l'etat de la souris
    AND.B   #%00000010, D0              ; Verifier si le bouton droit de la souris est enfonce

    CMP.B   #%10, D0                    ; Comparer D0 avec 2 (si le bouton droit est enfonce)
    RTS                                 

;---------------------------------------------------------------------------;
; Fonction : SI_SUR_GRILLE
; Description : Teste si le curseur de la souris est dans les limites de la grille
; Entrees : D1.L = position de la souris, H_DEC, V_DEC, TOT_LARG, TOT_HAUT
; Variables utilisees : D0, D1, D2, H_DEC, V_DEC, TOT_LARG, TOT_HAUT
;---------------------------------------------------------------------------;

SI_SUR_GRILLE:                          
    CLR.L   D0                          ; Initialiser D0 a 0

    MOVE.L  D1, D2                      ; Copier D1 (position de la souris) dans D2
    CMP.W   H_DEC, D2                   ; Verifier si la souris est a droite de H_DEC
    BCS     FIN_SI_SG                   ; Si oui, sortir de la fonction

    SUB.W   H_DEC, D2                   ; Soustraire H_DEC de D2
    CMP.W   TOT_LARG, D2                ; Verifier si la souris est dans les limites de la largeur
    BCC     FIN_SI_SG                   ; Si non, sortir de la fonction

    SWAP    D2                          ; Inverser les 16 premiers bits et les 16 derniers bits de D2
    CMP.W   V_DEC, D2                   ; Verifier si la souris est en dessous de V_DEC
    BCS     FIN_SI_SG                   ; Si oui, sortir de la fonction

    SUB.W   V_DEC, D2                   ; Soustraire V_DEC de D2
    CMP.W   TOT_HAUT, D2                ; Verifier si la souris est dans les limites de la hauteur
    BCC     FIN_SI_SG                   ; Si non, sortir de la fonction

    MOVE.B  #1, D0                      ; Si la souris est dans la zone de la grille, D0 = 1

FIN_SI_SG:                              ; Fin de la fonction SI_SUR_GRILLE
    CMP.B   #1, D0                      ; Comparer D0 avec 1 (si la souris est dans la grille)
    RTS                                 

;---------------------------------------------------------------------------;
; Fonction : SUR_BOUTON
; Description : Teste si le curseur de la souris est dans les limites d'un bouton
; Entrees : A1 = pointeur vers le bouton (definissant la position)
; Variables utilisees : D0, D1, D2, D3, A1
;---------------------------------------------------------------------------;

SUR_BOUTON:                             
    MOVE.L  (A1)+, D2                   ; Copier la position du bouton dans D2
    MOVE.L  (A1), D3                    ; Copier la position de fin du bouton dans D3
    SUB.L   #1, A1                      ; Decrementer A1 pour ajuster la position
    CLR.L   D0                          ; Initialiser D0 a 0
    CMP.W   D1, D2                      ; Comparer D1 avec D2 (si la souris est a gauche du bouton)
    BHI     FIN_SUR_BOUTON              ; Si oui, sortir de la fonction
    CMP.W   D1, D3                      ; Comparer D1 avec D3 (si la souris est a droite du bouton)
    BCS     FIN_SUR_BOUTON              ; Si oui, sortir de la fonction
    SWAP    D1                          ; Inverser les 16 premiers bits et les 16 derniers bits de D1
    SWAP    D2                          ; Inverser les 16 premiers bits et les 16 derniers bits de D2
    SWAP    D3                          ; Inverser les 16 premiers bits et les 16 derniers bits de D3
    CMP.W   D1, D2                      ; Comparer D1 avec D2 (si la souris est au-dessus du bouton)
    BHI     SWAP_SUR_BOUTON             ; Si oui, aller a l'echange des positions
    CMP.W   D1, D3                      ; Comparer D1 avec D3 (si la souris est en dessous du bouton)
    BCS     SWAP_SUR_BOUTON             ; Si oui, aller a l'echange des positions
    MOVE.L  #1, D0                      ; Si la souris est sur le bouton, D0 = 1

SWAP_SUR_BOUTON:                        ; Debut de l'echange des positions du bouton
    SWAP    D1                          ; Inverser les 16 premiers bits et les 16 derniers bits de D1
    SWAP    D2                          ; Inverser les 16 premiers bits et les 16 derniers bits de D2
    SWAP    D3                          ; Inverser les 16 premiers bits et les 16 derniers bits de D3

FIN_SUR_BOUTON:                         ; Fin de la fonction SUR_BOUTON
    CMP.B  #1, D0                       ; Comparer D0 avec 1 (si la souris est sur le bouton)
    RTS                                                    

;---------------------------------------------------------------------------;
; Fonction : GET_MOUSE
; Description : Recupere les informations sur l'etat des boutons de la souris
;              et la position de la souris
; Entrees : D1.L = coordonnees et etat des boutons
; Sorties : D0.B = etat des boutons de la souris, D1.L = position de la souris
; Variables utilisees : D0, D1
;---------------------------------------------------------------------------;

GET_MOUSE:                             
    MOVE    #61, D0                    
    TRAP    #15                        
    RTS                                

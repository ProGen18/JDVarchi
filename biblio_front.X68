*-----------------------------------------------------------
* Titre      : biblio_front
* Ecrit par  : TALAB Stephane
* Date       : 15/12/2024
* Description: 
*               - Gestion du dessin d'elements graphiques a l'ecran
*               - REMPLIR_BG : Remplir le fond avec une couleur specifiee
*               - DESSINE_CASE : Dessiner une case a la position specifiee
*               - PRINT_GRILLE : Dessiner une grille entiere en fonction des donnees fournies
*               - DESSINE_BOUTON : Dessiner un bouton avec ses dimensions et son texte
*               - SET_PEN_COLOR et SET_FILL_COLOR : Definir respectivement la couleur du crayon et de remplissage
*               - DRAW_FILL_RECT : Dessiner un rectangle plein
*               - DRAW_STRING : Dessiner une chaîne de caracteres a l'ecran
*-----------------------------------------------------------

;---------------------------------------------------------------------------;
; Fonction : REMPLIR_BG
; Description : Remplir le fond avec une couleur specifiee dans D1.L
; Entrees : D1.L = couleur de fond, D2.L = resolution
; Variables utilisees : D0, D1, D2, D3, D4
;---------------------------------------------------------------------------;

REMPLIR_BG:                             ; Debut
    JSR     SET_PEN_COLOR               ; Definir la couleur du pinceau avec D1
    JSR     SET_FILL_COLOR              ; Definir la couleur de remplissage avec D1
    
    MOVE.W  D2, D4                      ; Copier D2 (resolution) dans D4
    SWAP    D2                          ; Inverser les 16 premiers bits et les 16 derniers bits de D2
    MOVE.W  D2, D3                      ; Copier D2 dans D3
    CLR.W   D1                          ; Initialiser D1 a 0
    CLR.W   D2                          ; Initialiser D2 a 0
    
    JSR     DRAW_FILL_RECT              ; Dessiner un rectangle rempli avec D1, D2, D3, D4
    RTS                                 ; Fin

;---------------------------------------------------------------------------;
; Fonction : DESSINE_CASE
; Description : Dessine une case a la position specifiee avec les couleurs donnees
; Entrees : D1 = couleur du pinceau, D2 = coordonnee X1, D3 = coordonnee X2, D4 = coordonnee Y2
; Variables utilisees : D0, D1, D2, D3, D4, D5, I, J, H_DEC, V_DEC
;---------------------------------------------------------------------------;

DESSINE_CASE:                           ; Debut
    JSR     SET_PEN_COLOR               ; Definir la couleur du pinceau avec D1
    JSR     SET_FILL_COLOR              ; Definir la couleur de remplissage avec D2

    MOVE.L  J, D1                       ; Copier J (indice j) dans D1
    MOVE.L  I, D2                       ; Copier I (indice i) dans D2
    MULU    D5, D1                      ; Multiplier D1 par la taille de la cellule (D5)
    MULU    D5, D2                      ; Multiplier D2 par la taille de la cellule (D5)

    MOVE.L  D1, D3                      ; Copier D1 dans D3
    MOVE.L  D2, D4                      ; Copier D2 dans D4
    ADD.L   D5, D3                      ; Ajouter la taille de la cellule a D3 (X2)
    ADD.L   D5, D4                      ; Ajouter la taille de la cellule a D4 (Y2)

    ADD.W   H_DEC, D1                   ; Ajouter H_DEC a D1 (decalage horizontal)
    ADD.W   V_DEC, D2                   ; Ajouter V_DEC a D2 (decalage vertical)
    ADD.W   H_DEC, D3                   ; Ajouter H_DEC a D3
    ADD.W   V_DEC, D4                   ; Ajouter V_DEC a D4

    JSR     DRAW_FILL_RECT              ; Dessiner un rectangle rempli avec D1, D2, D3, D4
    RTS                                 ; Fin

;---------------------------------------------------------------------------;
; Fonction : PRINT_GRILLE
; Description : Dessine une grille en fonction des donnees fournies
; Entrees : A5 = adresse de la grille, D6 = largeur, D7 = hauteur, H_DEC, V_DEC
; Variables utilisees : D0, D1, D2, D3, D4, D5, D6, D7, I, J, H_DEC, V_DEC, PTR_TAB1
;---------------------------------------------------------------------------;

PRINT_GRILLE:                           ; Debut
    MOVE.L  A5, PTR_TAB1                ; Copier l'adresse de la grille (A5) dans PTR_TAB1
    CLR.L   D1                          ; Initialiser D1 (compteur i) a 0
    CLR.L   I                           ; Initialiser I (compteur i) a 0
    ADD.L   D6, A5                      ; Ajuster A5 avec la largeur de la grille
    ADD.L   #3, A5                      ; Decaler A5 pour tenir compte de l'espacement

TQ_I_PG:                                ; Debut de la boucle principale pour la hauteur (i)
    CMP.L   I, D7                       ; Comparer i avec la hauteur
    BEQ     FIN_TQ_I_PG                 ; Si i == hauteur, sortir de la boucle

    CLR.L   J                           ; Initialiser J (compteur j) a 0
    
TQ_J_PG:                                ; Debut de la boucle interne pour la largeur (j)
    CMP.L   J, D6                       ; Comparer j avec la largeur
    BEQ     FIN_TQ_J_PG                 ; Si j == largeur, sortir de la boucle interne

    MOVE.B  (A5)+, D0                   ; Charger l'element de la grille dans D0
    MOVE.L  #$FFFFFF, D1                ; Initialiser D1 a blanc (couleur par defaut)
    
    CMP.B   #0, D0                      ; Si la valeur de la case est 0
    BEQ     SUITE_PG                    ; Aller a la suite pour dessiner la case
    MOVE.L  #$000000, D1                ; Sinon, mettre D1 a noir

SUITE_PG:                               ; Suite du dessin de la case
    JSR     DESSINE_CASE                ; Appel a DESSINE_CASE pour dessiner la case
    ADD.L   #1, J                       ; Incrementer j pour passer a la colonne suivante
    JMP     TQ_J_PG                     ; Retourner au debut de la boucle interne pour la prochaine colonne
    
FIN_TQ_J_PG:
    ADD.L   #1, I                       ; Incrementer i pour passer a la ligne suivante
    ADD.L   #2, A5                      ; Decaler A5 pour la ligne suivante
    JMP     TQ_I_PG                     ; Retourner au debut de la boucle principale pour la prochaine ligne
    
FIN_TQ_I_PG:
    MOVE.L  PTR_TAB1, A5                ; Restaurer l'adresse initiale de la grille dans A5
    RTS                                 ; Fin de la fonction PRINT_GRILLE

;---------------------------------------------------------------------------;
; Fonction : DESSINE_BOUTON
; Description : Dessine un bouton avec ses dimensions et texte
; Entrees : A1 = adresse du bouton (contient les coordonnees et les dimensions)
; Variables utilisees : D0, D1, D2, D3, D4, D5, I, J, H_DEC, V_DEC
;---------------------------------------------------------------------------;

DESSINE_BOUTON:                         ; Debut de la fonction DESSINE_BOUTON
    MOVE.L  A1, PTR_TAB1                ; Copier l'adresse du bouton dans PTR_TAB1
    MOVE.W  (A1)+, D2                   ; Charger la coordonnee X du bouton dans D2
    MOVE.W  (A1)+, D1                   ; Charger la coordonnee Y du bouton dans D1
    MOVE.W  (A1)+, D4                   ; Charger la largeur du bouton dans D4
    MOVE.W  (A1)+, D3                   ; Charger la hauteur du bouton dans D3
    JSR     DRAW_FILL_RECT              ; Dessiner un rectangle pour le bouton avec D1, D2, D3, D4
    ADD.W  (A1)+, D2                    ; Ajouter la prochaine valeur de X a D2
    ADD.W  (A1)+, D1                    ; Ajouter la prochaine valeur de Y a D1
    JSR     DRAW_STRING                 ; Dessiner le texte du bouton a la position specifiee

    MOVE.L  PTR_TAB1, A1                ; Restaurer l'adresse initiale du bouton
    RTS                                 ; Fin de la fonction DESSINE_BOUTON

;---------------------------------------------------------------------------;
; Fonction : SET_PEN_COLOR
; Description : Change la couleur du crayon
; Entrees : D1.L = couleur
; Variables utilisees : D0, D1
;---------------------------------------------------------------------------;

SET_PEN_COLOR:                         
    MOVE    #80, D0                   
    TRAP    #15                        
    RTS                                 

;---------------------------------------------------------------------------;
; Fonction : SET_FILL_COLOR
; Description : Change la couleur de remplissage
; Entrees : D1.L = couleur
; Variables utilisees : D0, D1
;---------------------------------------------------------------------------;

SET_FILL_COLOR:                        
    MOVE    #81, D0                    
    TRAP    #15                       
    RTS                                

;---------------------------------------------------------------------------;
; Fonction : DRAW_FILL_RECT
; Description : Dessine un rectangle plein
; Entrees : D1.W = largeur , D2.W = hauteur, D3.W = largeur2 , D4.W = hauteur2
; Variables utilisees : D0, D1, D2, D3, D4
;---------------------------------------------------------------------------;

DRAW_FILL_RECT:                         
    MOVE    #87, D0                    
    TRAP    #15                        
    RTS                                

;---------------------------------------------------------------------------;
; Fonction : DRAW_STRING
; Description : Dessine une chaîne de caracteres
; Entrees : D1.W = largeur , D2.W = hauteur, A1(chaine)
; Variables utilisees : D0, D1, D2, A1
;---------------------------------------------------------------------------;

DRAW_STRING:                           
    MOVE    #95, D0                    
    TRAP    #15                       
    RTS                                

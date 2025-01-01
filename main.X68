*-----------------------------------------------------------
* Titre      : main
* Ecrit par  : TALAB Stephane
* Date       : 15/12/2024
* Description: Implementation du jeu de la vie de Conway
*               - Initialisation de l'environnement
*               - Configuration de la grille et de l'interface
*               - Gestion de la logique du jeu et des interactions utilisateur
*-----------------------------------------------------------

START:    ORG    $1000

; --- Initialisation ---

    CLR.L	D5                          ; Reinitialise le registre D5 a 0
    CLR.L	D6                          ; Reinitialise le registre D6 a 0
    CLR.L	D7                          ; Reinitialise le registre D7 a 0
    MOVE.W	T_CEL, D5                   ; Charge la taille d'une cellule dans D5
    MOVE.W  LARG, D6                    ; Charge la largeur de la grille dans D6
    MOVE.W  HAUT, D7                    ; Charge la hauteur de la grille dans D7

    ; Configuration de la graine pour la generation aleatoire
    JSR     DEF_GRAINE
    MOVE.L  RES, D1                     ; Charge la resolution d'ecran dans D1
    JSR     RESOLUTION

    ; --- Definir la couleur de fond ---
    MOVE.L	#$a5c6df, D1                ; Definit la couleur de fond en beige (BBVVRR)
    MOVE.L  RES, D2                     ; Charge les dimensions de resolution dans D2
    JSR		REMPLIR_BG                  ; Applique la couleur beige en fond sur l'ecran

    ; --- Definir les couleurs initiales du stylo et du remplissage ---
    MOVE.L  #$00FF00, D1                ; Definit la couleur du stylo en vert (BBVVRR)
    JSR     SET_PEN_COLOR

    MOVE.L  #$5cbd61, D1                ; Definit la couleur de remplissage du bouton "LANCER" en vert
    JSR     SET_FILL_COLOR

    MOVE.L  #BOUTON_LANCER, A1
    JSR     DESSINE_BOUTON              ; Dessine le bouton "LANCER"

    ; --- Dessiner les boutons ---
    MOVE.L  #$f0c066, D1                ; Definit la couleur de remplissage des autres boutons en bleu
    JSR     SET_FILL_COLOR

    MOVE.L  #$FFFFFF, D1                ; Definit la couleur du stylo en blanc
    JSR     SET_PEN_COLOR

    MOVE.L  #BOUTON_ARRETER, A1
    JSR     DESSINE_BOUTON              ; Dessine le bouton "ARRETER"    
    
    MOVE.L  #BOUTON_EFFACER, A1
    JSR     DESSINE_BOUTON              ; Dessine le bouton "EFFACER"
    
    MOVE.L  #BOUTON_ALEA, A1
    JSR     DESSINE_BOUTON              ; Dessine le bouton "ALEATOIRE"
    
    MOVE.L  #BOUTON_CHARGER, A1
    JSR     DESSINE_BOUTON              ; Dessine le bouton "OUVRIR"

    MOVE.L  #BOUTON_PLUS, A1
    JSR     DESSINE_BOUTON              ; Dessine le bouton "PLUS"

    MOVE.L  #BOUTON_MOINS, A1
    JSR     DESSINE_BOUTON              ; Dessine le bouton "MOINS"
    
    MOVE.L  #BOUTON_SAUV, A1
    JSR     DESSINE_BOUTON              ; Dessine le bouton "SAUVEGARDER"
    
    MOVE.L  #BOUTON_QUIT, A1
    JSR     DESSINE_BOUTON              ; Dessine le bouton "QUITTER"
    
    ; Reinitialisation des tableaux de donnees pour la simulation
    MOVE.L  #TAB2, A5
    JSR		RESET                       ; Initialise TAB2 a 0
    MOVE.L  #TAB2, A6
    MOVE.L  #TAB1, A5
    JSR		RESET                       ; Initialise TAB1 a 0

    ; Dessin initial de la grille
    JSR     PRINT_GRILLE

; --- Boucle principale du programme ---

TANTQUE:
	JSR     SI_CD                       ; Verifie si un clic droit a ete effectue
    BNE     CONTINUE1                   ; Si non, passer a l'etape suivante
	JSR     CLICK_D                     ; Sinon, traiter le clic droit

CONTINUE1:
    JSR     SI_CG                       ; Verifie si un clic gauche a ete effectue
    BNE     BOOL_LANCER_FAUX            ; Si non, reinitialiser l'etat "enfonce"
    JSR     CLICK_G                     ; Sinon, traiter le clic gauche
    JMP     BOOL_LANCER_VRAI

BOOL_LANCER_VRAI:
    MOVE.B  #1, BOOL_LANCER             ; Definit l'etat "clic gauche enfonce"
    JMP     CONTINUE2

BOOL_LANCER_FAUX:
    MOVE.B  #0, BOOL_LANCER             ; Reinitialise l'etat "clic gauche enfonce"
    JMP		CONTINUE2

CONTINUE2:
	TST.B	ACTUALISER                          ; Verifie si la grille est en cours de mise a jour
	BEQ		TANTQUE                     ; Si non, revenir au debut de la boucle
	
    JSR     MAJ                         ; Met a jour l'etat de la grille
    JSR     PRINT_GRILLE                ; Affiche la grille mise a jour
    
    JMP     TANTQUE                     ; Retour au debut de la boucle

FIN_TANTQUE:                            ; Fin de la boucle principale

; --- Quitter le programme ---

QUIT:
    BRA     FINPRG

; --- Gestion des clics droit ---
CLICK_D:
    CMP.B	#1, ACTUALISER              ; Verifie si la mise a jour de la grille est active
	BEQ		FIN_CLICK_D                 ; Si oui, ignorer le clic droit

    JSR     SI_SUR_GRILLE               ; Verifie si le clic est sur la grille
    BNE     FIN_CLICK_D                 ; Si non, ignorer le clic

    MOVE.B	#0, D2                      ; Met l'etat de la case selectionnee a 0 (vide)
	JSR		INIT_CASE

FIN_CLICK_D:
    RTS                                 ; Retour de la sous-routine

; --- Gestion des clics gauche ---
CLICK_G:
    CMP.B	#1, ACTUALISER              ; Verifie si la mise a jour de la grille est active
	BEQ		DEBUT_CLICK_G               ; Si oui, gerer les boutons activables

RELACHE_CLICK_G:
    JSR     SI_SUR_GRILLE               ; Verifie si le clic est sur la grille
    BNE     EXT_CLICK_G                 ; Si non, gerer les clics hors de la grille

    MOVE.L	#1, D2                      ; Met l'etat de la case selectionnee a 1 (active)
	JSR		INIT_CASE
    JMP     FIN_CLICK_G

EXT_CLICK_G:
    CMP.B   #1, BOOL_LANCER             ; Verifie si un clic gauche est en cours
    BEQ     FIN_CLICK_G

    ; Verifie si le clic est sur l'un des boutons
    MOVE.L  #BOUTON_LANCER, A1
    JSR     SUR_BOUTON
    BEQ     START_MAJ                   ; Si "LANCER" est clique, demarrer la simulation

    MOVE.L  #BOUTON_EFFACER, A1
    JSR     SUR_BOUTON
    BEQ     CLEAR_GRID                  ; Si "EFFACER" est clique, reinitialiser la grille
    
    MOVE.L  #BOUTON_ALEA, A1
    JSR     SUR_BOUTON
    BEQ     ALEA_GRID                   ; Si "ALEATOIRE" est clique, remplir la grille aleatoirement

    MOVE.L  #BOUTON_CHARGER, A1
    JSR     SUR_BOUTON
    BEQ     OPEN_SCH                    ; Si "OUVRIR" est clique, charger une sauvegarde

    MOVE.L  #BOUTON_SAUV, A1
    JSR     SUR_BOUTON
    BEQ     SAVE_SCH                    ; Si "SAUVEGARDER" est clique, enregistrer la partie

    MOVE.L  #BOUTON_PLUS, A1            
    JSR     SUR_BOUTON
    BEQ     AUG_LAT                     ; Si "+" est clique, augmenter la latence de la simulation

    MOVE.L  #BOUTON_MOINS, A1           
    JSR     SUR_BOUTON
    BEQ     DIM_LAT                     ; Si "-" est clique, diminuer la latence de la simulation

DEBUT_CLICK_G:
    CMP.B   #1, BOOL_LANCER             ; Verifie si un clic gauche est en cours
    BEQ     FIN_CLICK_G

    MOVE.L  #BOUTON_ARRETER, A1
    JSR     SUR_BOUTON
    BEQ     STOP_MAJ                    ; Si "ARRETER" est clique, arreter la simulation

    MOVE.L  #BOUTON_QUIT, A1
    JSR     SUR_BOUTON
    BEQ     QUIT                        ; Si "QUITTER" est clique, terminer le programme

FIN_CLICK_G:
    RTS                                 
    

; --- Demarrage de la simulation ---

START_MAJ:
    MOVE.L  #$FFFFFF, D1                ; Definit la couleur du pinceau sur blanc
    JSR     SET_PEN_COLOR
    MOVE.L  #$f0c066, D1                ; Redessine le bouton en bleu clair
    JSR     SET_FILL_COLOR

    MOVE.L  #BOUTON_LANCER, A1
    JSR     DESSINE_BOUTON              ; Redessine le bouton "LANCER"

    MOVE.L  #$0F00CF, D1                ; Definit la couleur du pinceau sur rouge
    JSR     SET_PEN_COLOR
    MOVE.L  #$0000FF, D1                ; Redessine le bouton en rouge
    JSR     SET_FILL_COLOR

    MOVE.L  #BOUTON_ARRETER, A1
    JSR     DESSINE_BOUTON              ; Dessine le bouton "ARRETER"

    MOVE.B  #1, ACTUALISER              ; Demarre l'actualisation automatique de la grille
    JMP     FIN_CLICK_G                 ; Retourne au traitement des clics

; --- Arret de la simulation ---

STOP_MAJ:
    MOVE.L  #$00FF00, D1                ; Definit la couleur du pinceau sur vert
    JSR     SET_PEN_COLOR
    MOVE.L  #$5cbd61, D1                ; Redessine le bouton en bleu clair
    JSR     SET_FILL_COLOR

    MOVE.L  #BOUTON_LANCER, A1
    JSR     DESSINE_BOUTON              ; Redessine le bouton "LANCER"

    MOVE.L  #$FFFFFF, D1                ; Definit la couleur du pinceau sur blanc
    JSR     SET_PEN_COLOR
    MOVE.L  #$f0c066, D1                ; Redessine le bouton en bleu clair
    JSR     SET_FILL_COLOR

    MOVE.L  #BOUTON_ARRETER, A1
    JSR     DESSINE_BOUTON              ; Redessine le bouton "ARRETER"

    MOVE.B  #0, ACTUALISER              ; Arrete l'actualisation automatique de la grille
    JMP     FIN_CLICK_G                 ; Retourne au traitement des clics

; --- Reinitialisation de la grille ---

CLEAR_GRID:
    JSR     RESET                       ; Reinitialise les tableaux de donnees
    JSR     PRINT_GRILLE                ; Redessine la grille
    JMP     FIN_CLICK_G              

; --- Remplissage aleatoire de la grille ---

ALEA_GRID:
    JSR     DEF_GRILLE_ALEA             ; Remplit la grille avec des valeurs aleatoires
    JSR     PRINT_GRILLE                ; Redessine la grille
    JMP     FIN_CLICK_G              

; --- Chargement d'une sauvegarde ---

OPEN_SCH:
    JSR     ATT_CG_UN                   ; Attend la fin d'un clic gauche

    MOVE.L  #0, D1
    MOVE.L  #0, A1
    MOVE.L  #EXTENSION, A2              ; Filtre pour les fichiers au format "*.schema"
    MOVE.L  #PWD, A3                    ; Pointeur vers le chemin du fichier selectionne
    JSR     CHOISIR_F                   ; Ouvre une boute de dialogue pour choisir un fichier

    CMP.B   #1, D1                  
    BNE     FIN_CLICK_G                 ; Si l'utilisateur a annule, revenir au traitement des clics

    MOVE.L  #PWD, A1                    ; Charge le chemin du fichier selectionne
    JSR     OUVRE_F                     ; Ouvre le fichier pour lecture

    CMP.L   #$FFFFFFFF, D0
    BEQ     FIN_CLICK_G                 ; Si une erreur survient, revenir au traitement des clics

    MOVE.L  A5, A1
    JSR     DEF_OPEN_GRILLE             ; Recupere les donnees du fichier
    JSR     FERME_FS                    ; Ferme tous les fichiers ouverts

    JSR     PRINT_GRILLE                ; Affiche la grille mise a jour
    JMP     FIN_CLICK_G              

; --- Sauvegarde de la grille ---

SAVE_SCH:
    JSR     ATT_CG_UN                   ; AttFIN la fin d'un clic gauche

    MOVE.L  #1, D1
    MOVE.L  #0, A1
    MOVE.L  #EXTENSION, A2              ; Filtre pour les fichiers au format "*.schema"
    MOVE.L  #PWD, A3                    ; Pointeur vers le chemin oe sauvegarder
    JSR     CHOISIR_F                   ; Ouvre une boete de dialogue pour choisir l'emplacement de sauvegarde

    CMP.B   #1, D1
    BNE     FIN_CLICK_G                 ; Si l'utilisateur a annule, revenir au traitement des clics

    MOVE.L  #PWD, A1
    JSR     DEF_AJT_EXTENSION           ; Ajoute une extension au fichier si necessaire
    JSR     NOUVEAU_F                   ; Cree un nouveau fichier

    MOVE.L  A5, A1
    JSR     DEF_DONNEES_F               ; Sauvegarde les donnees de la grille dans le fichier
    JSR     FERME_FS                    ; Ferme tous les fichiers ouverts

    JMP     FIN_CLICK_G              

; --- Aumenter la latence ---

AUG_LAT:
    CMP.L   #50000, NB_RAL
    BEQ     MAX_ATTEINT
    ADD.L   #5000, NB_RAL

MAX_ATTEINT:
    JMP     FIN_CLICK_G  

; --- Diminuer la latence ---

DIM_LAT:
    TST.L   NB_RAL
    BEQ     MIN_ATTEINT
    SUB.L   #5000, NB_RAL
    
MIN_ATTEINT:
    JMP     FIN_CLICK_G  

; --- Inclusion des bibliotheques necessaires ---

    INCLUDE 'biblio_aleatoire.X68'      ; Fonctions de generation aleatoire
    INCLUDE 'biblio_autres.X68'         ; Fonctions de bases diverses 
    INCLUDE 'biblio_fichier.X68'        ; Dessin et affichage graphique
    INCLUDE 'biblio_front.X68'          ; Gestion des fichiers
    INCLUDE 'biblio_grille.X68'         ; Fonctions de gestion de la grille
    INCLUDE 'biblio_souris.X68'         ; Bibliotheque principale

; --- Declaration des variables diverses ---

PTR_TAB1:   DC.L 0                      ; Initialisation des tableaux (Pointeur)
PTR_TAB2:   DC.L 0
TAB1:		DS.B 1024			        ; Tableau pour la premiere grille
TAB2:		DS.B 1024			        ; Tableau pour la deuxieme grille
VAR:        DC.B 0 				        ; Variable pour stocker la somme ou un calcul quelconque
I:          DC.L 0                      ; Compteur i pour les boucles
J:          DC.L 0                      ; Compteur j pour les boucles
K:          DC.L 0                      ; Compteur k pour les boucles
L:          DC.L 0                      ; Compteur l pour les boucles
SEED:       DC.W 0                      ; Graine pour la generation aleatoire
RAL_VAR:    DC.L 0	                    ; Variable compteur qui sert a ralentir la machine
NB_RAL:     DC.L 15000                  ; Variable qui stock le ralentissement

; --- Variables pour les parametres de resolution et la grille ---

RES:          DC.W 1005, 800            ; Resolution de la fenetre (largeur, hauteur)
LARG:         DC.W 30                   ; Nombre de cellules en largeur
HAUT:         DC.W 30                   ; Nombre de cellules en hauteur
T_CEL:	      DC.W 20                   ; Taille d'une cellule en pixels
TOT_LARG:     DC.W 600                  ; Largeur totale de la grille (en pixels)
TOT_HAUT:     DC.W 600                  ; Hauteur totale
H_DEC:		  DC.W 200                  ; Decalage horizontal pour centrer la grille
V_DEC:		  DC.W 100                  ; Decalage vertical pour centrer la grille

; --- Variables pour les boutons ---

; Bouton "LANCER"
BOUTON_LANCER:  DC.W 15, 15, 65, 165	; Coordonnees : Y1, X1, Y2, X2
                DC.W 18, 51         	; Position du texte : Y, X
                DC.B 'LANCER',0			; Libelle du bouton
            
; Bouton "ARRETER"
BOUTON_ARRETER: DC.W 15, 180, 65, 330   
                DC.W 18, 47            	
                DC.B 'ARRETER',0
            
; Bouton "ALEATOIRE" (remplissage aleatoire de la grille)
BOUTON_ALEA:    DC.W 15, 345, 65, 495  
                DC.W 18, 39             
                DC.B 'ALEATOIRE',0

; Bouton "SAUVEGARDER" (sauvegarde de la grille actuelle)
BOUTON_SAUV:    DC.W 15, 510, 65, 660  
                DC.W 18, 31             
                DC.B 'SAUVEGARDER',0

; Bouton "CHARGER" (chargement d'une grille sauvegardee)
BOUTON_CHARGER: DC.W 15, 675, 65, 825  
                DC.W 18, 47             
                DC.B 'CHARGER',0
			        
; Bouton "EFFACER" (reinitialisation de la grille)
BOUTON_EFFACER: DC.W 15, 840, 65, 990  
                DC.W 18, 47          
                DC.B 'EFFACER',0

; Bouton "+" (change la vitesse d'actualisation de la grille)
BOUTON_PLUS:    DC.W 400, 15, 430, 45
                DC.W 8, 11
                DC.B '+',0

; Bouton "-" (change la vitesse d'actualisation de la grille)
BOUTON_MOINS:   DC.W 450, 15, 480, 45
                DC.W 8, 11
                DC.B '-',0

; Bouton "QUITTER" (fermeture de l'application)
BOUTON_QUIT:    DC.W 740, 500, 770, 530
                DC.W 8, 11
                DC.B 'x',0
		        
BOOL_LANCER:    DC.B 0			    	; Variable pour suivre l'etat du BOUTON_LANCER
ACTUALISER:   	DC.B 0			        ; Variable de contrile pour lancer ou arreter la simulation

; --- Variables pour les fichiers ---

EXTENSION:      DC.B '*.schema',0 		; Extension des fichiers pour sauvegarder/ouvrir des grilles

PWD:            DC.B 0					; Variable pour stocker le chemin d'acces aux fichiers
                DS.B 62
                DC.B 0

        END    START					; Fin du programme et debut de l'execution au label START














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

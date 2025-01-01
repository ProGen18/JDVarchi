*-----------------------------------------------------------
* Titre      : biblio_fichier
* Ecrit par  : TALAB Stephane
* Date       : 15/12/2024
* Description: 
*               - Gestion des extensions de fichiers ".schema"
*               - Ouverture, fermeture, lecture, et ecriture de fichiers
*               - Recuperation et stockage de donnees de la grille
*               - Interface utilisateur pour selectionner des fichiers
*-----------------------------------------------------------

;---------------------------------------------------------------------------;
; Fonction : DEF_AJT_EXTENSION
; Description : Ajoute l'extension ".schema" au nom du fichier si necessaire
; Entrees : A1 = nom du fichier
; Variables utilisees : A1, PTR_TAB1
;---------------------------------------------------------------------------;

DEF_AJT_EXTENSION:                      ; Debut de la fonction DEF_AJT_EXTENSION
    MOVE.L  A1, PTR_TAB1                ; Sauvegarder A1 dans PTR_TAB1

TQ_AJT_EXTENSION:                       ; Debut de la boucle WHILE
    CMP.B   #0, (A1)                    ; Verifier si le caractere pointe par A1 est nul
    BEQ     FIN_TQ_AJT_EXTENSION        ; Sortir de la boucle si c'est le cas

    CMP.B   #$2E, (A1)+                 ; Verifier si c'est un point (.)
    BNE     TQ_AJT_EXTENSION            ; Si ce n'est pas un point, continuer la boucle

    CMP.B   #$73, (A1)                  ; Verifier si le caractere suivant est 's'
    BNE     TQ_AJT_EXTENSION            ; Si ce n'est pas 's', continuer la boucle

    CMP.B   #$63, 1(A1)                 ; Verifier si le caractere suivant est 'c'
    BNE     TQ_AJT_EXTENSION            ; Si ce n'est pas 'c', continuer la boucle

    CMP.B   #$68, 2(A1)                 ; Verifier si le caractere suivant est 'h'
    BNE     TQ_AJT_EXTENSION            ; Si ce n'est pas 'h', continuer la boucle

    CMP.B   #$65, 3(A1)                 ; Verifier si le caractere suivant est 'e'
    BNE     TQ_AJT_EXTENSION            ; Si ce n'est pas 'e', continuer la boucle

    CMP.B   #$6D, 4(A1)                 ; Verifier si le caractere suivant est 'm'
    BNE     TQ_AJT_EXTENSION            ; Si ce n'est pas 'm', continuer la boucle

    CMP.B   #$61, 5(A1)                 ; Verifier si le caractere suivant est 'a'
    BNE     TQ_AJT_EXTENSION            ; Si ce n'est pas 'a', continuer la boucle

    JMP     FIN_AJT_EXTENSION           ; Si c'est bien ".schema", aller a la fin


FIN_TQ_AJT_EXTENSION:                   ; Fin de la boucle WHILE
    MOVE.B  #$2E, (A1)+                 ; Ajouter le point (.)
    MOVE.B  #$73, (A1)+                 ; Ajouter 's'
    MOVE.B  #$63, (A1)+                 ; Ajouter 'c'
    MOVE.B  #$68, (A1)+                 ; Ajouter 'h'
    MOVE.B  #$65, (A1)+                 ; Ajouter 'e'
    MOVE.B  #$6D, (A1)+                 ; Ajouter 'm'
    MOVE.B  #$61, (A1)+                 ; Ajouter 'a'
    MOVE.B  #0, (A1)                    ; Terminer la chaîne par un caractere nul


FIN_AJT_EXTENSION:                      ; Fin de la fonction DEF_AJT_EXTENSION
    MOVE.L  PTR_TAB1, A1                ; Restaurer A1 depuis PTR_TAB1
    RTS                                 ; Retourner de la fonction DEF_AJT_EXTENSION

;---------------------------------------------------------------------------;
; Fonction : DEF_OPEN_GRILLE
; Description : Recupere les donnees d'un fichier .schema et les stocke dans A1
; Entrees : D1.L = ID du fichier ; A1 = adresse de la grille ; D6.L = largeur ; D7.L = hauteur
; Variables utilisees : D0, D1, D2, D6, D7, A1, PTR_TAB1, I, J
;---------------------------------------------------------------------------;

DEF_OPEN_GRILLE:                        
    MOVE.L  A1, PTR_TAB1                ; Sauvegarder A1 dans PTR_TAB1
    CLR.L   I                           ; Initialiser ia0
    ADD.L   D6, A1                      ; A1 += largeur
    ADD.L   #3, A1                      ; A1 += 3 

TQ_OPEN_GRILLE_1:                       
    CMP.L   I, D7                       ; Comparer i a la hauteur
    BEQ     FIN_TQ_OPEN_GRILLE_1        ; Sortir de la boucle si i == hauteur
    CLR.L   J                           ; Initialiser j a 0

TQ_OPEN_GRILLE_2:                       
    CMP.L   J, D6                       ; Comparer j a la largeur
    BEQ     TQ_OPEN_GRILLE_F            ; Aller a la fin de la boucle J si j == largeur

    MOVE.L  #1, D2                      ; Initialiser D2 a 1 (pour la lecture)
    JSR     LIRE_F                      ; Lire un octet du fichier dans A1
    CMP.B   #1, D0                      ; Verifier si la lecture est terminee (EOF)
    BEQ     TQ_OPEN_GRILLE_G            ; Aller a la fin de la boucle si EOF

    CMP.B   #$0D, (A1)                  ; Verifier si c'est un retour a la ligne
    BEQ     TQ_OPEN_GRILLE_2            ; Si c'est '\r', continuer la boucle
    CMP.B   #$0A, (A1)                  ; Verifier si c'est un saut de ligne
    BEQ     TQ_OPEN_GRILLE_G            ; Si c'est '\n', aller a la fin de la boucle

    SUB.B   #48, (A1)+                  ; Convertir le caractere en valeur numerique
    ADD.L   #1, J                       ; Incrementer j
    JMP     TQ_OPEN_GRILLE_2            ; Retourner a la boucle J

TQ_OPEN_GRILLE_G:                       
    CMP.L   J, D6                       ; Verifier si j == largeur
    BEQ     FIN_TQ_OPEN_GRILLE_2        ; Sortir de la boucle si j == largeur
    CLR.B   (A1)+                       ; Effacer l'octetal'adresse pointee par A1
    ADD.L   #1, J                       ; Incrementer j
    JMP     TQ_OPEN_GRILLE_G            ; Retourner a la boucle WHILE_GL

TQ_OPEN_GRILLE_F:                       
    MOVE.L  #1, D2                      ; Initialiser D2a1
    JSR     LIRE_F                      ; Lire un octet du fichier
    CMP.B   #1, D0                      ; Verifier si la lecture est terminee (EOF)
    BEQ     FIN_TQ_OPEN_GRILLE_2        ; Sortir de la boucle si EOF

    CMP.B   #$0A, (A1)                  ; Verifier si c'est un saut de ligne
    BNE     TQ_OPEN_GRILLE_F            ; Si ce n'est pas '\n', continuer
    CLR.B   (A1)                        ; Effacer le caractere dans A1
    JMP     FIN_TQ_OPEN_GRILLE_2        ; Sortir de la boucle J

FIN_TQ_OPEN_GRILLE_2:                   ; Fin de la boucle J
    ADD.L   #2, A1                      ; Decaler A1 de 2 octets
    ADD.L   #1, I                       ; Incrementer i
    JMP     TQ_OPEN_GRILLE_1            ; Retourner a la boucle I

FIN_TQ_OPEN_GRILLE_1:                   ; Fin de la boucle I
    MOVE.L  PTR_TAB1, A1                ; Restaurer A1 depuis PTR_TAB1
    RTS                                 

;---------------------------------------------------------------------------;
; Fonction : DEF_DONNEES_F
; Description : ecrit les donnees de la grille a l'adresse A1 dans un fichier
; Entrees : D1.L = ID du fichier ; A1 = adresse de la grille ; D6.L = largeur ; D7.L = hauteur
; Variables utilisees : D0, D1, D2, D6, D7, A1, PTR_TAB1, I, J
;---------------------------------------------------------------------------;

DEF_DONNEES_F:                          
    MOVE.L  A1, PTR_TAB1                ; Sauvegarder A1 dans PTR_TAB1
    MOVE.L  #1, D2                      ; Initialiser D2a1 (pour l'ecriture)
    CLR.L   I                           ; Initialiser ia0
    ADD.L   D6, A1                      ; A1 += largeur
    ADD.L   #3, A1                      ; A1 += 3 

TQ_I_DDF:                               ; Debut de la boucle I
    CMP.L   I, D7                       ; Comparer i a la hauteur
    BEQ     FIN_TQ_I_DDF                ; Sortir de la boucle si i == hauteur
    CLR.L   J                           ; Initialiser ja0

TQ_J_DDF:                               ; Debut de la boucle J
    CMP.L   J, D6                       ; Comparer j a la largeur
    BEQ     FIN_TQ_J_DDF                ; Sortir de la boucle si j == largeur

    ADD.B   #48, (A1)                   ; Convertir la valeur en caractere
    JSR     ECRIRE_F                    ; ecrire l'octet dans le fichier
    SUB.B   #48, (A1)+                  ; Retablir la valeur numerique apres ecriture

    ADD.L   #1, J                       ; Incrementer j
    JMP     TQ_J_DDF                    ; Retourner a la boucle J

FIN_TQ_J_DDF:                           ; Fin de la boucle J
    MOVE.B  #$0D, (A1)                  ; Ajouter un retour chariot '\r'
    JSR     ECRIRE_F                    ; ecrire le retour chariot dans le fichier
    CLR.B   (A1)+                       ; Effacer l'octetal'adresse pointee par A1
    MOVE.B  #$0A, (A1)                  ; Ajouter un saut de ligne '\n'
    JSR     ECRIRE_F                    ; ecrire le saut de ligne dans le fichier
    CLR.B   (A1)+                       ; Effacer l'octet a l'adresse pointee par A1

    ADD.L   #1, I                       ; Incrementer i
    JMP     TQ_I_DDF                    ; Retourner a la boucle I

FIN_TQ_I_DDF:                           ; Fin de la boucle I
    MOVE.L  PTR_TAB1, A1                ; Restaurer A1 depuis PTR_TAB1
    RTS                                 

;---------------------------------------------------------------------------;
; Fonction : CHOISIR_F
; Description : Permet a l'utilisateur de choisir un fichier (ouvrir ou sauvegarder)
; Entrees : D1.L = 0 pour ouvrir, 1 pour sauvegarder ; A1 = titre du fichier ; 
;          A2 = extensions autorisees ; A3 = nom du fichier selectionne
; Variables utilisees : D0, D1, A1, A2, A3
;---------------------------------------------------------------------------;

CHOISIR_F:
    MOVE    #58, D0                      
    TRAP    #15                           
    RTS                                   

;---------------------------------------------------------------------------;
; Fonction : FERME_FS
; Description : Ferme tous les fichiers ouverts
; Entrees : Aucun
; Variables utilisees : D0
;---------------------------------------------------------------------------;

FERME_FS:
    MOVE    #50, D0                      
    TRAP    #15                           
    RTS                                  

;---------------------------------------------------------------------------;
; Fonction : OUVRE_F
; Description : Ouvre un fichier dont le nom est contenu a l'adresse dans A1
; Entrees : A1 = adresse du nom du fichier a ouvrir
; Variables utilisees : D0, D1, A1
;---------------------------------------------------------------------------;

OUVRE_F:
    MOVE    #51, D0                      
    TRAP    #15                           
    RTS                                   

;---------------------------------------------------------------------------;
; Fonction : NOUVEAU_F
; Description : Ouvre un nouveau fichier dont le nom est contenu a l'adresse dans A1
; Entrees : A1 = adresse du nom du fichier a creer
; Variables utilisees : D0, D1
;---------------------------------------------------------------------------;

NOUVEAU_F:
    MOVE    #52, D0                      
    TRAP    #15                           
    RTS                                   

;---------------------------------------------------------------------------;
; Fonction : LIRE_F
; Description : Lit D2.L octets dans le fichier où l'ID est contenu dans D1.L
; Entrees : D1.L = ID du fichier ; D2.L = nombre d'octets a lire ; A1 = adresse du buffer de destination
; Variables utilisees : D0, D1, D2, A1
;---------------------------------------------------------------------------;

LIRE_F:
    MOVE    #53, D0                      
    TRAP    #15                           
    RTS                                   

;---------------------------------------------------------------------------;
; Fonction : ECRIRE_F
; Description : ecrit D2.L octets dans le fichier où l'ID est contenu dans D1.L
; Entrees : D1.L = ID du fichier ; D2.L = nombre d'octets a ecrire ; A1 = adresse du buffer a ecrire
; Variables utilisees : D0, D1, D2, A1
;---------------------------------------------------------------------------;

ECRIRE_F:
    MOVE    #54, D0                      
    TRAP    #15                           
    RTS                                   

*-----------------------------------------------------------
* Titre      : biblio_autres
* Ecrit par  : TALAB Stephane
* Date       : 15/12/2024
* Description: 
*               - Recuperation de l'heure systeme en centiemes de secondes
*               - Gestion de la fin du programme
*               - Modification de la resolution de la fenêtre
*-----------------------------------------------------------

;---------------------------------------------------------------------------;
; Fonction : GET_TIME
; Description : Stocke le nombre de centiemes de secondes depuis minuit dans D1.L
; Entrees : Aucune
; Sorties : D1.L = nombre de centiemes de secondes depuis minuit
; Variables utilisees : D0, D1
;---------------------------------------------------------------------------;

GET_TIME:
    MOVE    #8, D0          
    TRAP    #15             
    RTS                     

;---------------------------------------------------------------------------;
; Fonction : FINPRG
; Description : Termine le programme
; Entrees : Aucune
; Sorties : Aucune 
; Variables utilisees : D0
;---------------------------------------------------------------------------;

FINPRG:
    MOVE    #9, D0          
    TRAP    #15      

;---------------------------------------------------------------------------;
; Fonction : RESOLUTION
; Description : Change la resolution de la fenêtre
; Entrees : D1.L = largeur/hauteur
; Sorties : Aucune 
; Variables utilisees : D0, D1
;---------------------------------------------------------------------------;

RESOLUTION:                            
    MOVE    #33, D0                    
    TRAP    #15
    RTS           

SCPSNDVF = SCPSNDVF or {}
SCPSNDVF.CONFIG = SCPSNDVF.CONFIG or {}

/* 
                -> VERSION 2 <- 

==================================================
    "SCPSOUNDVF:StopSounds"
    - Description : Appelé lorsqu'un joueur stoppe tous les sons
    - Arguments : 
        1. ply (Player) - Joueur qui a stoppé tous les sons

    "SCPSOUNDVF:PlaySound"
    - Description : Appelé lorsqu'un joueur joue un son
    - Arguments : 
        1. ply (Player) - Joueur qui a joué le son
        2. sound (string) - Son joué

    "SCPSOUNDVF:ADDGROUP"
    - Description : Appelé lorsqu'un groupe est ajouté à la liste des groupes d'accès
    - Arguments : 
        1. ply (Player) - Joueur qui a ajouté le groupe
        2. group (string) - Groupe ajouté 

    "SCPSOUNDVF:REMOVEGROUP"
    - Description : Appelé lorsqu'un groupe est retiré de la liste des groupes d'accès
    - Arguments : 
        1. ply (Player) - Joueur qui a retiré le groupe
        2. group (string) - Groupe retiré 

    "SCPSOUNDVF:SHUDULE:ADD"
    - Description : Appelé lorsqu'un son est ajouté à la liste des sons planifiés
    - Arguments : 
        1. ply (Player) - Joueur qui a ajouté le son
        2. sound (string) - Son ajouté à la planification

==================================================
*/



-- Commande pour acceder au panel
SCPSNDVF.CONFIG.COMMANDE = "/sounds"
SCPSNDVF.CONFIG.BUTTONS = {
    ["Autre"] = {
        commands = {
            { title = "Backrooms KV-31", sound = "scpsounds/autre/backrooms_kv31_try.wav" },
            { title = "Cantine", sound = "scpsounds/ambiance/cantine_burger.wav" },
            { title = "Intrusion", sound = "scpsounds/deconf/securitybreach.wav" },
            { title = "Décontamination | MUSIQUE", sound = "scpsounds/autre/decontamination.wav" },
            { title = "Décontamination", sound = "scpsounds/autre/decontamination_no_music.wav" },
            { title = "Ogives Alpha | MUSIQUE", sound = "scpsounds/autre/warheads_music.wav" },
            { title = "Ogives Alpha", sound = "scpsounds/autre/warheads_nomusic.wav" },
            { title = "Personnel Extérieur", sound = "scpsounds/autre/personnel_ext.wav" },
            { title = "Roger", sound = "scpsounds/autre/roger.wav" },
            { title = "Roger Myers - Zone 106", sound = "scpsounds/autre/roger_myers.wav" },
            { title = "Début d'expérience", sound = "scpsounds/autre/EXP_DEBUT.mp3" },
            { title = "Arrêt expériences", sound = "scpsounds/autre/PCS_OFF.mp3" },
            { title = "Evacuation bunker", sound = "scpsounds/autre/Bunker.mp3" },
            { title = "Fin d'alerte bunker", sound = "scpsounds/autre/Fin_Bunker.mp3" },
        }
    },

    ["Déconfinement"] = {
        commands = {
            { title = "Brèche Générale", sound = "scpsounds/deconf/bigbreach.wav" },
            { title = "Brèche SCP-035 PA", sound = "scpsounds/deconf/Breach_035_PA.mp3" },
            { title = "Brèche SCP-049 PA", sound = "scpsounds/deconf/Breach_049_PA.mp3" },
            { title = "Brèche SCP-096 Évoluée", sound = "scpsounds/deconf/Breach_096_Evolved.mp3" },
            { title = "Brèche SCP-1048 Évolué", sound = "scpsounds/deconf/Breach_1048_Evolved.mp3" },
            { title = "Brèche SCP-106 Évoluée", sound = "scpsounds/deconf/Breach_106_Evolved.mp3" },
            { title = "Brèche SCP-173 OLD Évoluée", sound = "scpsounds/deconf/Breach_173_OLD_Evolved.mp3" },
            { title = "Brèche SCP-173 PA", sound = "scpsounds/deconf/Breach_173_PA.mp3" },
            { title = "Brèche SCP-457 PA", sound = "scpsounds/deconf/Breach_457_PA.mp3" },
            { title = "Brèche SCP-682", sound = "scpsounds/deconf/Breach_682.mp3" },
            { title = "Brèche SCP-682 OLD Évoluée", sound = "scpsounds/deconf/Breach_682_OLD_Evolved.mp3" },
            { title = "Brèche SCP-966 PA", sound = "scpsounds/deconf/Breach_966_PA.mp3" },
            { title = "Brèche SCP-Euclid", sound = "scpsounds/deconf/Breach_Euclid.mp3" },
            { title = "Brèche SCP-Keter", sound = "scpsounds/deconf/Breach_Keter.mp3" },
            { title = "Brèche SCP-Safe", sound = "scpsounds/deconf/Breach_Safe.mp3" },
            { title = "Brèche SCP-Secu", sound = "scpsounds/deconf/Breach_Secu.mp3" },
            { title = "OLD - SCP-008", sound = "scpsounds/deconf/008.wav" },
            { title = "OLD - SCP-035", sound = "scpsounds/deconf/035.wav" },
            { title = "OLD - SCP-049", sound = "scpsounds/deconf/049.wav" },
            { title = "OLD - SCP-079", sound = "scpsounds/deconf/079.wav" },
            { title = "OLD - SCP-096", sound = "scpsounds/deconf/096.wav" },
            { title = "OLD - SCP-1048", sound = "scpsounds/deconf/1048.wav" },
            { title = "OLD - SCP-106", sound = "scpsounds/deconf/106.wav" },
            { title = "OLD - SCP-173", sound = "scpsounds/deconf/173.wav" },
            { title = "OLD - SCP-457", sound = "scpsounds/deconf/457.wav" },
            { title = "OLD - SCP-682", sound = "scpsounds/deconf/682.wav" },
            { title = "OLD - SCP-966", sound = "scpsounds/deconf/966.wav" },
        }
    },
    
    ["FIM"] = {
        commands = {
            { title = "Entrée", sound = "scpsounds/fim/FIM_Entree_Random.mp3" },
            { title = "Alpha-1", sound = "scpsounds/fim/entreemtf1.wav" },
            { title = "Alpha-1 | Rappel", sound = "scpsounds/fim/rappel_a1.wav" },
            { title = "Alpha-1 | Sortie", sound = "scpsounds/fim/a1_leave.wav" },
            { title = "Epsilon-11", sound = "scpsounds/fim/entreemtf2.wav" },
            { title = "Epsilon-11 | Rappel", sound = "scpsounds/fim/rappel_ep11.wav" },
            { title = "Epsilon-11 | Sortie", sound = "scpsounds/fim/ep11_leave.wav" },
            { title = "Sortie FIM", sound = "scpsounds/fim/sortiefim.wav" },
        }
    },

    ["Reconfinement"] = {
        commands = {
            { title = "Femur Breaker", sound = "scpsounds/reconf/106_femurbreaker.wav" },
            { title = "SCP-049", sound = "scpsounds/reconf/049.wav" },
            { title = "SCP-096", sound = "scpsounds/reconf/096.wav" },
            { title = "SCP-106", sound = "scpsounds/reconf/106.wav" },
            { title = "SCP-173", sound = "scpsounds/reconf/173.wav" },
            { title = "SCP-457", sound = "scpsounds/reconf/457.wav" },
            { title = "SCP-939", sound = "scpsounds/reconf/939.wav" },

        }
    },

    ["Incidents"] = {
        commands = {
            { title = "Point de Contrôle", sound = "scpsounds/incidents/checkpoint.wav" },
            { title = "Maintenance Intercoms", sound = "scpsounds/incidents/maintenance_intercoms.wav" },
            { title = "Panne Électrique", sound = "scpsounds/incidents/panne_electrique.wav" },
            { title = "Fuite de Gaz", sound = "scpsounds/incidents/fuite_gaz.wav" },
            { title = "Alerte Incendie", sound = "scpsounds/incidents/feu.wav" },
        }
    },

    ["initiatives de réponses automatisées"] = {
        commands = {
            { title = "RA-1 \"ÉPINGLE À NOURRICE\"", sound = "scpsounds/autre/RA-1.ogg" },
            { title = "RA-3 \"MAUVAIS OPTICIEN\"", sound = "scpsounds/autre/RA-3.ogg" },
            { title = "RA-4 \"GRILLE-PAIN GÉANT\"", sound = "scpsounds/autre/RA-4.ogg" },
            { title = "RA-5 \"HEURE DE FERMETURE\"", sound = "scpsounds/autre/RA-5.ogg" },
            { title = "RA-6 \"ASTHME DE GRAND-...\"", sound = "scpsounds/autre/RA-6.ogg" },
            { title = "RA-7 \"NAVIRE EN NAUFRAGE\"", sound = "scpsounds/autre/RA-7.ogg" },
        }
    },

    ["Alarmes"] = {
        commands = {
            { title = "Alarme 1", sound = "scpsounds/ambiance/Alarme-1.mp3" },
            { title = "Alarme 2", sound = "scpsounds/ambiance/Alarme-2.mp3" },
            { title = "Alarme 3", sound = "scpsounds/ambiance/Alarme-3.mp3" },
            { title = "Alarme 4", sound = "scpsounds/ambiance/Alarme-4.mp3" },
            { title = "Alarme 5", sound = "scpsounds/ambiance/Alarme-5.mp3" },
            { title = "Alarme 6", sound = "scpsounds/ambiance/Alarme-6.mp3" },
        }
    },


    ["Classe-D"] = {
        commands = {
            { title = "Fin d'Alerte", sound = "scpsounds/classe_d/classd_fin.wav" },
            { title = "Évasion", sound = "scpsounds/classe_d/evasion.wav" },
            { title = "OLD - Prise d'Otage", sound = "scpsounds/classe_d/prise_otage.wav" },
            { title = "Entrez dans le Confinement", sound = "scpsounds/classe_d/hp_entreecellule.wav" },
            { title = "Avertissement 1", sound = "scpsounds/classe_d/entree_avert_1.wav" },
            { title = "Avertissement 2", sound = "scpsounds/classe_d/entree_avert_2.wav" },
            { title = "Rupture de Contrat", sound = "scpsounds/classe_d/fin_contrat.wav" },
            { title = "Fuite d'une Classe-D", sound = "scpsounds/classe_d/Fuite_UneClassD.mp3" },
            { title = "Fuite Classe-D", sound = "scpsounds/classe_d/Fuite_ClassD.mp3" },
            { title = "Prise d'Otage", sound = "scpsounds/classe_d/PO_ZC.mp3" },
        }
    },
    
}

--[[ v !! NE PAS RETIRER && NE PAS TOUCHER !! v ]] 

            if SERVER then return end

--[[ ^ !! NE PAS RETIRER && NE PAS TOUCHER !! ^ ]] 


SCPSNDVF.CONFIG.TEXTE = {
    titre = "SCP SOUNDS VF",
    lancer_sons = "LANCER DES SONS",
    administratif = "ADMINISTRATIF",
    boutons = {
        alarme = "ALARMES",
        fim = "FIM",
        deconfinement = "DÉCONFINEMENT",
        reconfinement = "RECONFINEMENT",
        autre = "AUTRE",
        planification = "PLANIFICATION",
        parametres = "PARAMÈTRES"
    },
    recherche = "RECHERCHER DES SONS"
}
timer.Simple(1, function()
    SCPSNDVF.CONFIG.COULEUR = {
        ["fond"] = Color(16, 15, 20),
        ["fond_txt"] = Color(20, 19, 25),
        ["texte"] = Color(35, 34, 96),
        ["accent"] = Color(66, 33, 33),
        ["gris_clair"] = Color(153, 153, 153),        
        ["blanc_fade"] = Color(255, 255, 255, 50),
        ["texte_btn"] = Color(255, 255, 255, 50),
    }

    SCPSNDVF.CONFIG.MATERIALS = {
        ["ALARM"] = Material("bsound_browser/icons/alarm.png", "smooth"),
        ["BUILD"] = Material("bsound_browser/icons/build.png", "smooth"),
        ["EXPLOSION"] = Material("bsound_browser/icons/explosion.png", "smooth"),
        ["GRAD"] = Material("bsound_browser/icons/grad.png", "smooth"),
        ["HANDCUFFS"] = Material("bsound_browser/icons/handcuffs.png", "smooth"),
        ["INCIDENT"] = Material("bsound_browser/icons/incident.png", "smooth"),
        ["IRA"] = Material("bsound_browser/icons/ira.png", "smooth"),
        ["LOCK"] = Material("bsound_browser/icons/lock.png", "smooth"),
        ["MORE"] = Material("bsound_browser/icons/more.png", "smooth"),
        ["MUTE"] = Material("bsound_browser/icons/mute_1.png", "smooth"),
        ["RECTANGLE"] = Material("bsound_browser/icons/rectangle.png", "smooth"),
        ["RIFLE"] = Material("bsound_browser/icons/rifle.png", "smooth"),
        ["TIMER"] = Material("bsound_browser/icons/timer.png", "smooth"),
        ["VOLUME"] = Material("bsound_browser/icons/volume.png", "smooth"),
        ["LOGO"] = Material("bsound_browser/logos/logo_scpsoundvf.png", "smooth"),
    }
end) 
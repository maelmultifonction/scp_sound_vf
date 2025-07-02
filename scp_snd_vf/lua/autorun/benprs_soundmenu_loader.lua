-- > Pas besoin de toucher à ce fichier < --
local isSystemReady = function() return false end
local LOADERCONFIG = LOADERCONFIG or {}
LOADERCONFIG.CONFIGURATION = LOADERCONFIG.CONFIGURATION or {}

-- CONFIGURATION DU LOADER
LOADERCONFIG.CONFIGURATION.DIRECTORIESCOLOR = Color(209, 189, 76)
LOADERCONFIG.CONFIGURATION.FILECOLOR = Color(106, 212, 216)
LOADERCONFIG.CONFIGURATION.SHCOLOR = Color(186, 141, 192)
LOADERCONFIG.CONFIGURATION.COLORCL = Color(187, 178, 102)
LOADERCONFIG.CONFIGURATION.COLORSV = Color(88, 135, 150)
LOADERCONFIG.CONFIGURATION.COLORBASE = Color(255, 255, 255)
LOADERCONFIG.CONFIGURATION.ADDONNAME = "SCP SOUND VF"
LOADERCONFIG.CONFIGURATION.ROOT = "benprs_soundmenu"

LOADERCONFIG.CONFIGURATION.CLIENTPRINT = false
LOADERCONFIG.CONFIGURATION.SERVERPRINT = true
LOADERCONFIG.CONFIGURATION.DIRECTORIEPRINT = true

LOADERCONFIG.CONFIGURATION.SERVERLOADER = true
LOADERCONFIG.CONFIGURATION.CLIENTLOADER = true
LOADERCONFIG.CONFIGURATION.SHAREDLOADER = true

LOADERCONFIG.CONFIGURATION.PREFIXSV = "sv_"
LOADERCONFIG.CONFIGURATION.PREFIXCL = "cl_"
LOADERCONFIG.CONFIGURATION.PREFIXSH = "sh_"

LOADERCONFIG.CONFIGURATION.EXTENSION = ".lua"
LOADERCONFIG.CONFIGURATION.FINDFOLDERS = "LUA"

local function AddFile(File, directory)
    local prefix = string.lower(string.Left(File, 3))
    
    if SERVER and prefix == LOADERCONFIG.CONFIGURATION.PREFIXSV and LOADERCONFIG.CONFIGURATION.SERVERLOADER then
        include(directory .. File)
        if LOADERCONFIG.CONFIGURATION.SERVERPRINT then
            MsgC(LOADERCONFIG.CONFIGURATION.COLORSV, LOADERCONFIG.CONFIGURATION.ADDONNAME .. " ", 
                 LOADERCONFIG.CONFIGURATION.COLORBASE, "Chargement des fichiers serveurs : ",
                 LOADERCONFIG.CONFIGURATION.FILECOLOR, File, Color(255, 255, 255), ". \n")
        end
    elseif prefix == LOADERCONFIG.CONFIGURATION.PREFIXSH and LOADERCONFIG.CONFIGURATION.SHAREDLOADER then
        if SERVER then
            AddCSLuaFile(directory .. File)
            if LOADERCONFIG.CONFIGURATION.SERVERPRINT then
                MsgC(LOADERCONFIG.CONFIGURATION.SHCOLOR, LOADERCONFIG.CONFIGURATION.ADDONNAME .. " ", 
                     LOADERCONFIG.CONFIGURATION.COLORBASE, "Chargement des fichiers partagés : ",
                     LOADERCONFIG.CONFIGURATION.FILECOLOR, File, Color(255, 255, 255), ". \n")
            end
        end
        include(directory .. File)
        if CLIENT and LOADERCONFIG.CONFIGURATION.CLIENTPRINT then
            MsgC(LOADERCONFIG.CONFIGURATION.SHCOLOR, LOADERCONFIG.CONFIGURATION.ADDONNAME .. " ",
                 LOADERCONFIG.CONFIGURATION.COLORBASE, "Chargement des fichiers partagés : ",
                 LOADERCONFIG.CONFIGURATION.FILECOLOR, File, Color(255, 255, 255), ". \n")
        end
    elseif prefix == LOADERCONFIG.CONFIGURATION.PREFIXCL and LOADERCONFIG.CONFIGURATION.CLIENTLOADER then
        if SERVER then
            AddCSLuaFile(directory .. File)
            if LOADERCONFIG.CONFIGURATION.SERVERPRINT then
                MsgC(LOADERCONFIG.CONFIGURATION.COLORCL, LOADERCONFIG.CONFIGURATION.ADDONNAME .. " ",
                     LOADERCONFIG.CONFIGURATION.COLORBASE, "Chargement des fichiers client : ",
                     LOADERCONFIG.CONFIGURATION.FILECOLOR, File, Color(255, 255, 255), ". \n")
            end
        elseif CLIENT then
            include(directory .. File)
            if LOADERCONFIG.CONFIGURATION.CLIENTPRINT then
                MsgC(LOADERCONFIG.CONFIGURATION.COLORCL, LOADERCONFIG.CONFIGURATION.ADDONNAME .. " ",
                     LOADERCONFIG.CONFIGURATION.COLORBASE, "Chargement des fichiers client : ",
                     LOADERCONFIG.CONFIGURATION.FILECOLOR, File, Color(255, 255, 255), ". \n")
            end
        end
    end
end

local function IncludeDir(directory)
    directory = directory .. "/"
    local files, directories = file.Find(directory .. "*", LOADERCONFIG.CONFIGURATION.FINDFOLDERS)

    for _, v in ipairs(files) do
        if string.EndsWith(v, LOADERCONFIG.CONFIGURATION.EXTENSION) then
            AddFile(v, directory)
        end
    end

    for _, v in ipairs(directories) do
        if LOADERCONFIG.CONFIGURATION.CLIENTPRINT and CLIENT and LOADERCONFIG.CONFIGURATION.DIRECTORIEPRINT then
            print("")
            MsgC(LOADERCONFIG.CONFIGURATION.DIRECTORIESCOLOR, LOADERCONFIG.CONFIGURATION.ADDONNAME .. " ",
                 LOADERCONFIG.CONFIGURATION.COLORBASE, "Répertoire : ", LOADERCONFIG.CONFIGURATION.FILECOLOR, v,
                 Color(255, 255, 255), ". \n")
        end

        if LOADERCONFIG.CONFIGURATION.SERVERPRINT and SERVER and LOADERCONFIG.CONFIGURATION.DIRECTORIEPRINT then
            print("")
            MsgC(LOADERCONFIG.CONFIGURATION.DIRECTORIESCOLOR, LOADERCONFIG.CONFIGURATION.ADDONNAME .. " ",
                 LOADERCONFIG.CONFIGURATION.COLORBASE, "Chargement du répertoire : ",
                 LOADERCONFIG.CONFIGURATION.FILECOLOR, v, Color(255, 255, 255), ". \n")
        end

        IncludeDir(directory .. v)
    end
end

if CLIENT then 
    hook.Add( "Initialize", "SCPSOUNDVF:CONNEXION:MESSAGE", function()
        isSystemReady = function() return true end
        timer.Simple(6.5, function() 
            chat.AddText(Color(161,66,66), "[ INFORMATION ] ", Color(218,218,218), "Ce serveur utilise le lanceur de sons de ", Color(4,77,211),  " SCP", Color(255,255,255), " SOUND", Color(143,0,0),  " VF", Color(218,218,218)," vous pouvez le retrouver en cliquant sur ce lien :")
            chat.AddText(Color(0,118,228), "https://steamcommunity.com/sharedfiles/filedetails/?id=2988855379") 
        end) 
    end )
end 
IncludeDir(LOADERCONFIG.CONFIGURATION.ROOT)

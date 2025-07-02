util.AddNetworkString("SCPSOUNDVF:SQL:CTS")
util.AddNetworkString("SCPSOUNDVF:SQL:STC")
util.AddNetworkString("BENPRS:SCPSOUNDVF::SQL:ADD_GROUP")
util.AddNetworkString("BENPRS:SCPSOUNDVF::SQL:SENDGRADES")
util.AddNetworkString("BENPRS:SCPSOUNDVF::SQL:REMOVE_GROUP")
util.AddNetworkString("SCPSOUNDVF:BOUCLAGE:CHANGE")
sql.Query([[
    CREATE TABLE IF NOT EXISTS SSNDVF_DAT(
        name TEXT PRIMARY KEY,
        value INTEGER
    )
]])
sql.Query([[
    CREATE TABLE IF NOT EXISTS SSNDVF_GRADES(
        name TEXT PRIMARY KEY,
        added_by TEXT
    )
]])

local addadmin = string.format(
    "INSERT OR REPLACE INTO SSNDVF_GRADES (name, added_by) VALUES (%s, %s)",
    sql.SQLStr("superadmin"), 
    sql.SQLStr("Console")
)
sql.Query(addadmin)


SCPSNDVF.CONFIG.GRADES = SCPSNDVF.CONFIG.GRADES or {}
SCPSNDVF.CONFIG.STATE = SCPSNDVF.CONFIG.STATE or {}

hook.Add("Initialize", "SCPSNDVF:SQL:INIT", function()
local result = sql.Query("SELECT * FROM SSNDVF_GRADES")
    if result then
        for _, row in ipairs(result) do
            table.Add(SCPSNDVF.CONFIG.GRADES, {row.name}) 
            print("SCPVF | Ajout de "..row.name.."à la liste d'accès.")
        end
    else
        print("[SQL ERROR] " .. sql.LastError())
    end
end)


local function parametre(nm, paramValue)
    if type(paramValue) == "boolean" then
        paramValue = paramValue and 1 or 0
    elseif type(paramValue) ~= "number" then
        error("SCPSNDVF : Une erreur est survenue lors de l'enregistrement dans la DB.")
    end

    local query = string.format(
        "INSERT OR REPLACE INTO SSNDVF_DAT (name, value) VALUES (%s, %d)",
        sql.SQLStr(nm),
        paramValue
    )

    if sql.Query(query) == false then
        print("[SQL ERROR] " .. sql.LastError())
    else
        print("[SQL] Paramètre '" .. nm .. "' enregistré avec la valeur " .. paramValue)
    end
end

local function getServerParameter(nm)
    local query = string.format(
        "SELECT value FROM SSNDVF_DAT WHERE name = %s",
        sql.SQLStr(nm)
    )

    local result = sql.Query(query)
    if result and result[1] then
        local value = tonumber(result[1].value)
        return value == 1
    else
        print("[SQL] Aucun résultat pour '" .. nm .. "'")
        return false
    end
end

hook.Add("PlayerInitialSpawn", "SCPVF:BOUCLAGE:SENDSTATE", function() 
    net.Start("SCPSOUNDVF:BOUCLAGE:CHANGE") 
    net.WriteBool(getServerParameter("BOUCLAGE"))
    net.Broadcast()
end)

net.Receive("SCPSOUNDVF:SQL:CTS", function(_, ply)
    if ply:GetUserGroup() != "superadmin" then return end 

    local uint = net.ReadUInt(3)
    local bool = net.ReadBool()  

    local parameters = {
        [1] = "BOUCLAGE",
        [2] = "PLANIFICATION"
    }

    if parameters[uint] then
        parametre(parameters[uint], bool)
    end

    net.Start("SCPSOUNDVF:BOUCLAGE:CHANGE") 
    net.WriteBool(getServerParameter("BOUCLAGE"))
    net.Broadcast()
end)

net.Receive("SCPSOUNDVF:SQL:STC", function(_, ply)
    if ply:GetUserGroup() ~= "superadmin" then return end 

    local nm = net.ReadString()
    local nm2 = net.ReadString()
    
    net.Start("SCPSOUNDVF:SQL:STC") 
        net.WriteBool(getServerParameter(nm))
        net.WriteBool(getServerParameter(nm2))
    net.Send(ply)

    for _, v in pairs(SCPSNDVF.CONFIG.GRADES) do 
        if type(v) ~= "string" then return end
        net.Start("BENPRS:SCPSOUNDVF::SQL:SENDGRADES")
        net.WriteString(v)
        net.Send(ply) 
    end
end)

net.Receive("BENPRS:SCPSOUNDVF::SQL:ADD_GROUP", function(_, ply)
    if ply:GetUserGroup() != "superadmin" then return end

    local group = net.ReadString()
    local addedBy = ply:Nick()

    local query = string.format(
        "INSERT INTO SSNDVF_GRADES (name, added_by) VALUES (%s, %s)",
        sql.SQLStr(group),
        sql.SQLStr(addedBy)
    )

    if sql.Query(query) == false then
        print("1. [ SCPSOUND VF SQL ERROR] " .. sql.LastError())
    else
        print("[ SCPSOUND VF SQL] Groupe '" .. group .. "' ajouté par '" .. addedBy .. "'.")

        local result = sql.Query("SELECT * FROM SSNDVF_GRADES")
        if result then
            table.insert(SCPSNDVF.CONFIG.GRADES, group)
        else
            print("2. [SCPSOUND VF SQL ERROR] " .. sql.LastError())
        end
    end

    hook.Run( "SCPSOUNDVF:ADDGROUP", ply, group)
end)


net.Receive("BENPRS:SCPSOUNDVF::SQL:REMOVE_GROUP", function(_,ply) 
    if ply:GetUserGroup() != "superadmin" then return end
    local group = net.ReadString() 

    for k, v in pairs(SCPSNDVF.CONFIG.GRADES) do 
        if v == group then 
            table.remove(SCPSNDVF.CONFIG.GRADES, k)
        end
    end

    local query = string.format(
        "DELETE FROM SSNDVF_GRADES WHERE name = %s",
        sql.SQLStr(group)
    )

    if sql.Query(query) == false then
        print("[ SCPSOUND VF SQL ERROR] " .. sql.LastError())
    else
        print("[ SCPSOUND VF SQL] Groupe '" .. group .. "' supprimé.")
    end 

    hook.Run( "SCPSOUNDVF:REMOVEGROUP", ply, group)
end)
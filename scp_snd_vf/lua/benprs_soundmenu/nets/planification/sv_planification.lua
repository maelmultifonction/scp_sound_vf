util.AddNetworkString("SCPSOUNDVF:SQL:ADD_SCHEDULED")
util.AddNetworkString("SCPSOUNDVF:SQL:FETCH_SCHEDULED")
util.AddNetworkString("SCPSOUNDVF:SQL:SCHEDULED_DATA")
util.AddNetworkString("SCPSOUNDVF:SQL:PLAY_SCHEDULED_SOUND")

-- Création de la table si elle n'existe pas
sql.Query([[
    CREATE TABLE IF NOT EXISTS scpsound_schedule (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        hour INTEGER,
        minute INTEGER,
        played_today INTEGER DEFAULT 0
    )
]])

-- Ajout d’un son planifié
net.Receive("SCPSOUNDVF:SQL:ADD_SCHEDULED", function(len, ply)
    if not ply:IsAdmin() then return end 

    local title = net.ReadString()
    local hour = net.ReadUInt(5)
    local minute = net.ReadUInt(6)

    sql.Query("INSERT INTO scpsound_schedule (title, hour, minute, played_today) VALUES (" ..
        sql.SQLStr(title) .. ", " .. hour .. ", " .. minute .. ", 0)")

    hook.Run( "SCPSOUNDVF:SHUDULE:ADD", ply, title)
end)

-- Envoi de la liste des sons planifiés
net.Receive("SCPSOUNDVF:SQL:FETCH_SCHEDULED", function(len, ply)
    
    local result = sql.Query("SELECT * FROM scpsound_schedule")
    if not result then result = {} end

    net.Start("SCPSOUNDVF:SQL:SCHEDULED_DATA")
    net.WriteTable(result)
    net.Send(ply)
end)

-- Timer pour jouer les sons à la bonne heure
timer.Create("SCPSOUNDVF:CheckSchedule", 60, 0, function()
    local hour = tonumber(os.date("%H"))
    local minute = tonumber(os.date("%M"))

    local scheduled = sql.Query("SELECT * FROM scpsound_schedule WHERE hour = " .. hour .. " AND minute = " .. minute .. " AND played_today = 0")

    if scheduled and istable(scheduled) then
        for _, sound in ipairs(scheduled) do
            net.Start("SCPSOUNDVF:SQL:PLAY_SCHEDULED_SOUND")
            net.WriteString(sound.title)
            net.Broadcast()

            sql.Query("DELETE FROM scpsound_schedule WHERE id = " .. tonumber(sound.id or 0))
        end
    end
end)


util.AddNetworkString("SCPSOUNDVF:SQL:REMOVE_SCHEDULED")

net.Receive("SCPSOUNDVF:SQL:REMOVE_SCHEDULED", function(len, ply)
    if not ply:IsAdmin() then return end

    local id = net.ReadUInt(16)
    if id < 0 then return end

    sql.Query("DELETE FROM scpsound_schedule WHERE id = " .. id)
    hook.Run("SCPSOUNDVF:SCHEDULE:REMOVE", ply, id)
end)
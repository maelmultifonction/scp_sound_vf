
local SCPSOUNDVF_SYSTEM_BOUCLAGE = false

util.AddNetworkString("BENPRS:SCPSOUNDVF::LAUNCHSOUND")
util.AddNetworkString("BENPRS:SCPSOUNDVF::LAUNCHSOUNDCL")
util.AddNetworkString("BENPRS:SCPSOUNDVF::LOOPSOUND")
util.AddNetworkString("BENPRS:SCPSOUNDVF::CHANGELOOPBOOL")

net.Receive("BENPRS:SCPSOUNDVF::LAUNCHSOUND", function(_, ply)
    if not ply:IsValid() or not ply:IsPlayer() then
        return
    end
    local link = net.ReadString()

    if not table.HasValue(SCPSNDVF.CONFIG.GRADES, ply:GetUserGroup()) then
        ply:ChatPrint("Vous n'avez pas la permission d'effectuer cette action.")
        return 
    end
        net.Start("BENPRS:SCPSOUNDVF::LAUNCHSOUNDCL")
        net.WriteString("https://up-rp.4kaptured.com/docs/"..link)
        net.Broadcast()

    hook.Run("SCPSOUNDVF:PlaySound", ply, link)
end)



net.Receive("BENPRS:SCPSOUNDVF::LOOPSOUND", function(_, ply)
    if not ply:IsValid() or not ply:IsPlayer() then
        return
    end
    
    if not table.HasValue(SCPSNDVF.CONFIG.GRADES, ply:GetUserGroup()) then
        ply:ChatPrint("Vous n'avez pas la permission d'effectuer cette action.")
        return 
    end

    SCPSOUNDVF_SYSTEM_BOUCLAGE = not SCPSOUNDVF_SYSTEM_BOUCLAGE
    net.Start("BENPRS:SCPSOUNDVF::CHANGELOOPBOOL")
    net.WriteBool(SCPSOUNDVF_SYSTEM_BOUCLAGE)
    net.Broadcast()

end)



util.AddNetworkString("BENPRS:SCPSOUNDVF::STOPSOUND")
util.AddNetworkString("BENPRS:SCPSOUNDVF::STOPSOUND_CL")

net.Receive("BENPRS:SCPSOUNDVF::STOPSOUND", function(_, ply)
    if not table.HasValue(SCPSNDVF.CONFIG.GRADES, ply:GetUserGroup()) then
        ply:ChatPrint("Vous n'avez pas la permission d'effectuer cette action.")
        return 
    end

    net.Start("BENPRS:SCPSOUNDVF::STOPSOUND_CL")
    net.Broadcast()

    hook.Run( "SCPSOUNDVF:StopSounds", ply)
end)


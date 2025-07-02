
util.AddNetworkString("BENPRS:SCPSOUNDVF::CLOPENMENU")
hook.Add( "PlayerSay", "playurlmenu", function( ply, text )
	if ( string.lower( text ) == SCPSNDVF.CONFIG.COMMANDE ) then
        if table.HasValue(SCPSNDVF.CONFIG.GRADES, ply:GetUserGroup()) then
            net.Start("BENPRS:SCPSOUNDVF::CLOPENMENU")
            net.Send(ply)
        else
            ply:ChatPrint("Vous n'avez pas la permission d'acceder au panel.")
        end
        return ""
    end

end) 




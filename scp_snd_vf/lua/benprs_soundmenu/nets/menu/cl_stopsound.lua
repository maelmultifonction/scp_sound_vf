hook.Add( "Initialize", "SCPSOUNDVF:CONNEXION:MESSAGE", function()
    timer.Simple(6.5, function() 
        chat.AddText(Color(161,66,66), "[ INFORMATION ] ", Color(218,218,218), "Ce serveur utilise le lanceur de sons de ", Color(4,77,211),  " SCP", Color(255,255,255), " SOUND", Color(143,0,0),  " VF", Color(218,218,218)," vous pouvez le retrouver en cliquant sur ce lien :")
        chat.AddText(Color(0,118,228), "https://steamcommunity.com/sharedfiles/filedetails/?id=2988855379") 
        chat.AddText(Color(0,118,228), "Utilisez la commande !volume [0-100] pour modifier le volume du son.") 
    end) 
end )


net.Receive("BENPRS:SCPSOUNDVF::STOPSOUND_CL", function()
    if not IsValid(VAR_SYSTEM_BENSOUNDMENU_PLAYSOUND) then return end
    VAR_SYSTEM_BENSOUNDMENU_PLAYSOUND:Stop()
end)
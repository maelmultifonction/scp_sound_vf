local MODULE = GAS.Logging:MODULE()

MODULE.Category = "SCP Sound VF"
MODULE.Name     = "Diffusion de son"
MODULE.Colour   = Color(31,10,41)

MODULE:Setup(function()
	MODULE:Hook("SCPSOUNDVF:PlaySound", "SCPSNDVF:BLOGS:START",function(ply,arg)
		MODULE:Log(GAS.Logging:FormatPlayer(ply) .. " a lancé le son " .. GAS.Logging:Escape(arg))
	end)
end)

GAS.Logging:AddModule(MODULE)

--======================================================================================--

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "SCP Sound VF"
MODULE.Name     = "Arrêt d'un son"
MODULE.Colour   = Color(31,10,41)

MODULE:Setup(function()
	MODULE:Hook("SCPSOUNDVF:StopSounds", "SCPSNDVF:BLOGS:STOP",function(ply,arg)
		MODULE:Log(GAS.Logging:FormatPlayer(ply).." a stoppé un son.")
	end)
end)

GAS.Logging:AddModule(MODULE)

--======================================================================================--

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "SCP Sound VF"
MODULE.Name     = "Ajout d'un groupe d'accès"
MODULE.Colour   = Color(31,10,41)

MODULE:Setup(function()
	MODULE:Hook("SCPSOUNDVF:ADDGROUP", "SCPSNDVF:BLOGS:ADDGROUP",function(ply,arg)
		MODULE:Log(GAS.Logging:FormatPlayer(ply).." a ajouté le groupe " .. GAS.Logging:Escape(arg) .. " à la liste des groupes d'accès.")
	end)
end)

GAS.Logging:AddModule(MODULE)

--======================================================================================--

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "SCP Sound VF"
MODULE.Name     = "Retrait d'un groupe d'accès"
MODULE.Colour   = Color(31,10,41)

MODULE:Setup(function()
	MODULE:Hook("SCPSOUNDVF:REMOVEGROUP", "SCPSNDVF:BLOGS:REMOVEGROUP",function(ply,arg)
		MODULE:Log(GAS.Logging:FormatPlayer(ply).." a retiré le groupe " .. GAS.Logging:Escape(arg) .. " à la liste des groupes d'accès.")
	end)
end)

GAS.Logging:AddModule(MODULE)

--======================================================================================--

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "SCP Sound VF"
MODULE.Name     = "Ajout d'un son planifié"
MODULE.Colour   = Color(31,10,41)

MODULE:Setup(function()
	MODULE:Hook("SCPSOUNDVF:SHUDULE:ADD", "SCPSNDVF:BLOGS:ADDSHEDULE",function(ply,arg)
		MODULE:Log(GAS.Logging:FormatPlayer(ply).." a ajouté " .. GAS.Logging:Escape(arg) .. " à la liste des sons planifiés.")
	end)
end)

GAS.Logging:AddModule(MODULE)

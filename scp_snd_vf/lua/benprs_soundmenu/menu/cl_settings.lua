SCPSNDVF.PANEL = SCPSNDVF.PANEL or {}
SCPSNDVF.PANEL.SETTINGS = SCPSNDVF.PANEL.SETTINGS or {}
local RNDX = include("../func/cl_rndx.lua")
local RPExtraTeamsCache = {}

local function CacheEXTRATEAMS()
    if not DarkRP then return end 
    RPExtraTeamsCache = {}
    for _, v in pairs(RPExtraTeams) do
        RPExtraTeamsCache[v.name] = v
    end
end
hook.Add("InitPostEntity", "CacheEXTRATEAMS", CacheEXTRATEAMS)

local function toggleswitch(ts, parent, x, y, int)
    local animation_progress = 0
    local toggle_state = ts

    local toggle_button = vgui.Create("DButton", parent)
    toggle_button:SetSize(RW(60), RH(30))
    toggle_button:SetPos(RW(x), RH(y))
    toggle_button:SetText("")

    toggle_button.Paint = function(self, w, h)
        animation_progress = Lerp(FrameTime() * 10, animation_progress, toggle_state and 1 or 0)

        local bg_color = Color(Lerp(animation_progress, 196, 241), Lerp(animation_progress, 143, 150),Lerp(animation_progress, 74, 30))
        RNDX.Draw(28, 0, 0, w, h, bg_color )
        RNDX.Draw(h/2, Lerp(animation_progress, 0, w - h), 0, RW(31), h, color_white, RNDX.SHAPE_CIRCLE )
        
      --  RNDX.Draw(0, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond_txt"] )
    end

    toggle_button.DoClick = function()
        toggle_state = not toggle_state 

        net.Start("SCPSOUNDVF:SQL:CTS")
        net.WriteUInt(int,3)
        net.WriteBool(toggle_state)
        net.SendToServer()
    end
end

function SCPSNDVF.PANEL.SETTINGS.OpenSettingsMenu()

    net.Start("SCPSOUNDVF:SQL:STC")
        net.WriteString("BOUCLAGE")
        net.WriteString("PLANIFICATION")
    net.SendToServer()

    local scpsndvf_settings = vgui.Create("DFrame")
    scpsndvf_settings:SetSize(RW(590), RH(1000)) 
    scpsndvf_settings:ShowCloseButton(false)
    scpsndvf_settings:SetTitle("")
    scpsndvf_settings:SetDraggable(false)
    scpsndvf_settings:MakePopup()
    scpsndvf_settings:Center()


    SCPSNDVF.PANEL.MAIN:Hide()

    local function doubletext(posy, text1, text2, col)
        draw.SimpleText(text1, SCPSNDVF:Font("Poppins", 18, 90), RW(30),RH(posy), SCPSNDVF.CONFIG.COULEUR["blanc_fade"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.DrawText(text2, SCPSNDVF:Font("Poppins", 6, 60), RW(32),RH(posy+20), col or SCPSNDVF.CONFIG.COULEUR["blanc_fade"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) 
    end 

    scpsndvf_settings.Paint = function(self,w,h) 
        local clr =  SCPSNDVF.CONFIG.COULEUR["blanc_fade"]
        RNDX.Draw(16, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond"] )
        draw.SimpleText("PANEL DE GESTION", SCPSNDVF:Font("Poppins", 25, 90), w/2,RH(60), SCPSNDVF.CONFIG.COULEUR["blanc_fade"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("PERMISSIONS", SCPSNDVF:Font("Poppins", 25, 90), w/2,RH(450), SCPSNDVF.CONFIG.COULEUR["blanc_fade"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        doubletext(180, "BOUCLAGE", "Une fois que l'audio a atteint la fin, il redémarrera \nautomatiquement et continuera de jouer en boucle.")
        doubletext(290, "PLANIFICATION", "Active ou désactive la lecture automatique des sons. \nCela permet de gérer efficacement l'enchaînement des sons.")

        surface.SetDrawColor( SCPSNDVF.CONFIG.COULEUR["blanc_fade"])
        surface.DrawLine(RW(30), RH(400), RW(560), RH(400))

        draw.SimpleText("Version 2.1 | La lune noire hurle-t-elle ?", SCPSNDVF:Font("Poppins", 10, 5), w/2,RH(950), SCPSNDVF.CONFIG.COULEUR["blanc_fade"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end 

    scpsndvf_settings.OnClose = function() 
       SCPSNDVF.PANEL.MAIN:Show()
    end


    local grade = vgui.Create( "DTextEntry", scpsndvf_settings )
	grade:SetPos(RW(50),RH(480))
    grade:SetSize(RW(490), RH(30))
	grade:SetPlaceholderText( "ENTREZ LE GRADE ICI" )
	grade.OnEnter = function( self )
		net.Start("BENPRS:SCPSOUNDVF::SQL:ADD_GROUP")
        net.WriteString(self:GetText()) 
        net.SendToServer()

        scpsndvf_settings:Remove()
        SCPSNDVF.PANEL.SETTINGS.OpenSettingsMenu()

        notification.AddLegacy( "Groupe "..self:GetText().." ajouté avec succès.", NOTIFY_GENERIC, 5 )
	end
    

    local cursorAlpha, cursorDirection, cursorSpeed = 0, 1, 255 / 0.3

    function grade:Paint(w, h)
        local text = self:GetText()
        local hasFocus = self:HasFocus()

        if hasFocus then
            RNDX.DrawOutlined(32, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["accent"], 5 )
        end
        RNDX.Draw(32, 0+1, 0+1, w-2, h-2, SCPSNDVF.CONFIG.COULEUR["fond_txt"] )
        --

        if text == "" then
            draw.SimpleText("+", SCPSNDVF:Font("Poppins", 14, 90), RW(12), RH(17), SCPSNDVF.CONFIG.COULEUR["texte_btn"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(self:GetPlaceholderText(), SCPSNDVF:Font("Poppins", 12, 90), RW(40), RH(17), SCPSNDVF.CONFIG.COULEUR["texte_btn"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            self.textAlpha = self.textAlpha or 0
            local targetAlpha = text == "" and 0 or 50
            self.textAlpha = Lerp(FrameTime() * 0.9, self.textAlpha, targetAlpha)
            draw.SimpleText(text, SCPSNDVF:Font("Poppins", 12, 90), RW(10), RH(17), Color(255, 255, 255, self.textAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        if hasFocus then
            cursorAlpha = math.Clamp(cursorAlpha + (cursorDirection * cursorSpeed * FrameTime()), 0, 255)
            cursorDirection = (cursorAlpha == 0 and 1) or (cursorAlpha == 255 and -1) or cursorDirection

            local cursorX = RW(10) + surface.GetTextSize(text)
            local smoothCursorX = Lerp(FrameTime() * 30, self.smoothCursorX or cursorX, cursorX)
            self.smoothCursorX = smoothCursorX

            draw.SimpleText("|", SCPSNDVF:Font("Poppins", 12, 1), smoothCursorX, RH(17), ColorAlpha(SCPSNDVF.CONFIG.COULEUR["accent"], cursorAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
    
    dpanel = vgui.Create("DScrollPanel", scpsndvf_settings) 
    dpanel:SetSize(RW(490), RH(350))
    dpanel:SetPos(RW(50), RH(530))
    dpanel.Paint = function(self, w, h)
        RNDX.Draw(8, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond"] )
    end

    local sbar = dpanel:GetVBar()
    sbar:SetWide(8)
    function sbar:Paint(w, h)
    end
    function sbar.btnUp:Paint(w, h) end
    function sbar.btnDown:Paint(w, h) end
    function sbar.btnGrip:Paint(w, h)
        RNDX.Draw(4, 0, 0, w, h, Color(165,165,165) )
    end


    net.Receive("BENPRS:SCPSOUNDVF::SQL:SENDGRADES", function() 
        local nm = net.ReadString()
        local bool = net.ReadBool()
        local DButton = dpanel:Add("DButton")
        DButton:SetText(tostring(nm))
        DButton:Dock(TOP)
        DButton:DockMargin(0, 0, 0, 5)
        DButton:SetSize(0, RH(40))
        DButton:SetFont(SCPSNDVF:Font("Arial", 10, 30))
        
        local material = Material("materials/bsound_browser/icons/rectangle.png")
        local scrollOffset = 0

        function DButton:Paint(w, h)
            RNDX.Draw(8, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond_txt"] )
            draw.SimpleText("Accès", SCPSNDVF:Font("Poppins", 10, 30), RW(10), RH(20), SCPSNDVF.CONFIG.COULEUR["texte_btn"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(self:GetText(), SCPSNDVF:Font("Poppins", 9, 30), RW(245), RH(20), SCPSNDVF.CONFIG.COULEUR["texte_btn"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            local teamData = RPExtraTeamsCache[self:GetText()]
            local entryType = (DarkRP and teamData) and "Métier" or "Groupe"
            
            draw.SimpleText(entryType,  SCPSNDVF:Font("Poppins", 9, 30), RW(465), RH(20),  SCPSNDVF.CONFIG.COULEUR["texte_btn"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            draw.SimpleText(self:GetText(), SCPSNDVF:Font("Poppins", 9, 30), RW(245), RH(20), SCPSNDVF.CONFIG.COULEUR["texte_btn"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            --draw.SimpleText("SCP SOUND VF", SCPSNDVF:Font("Poppins", 9, 30), RW(465), RH(20), SCPSNDVF.CONFIG.COULEUR["texte_btn"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

            local hoverAlpha = self.hoverAlpha or 0
            local targetAlpha = self:IsHovered() and 80 or 0
            hoverAlpha = Lerp(FrameTime() * 10, hoverAlpha, targetAlpha)
            self.hoverAlpha = hoverAlpha

            if hoverAlpha > 0 then
                scrollOffset = (scrollOffset + FrameTime() * 50) % RW(60)
                for i = -1, math.ceil(w / RW(80)) + 1 do
                    RNDX.DrawMaterial(0, i * RW(60) - scrollOffset + RW(30), 0,RW(60), h, Color(255, 255, 255, hoverAlpha),material )
                end
            end
            
            return true
        end

        function DButton:DoClick()
            if self:GetText() == "superadmin" then  notification.AddLegacy( "Vous ne pouvez pas supprimer le grade 'superadmin'.", NOTIFY_ERROR, 5 ) return end

            net.Start("BENPRS:SCPSOUNDVF::SQL:REMOVE_GROUP")
            net.WriteString(self:GetText())
            net.SendToServer()

            self:Remove()
            notification.AddLegacy( "Groupe "..self:GetText().." supprimé avec succès.", NOTIFY_GENERIC, 5 )
        end
    end)


    local CROSS = vgui.Create("DButton", scpsndvf_settings)
    CROSS:SetSize(RW(102), RH(60))
    CROSS:SetPos(RW(500), RH(35))
    CROSS:SetText("×")
    CROSS:SetFont(SCPSNDVF:Font("Poppins", 50, 30))
    CROSS.Paint = nil 

    CROSS.Think = function(self,w,h)
        if self:IsHovered() then 
            self:SetColor(SCPSNDVF.CONFIG.COULEUR["accent"])
        else
            self:SetColor(SCPSNDVF.CONFIG.COULEUR["gris_clair"])
        end
    end

    CROSS.DoClick = function()
        scpsndvf_settings:Close()
    end

    local bouclage = nil 
    local planification = nil
    net.Receive("SCPSOUNDVF:SQL:STC", function() 
        bouclage = net.ReadBool()
        planification = net.ReadBool()
        toggleswitch(bouclage, scpsndvf_settings, 420, 155,1)
        toggleswitch(planification, scpsndvf_settings, 420, 260,2) 
    end)

end 

SCPSNDVF.PANEL = SCPSNDVF.PANEL or {}

local RNDX = include("../func/cl_rndx.lua")
local ply = LocalPlayer()

local function draw_button_left(frame, yPos, img, texte, func)
    local ALARMES = vgui.Create("DButton", frame)
    ALARMES:SetSize(RW(290), RH(55))
    ALARMES:SetPos(RW(0), yPos) 
    ALARMES:SetText("")
    ALARMES:SetFont(SCPSNDVF:Font("Poppins", 25, 30))

    local progression = 0
    local vitesse = 1500

    ALARMES.Paint = function(self, w, h)
        RNDX.DrawMaterial(0, RW(12), RH(15), RW(32), RH(32), color_white, img)

        local textSettings = {
            text = texte,
            font = SCPSNDVF:Font("Poppins", 16, 100),
            pos = {RW(60), h / 2 + RH(3)},
            color = SCPSNDVF.CONFIG.COULEUR["texte_btn"],
            xalign = TEXT_ALIGN_LEFT,
            yalign = TEXT_ALIGN_CENTER
        }

        draw.TextShadow(textSettings, 4, 40)

        local isHovered = self:IsHovered()
        local targetProgress = isHovered and w or 0

        progression = math.Approach(progression, targetProgress, vitesse * FrameTime())

        if (isHovered and progression < w) or (not isHovered and progression > 0) then
            RNDX.DrawMaterial(0,-20,0,progression,h, color_white, SCPSNDVF.CONFIG.MATERIALS["GRAD"])
        end

        if progression == w then
            RNDX.DrawMaterial(0,-20,0,w+40,h, color_white, SCPSNDVF.CONFIG.MATERIALS["GRAD"])
        end
    end

    ALARMES.Think = function(self)
        if self:IsHovered() then
            self:SetColor(SCPSNDVF.CONFIG.COULEUR["accent"])
        else
            self:SetColor(SCPSNDVF.CONFIG.COULEUR["gris_clair"])
        end
    end

    ALARMES.DoClick = func
end


net.Receive("BENPRS:SCPSOUNDVF::CLOPENMENU",  function()
    local category = "Autre"

    SCPSNDVF.PANEL.MAIN = vgui.Create("DFrame")
    SCPSNDVF.PANEL.MAIN:SetSize(0,0) 
    SCPSNDVF.PANEL.MAIN:ShowCloseButton(false)
    SCPSNDVF.PANEL.MAIN:SetTitle("")
    SCPSNDVF.PANEL.MAIN:SetSize(RW(1862), RH(988))
    SCPSNDVF.PANEL.MAIN:MakePopup()
    SCPSNDVF.PANEL.MAIN:Center()
    SCPSNDVF.PANEL.MAIN:SetDraggable(false)
    SCPSNDVF.PANEL.MAIN:SetKeyboardInputEnabled(true)
    hook.Add("OnPauseMenuShow", "BENPRS:SCPSOUNDVF::ECHAPCLOSE", function()
        SCPSNDVF.PANEL.MAIN:Close()
        hook.Remove("OnPauseMenuShow", "BENPRS:SCPSOUNDVF::ECHAPCLOSE")
	    return false
    end)

    SCPSNDVF.PANEL.MAIN.OnKeyCodePressed = function(self, key)
        if key == KEY_ESCAPE then
            self:Close()
        end
    end
    SCPSNDVF.PANEL.MAIN.Paint = function(self, w, h)
        RNDX.Draw(0, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond"])
        RNDX.Draw(1, 0, 0, w, RH(102), SCPSNDVF.CONFIG.COULEUR["fond_txt"])

        draw.SimpleTextColor(SCPSNDVF:Font("Poppins", 25, 30), RW(140), RH(60), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, Color(71,67,232), "SCP", color_white, " SOUNDS ", Color(247, 70,60), "VF")
        draw.SimpleText("LANCER DES SONS", SCPSNDVF:Font("Poppins", 9, 0), RW(20), RH(160), SCPSNDVF.CONFIG.COULEUR["blanc_fade"])
        draw.SimpleText("ADMINISTRATIF", SCPSNDVF:Font("Poppins", 9, 0), RW(20), RH(840), SCPSNDVF.CONFIG.COULEUR["blanc_fade"])

        RNDX.DrawMaterial(12, RW(20), RH(10), RW(90), RH(90), color_white, SCPSNDVF.CONFIG.MATERIALS["LOGO"])
    end


    local CROSS = vgui.Create("DButton", SCPSNDVF.PANEL.MAIN)
    CROSS:SetSize(RW(102), RH(60))
    CROSS:SetPos(RW(1750), RH(30))
    CROSS:SetText("×")
    CROSS:SetFont(SCPSNDVF:Font("Poppins", 50, 30))
    CROSS.Paint = nil 
    CROSS.fadeAlpha = 0
    CROSS.Think = function(self)
        local target = self:IsHovered() and 255 or 100
        self.fadeAlpha = Lerp(FrameTime() * 10, self.fadeAlpha or target, target)
        self:SetColor(ColorAlpha(SCPSNDVF.CONFIG.COULEUR["accent"], self.fadeAlpha))
    end
    CROSS.Paint = function(self, w, h)
        draw.SimpleText("×", self:GetFont(), w / 2, h / 2, ColorAlpha(SCPSNDVF.CONFIG.COULEUR["accent"], self.fadeAlpha or 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    CROSS.DoClick = function()
        local animationencours = true
        SCPSNDVF.PANEL.MAIN:SetMouseInputEnabled(false)
        SCPSNDVF.PANEL.MAIN:SetKeyBoardInputEnabled(false)
        SCPSNDVF.PANEL.MAIN:Close()
    end

    local refresh = vgui.Create("DButton", SCPSNDVF.PANEL.MAIN)
    refresh:SetSize(RW(55), RH(55))
    refresh:SetPos(RW(1710), RH(25))
    refresh:SetText("")
    refresh.DoClick = function()
        net.Start("BENPRS:SCPSOUNDVF::STOPSOUND")
        net.SendToServer()
    end
    refresh.fadeAlpha = 0
    refresh.Think = function(self)
        local target = self:IsHovered() and 255 or 0
        self.fadeAlpha = Lerp(FrameTime() * 10, self.fadeAlpha or target, target)
    end
    refresh.Paint = function(self, w, h)
        RNDX.DrawMaterial(0, 0, 0, w, h, color_white, SCPSNDVF.CONFIG.MATERIALS["MUTE"])
        if refresh.fadeAlpha > 0 then
            local accent = ColorAlpha(SCPSNDVF.CONFIG.COULEUR["accent"], refresh.fadeAlpha)
            RNDX.DrawMaterial(0, 0, 0, w, h, accent, SCPSNDVF.CONFIG.MATERIALS["MUTE"])
        end
    end

    local DPanel = vgui.Create("DPanel", SCPSNDVF.PANEL.MAIN)
    DPanel:SetPos(RW(310), RH(140))
    DPanel:SetSize(RW(1484), RH(807))
    DPanel.Paint = function(self, w, h)
        RNDX.Draw(24, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond_txt"])
    end

    local scrollPanel = vgui.Create("DScrollPanel", DPanel)
    scrollPanel:SetSize(DPanel:GetWide(), DPanel:GetTall())
    scrollPanel:SetPos(0, 0)

    local sbar = scrollPanel:GetVBar()
    sbar.Paint = function(w, h) end
    sbar.btnUp.Paint = function(w, h) end
    sbar.btnDown.Paint = function(w, h) end
    sbar.btnGrip.Paint = function(self, w, h)
        RNDX.Draw(0, w/2, 0, 2, h, SCPSNDVF.CONFIG.COULEUR["gris_clair"] )
    end


    local function soundplaybutton(title, _sound, posx, posy)
        local ALARMES = vgui.Create("DButton", scrollPanel)
        ALARMES:SetSize(RW(601), RH(89))
        ALARMES:SetPos(posx, posy)
        ALARMES:SetText("")
        ALARMES:SetFont(SCPSNDVF:Font("Poppins", 25, 30))

        local fadeAlpha = 100
        ALARMES.Paint = function(self, w, h)
            if self:IsHovered() then
                fadeAlpha = math.min(fadeAlpha + FrameTime() * 600, 255)
            else
                fadeAlpha = math.max(fadeAlpha - FrameTime() * 600, 100)
            end

            local color = Color(255, 255, 255, fadeAlpha)

            RNDX.Draw(12, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond"], RNDX.SHAPE_IOS)
            RNDX.DrawMaterial(32, RW(12), RH(15), RW(64), RH(64), color, SCPSNDVF.CONFIG.MATERIALS["VOLUME"], RNDX.SHAPE_IOS)

            local textSettings = {
                text = title,
                font = SCPSNDVF:Font("Poppins", 20, 100),
                pos = {RW(570), h / 2 + RH(3)},
                color = Color(255, 255, 255, 50),
                xalign = TEXT_ALIGN_RIGHT,
                yalign = TEXT_ALIGN_CENTER
            }
            
            draw.TextShadow(textSettings, 4, 40)
        end


        ALARMES.DoClick = function()
            net.Start("BENPRS:SCPSOUNDVF::STOPSOUND")
            net.SendToServer()

            net.Start("BENPRS:SCPSOUNDVF::LAUNCHSOUND")
            net.WriteString(_sound)
            net.SendToServer()
        end 
    end

    
    local searchBox = vgui.Create("DTextEntry", SCPSNDVF.PANEL.MAIN)
    searchBox:SetSize(RW(400), RH(40))
    searchBox:SetPos(RW(600), RH(35))
    searchBox:SetPlaceholderText("")
    searchBox:SetFont(SCPSNDVF:Font("Poppins", 18, 90))
    searchBox:SetTextColor(SCPSNDVF.CONFIG.COULEUR["texte_btn"])
    searchBox:SetDrawLanguageID(false)
    searchBox.OnChange = function(self)
        local searchText = self:GetValue():lower()
        scrollPanel:Clear()
        local posY = RH(15)
        local colonne = true
    
        for cat, data in pairs(SCPSNDVF.CONFIG.BUTTONS) do
            for _, command in ipairs(data.commands) do
                if command.title:lower():find(searchText, 1, true) then
                    local posX = colonne and RW(53) or RW(800)
                    soundplaybutton(command.title, command.sound, posX, posY)
    
                    colonne = not colonne
    
                    if colonne then
                        posY = posY + RH(120)
                    end
                end
            end
        end
    end

    searchBox.Paint = function(self, w, h)
        RNDX.Draw(0, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond"] )
        surface.SetDrawColor(SCPSNDVF.CONFIG.COULEUR["accent"])
        if self:GetValue() == "" then
            draw.SimpleText("RECHERCHER UN SON...", SCPSNDVF:Font("Poppins", 16, 100), RW(10), RH(25), SCPSNDVF.CONFIG.COULEUR["texte_btn"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        self:DrawTextEntryText(SCPSNDVF.CONFIG.COULEUR["texte_btn"], SCPSNDVF.CONFIG.COULEUR["accent"], SCPSNDVF.CONFIG.COULEUR["texte_btn"])
    end


    local function button_menu(cat)
        category = cat
        searchBox:SetValue("") -- Clear search box when switching categories
        scrollPanel:Clear()
        local posY = RH(15)
        local colonne = true
    
        if SCPSNDVF.CONFIG.BUTTONS[cat] then
            for _, command in ipairs(SCPSNDVF.CONFIG.BUTTONS[cat].commands) do
                local posX = colonne and RW(53) or RW(800)
                soundplaybutton(command.title, command.sound, posX, posY)
    
                colonne = not colonne
    
                if colonne then
                    posY = posY + RH(120)
                end
            end
        end
    end
    
    local lastCategory = cookie.GetString("SCPSNDVF_LastCategory", "Incidents")
    button_menu(lastCategory)

    SCPSNDVF.PANEL.MAIN.OnClose = function()
        cookie.Set("SCPSNDVF_LastCategory", category)
    end
    
    draw_button_left(SCPSNDVF.PANEL.MAIN, RH(200), SCPSNDVF.CONFIG.MATERIALS["INCIDENT"], "INCIDENTS", function()
        category = "Incidents"
        button_menu("Incidents")
    end)
    
    draw_button_left(SCPSNDVF.PANEL.MAIN, RH(250), SCPSNDVF.CONFIG.MATERIALS["RIFLE"], "FIM", function()
        category = "FIM"
        button_menu("FIM")
    end)
    
    draw_button_left(SCPSNDVF.PANEL.MAIN, RH(300), SCPSNDVF.CONFIG.MATERIALS["EXPLOSION"], "DÉCONFINEMENT", function()
        category = "Déconfinement"
        button_menu(category)
    end)
    
    draw_button_left(SCPSNDVF.PANEL.MAIN, RH(350), SCPSNDVF.CONFIG.MATERIALS["LOCK"], "RECONFINEMENT", function()
        category = "Reconfinement" 
        button_menu(category)
    end)
    
    draw_button_left(SCPSNDVF.PANEL.MAIN, RH(400), SCPSNDVF.CONFIG.MATERIALS["HANDCUFFS"], "CLASSE-D", function()
        category = "Classe-D" 
        button_menu(category) 
    end)

    draw_button_left(SCPSNDVF.PANEL.MAIN, RH(450), SCPSNDVF.CONFIG.MATERIALS["IRA"], "I.R.A", function()
        category = "initiatives de réponses automatisées" 
        button_menu(category)
    end)

    draw_button_left(SCPSNDVF.PANEL.MAIN, RH(500), SCPSNDVF.CONFIG.MATERIALS["ALARM"], "ALARMES", function()
        category = "Alarmes" 
        button_menu(category)
    end)

    draw_button_left(SCPSNDVF.PANEL.MAIN, RH(550), SCPSNDVF.CONFIG.MATERIALS["MORE"], "AUTRE", function()
        category = "Autre" 
        button_menu(category)
    end)
    
    draw_button_left(SCPSNDVF.PANEL.MAIN, RH(870), SCPSNDVF.CONFIG.MATERIALS["TIMER"], "PLANIFICATION", function()
        SCPSNDVF.PANEL.SETTINGS.OpenScheduleMenu()
    end)

    draw_button_left(SCPSNDVF.PANEL.MAIN, RH(920), SCPSNDVF.CONFIG.MATERIALS["BUILD"], "PARAMÈTRES", function()
        SCPSNDVF.PANEL.SETTINGS.OpenSettingsMenu() 
    end)

    
end)


hook.Add("OnPlayerChat", "SCPSNDVF_VolumeCommand", function(ply, text)
    local arg = string.match(text, "^!volume%s*(%d+)$")
    if arg then
        local vol = tonumber(arg)
        if vol and vol >= 0 and vol <= 100 then
            local cookieVal = tostring(vol / 100)
            cookie.Set("SCPSNDVF_Volume", cookieVal)
            chat.AddText(Color(93,92,156), "[SCP SOUND VF] ", color_white, "Volume réglé à " .. vol .. "%")
        else
            chat.AddText(Color(212, 115,110), "[SCP SOUND VF] ", color_white, "Utilisation: !volume [0-100]")
        end
        return true
    end
end)

function SCPSNDVF.GetSavedVolume()
    local v = tonumber(cookie.GetString("SCPSNDVF_Volume", "0.5"))
    return math.Clamp(v or 0.5, 0, 1)
end

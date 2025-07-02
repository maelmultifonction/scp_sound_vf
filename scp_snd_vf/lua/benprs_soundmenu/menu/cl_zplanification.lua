local RNDX = include("../func/cl_rndx.lua")

function SCPSNDVF.PANEL.SETTINGS.OpenScheduleMenu()
    SCPSNDVF.PANEL.MAIN:Hide()
    local scheduleMenu = vgui.Create("DFrame")
    scheduleMenu:SetSize(RW(590), RH(700))
    scheduleMenu:Center()
    scheduleMenu:MakePopup()
    scheduleMenu:SetTitle("")
    scheduleMenu:ShowCloseButton(false)
    scheduleMenu.Paint = function(self, w, h)
        RNDX.Draw(12, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond"])

        RNDX.Draw(12, RW(25), RH(18), RW(2), RH(60), SCPSNDVF.CONFIG.COULEUR["blanc_fade"])
        draw.SimpleText("Planification", SCPSNDVF:Font("Poppins", 26, 90), RW(30), RH(0), SCPSNDVF.CONFIG.COULEUR["blanc_fade"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Ajouter un son planifié", SCPSNDVF:Font("Poppins", 12, 90), RW(30), RH(50), SCPSNDVF.CONFIG.COULEUR["texte_btn"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    scheduleMenu.OnClose = function() 
       SCPSNDVF.PANEL.MAIN:Show()
    end
    local closeBtn = vgui.Create("DButton", scheduleMenu)
    closeBtn:SetSize(RW(40), RH(40))
    closeBtn:SetPos(RW(540), RH(30))
    closeBtn:SetText("")
    closeBtn:SetFont(SCPSNDVF:Font("Poppins", 30, 30))
    closeBtn.Paint = function(self, w, h)
        local color = self:IsHovered() and SCPSNDVF.CONFIG.COULEUR["accent"] or SCPSNDVF.CONFIG.COULEUR["texte_btn"]
        draw.SimpleText("×", self:GetFont(), w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    closeBtn.DoClick = function()
        scheduleMenu:Close()
    end

    local soundList = vgui.Create("DScrollPanel", scheduleMenu)
    soundList:SetSize(RW(520), RH(400))
    soundList:SetPos(RW(35), RH(100))

    net.Start("SCPSOUNDVF:SQL:FETCH_SCHEDULED")
    net.SendToServer()

    net.Receive("SCPSOUNDVF:SQL:SCHEDULED_DATA", function()
        local list = net.ReadTable()
        soundList:Clear()

        for _, data in pairs(list) do
            local pnl = soundList:Add("DPanel")
            pnl:SetTall(RH(40))
            pnl:Dock(TOP)
            pnl:DockMargin(0, 0, 0, 5)

            local material = Material("materials/bsound_browser/icons/rectangle.png")
            pnl.scrollOffset = 0

            pnl.Paint = function(self, w, h)
                RNDX.Draw(12, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond_txt"])
                draw.SimpleText(data.title, SCPSNDVF:Font("Poppins", 14, 400), RW(10), h / 2, SCPSNDVF.CONFIG.COULEUR["texte_btn"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(string.format("%02d:%02d", data.hour, data.minute), SCPSNDVF:Font("Poppins", 13, 500), w - RW(20), h / 2, SCPSNDVF.CONFIG.COULEUR["accent"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                self.hoverAlpha = self.hoverAlpha or 0
                local targetAlpha = self:IsHovered() and 80 or 0
                self.hoverAlpha = Lerp(FrameTime() * 10, self.hoverAlpha, targetAlpha)

                if self.hoverAlpha > 0 then
                    self.scrollOffset = (self.scrollOffset + FrameTime() * 50) % RW(60)
                    for i = -2, math.ceil(w / RW(80)) + 1 do
                        local x = i * RW(60) - self.scrollOffset + RW(60)
                        if x + RW(60) > 0 and x < w then
                            RNDX.DrawMaterial(0, x, 0, RW(60), h, Color(255, 255, 255, self.hoverAlpha), material)
                        end
                    end
                end
            end

            pnl.OnMousePressed = function(self, mcode)
                if mcode == MOUSE_LEFT then
                    net.Start("SCPSOUNDVF:SQL:REMOVE_SCHEDULED")
                    net.WriteUInt(data.id, 32)
                    net.SendToServer()

                    timer.Simple(0.1, function()
                        net.Start("SCPSOUNDVF:SQL:FETCH_SCHEDULED")
                        net.SendToServer()
                    end)
                end
            end
        end
    end)

    local titleEntry = vgui.Create("DTextEntry", scheduleMenu)
    titleEntry:SetSize(RW(520), RH(30))
    titleEntry:SetPos(RW(35), RH(500))
    titleEntry:SetDrawLanguageID(false)
    titleEntry:SetFont(SCPSNDVF:Font("Poppins", 16, 90))
    titleEntry.Paint = function(self, w, h)
        RNDX.Draw(8, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond_txt"])
        if self:GetText() == "" then
            draw.SimpleText("Entrez le titre du son", SCPSNDVF:Font("Poppins", 15, 90), RW(10), h / 2, SCPSNDVF.CONFIG.COULEUR["blanc_fade"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        self:DrawTextEntryText(SCPSNDVF.CONFIG.COULEUR["texte_btn"], SCPSNDVF.CONFIG.COULEUR["accent"], SCPSNDVF.CONFIG.COULEUR["texte_btn"])
    end


    local hourEntry = vgui.Create("DTextEntry", scheduleMenu)
    hourEntry:SetSize(RW(250), RH(30))
    hourEntry:SetPos(RW(35), RH(540))
    hourEntry:SetPlaceholderText("Heure (0-23)")
    hourEntry:SetDrawLanguageID(false)
    hourEntry:SetFont(SCPSNDVF:Font("Poppins", 16, 90))
    hourEntry.Paint = function(self, w, h)
        RNDX.Draw(0, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond_txt"] )
        surface.SetDrawColor(SCPSNDVF.CONFIG.COULEUR["accent"])
        if self:GetValue() == "" then
            draw.SimpleText("HEURE (0-23)", SCPSNDVF:Font("Poppins", 16, 100), RW(10), RH(18), SCPSNDVF.CONFIG.COULEUR["texte_btn"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        self:DrawTextEntryText(SCPSNDVF.CONFIG.COULEUR["texte_btn"], SCPSNDVF.CONFIG.COULEUR["accent"], SCPSNDVF.CONFIG.COULEUR["texte_btn"])
    end
    local minuteEntry = vgui.Create("DTextEntry", scheduleMenu)
    minuteEntry:SetSize(RW(250), RH(30))
    minuteEntry:SetPos(RW(305), RH(540))
    minuteEntry:SetPlaceholderText("Minute (0-59)")
    minuteEntry:SetDrawLanguageID(false)
    minuteEntry:SetFont(SCPSNDVF:Font("Poppins", 16, 90))
    minuteEntry.Paint = function(self, w, h)
        RNDX.Draw(0, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond_txt"] )
        surface.SetDrawColor(SCPSNDVF.CONFIG.COULEUR["accent"])
        if self:GetValue() == "" then
            draw.SimpleText("MINUTE (0-59)", SCPSNDVF:Font("Poppins", 16, 100), RW(10), RH(18), SCPSNDVF.CONFIG.COULEUR["texte_btn"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        self:DrawTextEntryText(SCPSNDVF.CONFIG.COULEUR["texte_btn"], SCPSNDVF.CONFIG.COULEUR["accent"], SCPSNDVF.CONFIG.COULEUR["texte_btn"])
    end

    local addButton = vgui.Create("DButton", scheduleMenu)
    addButton:SetSize(RW(520), RH(40))
    addButton:SetPos(RW(35), RH(580))
    addButton:SetText("")
    addButton:SetTextColor(SCPSNDVF.CONFIG.COULEUR["texte_btn"])
    addButton:SetFont(SCPSNDVF:Font("Poppins", 16, 90))
    addButton.DoClick = function()
        local title = titleEntry:GetText()
        local hour = tonumber(hourEntry:GetText()) or 0
        local minute = tonumber(minuteEntry:GetText()) or 0

        if title == "" then return end

        net.Start("SCPSOUNDVF:SQL:ADD_SCHEDULED")
        net.WriteString(title)
        net.WriteUInt(hour, 5)
        net.WriteUInt(minute, 6)
        net.SendToServer()

        net.Start("SCPSOUNDVF:SQL:FETCH_SCHEDULED")
        net.SendToServer()
    end
    addButton.Paint = function(self, w, h)
        local bgColor = self:IsDown() and SCPSNDVF.CONFIG.COULEUR["accent_hover"]
            or (self:IsHovered() and SCPSNDVF.CONFIG.COULEUR["accent"] or SCPSNDVF.CONFIG.COULEUR["fond_txt"])
        RNDX.Draw(8, 0, 0, w, h, bgColor)
        
        draw.SimpleText("+ AJOUTE A LA LISTE", SCPSNDVF:Font("Poppins", 16, 600), w / 2, h / 2, SCPSNDVF.CONFIG.COULEUR["texte_btn"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

end
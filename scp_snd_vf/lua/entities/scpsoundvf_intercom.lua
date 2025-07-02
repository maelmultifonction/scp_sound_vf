AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Système d'intercom"
ENT.Category = "SCP SOUND VF"
ENT.Spawnable = true

ENT.MaxDistance = 100

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/cod/bo1/interrogation_room/p_int_microphone.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:DropToFloor()
        local phys = self:GetPhysicsObject()

        if phys:IsValid() then
            phys:Wake()
        end

        self.TalkingPlayer = nil
        self.utilisation = false

        -- Timer qui vérifie la distance toutes les 0.5 secondes
        timer.Create("SCPSoundVF_IntercomCheck_" .. self:EntIndex(), 0.5, 0, function()
            if not IsValid(self) then return end

            if IsValid(self.TalkingPlayer) then
                local dist = self:GetPos():Distance(self.TalkingPlayer:GetPos())
                if dist > self.MaxDistance then
                    self:StopIntercom()
                end
            end
        end)
    end
end

function ENT:SpawnFunction(ply, tr)
    if not tr.Hit then return end

    local SpawnPos = tr.HitPos + tr.HitNormal

    local ent = ents.Create("scpsoundvf_intercom")
    ent:SetPos(SpawnPos)
    ent:SetAngles(ply:GetAngles() + Angle(0, -90, 0))
    ent:Spawn()
    ent:Activate()

    return ent
end

function ENT:Use(activator)
    if not activator:IsPlayer() then return end

    if self.TalkingPlayer == activator then
        if not self.utilisation then
            self.TalkingPlayer = nil
            if VoiceBox and VoiceBox.FX then
                activator:RemoveVoiceFX("PASystem")
            end

            net.Start("BENPRS:SCPSOUNDVF::INTERCOM_HUD")
            net.WriteBool(false)
            net.Broadcast()

            net.Start("BENPRS:SCPSOUNDVF::INTERCOM_HUD_SPEAK")
            net.WriteBool(false)
            net.Send(activator)
        end
    else
        if not self.utilisation then
            self.utilisation = true
            net.Start("BENPRS:SCPSOUNDVF::INTERCOM_HUD")
            net.WriteBool(true)
            net.Broadcast()

            net.Start("BENPRS:SCPSOUNDVF::INTERCOM_HUD_SPEAK")
            net.WriteBool(true)
            net.Send(activator)

            timer.Simple(2.5, function()
                if not IsValid(self) or not IsValid(activator) then return end
                self.utilisation = false
                self.TalkingPlayer = activator
                if VoiceBox and VoiceBox.FX then
                    activator:AddVoiceFX("PASystem")
                end
            end)
        end
    end
end

function ENT:StopIntercom()
    if not IsValid(self.TalkingPlayer) then return end

    if VoiceBox and VoiceBox.FX then
        self.TalkingPlayer:RemoveVoiceFX("PASystem")
    end

    net.Start("BENPRS:SCPSOUNDVF::INTERCOM_HUD")
    net.WriteBool(false)
    net.Broadcast()

    net.Start("BENPRS:SCPSOUNDVF::INTERCOM_HUD_SPEAK")
    net.WriteBool(false)
    net.Send(self.TalkingPlayer)

    self.TalkingPlayer = nil
    self.utilisation = false
end

function ENT:OnRemove()
    if SERVER then
        timer.Remove("SCPSoundVF_IntercomCheck_" .. self:EntIndex())

        if IsValid(self.TalkingPlayer) and VoiceBox and VoiceBox.FX then
            self.TalkingPlayer:RemoveVoiceFX("PASystem")
        end

        net.Start("BENPRS:SCPSOUNDVF::INTERCOM_HUD")
        net.WriteBool(false)
        net.Broadcast()

        net.Start("BENPRS:SCPSOUNDVF::INTERCOM_HUD_SPEAK")
        net.WriteBool(false)
        net.Broadcast()
    end
end

local function CanHearIntercom(listener, talker)
    for _, ent in ipairs(ents.FindByClass("scpsoundvf_intercom")) do
        if IsValid(ent.TalkingPlayer) and ent.TalkingPlayer == talker then
            return true, false
        end
    end
end
hook.Add("PlayerCanHearPlayersVoice", "SCPSoundVF_Intercom", CanHearIntercom)

hook.Add("PlayerDisconnected", "SCPSoundVF_IntercomDisconnect", function(ply)
    for _, ent in ipairs(ents.FindByClass("scpsoundvf_intercom")) do
        if IsValid(ent) and ent.TalkingPlayer == ply then
            ent:StopIntercom()
        end
    end
end)

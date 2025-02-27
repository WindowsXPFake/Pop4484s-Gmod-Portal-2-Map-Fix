AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Button"
ENT.Category = "Portal 2"
ENT.Spawnable = true

ENT.Delay = 1
ENT.istimer = false

ENT.Timing = false
ENT.ResetTime = 0

function ENT:Initialize()
    if CLIENT then return end
    self:SetModel("models/props/switch001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetUseType(SIMPLE_USE)
end

function ENT:KeyValue(k, v)
    if k == "OnPressed" or k == "OnButtonReset" then
        self:StoreOutput(k, v)
    end
    if k == "Delay" then
        self.Delay = tonumber(v)
    end
    if k == "istimer" then
        self.istimer = v
    end
end

function ENT:Use(activator)
    if self.Timing then return end
    self:ResetSequence( "down" )
    self:TriggerOutput("OnPressed",activator)
    self:EmitSound("buttons/button_synth_positive_01.wav")
    self.Timing = true
    self.ResetTime = CurTime() + self.Delay
end

function ENT:Think()
    self:OnCustomThink()
    if self.Timing and self.Delay >= 0 then
        if CurTime() > self.ResetTime then
            self:ResetSequence( "up" )
            self:EmitSound("buttons/button_synth_negative_02.wav")
            self:TriggerOutput("OnButtonReset",self)
            self.Timing = false
        end 
    end
end

ENT.AutomaticFrameAdvance = true
function ENT:OnCustomThink()
    self:NextThink(CurTime())
    return true
end
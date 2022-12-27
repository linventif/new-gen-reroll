AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(NGReroll.Config.ModelPath)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activator)
    if NGReroll.Config.Sound then
        self:EmitSound(NGReroll.Config.SoundPath)
    end
    net.Start("NGReroll")
    net.WriteString("open-npc")
    net.Send(activator)
end
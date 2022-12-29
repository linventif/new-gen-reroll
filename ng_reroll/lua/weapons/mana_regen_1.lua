if SERVER then
	AddCSLuaFile("mana_regen_1.lua")
end

SWEP.PrintName = "Mana Regen 1"
SWEP.Author = "Linventif"
SWEP.Category = "Linventif's Weapons"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

function SWEP:Initialize()
	self:SetNoDraw(true)
	self:SetHoldType("normal")
end

local function ManaRegen(ply)
	if SERVER then
		if ply:GetNWInt("NGMana") < ply:GetNWInt("NGMaxMana") then
			ply:SetNWInt("NGMana", ply:GetNWInt("NGMana") + 1)
		end
	end
end

local cooldown = 0

function SWEP:PrimaryAttack()
	if cooldown < CurTime() then
		cooldown = CurTime() + 2
		local mana = tonumber(self.Owner:GetNWInt("NGMana"))
		local maxMana = tonumber(self.Owner:GetNWInt("NGMaxMana"))
		if mana < maxMana then
			self.Owner:SetNWInt("NGMana", mana + 100)
		end
	end
end
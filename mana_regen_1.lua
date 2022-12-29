if SERVER then
	AddCSLuaFile("mana_regen_1.lua")
end

SWEP.PrintName = "Mana Regen 1"
SWEP.Author = "Linventif"
SWEP.Category = "Linventif's Weapons"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.2

function SWEP:Initialize()
	self:SetNoDraw(true)
	self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
	local mana = self.Owner:GetNWInt("NGMana")
	local mana_max = self.Owner:GetNWInt("NGManaMax")
	if mana < mana_max then
		self.Owner:SetMana(mana + 1)
	end
end
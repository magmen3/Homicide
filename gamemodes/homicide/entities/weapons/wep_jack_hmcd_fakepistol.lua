if SERVER then
	AddCSLuaFile()
else
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_fakepistol")
end

SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName = translate.weaponfakepistol
SWEP.Instructions = translate.weaponfakepistolDesc
SWEP.Slot = 5
SWEP.SlotPos = 3
SWEP.ViewModel = "models/weapons/homicide/c_fakepistol.mdl"
SWEP.Primary.Sound = ""
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Sound = ""
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.BarrelMustSmoke = false
SWEP.DeathDroppable = false
SWEP.CanAmmoShow = false
SWEP.ENT = "ent_jack_hmcd_fakepistol"
SWEP.DangerLevel = 70
SWEP.OneHanded = true
SWEP.Color = Color(25, 25, 25)

local vecfw = Vector(0, 0, 10)
function SWEP:PrimaryAttack()
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	if SERVER then
		local Fake = ents.Create(self.ENT)
		Fake.HmcdSpawned = self.HmcdSpawned
		Fake:SetPos(self:GetOwner():GetPos() + self:GetOwner():GetForward() + vecfw)
		Fake:Spawn()
		Fake:Activate()
		Fake:GetPhysicsObject():SetVelocity(self:GetOwner():GetVelocity())
		self:Remove()
	end
end

function SWEP:Reload()
end
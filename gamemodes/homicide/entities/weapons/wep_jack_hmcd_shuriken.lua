if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.Slot = 2
	SWEP.SlotPos = 1
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/jaanus/w_shuriken.mdl"
SWEP.WorldModel = "models/jaanus/w_shuriken.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_shuriken")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponShuriken
SWEP.Instructions = translate.weaponShurikenDesc
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.Poisonable = true
SWEP.CarryWeight = 300
SWEP.HoldType = "grenade"
SWEP.DownAmt = 10
SWEP.CommandDroppable = false

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.Thrown = false
	self.PrintName = translate.weaponShuriken
	self.Instructions = translate.weaponShurikenDesc
	self.DownAmt = 10
end

function SWEP:UseActivate()
	if self.Thrown then return end
	self:ThrowStar()
end

function SWEP:Deploy()
	if not IsFirstTimePredicted() then return end
	self.DownAmt = 10
	self.Thrown = false
	if SERVER then sound.Play("snd_jack_hmcd_knifedraw.wav", self:GetOwner():GetPos(), 55, math.random(100, 120)) end
	self:SetNextPrimaryFire(CurTime() + .5)
	return true
end

function SWEP:ThrowStar(force)
	if SERVER then self:GetOwner():SetLagCompensated(true) end
	self.Thrown = true
	self:GetOwner():ViewPunch(Angle(2, 0, 0))
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	if CLIENT then return end
	sound.Play("weapons/slam/throw.wav", self:GetPos(), 55, math.random(90, 110))
	local ent = ents.Create("ent_jack_hmcd_shuriken")
	ent.HmcdSpawned = self.HmcdSpawned
	ent:SetOwner(self:GetOwner())
	ent:SetPos(self:GetOwner():GetShootPos())
	local knife_ang = self:GetOwner():EyeAngles()
	knife_ang:RotateAroundAxis(knife_ang:Up(), -90)
	ent:SetAngles(knife_ang)
	ent.Poisoned = self.Poisoned
	ent.Thrown = true
	ent:Spawn()
	local phys = ent:GetPhysicsObject()
	phys:SetVelocity(self:GetOwner():GetVelocity() + self:GetOwner():GetAimVector() * 1500)
	phys:AddAngleVelocity(Vector(0, 0, 3500))
	timer.Simple(.2, function() if IsValid(self) then self:Remove() end end)
	if SERVER then self:GetOwner():SetLagCompensated(false) end
end

if CLIENT then
	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 8 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 8 or 0)

		--ang:RotateAroundAxis(ang:Right(),40)
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return pos + ang:Forward() * 20 + ang:Right() * 10 - ang:Up() * (7 + self.DownAmt), ang
	end

	function SWEP:DrawWorldModel()
		if GAMEMODE:ShouldDrawWeaponWorldModel(self) then self:DrawModel() end
	end
end
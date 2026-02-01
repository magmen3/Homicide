if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 2
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/jordfood/jtun.mdl"
SWEP.WorldModel = "models/jordfood/jtun.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_poisoncanister")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponPoisonCan
SWEP.Instructions = translate.weaponPoisonCanDesc
SWEP.DeathDroppable = false
SWEP.CommandDroppable = false
SWEP.HoldType = "slam"
SWEP.DownAmt = 8
SWEP.CommandDroppable = false

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.PrintName = translate.weaponPoisonCan
	self.Instructions = translate.weaponPoisonCanDesc
	self.DownAmt = 8
end

function SWEP:UseActivate()
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + 1)
	if CLIENT then return end
	local Can = ents.Create("ent_jack_hmcd_poisoncanister")
	Can:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 20)
	Can:SetOwner(self:GetOwner())
	Can.HmcdSpawned = self.HmcdSpawned
	Can:Spawn()
	Can:Activate()
	Can:GetPhysicsObject():SetVelocity(self:GetOwner():GetVelocity())
	self:GetOwner():LagCompensation(false)
	sound.Play("physics/metal/soda_can_impact_hard2.wav", Can:GetPos(), 55, math.random(70, 90))
	if SERVER then
		self:Remove()
	end
end

if CLIENT then
	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 8 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 8 or 0)

		local NewPos = pos + ang:Forward() * 10 - ang:Up() * (4 + self.DownAmt) + ang:Right() * 5
		ang:RotateAroundAxis(ang:Up(), 70)
		ang:RotateAroundAxis(ang:Forward(), 5)
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return NewPos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 4 - Ang:Up() * 0 + Ang:Right() * 1.5)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel("models/jordfood/jtun.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
		end
	end
end
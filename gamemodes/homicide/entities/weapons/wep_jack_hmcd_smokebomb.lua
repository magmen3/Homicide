if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.Slot = 5
	SWEP.SlotPos = 1
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/props_junk/jlare.mdl"
SWEP.WorldModel = "models/props_junk/jlare.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_smokebomb")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponSmokeBomb
SWEP.Instructions = translate.weaponSmokeBombDesc
SWEP.CarryWeight = 800
SWEP.HoldType = "normal"
SWEP.DownAmt = 10
SWEP.CommandDroppable = false

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.PrintName = translate.weaponSmokeBomb
	self.Instructions = translate.weaponSmokeBombDesc
	self.DownAmt = 10
end

function SWEP:UseActivate()
	self:SetNextPrimaryFire(CurTime() + 1)
	if CLIENT then return end
	local Bom = ents.Create("ent_jack_hmcd_smokebomb")
	Bom.HmcdSpawned = self.HmcdSpawned
	Bom:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 20)
	Bom:Spawn()
	Bom:Activate()
	Bom:GetPhysicsObject():SetVelocity(self:GetOwner():GetVelocity() + self:GetOwner():GetAimVector() * 300)
	sound.Play("snd_jack_hmcd_match.wav", self:GetPos(), 65, math.random(90, 110))
	sound.Play("weapons/slam/throw.wav", self:GetPos(), 65, math.random(90, 110))
	self:Remove()
end

if CLIENT then
	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 8 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 8 or 0)

		local NewPos = pos + ang:Forward() * 30 - ang:Up() * (12 + self.DownAmt) + ang:Right() * 10
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return NewPos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 4 - Ang:Up() * 2 + Ang:Right() * 1)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel("models/props_junk/jlare.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(.75, 0)
		end
	end
end
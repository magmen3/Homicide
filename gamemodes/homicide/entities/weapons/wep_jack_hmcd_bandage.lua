if SERVER then
	AddCSLuaFile()
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.PrintName = translate.weaponSmallBandage
SWEP.Instructions = translate.weaponBandageDesc
SWEP.ENT = "ent_jack_hmcd_bandage"
SWEP.CarryWeight = 300
SWEP.HoldType = "slam"
SWEP.AllowUseOthers = true

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.PrintName = translate.weaponSmallBandage
	self.Instructions = translate.weaponBandageDesc
end

function SWEP:UseActivate()
	if CLIENT then return end
	if self:GetOwner().Bleedout <= 0 then return end
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	sound.Play("snd_jack_hmcd_bandage.wav", self:GetOwner():GetShootPos(), 60, math.random(100, 110))
	self:GetOwner():ViewPunch(Angle(-10, 0, 0))
	self:GetOwner().Bleedout = math.Clamp(self:GetOwner().Bleedout - 20, 0, 1000)
	self:GetOwner():RemoveAllDecals()
	if SERVER then
		self:Remove()
	end
end

function SWEP:UseOthers(ply, pos)
	if IsValid(ply) and ply:IsPlayer() and (ply.Bleedout > 0) then
		sound.Play("snd_jack_hmcd_bandage.wav", pos, 60, math.random(100, 110))
		ply:ViewPunch(Angle(-10, 0, 0))
		ply.Bleedout = math.Clamp(ply.Bleedout - 30, 0, 1000)
		ply:RemoveAllDecals()
		if SERVER then
			self:Remove()
		end
	end
end

function SWEP:Think()
	if SERVER then
		local HoldType = "slam"
		if self:GetOwner():IsSprinting() then HoldType = "normal" end
		self:SetHoldType(HoldType)
	end
end

if CLIENT then
	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 0 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 20 or 0)

		pos = pos - ang:Up() * (self.DownAmt + 10) + ang:Forward() * 30 + ang:Right() * 7
		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Right(), -10)
		ang:RotateAroundAxis(ang:Forward(), -10)
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return pos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 3)
				Ang:RotateAroundAxis(Ang:Up(), 90)
				Ang:RotateAroundAxis(Ang:Right(), 90)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel(self.WorldModel)
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
		end
	end
end
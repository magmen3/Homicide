if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.Slot = 5
	SWEP.SlotPos = 2
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/weapons/w_models/w_jyringe_jroj.mdl"
SWEP.WorldModel = "models/weapons/w_models/w_jyringe_jroj.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_adrenaline")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponAdrenaline
SWEP.Instructions = translate.weaponAdrenalineDesc
SWEP.HoldType = "normal"
SWEP.DownAmt = 8

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.PrintName = translate.weaponAdrenaline
	self.Instructions = translate.weaponAdrenalineDesc
	self.DownAmt = 8
end

function SWEP:SetupDataTables()
end

function SWEP:UseActivate()
	if CLIENT then return end
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	sound.Play("snd_jack_hmcd_needleprick.wav", self:GetOwner():GetShootPos() + VectorRand(), 60, math.random(90, 110))
	sound.Play("snd_jack_hmcd_needleprick.wav", self:GetOwner():GetShootPos() + VectorRand(), 50, math.random(90, 110))
	sound.Play("snd_jack_hmcd_needleprick.wav", self:GetOwner():GetShootPos() + VectorRand(), 40, math.random(90, 110))
	local Ply, LifeID = self:GetOwner(), self:GetOwner().LifeID
	timer.Simple(GAMEMODE.Realism:GetBool() and 5 or 2, function()
		if IsValid(Ply) and Ply:Alive() then
			Ply:SetHighOnDrugs(true)
		end
	end)

	timer.Simple(22, function()
		if IsValid(Ply) and Ply:Alive() and (Ply.LifeID == LifeID) then
			Ply:SetHighOnDrugs(false)
		end
	end)
	if SERVER then
		self:Remove()
	end
end

if CLIENT then
	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 8 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 8 or 0)

		local NewPos = pos + ang:Forward() * 30 - ang:Up() * (8 + self.DownAmt) + ang:Right() * 10
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		ang:RotateAroundAxis(ang:Right(), 60)
		return NewPos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 6 - Ang:Up() * 2 + Ang:Right() * 1)
				Ang:RotateAroundAxis(Ang:Right(), -30)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel("models/weapons/w_models/w_jyringe_jroj.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(.5, 0)
		end
	end

	function SWEP:ViewModelDrawn()
	end
end
if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 4
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/w_models/weapons/w_eq_painpills.mdl"
SWEP.WorldModel = "models/w_models/weapons/w_eq_painpills.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_painpills")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponPills
SWEP.Instructions = translate.weaponPillsDesc
SWEP.ENT = "ent_jack_hmcd_painpills"
SWEP.DownAmt = 20
SWEP.CarryWeight = 200
SWEP.HoldType = "slam"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.DownAmt = 20
	self.PrintName = translate.weaponPills
	self.Instructions = translate.weaponPillsDesc
end

function SWEP:UseActivate()
	if CLIENT then return end
	if self:GetOwner():Health() > 99 then return end
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	sound.Play("snd_jack_hmcd_pillsuse.wav", self:GetOwner():GetShootPos(), 60, math.random(90, 110))
	self:GetOwner():ViewPunch(Angle(-30, 0, 0))
	local Boost = math.Clamp(self:GetOwner().PainBoost - CurTime(), 0, 1000)
	Boost = Boost + 40
	self:GetOwner().PainBoost = CurTime() + Boost
	net.Start("HMCD_PainBoost")
	net.WriteFloat(Boost)
	net.Send(self:GetOwner())
	if self.Poisoned then HMCD_Poison(self:GetOwner(), self.Poisoner) end
	if SERVER then
		self:Remove()
	end
end

if CLIENT then
	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 0 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 20 or 0)

		pos = pos - ang:Up() * (self.DownAmt + 11) + ang:Forward() * 25 + ang:Right() * 7
		ang:RotateAroundAxis(ang:Up(), -40)
		ang:RotateAroundAxis(ang:Right(), -10)
		ang:RotateAroundAxis(ang:Forward(), -10)
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return pos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 3.5 + Ang:Right() * 2 - Ang:Up() * -1)
				Ang:RotateAroundAxis(Ang:Right(), 180)
				--Ang:RotateAroundAxis(Ang:Right(),90)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel("models/w_models/weapons/w_eq_painpills.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			--self.DatWorldModel:SetModelScale(1,0)
		end
	end
end
if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 3
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/w_models/weapons/w_eq_medkit.mdl"
SWEP.WorldModel = "models/w_models/weapons/w_eq_medkit.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_medkit")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponMedkit
SWEP.Instructions = translate.weaponMedkitDesc
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.Weight = 3
SWEP.ENT = "ent_jack_hmcd_medkit"
SWEP.DownAmt = 20
SWEP.CarryWeight = 1800
SWEP.HoldType = "slam"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.DownAmt = 20
	self.PrintName = translate.weaponMedkit
	self.Instructions = translate.weaponMedkitDesc
end

function SWEP:UseActivate()
	if CLIENT then return end
	if (self:GetOwner().Bleedout <= 0) and (self:GetOwner():Health() > 99) then return end
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	sound.Play("snd_jack_hmcd_bandage.wav", self:GetOwner():GetShootPos(), 60, math.random(90, 110))
	self:GetOwner():ViewPunch(Angle(-10, 0, 0))
	self:GetOwner().Bleedout = math.Clamp(self:GetOwner().Bleedout - 50, 0, 1000)
	local Boost = math.Clamp(self:GetOwner().FoodBoost - CurTime(), 0, 1000)
	Boost = Boost + 90
	self:GetOwner().FoodBoost = CurTime() + Boost
	net.Start("HMCD_FoodBoost")
	net.WriteFloat(Boost)
	net.Send(self:GetOwner())
	local Boost2 = math.Clamp(self:GetOwner().PainBoost - CurTime(), 0, 1000)
	Boost2 = Boost2 + 90
	self:GetOwner().PainBoost = CurTime() + Boost2
	net.Start("HMCD_PainBoost")
	net.WriteFloat(Boost2)
	net.Send(self:GetOwner())
	self:GetOwner():SetHealth(math.Clamp(self:GetOwner():Health() + 1, 0, 100))
	self:GetOwner():RemoveAllDecals()
	if SERVER then
		self:Remove()
	end
end

function SWEP:UseOthers(ply, pos)
	if CLIENT then return end
	local ply, pos = HMCD_WhomILookinAt(self:GetOwner(), .3, 50)
	if IsValid(ply) and ply:IsPlayer() and ((ply.Bleedout > 0) or (ply:Health() < 100)) then
		sound.Play("snd_jack_hmcd_bandage.wav", pos, 60, math.random(90, 110))
		ply:ViewPunch(Angle(-10, 0, 0))
		ply.Bleedout = math.Clamp(ply.Bleedout - 70, 0, 1000)
		local Boost = math.Clamp(ply.FoodBoost - CurTime(), 0, 1000)
		Boost = Boost + 120
		ply.FoodBoost = CurTime() + Boost
		net.Start("HMCD_FoodBoost")
		net.WriteFloat(Boost)
		net.Send(ply)
		local Boost2 = math.Clamp(ply.PainBoost - CurTime(), 0, 1000)
		Boost2 = Boost2 + 120
		ply.PainBoost = CurTime() + Boost2
		net.Start("HMCD_PainBoost")
		net.WriteFloat(Boost2)
		net.Send(ply)
		ply:SetHealth(math.Clamp(ply:Health() + 5, 0, 100))
		ply:RemoveAllDecals()
		if SERVER then
			self:Remove()
		end
	end
end

if CLIENT then
	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 0 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 20 or 0)

		pos = pos - ang:Up() * (self.DownAmt + 8) + ang:Forward() * 25 + ang:Right() * 12
		ang:RotateAroundAxis(ang:Forward(), -90)
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
			self.DatWorldModel = ClientsideModel("models/w_models/weapons/w_eq_medkit.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
		end
	end
end
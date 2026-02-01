if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 3
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/Items/Flare.mdl"
SWEP.WorldModel = "models/Items/Flare.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_poisonliquid")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponPoisonLiq
SWEP.Instructions = translate.weaponPoisonLiqDesc
SWEP.HoldType = "normal"
SWEP.DownAmt = 10
SWEP.CommandDroppable = false

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.PrintName = translate.weaponPoisonLiq
	self.Instructions = translate.weaponPoisonLiqDesc
	self.DownAmt = 10
end

function SWEP:UseActivate()
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + 1)
	self:AttackFront()
end

function SWEP:AttackFront()
	if CLIENT then return end
	self:GetOwner():LagCompensation(true)
	local Ent, HitPos, HitNorm = HMCD_WhomILookinAt(self:GetOwner(), .2, 65)
	if IsValid(Ent) and (Ent.IsLoot or (Ent:GetClass() == "prop_physics") or (Ent:GetClass() == "prop_physics_mutiplayer")) then
		sound.Play("snd_jack_hmcd_needleprick.wav", self:GetOwner():GetShootPos(), 45, math.random(90, 110))
		sound.Play("snd_jack_hmcd_needleprick.wav", HitPos, 40, math.random(90, 110))
		self:GetOwner():ViewPunch(Angle(1, 0, 0))
		Ent.ContactPoisoned = true
		Ent.Poisoner = self:GetOwner()
		Ent.GameSpawned = false
		net.Start("hmcd_hudhalo")
		net.WriteEntity(Ent)
		net.WriteInt(3, 32)
		net.Send(self:GetOwner())
		self:Remove()
	else
		sound.Play("snd_jack_hmcd_tinyswish.wav", self:GetOwner():GetShootPos(), 45, math.random(90, 110))
	end

	self:GetOwner():LagCompensation(false)
end

if CLIENT then
	function SWEP:PreDrawViewModel(vm, ply, wep)
		vm:SetMaterial("debug/env_cubemap_model")
	end

	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 8 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 8 or 0)

		local NewPos = pos + ang:Forward() * 40 - ang:Up() * (18 + self.DownAmt) + ang:Right() * 15
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
			self.DatWorldModel = ClientsideModel("models/Items/Flare.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetMaterial("debug/env_cubemap_model")
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(.5, 0)
		end
	end
end
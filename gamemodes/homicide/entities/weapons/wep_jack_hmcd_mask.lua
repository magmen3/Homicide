if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.Slot = 5
	SWEP.SlotPos = 3
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/props_c17/SuitCase_Passenger_Physics.mdl"
SWEP.WorldModel = "models/props_c17/SuitCase_Passenger_Physics.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_mask")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponMask
SWEP.Instructions = translate.weaponMaskDesc
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.DownAmt = 20
SWEP.CommandDroppable = false
SWEP.DeathDroppable = false
SWEP.HoldType = "normal"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.DownAmt = 20
	self.PrintName = translate.weaponMask
	self.Instructions = translate.weaponMaskDesc
end

function SWEP:UseActivate()
	if SERVER then self:GetOwner():MurdererHideIdentity() end
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
	timer.Simple(.5, function()
		if IsValid(self) and SERVER then
			self:GetOwner():SelectWeapon("wep_jack_hmcd_knife")
		end
	end)
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end
	if self:GetOwner():IsSprinting() then return end
	if SERVER then self:GetOwner():MurdererShowIdentity() end
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
	timer.Simple(.5, function()
		if IsValid(self) and SERVER then
			self:GetOwner():SelectWeapon("wep_jack_hmcd_hands")
		end
	end)
end

if CLIENT then
	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 0 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 20 or 0)

		pos = pos - ang:Up() * (self.DownAmt + 8) + ang:Forward() * 45 + ang:Right() * 22
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		--ang:RotateAroundAxis(ang:Forward(),-90)
		return pos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 3)
				--Ang:RotateAroundAxis(Ang:Up(),90)
				Ang:RotateAroundAxis(Ang:Right(), 90)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel("models/props_c17/SuitCase_Passenger_Physics.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(.75, 0)
		end
	end
end
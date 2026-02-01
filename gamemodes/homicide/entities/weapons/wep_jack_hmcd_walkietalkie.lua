if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.Slot = 5
	SWEP.SlotPos = 3
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/sirgibs/ragdoll/css/terror_arctic_radio.mdl"
SWEP.WorldModel = "models/sirgibs/ragdoll/css/terror_arctic_radio.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_walkietalkie")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponWalkieTalkie
SWEP.Instructions = translate.weaponWalkieTalkieDesc
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.DeathDroppable = false
SWEP.ENT = "ent_jack_hmcd_walkietalkie"
SWEP.DownAmt = 20
SWEP.CarryWeight = 800
SWEP.CommandDroppable = true
SWEP.HoldType = "normal"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.DownAmt = 20
	self.PrintName = translate.weaponWalkieTalkie
	self.Instructions = translate.weaponWalkieTalkieDesc
end

function SWEP:UseActivate()
end

if CLIENT then
	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 0 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 20 or 0)

		pos = pos - ang:Up() * (self.DownAmt + 47) + ang:Forward() * 20 + ang:Right() * 5
		ang:RotateAroundAxis(ang:Up(), -90)
		--ang:RotateAroundAxis(ang:Right(),-10)
		--ang:RotateAroundAxis(ang:Forward(),-10)
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return pos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos - Ang:Up() * 50 - Ang:Right() * 8 + Ang:Forward() * 3)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel("models/sirgibs/ragdoll/css/terror_arctic_radio.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(1.25, 0)
		end
	end
end
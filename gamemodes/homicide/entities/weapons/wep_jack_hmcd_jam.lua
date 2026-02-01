if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.Slot = 5
	SWEP.SlotPos = 5
end

SWEP.ViewModel = "models/props_junk/wood_pallet001a_chunka1.mdl"
SWEP.WorldModel = "models/props_junk/wood_pallet001a_chunka1.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_jam")
	SWEP.BounceWeaponIcon = false
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.PrintName = translate.weaponJam
SWEP.Instructions = translate.weaponJamDesc
SWEP.ENT = "ent_jack_hmcd_jam"
SWEP.HoldType = "slam"
SWEP.AllowUseOthers = false

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.PrintName = translate.weaponJam
	self.Instructions = translate.weaponJamDesc
end

function SWEP:UseActivate()
	if CLIENT then return end
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	local Tr = util.QuickTrace(self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector() * 65, {self:GetOwner()})
	if Tr.Hit and Tr.Entity and HMCD_IsDoor(Tr.Entity) then
		local Doors = {Tr.Entity}
		for key, other in ipairs(ents.FindInSphere(Tr.HitPos, 65)) do
			if HMCD_IsDoor(other) then table.insert(Doors, other) end
		end

		local Block = ents.Create(self.ENT)
		Block.HmcdSpawned = self.HmcdSpawned
		Block:SetPos(Tr.HitPos + Tr.HitNormal * 5)
		local Ang = Tr.HitNormal:Angle()
		Ang:RotateAroundAxis(Ang:Up(), -90)
		Block:SetAngles(Ang)
		Block:Spawn()
		Block:Activate()
		Block:Block(Doors)
		if SERVER then
			self:Remove()
		end
	end
end

if CLIENT then
	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 0 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 20 or 0)

		pos = pos - ang:Up() * (self.DownAmt + 3) + ang:Forward() * 12 + ang:Right() * 6
		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Up(), 10)
		ang:RotateAroundAxis(ang:Forward(), -110)
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return pos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 4 + Ang:Right() * 2 - Ang:Up() * 2)
				Ang:RotateAroundAxis(Ang:Right(), 120)
				--Ang:RotateAroundAxis(Ang:Right(),90)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel(self.WorldModel)
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(.5, 0)
		end
	end
end
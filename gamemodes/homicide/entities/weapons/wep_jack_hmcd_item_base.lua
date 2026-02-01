if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 75
	SWEP.Slot = 3
	SWEP.SlotPos = 3
	function SWEP:DrawViewModel()
		return false
	end

	function SWEP:DrawWorldModel()
		self:DrawModel()
	end
end

SWEP.Base = "weapon_base_hmcd"
SWEP.ViewModel = "models/bandages.mdl"
SWEP.WorldModel = "models/bandages.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_bandage")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = "Item Base"
SWEP.Instructions = translate.weaponBandageDesc
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.Weight = 3
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.CommandDroppable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.ENT = "ent_jack_hmcd_bandage"
SWEP.HomicideSWEP = true
SWEP.CarryWeight = 300
SWEP.HoldType = "slam"
SWEP.AllowUseOthers = false
SWEP.DownAmt = 20
SWEP.DontRemove = false

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.DownAmt = 20
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	if self:GetOwner():IsSprinting() then return end

	self:UseActivate()
end

function SWEP:UseActivate()
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
end

function SWEP:Deploy()
	if not IsFirstTimePredicted() then return end
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
	self.DownAmt = 20
	return true
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end
	if not self.AllowUseOthers or self:GetOwner():IsSprinting() then return end
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	if SERVER then
		local Dude, Pos = HMCD_WhomILookinAt(self:GetOwner(), .3, 50)
		if IsValid(Dude) and Dude:IsPlayer() then
			self:UseOthers(Dude, Pos)
		end
	end
end

function SWEP:UseOthers(ply, pos)
end

function SWEP:Think()
	if SERVER then
		local HoldType = self.HoldType
		if self:GetOwner():IsSprinting() then HoldType = "normal" end
		self:SetHoldType(HoldType)
	end
end

function SWEP:Reload()
end

function SWEP:Holster()
	self:FixMats()
	return true
end

function SWEP:FixMats()
	local owner = self:GetOwner()
	if IsValid(owner) and CLIENT and owner:IsPlayer() then
		local vm = owner:GetViewModel()
		if IsValid(vm) then
			vm:SetMaterial("")
			vm:SetColor(color_white)
		end
	end
end

function SWEP:OnRemove()
	self:FixMats()
end

function SWEP:OnDrop()
	self:FixMats()
	if self.ENT and self.ENT ~= nil then
		local Ent = ents.Create(self.ENT)
		Ent.HmcdSpawned = self.HmcdSpawned
		Ent:SetPos(self:GetPos())
		Ent:SetAngles(self:GetAngles())
		Ent:Spawn()
		Ent:Activate()
		Ent:GetPhysicsObject():SetVelocity(self:GetVelocity() / 2)
	end
	self:Remove()
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
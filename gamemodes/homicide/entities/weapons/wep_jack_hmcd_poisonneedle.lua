if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 75
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	killicon.AddFont("wep_jack_hmcd_poisonneedle", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))
	function SWEP:DrawViewModel()
		return false
	end

	function SWEP:DrawWorldModel()
		self:DrawModel()
	end
end

SWEP.Base = "weapon_base"
SWEP.ViewModel = "models/weapons/w_models/w_jyringe_proj.mdl"
SWEP.WorldModel = "models/weapons/w_models/w_jyringe_proj.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_poisonneedle")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponPoisonNeedle
SWEP.Instructions = translate.weaponPoisonNeedleDesc
SWEP.BobScale = 2
SWEP.SwayScale = 2
SWEP.Weight = 3
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.Primary.Delay = 0.5
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Delay = 0.9
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.HomicideSWEP = true
function SWEP:Initialize()
	self:SetHoldType("normal")
	self.PrintName = translate.weaponPoisonNeedle
	self.Instructions = translate.weaponPoisonNeedleDesc
end

function SWEP:SetupDataTables()
end

--
function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	if self:GetOwner():IsSprinting() then return end
	self:SetNextPrimaryFire(CurTime() + 1)
	self:AttackFront()
end

function SWEP:Deploy()
	if not IsFirstTimePredicted() then return end
	self.DownAmt = 8
	self:SetNextPrimaryFire(CurTime() + 1)
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
end

--
function SWEP:SecondaryAttack()
end

--
function SWEP:Think()
end

--
function SWEP:AttackFront()
	if CLIENT then return end
	self:GetOwner():LagCompensation(true)
	local Ent, HitPos, HitNorm = HMCD_WhomILookinAt(self:GetOwner(), .2, 60)
	if IsValid(Ent) and Ent:IsPlayer() then
		if self:CanBackStab(Ent) then
			sound.Play("snd_jack_hmcd_needleprick.wav", self:GetOwner():GetShootPos(), 50, math.random(90, 110))
			sound.Play("snd_jack_hmcd_needleprick.wav", HitPos, 40, math.random(90, 110))
			self:GetOwner():ViewPunch(Angle(1, 0, 0))
			Ent:ViewPunch(Angle(-.05, 0, 0))
			-- covert poisoning FTW
			HMCD_Poison(Ent, self:GetOwner())
			self:Remove()
		else
			self:GetOwner():PrintMessage(HUD_PRINTCENTER, translate.weaponPoisonNeedleBehind)
		end
	else
		sound.Play("snd_jack_hmcd_tinyswish.wav", self:GetOwner():GetShootPos(), 50, math.random(90, 110))
	end

	self:GetOwner():LagCompensation(false)
end

function SWEP:Reload()
end

--
function SWEP:CanBackStab(ent)
	if not ent:IsPlayer() then return false end
	local TrueVec = (self:GetOwner():GetPos() - ent:GetPos()):GetNormalized()
	local LookVec = ent:GetAimVector()
	local Dot = LookVec:Dot(TrueVec)
	local ApproachAngle = -math.deg(math.asin(Dot)) + 90
	local RelSpeed = (ent:GetPhysicsObject():GetVelocity() - self:GetOwner():GetVelocity()):Length()
	if (ApproachAngle <= 120) or (RelSpeed > 100) then
		return false
	else
		return true
	end
end

if CLIENT then
	function SWEP:GetViewModelPosition(pos, ang)
		if not self.DownAmt then self.DownAmt = 8 end
		if self:GetOwner():IsSprinting() then
			self.DownAmt = math.Clamp(self.DownAmt + .1, 0, 8)
		else
			self.DownAmt = math.Clamp(self.DownAmt - .1, 0, 8)
		end

		local NewPos = pos + ang:Forward() * 30 - ang:Up() * (12 + self.DownAmt) + ang:Right() * 10
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
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
			self.DatWorldModel = ClientsideModel("models/weapons/w_models/w_jyringe_proj.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(.6, 0)
		end
	end

	function SWEP:ViewModelDrawn()
	end
	--
end
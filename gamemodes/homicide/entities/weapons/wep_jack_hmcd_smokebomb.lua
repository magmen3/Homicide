if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 75
	SWEP.Slot = 5
	SWEP.SlotPos = 1
	killicon.AddFont("wep_jack_hmcd_smokebomb", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))
	function SWEP:DrawViewModel()
		return false
	end

	function SWEP:DrawWorldModel()
		self:DrawModel()
	end
end

SWEP.Base = "weapon_base"
SWEP.ViewModel = "models/props_junk/jlare.mdl"
SWEP.WorldModel = "models/props_junk/jlare.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_smokebomb")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponSmokeBomb
SWEP.Instructions = translate.weaponSmokeBombDesc
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
SWEP.CarryWeight = 800
function SWEP:Initialize()
	self:SetHoldType("normal")
	self.PrintName = translate.weaponSmokeBomb
	self.Instructions = translate.weaponSmokeBombDesc
end

function SWEP:SetupDataTables()
end

--
function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	if self:GetOwner():IsSprinting() then return end
	self:SetNextPrimaryFire(CurTime() + 1)
	if CLIENT then return end
	local Bom = ents.Create("ent_jack_hmcd_smokebomb")
	Bom.HmcdSpawned = self.HmcdSpawned
	Bom:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 20)
	Bom:Spawn()
	Bom:Activate()
	Bom:GetPhysicsObject():SetVelocity(self:GetOwner():GetVelocity() + self:GetOwner():GetAimVector() * 300)
	sound.Play("snd_jack_hmcd_match.wav", self:GetPos(), 65, math.random(90, 110))
	sound.Play("weapons/slam/throw.wav", self:GetPos(), 65, math.random(90, 110))
	self:Remove()
end

function SWEP:Deploy()
	if not IsFirstTimePredicted() then return end
	self.DownAmt = 8
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
function SWEP:Reload()
end

--
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
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 4 - Ang:Up() * 2 + Ang:Right() * 1)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel("models/props_junk/jlare.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(.75, 0)
		end
	end

	function SWEP:ViewModelDrawn()
	end
	--
end
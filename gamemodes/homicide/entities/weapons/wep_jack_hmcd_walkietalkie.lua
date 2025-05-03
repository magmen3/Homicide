if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 75
	SWEP.Slot = 5
	SWEP.SlotPos = 3
	killicon.AddFont("wep_jack_hmcd_walkietalkie", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))
	function SWEP:DrawViewModel()
		return false
	end

	function SWEP:DrawWorldModel()
		self:DrawModel()
	end
end

SWEP.Base = "weapon_base"
SWEP.ViewModel = "models/sirgibs/ragdoll/css/terror_arctic_radio.mdl"
SWEP.WorldModel = "models/sirgibs/ragdoll/css/terror_arctic_radio.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_walkietalkie")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponWalkieTalkie
SWEP.Instructions = translate.weaponWalkieTalkieDesc
SWEP.BobScale = 3
SWEP.SwayScale = 3
SWEP.Weight = 3
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.CommandDroppable = false
SWEP.DeathDroppable = false
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
SWEP.ENT = "ent_jack_hmcd_walkietalkie"
SWEP.DownAmt = 0
SWEP.HomicideSWEP = true
SWEP.CarryWeight = 800
SWEP.CommandDroppable = true
function SWEP:Initialize()
	self:SetHoldType("normal")
	self.DownAmt = 20
	self.PrintName = translate.weaponWalkieTalkie
	self.Instructions = translate.weaponWalkieTalkieDesc
end

function SWEP:SetupDataTables()
end

--
function SWEP:PrimaryAttack()
end

--
function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime() + 1)
	self.DownAmt = 20
	return true
end

function SWEP:SecondaryAttack()
end

--
function SWEP:Think()
end

--
function SWEP:Reload()
end

--
function SWEP:OnDrop()
	local Ent = ents.Create(self.ENT)
	Ent.HmcdSpawned = self.HmcdSpawned
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	Ent:Spawn()
	Ent:Activate()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity() / 2)
	self:Remove()
end

if CLIENT then
	function SWEP:PreDrawViewModel(vm, ply, wep)
	end

	--
	function SWEP:GetViewModelPosition(pos, ang)
		if not self.DownAmt then self.DownAmt = 0 end
		if self:GetOwner():IsSprinting() then
			self.DownAmt = math.Clamp(self.DownAmt + .2, 0, 20)
		else
			self.DownAmt = math.Clamp(self.DownAmt - .2, 0, 20)
		end

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
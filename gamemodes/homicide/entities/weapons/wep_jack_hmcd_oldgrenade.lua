if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 75
	SWEP.Slot = 4
	SWEP.SlotPos = 2
	killicon.AddFont("wep_jack_hmcd_oldgrenade", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))
	function SWEP:DrawViewModel()
		return false
	end

	function SWEP:DrawWorldModel()
		self:DrawModel()
	end
end

SWEP.Base = "weapon_base"
SWEP.ViewModel = "models/weapons/v_jj_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_jj_fraggrenade.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_oldgrenade")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponGrenade
SWEP.Instructions = translate.weaponGrenadeDescDM
SWEP.BobScale = 3
SWEP.SwayScale = 3
SWEP.Weight = 3
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.ViewModelFlip = true
SWEP.Primary.Delay = 0.5
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Delay = 0.9
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.HomicideSWEP = true
SWEP.CommandDroppable = true
SWEP.CarryWeight = 1000
SWEP.DetTime = 0
SWEP.Armed = false
function SWEP:Initialize()
	self:SetHoldType("grenade")
	self.Thrown = false
	self.PrintName = translate.weaponGrenade
	self.Instructions = translate.weaponGrenadeDescDM
end

function SWEP:SetupDataTables()
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	if self:GetOwner():IsSprinting() then return end
	self:DoBFSAnimation("throw")
	self:GetOwner():GetViewModel():SetPlaybackRate(1.5)
	self:EmitSound("snd_jack_hmcd_throw.wav")
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:GetOwner():ViewPunch(Angle(-10, -5, 0))
	timer.Simple(.2, function() if IsValid(self) then self:GetOwner():ViewPunch(Angle(20, 10, 0)) end end)
	timer.Simple(.25, function() if IsValid(self) then self:ThrowGrenade() end end)
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:Deploy()
	if not IsFirstTimePredicted() then return end
	self.DownAmt = 10
	self:DoBFSAnimation("deploy")
	self:GetOwner():GetViewModel():SetPlaybackRate(.6)
	timer.Simple(1, function()
		if IsValid(self) and IsValid(self:GetOwner()) and IsValid(self:GetOwner():GetViewModel()) then
			self:DoBFSAnimation("pullpin")
			self:GetOwner():GetViewModel():SetPlaybackRate(.75)
			timer.Simple(.8, function() if IsValid(self) then self:EmitSound("snd_jack_hmcd_pinpull.wav") end end)
		end
	end)

	self:SetNextPrimaryFire(CurTime() + 2.5)
	self:SetNextSecondaryFire(CurTime() + 2.5)
	return true
end

function SWEP:ThrowGrenade()
	if CLIENT then return end
	self:GetOwner():SetLagCompensated(true)
	local Grenade = ents.Create("ent_jack_hmcd_oldgrenade")
	Grenade.HmcdSpawned = self.HmcdSpawned
	Grenade:SetAngles(VectorRand():Angle())
	Grenade:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 20)
	Grenade:SetOwner(self:GetOwner())
	Grenade:Spawn()
	Grenade:Activate()
	Grenade.Armed = self.Armed
	Grenade.DetTime = self.DetTime
	Grenade:GetPhysicsObject():SetVelocity(self:GetOwner():GetVelocity() + self:GetOwner():GetAimVector() * 1000)
	Grenade:Arm()
	self:GetOwner():SetLagCompensated(false)
	timer.Simple(.1, function() if IsValid(self) then self:Remove() end end)
end

function SWEP:RigGrenade()
	if CLIENT then return end
	if self.Armed then return end
	self:GetOwner():SetLagCompensated(true)
	local Tr = util.QuickTrace(self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector() * 65, {self:GetOwner()})
	if Tr.Hit then
		local Grenade = ents.Create("ent_jack_hmcd_oldgrenade")
		Grenade.HmcdSpawned = self.HmcdSpawned
		Grenade:SetAngles(Tr.HitNormal:Angle())
		Grenade:SetPos(Tr.HitPos + Tr.HitNormal * 2)
		Grenade:SetOwner(self:GetOwner())
		Grenade.Rigged = true
		Grenade:Spawn()
		Grenade:Activate()
		sound.Play("snd_jack_hmcd_click.wav", Tr.HitPos, 60, 100)
		Grenade.Constraint = constraint.Weld(Grenade, Tr.Entity, 0, 0, 300, true, false)
		sound.Play("snd_jack_hmcd_detonator.wav", Tr.HitPos, 60, 100)
		local Ply = self:GetOwner()
		timer.Simple(.3, function()
			net.Start("hmcd_hudhalo")
			net.WriteEntity(Grenade)
			net.WriteInt(4, 32)
			net.Send(Ply)
		end)

		timer.Simple(.2, function() if IsValid(self) then self:Remove() end end)
	end

	self:GetOwner():SetLagCompensated(false)
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end
	if self:GetOwner():IsSprinting() then return end
	self:RigGrenade()
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:Think()
	if SERVER then
		local HoldType = "grenade"
		if self:GetOwner():IsSprinting() then HoldType = "normal" end
		self:SetHoldType(HoldType)
		if self.Armed and (self.DetTime < CurTime()) then self:Detonate() end
	end
end

function SWEP:Detonate()
	self:GetOwner():SetLagCompensated(true)
	local Grenade = ents.Create("ent_jack_hmcd_oldgrenade")
	Grenade.HmcdSpawned = self.HmcdSpawned
	Grenade:SetAngles(VectorRand():Angle())
	Grenade:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 20)
	Grenade:SetOwner(self:GetOwner())
	Grenade:Spawn()
	Grenade:Activate()
	Grenade:Detonate()
	self:Remove()
	self:GetOwner():SetLagCompensated(false)
end

local clr_spoon = Color(50, 40, 0)
function SWEP:Reload()
	if not GAMEMODE.Realism:GetBool() then return end
	if CLIENT then return end
	local owner = self:GetOwner()
	if self.Armed then return end
	if self:GetNextPrimaryFire() > CurTime() then return end
	owner:SetLagCompensated(true)
	if IsValid(self) then
		sound.Play("snd_jack_hmcd_spoonfling.wav", owner:GetPos(), 65, 100)
		local Spoon = ents.Create("prop_physics")
		Spoon.HmcdSpawned = self.HmcdSpawned -- owner.HmcdSpawned
		Spoon:SetModel("models/shells/shell_gndspoon.mdl")
		Spoon:SetPos(owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand")))
		Spoon:SetAngles(owner:GetAngles())
		Spoon:SetMaterial("models/shiny")
		Spoon:SetColor(clr_spoon)
		Spoon:Spawn()
		Spoon:Activate()
		Spoon:GetPhysicsObject():AddAngleVelocity(VectorRand() * 100)
		Spoon:GetPhysicsObject():SetVelocity(owner:GetPhysicsObject():GetVelocity() + Vector(0, 0, 150) + owner:GetAimVector() * 150)
	end

	self.Armed = true
	self.DetTime = CurTime() + math.random(3, 4)
	owner:SetLagCompensated(false)
end

function SWEP:Holster(wep)
	if self.Armed then
		return false
	else
		return true
	end
end

function SWEP:DoBFSAnimation(anim)
	if self:GetOwner() and self:GetOwner().GetViewModel then
		local vm = self:GetOwner():GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	end
end

function SWEP:FireAnimationEvent(pos, ang, event, name)
	return true
end

if CLIENT then
	function SWEP:DrawWorldModel()
		if GAMEMODE:ShouldDrawWeaponWorldModel(self) then self:DrawModel() end
	end
end
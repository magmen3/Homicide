if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 75
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	killicon.AddFont("wep_jack_hmcd_baseballbat", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))
	function SWEP:DrawViewModel()
		return false
	end

	function SWEP:DrawWorldModel()
		self:DrawModel()
	end
end

SWEP.Base = "weapon_base"
SWEP.ViewModel = "models/weapons/v_knije_t.mdl"
SWEP.WorldModel = "models/weapons/w_knije_t.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_baseballbat")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponBaseballBat
SWEP.Instructions = translate.weaponBaseballBatDesc
SWEP.BobScale = 3
SWEP.SwayScale = 3
SWEP.Weight = 3
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.CommandDroppable = true
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
SWEP.ENT = "ent_jack_hmcd_baseballbat"
SWEP.NoHolster = true
SWEP.DeathDroppable = true
SWEP.HomicideSWEP = true
SWEP.CarryWeight = 3000
function SWEP:Initialize()
	self:SetHoldType("melee2")
	self:SetWindUp(0)
	self.NextWindThink = CurTime()
	self.PrintName = translate.weaponBaseballBat
	self.Instructions = translate.weaponBaseballBatDesc
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "WindUp")
end

function SWEP:PrimaryAttack()
	--for i=0,10 do PrintTable(self:GetOwner():GetViewModel():GetAnimInfo(i)) end
	if self:GetOwner().Stamina < 25 then return end
	if self:GetOwner():IsSprinting() then return end
	if not IsFirstTimePredicted() then
		timer.Simple(.2, function() if IsValid(self) then self:DoBFSAnimation("stab") end end)
		return
	end

	sound.Play("snd_jack_hmcd_tinyswish", self:GetOwner():GetShootPos(), 60, math.random(80, 90))
	self:SetWindUp(1)
	self:DoBFSAnimation("idle")
	self:SetNextPrimaryFire(CurTime() + 1.25)
	self:GetOwner():ViewPunch(Angle(0, -10, 0))
	timer.Simple(.1, function() if IsValid(self) then self:GetOwner():SetAnimation(PLAYER_ATTACK1) end end)
	timer.Simple(.2, function()
		if IsValid(self) then
			self:DoBFSAnimation("stab")
			timer.Simple(.1, function() if IsValid(self) then self:AttackFront() end end)
		end
	end)
end

function SWEP:Deploy()
	if not IsFirstTimePredicted() then
		self:DoBFSAnimation("draw")
		self:GetOwner():GetViewModel():SetPlaybackRate(.1)
		return
	end

	self:DoBFSAnimation("draw")
	self:GetOwner():GetViewModel():SetPlaybackRate(.25)
	if SERVER then sound.Play("Wood_Plank.ImpactSoft", self:GetPos(), 65, math.random(90, 110)) end
	return true
end

function SWEP:SecondaryAttack()
end

--
function SWEP:Think()
	local Time = CurTime()
	if self.NextWindThink < Time then
		self.NextWindThink = Time + .05
		self:SetWindUp(math.Clamp(self:GetWindUp() - .1, 0, 1))
	end
end

function SWEP:AttackFront()
	if CLIENT then return end
	self:GetOwner():ViewPunch(Angle(0, 20, 0))
	self:GetOwner():LagCompensation(true)
	HMCD_StaminaPenalize(self:GetOwner(), 20)
	local Ent, HitPos, HitNorm = HMCD_WhomILookinAt(self:GetOwner(), .4, 70)
	local AimVec, Mul = self:GetOwner():GetAimVector(), 1
	sound.Play("weapons/iceaxe/iceaxe_swing1.wav", self:GetOwner():GetShootPos(), 65, math.random(60, 70))
	if IsValid(Ent) or (Ent and Ent.IsWorld and Ent:IsWorld()) then
		local SelfForce = 150
		if self:IsEntSoft(Ent) then
			sound.Play("Flesh.ImpactHard", HitPos + vector_up, 65, math.random(90, 110))
			SelfForce = 30
			sound.Play("Flesh.ImpactHard", HitPos, 65, math.random(90, 110))
			sound.Play("Flesh.ImpactHard", HitPos - vector_up, 65, math.random(90, 110))
		else
			sound.Play("Wood_Plank.ImpactHard", HitPos, 65, math.random(90, 110))
			sound.Play("Wood_Plank.ImpactHard", HitPos - vector_up, 65, math.random(90, 110))
		end

		sound.Play("Wood_Plank.ImpactSoft", HitPos, 65, math.random(90, 110))
		local DamageAmt = math.random(20, 25)
		local Dam = DamageInfo()
		Dam:SetAttacker(self:GetOwner())
		Dam:SetInflictor(self)
		Dam:SetDamage(DamageAmt * Mul)
		Dam:SetDamageForce(AimVec * Mul / 5)
		Dam:SetDamageType(DMG_CLUB)
		Dam:SetDamagePosition(HitPos)
		Ent:TakeDamageInfo(Dam)
		local Phys = Ent:GetPhysicsObject()
		if IsValid(Phys) then
			if Ent:IsPlayer() then Ent:SetVelocity(AimVec * SelfForce / 10) end
			Phys:ApplyForceOffset(AimVec * 15000 * Mul, HitPos)
			Ent:SetPhysicsAttacker(self:GetOwner(), 3)
			self:GetOwner():SetVelocity(-AimVec * SelfForce / 10)
		end

		if Ent:GetClass() == "func_breakable_surf" and math.random(1, 2) == 2 then Ent:Fire("break", "", 0) end
	end

	self:GetOwner():LagCompensation(false)
end

function SWEP:Reload()
end

--
function SWEP:DoBFSAnimation(anim)
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
end

function SWEP:IsEntSoft(ent)
	return ent:IsNPC() or ent:IsPlayer() or (ent:GetClass() == "prop_ragdoll")
end

function SWEP:Holster()
	return true
end

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
	local DownAmt = 0
	function SWEP:GetViewModelPosition(pos, ang)
		if self:GetOwner():IsSprinting() then
			DownAmt = math.Clamp(DownAmt + .6, 0, 50)
		else
			DownAmt = math.Clamp(DownAmt - .6, 0, 50)
		end

		ang:RotateAroundAxis(ang:Forward(), 10)
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return pos + ang:Up() * 0 - ang:Forward() * (DownAmt - 10) - ang:Up() * DownAmt + ang:Right() * (3 + self:GetWindUp() * 5), ang
	end

	function SWEP:DrawWorldModel()
		if GAMEMODE:ShouldDrawWeaponWorldModel(self) then self:DrawModel() end
	end
end
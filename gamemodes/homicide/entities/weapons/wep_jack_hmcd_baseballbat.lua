if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 75
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	function SWEP:DrawViewModel()
		return false
	end

	function SWEP:DrawWorldModel()
		self:DrawModel()
	end
end

SWEP.Base = "weapon_base_hmcd"
SWEP.ViewModel = "models/weapons/homicide/c_baseballbat.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_knije_t.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_baseballbat")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponBaseballBat
SWEP.Instructions = translate.weaponBaseballBatDesc
SWEP.BobScale = 0
SWEP.SwayScale = 0
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
SWEP.DangerLevel = 65
SWEP.DownAmt = 100

function SWEP:Initialize()
	self:SetHoldType("melee2")
	self:SetWindUp(0)
	self.NextWindThink = CurTime()
	self.PrintName = translate.weaponBaseballBat
	self.Instructions = translate.weaponBaseballBatDesc
	self.DownAmt = 100
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
	self:GetOwner():ViewPunch(Angle(0, -30, 0))
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
	self:GetOwner():GetViewModel():SetPlaybackRate(.35)
	if SERVER then sound.Play("Wood_Plank.ImpactSoft", self:GetPos(), 65, math.random(90, 110)) end
	self.DownAmt = 100
	return true
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
	local Time = CurTime()
	if self.NextWindThink < Time then
		self.NextWindThink = Time + .05
		self:SetWindUp(math.Clamp(self:GetWindUp() - .1, 0, 1))
	end
end

function SWEP:AttackFront()
	if CLIENT then return end
	self:GetOwner():ViewPunch(Angle(0, 40, 0))
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

function SWEP:DoBFSAnimation(anim)
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
end

function SWEP:IsEntSoft(ent)
	return ent:IsNPC() or ent:IsPlayer() or (ent:GetClass() == "prop_ragdoll")
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
	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 100 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 50 or 0)

		ang:RotateAroundAxis(ang:Forward(), 10)
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return pos + ang:Up() * 0 - ang:Forward() * 0.5 * (self.DownAmt - 10) - ang:Up() * self.DownAmt + ang:Right() * (-3 + self:GetWindUp() * 5), ang
	end

	local vechands, vecfull, vecshit = Vector(0.75, 0.75, 0.75), Vector(1, 1, 1), Vector(-10, 0, -10)
	local hidebones = {
		["ValveBiped.Bip01_L_UpperArm"] = true,
		["ValveBiped.Bip01_R_UpperArm"] = true
	}
	local shitbones = {
		["ValveBiped.Bip01_R_Hand"] = Angle(0, 0, 180),
		["ValveBiped.Bip01_R_Forearm"] = Angle(-9, 12, 180)
	}
	function SWEP:PreDrawViewModel(vm, ply, wep)
		if IsValid(vm) and IsValid(ply) then
			for i = 0, vm:GetBoneCount() do
				if string.find(vm:GetBoneName(i), "ValveBiped") then
					local matrix = vm:GetBoneMatrix(i)
					if matrix then
						matrix:SetScale(vechands)
						vm:SetBoneMatrix(i, matrix)
					end
					if hidebones[vm:GetBoneName(i)] then
						local matrix = vm:GetBoneMatrix(i)
						if matrix then
							matrix:Zero()
							matrix:SetTranslation(vm:LocalToWorld(vecshit))
							vm:SetBoneMatrix(i, matrix)
						end
					end
					if shitbones[vm:GetBoneName(i)] then
						local matrix = vm:GetBoneMatrix(i)
						if matrix then
							matrix:SetAngles(vm:LocalToWorldAngles(shitbones[vm:GetBoneName(i)]))
							vm:SetBoneMatrix(i, matrix)
						end
					end
				end
			end
		end
	end

	function SWEP:Holster()
		local ply = self:GetOwner()
		if IsValid(ply) then
			local vm = ply:GetViewModel()
			if IsValid(vm) then
				for i = 0, vm:GetBoneCount() do
					if vm:GetBoneName(i) == "__INVALIDBONE__" then
						continue
					end
					local matrix = vm:GetBoneMatrix(i)
					if matrix then
						matrix:SetScale(vecfull)
						matrix:SetAngles(angle_zero)
						vm:SetBoneMatrix(i, matrix)
					end
				end
				vm:SetSubMaterial()
			end
		end

		return true
	end

	function SWEP:DrawWorldModel()
		if GAMEMODE:ShouldDrawWeaponWorldModel(self) then self:DrawModel() end
	end
end
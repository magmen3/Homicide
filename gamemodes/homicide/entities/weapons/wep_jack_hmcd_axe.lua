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
SWEP.ViewModel = "models/weapons/homicide/c_axe.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/props/cs_militia/axe.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_axe")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponAxe
SWEP.Instructions = translate.weaponAxeDesc
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
SWEP.ENT = "ent_jack_hmcd_axe"
SWEP.NoHolster = true
SWEP.DeathDroppable = true
SWEP.HomicideSWEP = true
SWEP.Poisonable = true
SWEP.CarryWeight = 4000
SWEP.DownAmt = 100
function SWEP:Initialize()
	self:SetHoldType("melee2")
	self:SetWindUp(0)
	self.NextWindThink = CurTime()
	self.PrintName = translate.weaponAxe
	self.Instructions = translate.weaponAxeDesc
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
	self:GetOwner():ViewPunch(Angle(0, -25, 0))
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
	self:SetNextPrimaryFire(CurTime() + .5)
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
	self:GetOwner():ViewPunch(Angle(0, 45, 0))
	self:GetOwner():LagCompensation(true)
	HMCD_StaminaPenalize(self:GetOwner(), 20)
	local Ent, HitPos, HitNorm = HMCD_WhomILookinAt(self:GetOwner(), .5, 80)
	local AimVec, Mul = self:GetOwner():GetAimVector(), 1
	sound.Play("weapons/iceaxe/iceaxe_swing1.wav", self:GetOwner():GetShootPos(), 65, math.random(60, 70))
	if IsValid(Ent) or (Ent and Ent.IsWorld and Ent:IsWorld()) then
		local SelfForce = 150
		if self:IsEntSoft(Ent) then
			if self.Poisoned and Ent:IsPlayer() then
				HMCD_Poison(Ent, self:GetOwner())
				self.Poisoned = false
			end

			sound.Play("Flesh.ImpactHard", HitPos + vector_up, 65, math.random(90, 110))
			SelfForce = 30
			local Pi = math.random(90, 110)
			sound.Play("snd_jack_hmcd_axehit.wav", HitPos, 65, Pi)
			sound.Play("snd_jack_hmcd_axehit.wav", HitPos - vector_up, 65, Pi)
			sound.Play("Canister.ImpactHard", HitPos, 65, math.random(90, 110))
			util.Decal("Blood", HitPos + HitNorm, HitPos - HitNorm)
			local edata = EffectData()
			edata:SetStart(self:GetOwner():GetShootPos())
			edata:SetOrigin(HitPos)
			edata:SetNormal(HitNorm)
			edata:SetEntity(Ent)
			util.Effect("BloodImpact", edata, true, true)
			timer.Simple(.05, function()
				if IsValid(self) then
					for i = 1, 10 do
						local BloodTr = util.QuickTrace(HitPos - AimVec * 10, AimVec * 100 + VectorRand() * 25, {self, self:GetOwner()})
						if BloodTr.Hit then util.Decal("Blood", BloodTr.HitPos + BloodTr.HitNormal, BloodTr.HitPos - BloodTr.HitNormal) end
					end
				end
			end)
		else
			sound.Play("Canister.ImpactHard", HitPos, 65, math.random(90, 110))
			sound.Play("SolidMetal.ImpactHard", HitPos - vector_up, 65, math.random(90, 110))
			sound.Play("Wood_Plank.ImpactSoft", HitPos + vector_up, 65, math.random(90, 110))
		end

		sound.Play("Wood_Plank.ImpactSoft", HitPos, 65, math.random(90, 110))
		local DamageAmt = math.random(45, 55)
		local Dam = DamageInfo()
		Dam:SetAttacker(self:GetOwner())
		Dam:SetInflictor(self)
		Dam:SetDamage(DamageAmt * Mul)
		Dam:SetDamageForce(AimVec * Mul / 50)
		Dam:SetDamageType(DMG_SLASH)
		Dam:SetDamagePosition(HitPos)
		Ent:TakeDamageInfo(Dam)
		local Phys = Ent:GetPhysicsObject()
		if IsValid(Phys) then
			if Ent:IsPlayer() then Ent:SetVelocity(-Ent:GetVelocity() / 5) end
			Phys:ApplyForceOffset(AimVec * 10000 * Mul, HitPos)
			self:GetOwner():SetVelocity(-AimVec * SelfForce / 50)
		end

		if Ent:GetClass() == "func_breakable_surf" then Ent:Fire("break", "", 0) end
		if IsValid(Ent) and HMCD_IsDoor(Ent) and not Ent:GetNoDraw() then
			if math.random(1, 3) == 1 then HMCD_BlastThatDoor(Ent) end
		elseif Ent:GetClass() == "func_breakable" then
			if math.random(1, 3) == 1 then Ent:Fire("break", "", 0) end
		end

		if math.random(1, 2) == 2 then
			local Constraints = constraint.FindConstraints(Ent, "Rope")
			if Constraints then
				local Const = table.Random(Constraints)
				if Const and Const.Constraint then
					Const.Constraint:Remove()
					sound.Play("Wood_Furniture.Break", Ent:GetPos(), 60, 100)
				end
			end
		end
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
	Ent.Poisoned = self.Poisoned
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
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 4 + Ang:Right() - Ang:Up() * 7)
				Ang:RotateAroundAxis(Ang:Forward(), 90)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel("models/props/cs_militia/axe.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(1, 0)
		end
	end
end
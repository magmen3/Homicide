if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
else
	SWEP.PrintName = translate and translate.hands or "Hands"
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 75
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_hands")
	SWEP.BounceWeaponIcon = false
	local HandTex, ClosedTex = surface.GetTextureID("vgui/hud/hmcd_hand"), surface.GetTextureID("vgui/hud/hmcd_closedhand")
	function SWEP:DrawHUD()
		if GetViewEntity() ~= LocalPlayer() then return end
		if not self:GetFists() then
			local Tr = util.QuickTrace(self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector() * self.ReachDistance, {self:GetOwner()})
			if Tr.Hit then
				if self:CanPickup(Tr.Entity) then
					local Size = math.Clamp(1 - ((Tr.HitPos - self:GetOwner():GetShootPos()):Length() / self.ReachDistance) ^ 2, .2, 1)
					if self:GetOwner():KeyDown(IN_ATTACK2) then
						surface.SetTexture(ClosedTex)
					else
						surface.SetTexture(HandTex)
					end

					surface.SetDrawColor(Color(255, 255, 255, 255 * Size))
					surface.DrawTexturedRect(ScrW() / 2 - (64 * Size), ScrH() / 2 - (64 * Size), 128 * Size, 128 * Size)
				end
			end
		end
	end
end

SWEP.SwayScale = 3
SWEP.BobScale = 3
SWEP.Instructions = translate.weaponHandsDesc
SWEP.AdminOnly = true
SWEP.HoldType = "normal"
SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.UseHands = true
SWEP.AttackSlowDown = .5
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.ReachDistance = 60
SWEP.HomicideSWEP = true
function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "NextIdle")
	self:NetworkVar("Bool", 2, "Fists")
	self:NetworkVar("Float", 1, "NextDown")
	self:NetworkVar("Bool", 3, "Blocking")
end

function SWEP:PreDrawViewModel(vm, wep, ply)
end

--vm:SetMaterial("engine/occlusionproxy") -- Hide that view model with hacky material
function SWEP:Initialize()
	self:SetNextIdle(CurTime() + 5)
	self:SetNextDown(CurTime() + 5)
	self:SetHoldType(self.HoldType)
	self:SetFists(false)
	self:SetBlocking(false)
	self.PrintName = translate and translate.hands or "Hands"
	self.Instructions = translate.weaponHandsDesc
end

function SWEP:Deploy()
	if not IsFirstTimePredicted() then
		self:DoBFSAnimation("fists_draw")
		self:GetOwner():GetViewModel():SetPlaybackRate(.1)
		return
	end

	self:SetNextPrimaryFire(CurTime() + .1)
	self:SetFists(false)
	self:SetNextDown(CurTime())
	self:DoBFSAnimation("fists_draw")
	return true
end

function SWEP:Holster()
	self:OnRemove()
	return true
end

function SWEP:CanPrimaryAttack()
	return true
end

local pickupWhiteList = {
	["prop_ragdoll"] = true,
	["prop_physics"] = true,
	["prop_physics_multiplayer"] = true
}

function SWEP:CanPickup(ent)
	if ent:IsNPC() then return false end
	if ent.IsLoot then return true end
	local class = ent:GetClass()
	if pickupWhiteList[class] then return true end
	return false
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end
	if self:GetFists() then return end
	if SERVER then
		self:SetCarrying()
		local tr = self:GetOwner():GetEyeTraceNoCursor()
		if IsValid(tr.Entity) and self:CanPickup(tr.Entity) and not tr.Entity:IsPlayer() then
			local Dist = (self:GetOwner():GetShootPos() - tr.HitPos):Length()
			if Dist < self.ReachDistance then
				if tr.Entity.ContactPoisoned then
					if self:GetOwner().Murderer then
						self:GetOwner():ChatPrint(translate.poisoned)
						return
					else
						tr.Entity.ContactPoisoned = false
						HMCD_Poison(self:GetOwner(), tr.Entity.Poisoner)
					end
				end

				sound.Play("Flesh.ImpactSoft", self:GetOwner():GetShootPos(), 65, math.random(90, 110))
				self:SetCarrying(tr.Entity, tr.PhysicsBone, tr.HitPos, Dist)
				tr.Entity.Touched = true
				self:ApplyForce()
			end
		elseif IsValid(tr.Entity) and tr.Entity:IsPlayer() then
			local Dist = (self:GetOwner():GetShootPos() - tr.HitPos):Length()
			if Dist < self.ReachDistance then
				sound.Play("Flesh.ImpactSoft", self:GetOwner():GetShootPos(), 65, math.random(90, 110))
				self:GetOwner():SetVelocity(self:GetOwner():GetAimVector() * 20)
				tr.Entity:SetVelocity(-self:GetOwner():GetAimVector() * 50)
				HMCD_StaminaPenalize(self:GetOwner(), 2)
				self:SetNextSecondaryFire(CurTime() + .25)
			end
		end
	end
end

function SWEP:ApplyForce()
	local target = self:GetOwner():GetAimVector() * self.CarryDist + self:GetOwner():GetShootPos()
	local phys = self.CarryEnt:GetPhysicsObjectNum(self.CarryBone)
	if IsValid(phys) then
		local TargetPos = phys:GetPos()
		if self.CarryPos then TargetPos = self.CarryEnt:LocalToWorld(self.CarryPos) end
		local vec = target - TargetPos
		local len, mul = vec:Length(), self.CarryEnt:GetPhysicsObject():GetMass()
		if (len > self.ReachDistance) or (mul > 170) then
			self:SetCarrying()
			return
		end

		if self.CarryEnt:GetClass() == "prop_ragdoll" then mul = mul * 2 end
		vec:Normalize()
		local avec, velo = vec * len, phys:GetVelocity() - self:GetOwner():GetVelocity()
		if self.CarryPos then
			phys:ApplyForceOffset((avec - velo / 2) * mul, self.CarryEnt:LocalToWorld(self.CarryPos))
		else
			phys:ApplyForceCenter((avec - velo / 2) * mul)
		end

		phys:ApplyForceCenter(Vector(0, 0, mul))
		phys:AddAngleVelocity(-phys:GetAngleVelocity() / 10)
	end
end

function SWEP:OnRemove()
	if IsValid(self:GetOwner()) and CLIENT and self:GetOwner():IsPlayer() then
		local vm = self:GetOwner():GetViewModel()
		if IsValid(vm) then vm:SetMaterial("") end
	end
end

function SWEP:GetCarrying()
	return self.CarryEnt
end

function SWEP:SetCarrying(ent, bone, pos, dist)
	if IsValid(ent) then
		self.CarryEnt = ent
		self.CarryBone = bone
		self.CarryDist = dist
		if ent:GetClass() ~= "prop_ragdoll" then
			self.CarryPos = ent:WorldToLocal(pos)
		else
			self.CarryPos = nil
		end
	else
		self.CarryEnt = nil
		self.CarryBone = nil
		self.CarryPos = nil
		self.CarryDist = nil
	end
end

function SWEP:Think()
	if IsValid(self:GetOwner()) and self:GetOwner():KeyDown(IN_ATTACK2) and not self:GetFists() then
		if IsValid(self.CarryEnt) then self:ApplyForce() end
	elseif self.CarryEnt then
		self:SetCarrying()
	end

	if self:GetFists() and self:GetOwner():KeyDown(IN_ATTACK2) then
		self:SetNextPrimaryFire(CurTime() + .5)
		self:SetBlocking(true)
	else
		self:SetBlocking(false)
	end

	local HoldType = "fist"
	if self:GetFists() then
		HoldType = "fist"
		local Time = CurTime()
		if self:GetNextIdle() < Time then
			self:DoBFSAnimation("fists_idle_0" .. math.random(1, 2))
			self:UpdateNextIdle()
		end

		if self:GetBlocking() then
			self:SetNextDown(Time + 1)
			HoldType = "camera"
		end

		if (self:GetNextDown() < Time) or self:GetOwner():IsSprinting() then
			self:SetNextDown(Time + 1)
			self:SetFists(false)
			self:SetBlocking(false)
		end
	else
		HoldType = "normal"
		self:DoBFSAnimation("fists_draw")
	end

	if IsValid(self.CarryEnt) or self.CarryEnt then HoldType = "magic" end
	if self:GetOwner():IsSprinting() then HoldType = "normal" end
	if SERVER then self:SetHoldType(HoldType) end
end

function SWEP:PrimaryAttack()
	local side = "fists_left"
	if math.random(1, 2) == 1 then side = "fists_right" end
	self:SetNextDown(CurTime() + 7)
	if not self:GetFists() then
		self:SetFists(true)
		self:DoBFSAnimation("fists_draw")
		self:SetNextPrimaryFire(CurTime() + .35)
		return
	end

	if self:GetBlocking() then return end
	if not self:GetOwner().Stamina then return end
	if self:GetOwner().Stamina < 5 then return end
	if self:GetOwner():IsSprinting() then return end
	if not IsFirstTimePredicted() then
		self:DoBFSAnimation(side)
		self:GetOwner():GetViewModel():SetPlaybackRate(1.25)
		return
	end

	self:GetOwner():ViewPunch(Angle(0, 0, math.random(-2, 2)))
	self:DoBFSAnimation(side)
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:GetOwner():GetViewModel():SetPlaybackRate(1.25)
	self:UpdateNextIdle()
	if SERVER then
		HMCD_StaminaPenalize(self:GetOwner(), 4)
		sound.Play("weapons/slam/throw.wav", self:GetPos(), 65, math.random(90, 110))
		self:GetOwner():ViewPunch(Angle(0, 0, math.random(-2, 2)))
		timer.Simple(.075, function() if IsValid(self) then self:AttackFront() end end)
	end

	self:SetNextPrimaryFire(CurTime() + .35)
	self:SetNextSecondaryFire(CurTime() + .35)
end

function SWEP:AttackFront()
	if CLIENT then return end
	self:GetOwner():LagCompensation(true)
	local Ent, HitPos = HMCD_WhomILookinAt(self:GetOwner(), .3, 55)
	local AimVec = self:GetOwner():GetAimVector()
	if IsValid(Ent) or (Ent and Ent.IsWorld and Ent:IsWorld()) then
		local SelfForce, Mul = 125, 1
		if self:IsEntSoft(Ent) then
			SelfForce = 25
			if Ent:IsPlayer() and IsValid(Ent:GetActiveWeapon()) and Ent:GetActiveWeapon().GetBlocking and Ent:GetActiveWeapon():GetBlocking() then
				sound.Play("Flesh.ImpactSoft", HitPos, 65, math.random(90, 110))
				self:GetOwner():ViewPunch(AngleRand(-1, 1))
			else
				sound.Play("Flesh.ImpactHard", HitPos, 65, math.random(90, 110))
				self:GetOwner():ViewPunch(AngleRand(-2, 2))
			end
		else
			sound.Play("Flesh.ImpactSoft", HitPos, 65, math.random(90, 110))
			self:GetOwner():ViewPunch(AngleRand(-2, 2))
		end

		local DamageAmt = math.random(2, 4)
		local Dam = DamageInfo()
		Dam:SetAttacker(self:GetOwner())
		Dam:SetInflictor(self)
		Dam:SetDamage(DamageAmt * Mul)
		Dam:SetDamageForce(AimVec * Mul ^ 3)
		Dam:SetDamageType(DMG_CLUB)
		Dam:SetDamagePosition(HitPos)
		Ent:TakeDamageInfo(Dam)
		local Phys = Ent:GetPhysicsObject()
		if IsValid(Phys) then
			if Ent:IsPlayer() then Ent:SetVelocity(AimVec * SelfForce * 1.5) end
			Phys:ApplyForceOffset(AimVec * 5000 * Mul, HitPos)
			self:GetOwner():SetVelocity(-AimVec * SelfForce * .8)
		end

		if Ent:GetClass() == "func_breakable_surf" and math.random(1, 20) == 10 then
			Ent:Fire("break", "", 0)
		end

		if self:GetOwner():GetVR() and CLIENT then
			VRMOD_TriggerHaptic("vibration_right", 0, 0.3, 10, 15)
			VRMOD_TriggerHaptic("vibration_left", 0, 0.3, 10, 15)
		end
	end

	self:GetOwner():LagCompensation(false)
end

function SWEP:Reload()
	if not IsFirstTimePredicted() then return end
	self:SetFists(false)
	self:SetBlocking(false)
	self:SetCarrying()
end

function SWEP:DrawWorldModel()
end

-- no, do nothing
function SWEP:DoBFSAnimation(anim)
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
end

function SWEP:UpdateNextIdle()
	local vm = self:GetOwner():GetViewModel()
	self:SetNextIdle(CurTime() + vm:SequenceDuration())
end

function SWEP:IsEntSoft(ent)
	return ent:IsNPC() or ent:IsPlayer()
end

if CLIENT then
	local BlockAmt = 0
	function SWEP:GetViewModelPosition(pos, ang)
		if self:GetBlocking() then
			BlockAmt = math.Clamp(BlockAmt + FrameTime() * 1.5, 0, 1)
		else
			BlockAmt = math.Clamp(BlockAmt - FrameTime() * 1.5, 0, 1)
		end

		pos = pos - ang:Up() * 15 * BlockAmt
		ang:RotateAroundAxis(ang:Right(), BlockAmt * 60)
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.2)
		return pos, ang
	end
end
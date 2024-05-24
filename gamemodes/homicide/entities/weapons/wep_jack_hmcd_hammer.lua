if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 75
	SWEP.Slot = 1
	SWEP.SlotPos = 5
	killicon.AddFont("wep_jack_hmcd_hammer", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))
	function SWEP:DrawViewModel()
		return false
	end

	function SWEP:DrawWorldModel()
		self:DrawModel()
	end

	local NailMat = surface.GetTextureID("vgui/hud/hmcd_nail")
	function SWEP:DrawHUD()
		local Tr = util.QuickTrace(self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector() * 65, {self:GetOwner()})
		if self:CanNail(Tr) then
			surface.SetTexture(NailMat)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(ScrW() / 2, ScrH() / 2 - 32, 64, 64)
		end
	end
end

SWEP.Base = "weapon_base"
SWEP.ViewModel = "models/weapons/v_jjife_t.mdl"
SWEP.WorldModel = "models/weapons/w_jjife_t.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_hammer")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponHammer
SWEP.Instructions = translate.weaponHammerDesc
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
SWEP.Primary.Ammo = "AirboatGun"
SWEP.Secondary.Delay = 0.9
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.ENT = "ent_jack_hmcd_hammer"
SWEP.DownAmt = 0
SWEP.HomicideSWEP = true
SWEP.AmmoType = "AirboatGun"
SWEP.CanAmmoShow = true
SWEP.UnNailables = {MAT_SAND, MAT_SLOSH, MAT_GLASS}
SWEP.CarryWeight = 1000
function SWEP:CanNail(Tr)
	return (self:GetOwner():GetAmmoCount(self.Primary.Ammo) > 0) and Tr.Hit and Tr.Entity and (IsValid(Tr.Entity) or Tr.Entity:IsWorld()) and not (Tr.Entity:IsPlayer() or Tr.Entity:IsNPC()) and not table.HasValue(self.UnNailables, Tr.MatType)
end

function SWEP:Initialize()
	self:SetHoldType("melee")
	self.DownAmt = 20
	self.PrintName = translate.weaponHammer
	self.Instructions = translate.weaponHammerDesc
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then
		self:DoBFSAnimation("midslash2")
		self:GetOwner():GetViewModel():SetPlaybackRate(.65)
		return
	end

	if self:GetOwner().Stamina < 5 then return end
	if self:GetOwner():IsSprinting() then return end
	self:DoBFSAnimation("midslash2")
	self:GetOwner():GetViewModel():SetPlaybackRate(.65)
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:GetOwner():ViewPunch(Angle(-3, 0, 0))
	if SERVER then sound.Play("weapons/slam/throw.wav", self:GetOwner():GetPos(), 60, math.random(90, 110)) end
	timer.Simple(.1, function() if IsValid(self) then self:AttackFront() end end)
	self:SetNextSecondaryFire(CurTime() + 1.5)
	self:SetNextPrimaryFire(CurTime() + 1.5)
end

function SWEP:IsEntSoft(ent)
	return ent:IsNPC() or ent:IsPlayer() or (ent:GetClass() == "prop_ragdoll")
end

function SWEP:AttackFront()
	if CLIENT then return end
	self:GetOwner():ViewPunch(Angle(3, 0, 0))
	self:GetOwner():LagCompensation(true)
	HMCD_StaminaPenalize(self:GetOwner(), 6)
	local Ent, HitPos, HitNorm = HMCD_WhomILookinAt(self:GetOwner(), .3, 60)
	local AimVec, Mul = self:GetOwner():GetAimVector(), 1
	if IsValid(Ent) or (Ent and Ent.IsWorld and Ent:IsWorld()) then
		local SelfForce = 125
		if self:IsEntSoft(Ent) then
			SelfForce = 25
			sound.Play("Flesh.ImpactHard", HitPos, 55, math.random(90, 110))
			util.Decal("Impact.Flesh", HitPos + HitNorm, HitPos - HitNorm)
		end

		sound.Play("snd_jack_hmcd_hammerhit.wav", HitPos, 60, math.random(90, 110))
		local DamageAmt = math.random(8, 14)
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
			if Ent:IsPlayer() then Ent:SetVelocity(AimVec * SelfForce / 2) end
			Phys:ApplyForceOffset(AimVec * 4500 * Mul, HitPos)
			self:GetOwner():SetVelocity(-AimVec * SelfForce / 10)
		end
	end

	self:GetOwner():LagCompensation(false)
end

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime() + 1)
	self.DownAmt = 20
	self:DoBFSAnimation("draw")
	--self:GetOwner():GiveAmmo(10,"AirboatGun")
	return true
end

function SWEP:SecondaryAttack()
	if self:GetOwner():IsSprinting() then return end
	if SERVER then
		if self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 then
			net.Start("HMCD_AmmoShow")
			net.Send(self:GetOwner())
			net.Broadcast()
			return
		end

		local ShPos, AimVec = self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector()
		local Tr = util.QuickTrace(ShPos, AimVec * 65, {self:GetOwner()})
		if self:CanNail(Tr) then
			local NewTr, NewEnt = util.QuickTrace(Tr.HitPos, AimVec * 10, {self:GetOwner(), Tr.Entity}), nil
			if self:CanNail(NewTr) then
				if not NewTr.HitSky then NewEnt = NewTr.Entity end
				if NewEnt and (IsValid(NewEnt) or NewEnt:IsWorld()) and not (NewEnt:IsPlayer() or NewEnt:IsNPC() or (NewEnt == Tr.Entity)) then
					if HMCD_IsDoor(Tr.Entity) then
						if self:GetOwner():GetAmmoCount(self.AmmoType) >= 3 then
							Tr.Entity:Fire("lock", "", 0)
							self:TakePrimaryAmmo(3)
							sound.Play("snd_jack_hmcd_hammerhit.wav", Tr.HitPos, 65, math.random(90, 110))
							self:SprayDecals()
							self:GetOwner():PrintMessage(HUD_PRINTCENTER, translate.weaponDoorSealed)
							net.Start("HMCD_AmmoShow")
							net.Send(self:GetOwner())
							net.Broadcast()
							self:GetOwner():ViewPunch(Angle(3, 0, 0))
							self:DoBFSAnimation("midslash2")
							self:GetOwner():SetAnimation(PLAYER_ATTACK1)
							self:GetOwner():GetViewModel():SetPlaybackRate(.75)
							timer.Simple(1, function() if IsValid(self) then self:DoBFSAnimation("idle") end end)
						else
							self:GetOwner():PrintMessage(HUD_PRINTCENTER, translate.weaponHammerNailsNeeded)
						end
					else
						local Strength = HMCD_BindObjects(Tr.Entity, Tr.HitPos, NewEnt, NewTr.HitPos, 4)
						self:TakePrimaryAmmo(1)
						sound.Play("snd_jack_hmcd_hammerhit.wav", Tr.HitPos, 65, math.random(90, 110))
						util.Decal("hmcd_jackanail", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
						self:GetOwner():PrintMessage(HUD_PRINTCENTER, translate.weaponBondStrength .. tostring(Strength))
						net.Start("HMCD_AmmoShow")
						net.Send(self:GetOwner())
						net.Broadcast()
						self:GetOwner():ViewPunch(Angle(3, 0, 0))
						self:DoBFSAnimation("midslash2")
						self:GetOwner():SetAnimation(PLAYER_ATTACK1)
						self:GetOwner():GetViewModel():SetPlaybackRate(.75)
						timer.Simple(1, function() if IsValid(self) then self:DoBFSAnimation("idle") end end)
					end
				end
			end
		end
	end

	self:SetNextSecondaryFire(CurTime() + 2.5)
	self:SetNextPrimaryFire(CurTime() + 2.5)
end

function SWEP:SprayDecals()
	local Tr = util.QuickTrace(self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector() * 70, {self:GetOwner()})
	util.Decal("hmcd_jackanail", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
	local Tr2 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(0, 0, .15)) * 70, {self:GetOwner()})
	util.Decal("hmcd_jackanail", Tr2.HitPos + Tr2.HitNormal, Tr2.HitPos - Tr2.HitNormal)
	local Tr3 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(0, 0, -.15)) * 70, {self:GetOwner()})
	util.Decal("hmcd_jackanail", Tr3.HitPos + Tr3.HitNormal, Tr3.HitPos - Tr3.HitNormal)
	local Tr4 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(0, .15, 0)) * 70, {self:GetOwner()})
	util.Decal("hmcd_jackanail", Tr4.HitPos + Tr4.HitNormal, Tr4.HitPos - Tr4.HitNormal)
	local Tr5 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(0, -.15, 0)) * 70, {self:GetOwner()})
	util.Decal("hmcd_jackanail", Tr5.HitPos + Tr5.HitNormal, Tr5.HitPos - Tr5.HitNormal)
	local Tr6 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(.15, 0, 0)) * 70, {self:GetOwner()})
	util.Decal("hmcd_jackanail", Tr6.HitPos + Tr6.HitNormal, Tr6.HitPos - Tr6.HitNormal)
	local Tr7 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(-.15, 0, 0)) * 70, {self:GetOwner()})
	util.Decal("hmcd_jackanail", Tr7.HitPos + Tr7.HitNormal, Tr7.HitPos - Tr7.HitNormal)
end

function SWEP:Think()
	if SERVER then
		local HoldType = "melee"
		if self:GetOwner():IsSprinting() then HoldType = "normal" end
		self:SetHoldType(HoldType)
	end
end

function SWEP:Reload()
	if SERVER then
		net.Start("HMCD_AmmoShow")
		net.Send(self:GetOwner())
		net.Broadcast()
	end
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

function SWEP:DoBFSAnimation(anim)
	if self:GetOwner() and self:GetOwner().GetViewModel then
		local vm = self:GetOwner():GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	end
end

if CLIENT then
	function SWEP:PreDrawViewModel(vm, ply, wep)
	end

	function SWEP:GetViewModelPosition(pos, ang)
		if not self.DownAmt then self.DownAmt = 0 end
		if self:GetOwner():IsSprinting() then
			self.DownAmt = math.Clamp(self.DownAmt + .2, 0, 20)
		else
			self.DownAmt = math.Clamp(self.DownAmt - .2, 0, 20)
		end

		pos = pos - ang:Up() * (self.DownAmt + 0) --+ang:Forward()*0+ang:Right()*0
		--ang:RotateAroundAxis(ang:Up(),0)
		--ang:RotateAroundAxis(ang:Right(),0)
		--ang:RotateAroundAxis(ang:Forward(),0)
		return pos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 4 + Ang:Right() * -1 - Ang:Up() * 1.5)
				Ang:RotateAroundAxis(Ang:Right(), -90)
				Ang:RotateAroundAxis(Ang:Up(), -60)
				Ang:RotateAroundAxis(Ang:Forward(), -70)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel("models/weapons/w_jjife_t.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			--self.DatWorldModel:SetModelScale(1,0)
		end
	end
end
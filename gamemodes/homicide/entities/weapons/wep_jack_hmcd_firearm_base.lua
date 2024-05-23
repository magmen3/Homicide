----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------[[
--           JJJJJJJJJJJ                                   kkkkkkkk                                                                                            d::::::d                       --
--           J:::::::::J                                   k::::::k                                                                                            d::::::d                       --
--           J:::::::::J                                   k::::::k                                                                                            d::::::d                       --
--           JJ:::::::JJ                                   k::::::k                                                                                            d:::::d                        --
--             J:::::J  aaaaaaaaaaaaa      cccccccccccccccc k:::::k    kkkkkkkaaaaaaaaaaaaa  rrrrr   rrrrrrrrr   uuuuuu    uuuuuunnnn  nnnnnnnn        ddddddddd:::::d   aaaaaaaaaaaaa        --
--             J:::::J  a::::::::::::a   cc:::::::::::::::c k:::::k   k:::::k a::::::::::::a r::::rrr:::::::::r  u::::u    u::::un:::nn::::::::nn    dd::::::::::::::d   a::::::::::::a       --
--             J:::::J  aaaaaaaaa:::::a c:::::::::::::::::c k:::::k  k:::::k  aaaaaaaaa:::::ar:::::::::::::::::r u::::u    u::::un::::::::::::::nn  d::::::::::::::::d   aaaaaaaaa:::::a      --
--             J:::::j           a::::ac:::::::cccccc:::::c k:::::k k:::::k            a::::arr::::::rrrrr::::::ru::::u    u::::unn:::::::::::::::nd:::::::ddddd:::::d            a::::a      --
--             J:::::J    aaaaaaa:::::ac::::::c     ccccccc k::::::k:::::k      aaaaaaa:::::a r:::::r     r:::::ru::::u    u::::u  n:::::nnnn:::::nd::::::d    d:::::d     aaaaaaa:::::a      --
-- JJJJJJJ     J:::::J  aa::::::::::::ac:::::c              k:::::::::::k     aa::::::::::::a r:::::r     rrrrrrru::::u    u::::u  n::::n    n::::nd:::::d     d:::::d   aa::::::::::::a      --
-- J:::::J     J:::::J a::::aaaa::::::ac:::::c              k:::::::::::k    a::::aaaa::::::a r:::::r            u::::u    u::::u  n::::n    n::::nd:::::d     d:::::d  a::::aaaa::::::a      --
-- J::::::J   J::::::Ja::::a    a:::::ac::::::c     ccccccc k::::::k:::::k  a::::a    a:::::a r:::::r            u:::::uuuu:::::u  n::::n    n::::nd:::::d     d:::::d a::::a    a:::::a      --
-- J:::::::JJJ:::::::Ja::::a    a:::::ac:::::::cccccc:::::ck::::::k k:::::k a::::a    a:::::a r:::::r            u:::::::::::::::uun::::n    n::::nd::::::ddddd::::::dda::::a    a:::::a      --
--  JJ:::::::::::::JJ a:::::aaaa::::::a c:::::::::::::::::ck::::::k  k:::::ka:::::aaaa::::::a r:::::r             u:::::::::::::::un::::n    n::::n d:::::::::::::::::da:::::aaaa::::::a      --
--    JJ:::::::::JJ    a::::::::::aa:::a cc:::::::::::::::ck::::::k   k:::::ka::::::::::aa:::ar:::::r              uu::::::::uu:::un::::n    n::::n  d:::::::::ddd::::d a::::::::::aa:::a     --
--      JJJJJJJJJ       aaaaaaaaaa  aaaa   cccccccccccccccckkkkkkkk    kkkkkkkaaaaaaaaaa  aaaarrrrrrr                uuuuuuuu  uuuunnnnnn    nnnnnn   ddddddddd   ddddd  aaaaaaaaaa  aaaa     --
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]
if SERVER then
	AddCSLuaFile()
else
	killicon.AddFont("wep_jack_hmcd_smallpistol", "HL2MPTypeDeath", "1", Color(255, 0, 0))
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_smallpistol")
	SWEP.BounceWeaponIcon = false
end

SWEP.Base = "weapon_base"
SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFlip = true
SWEP.ViewModelFOV = 75
SWEP.ViewModel = "models/weapons/v_pist_jivejeven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"
SWEP.HoldType = "pistol"
SWEP.BobScale = 1.5
SWEP.SwayScale = 1.5
SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = "snd_jack_hmcd_smp_close.wav"
SWEP.Primary.Damage = 120
SWEP.Primary.NumShots = 1
SWEP.Primary.Recoil = 5
SWEP.Primary.Cone = 1
SWEP.Primary.Delay = 3
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Tracer = 1
SWEP.Primary.Force = 420
SWEP.Primary.TakeAmmoPerBullet = false
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Pistol"
SWEP.Secondary.Sound = ""
SWEP.Secondary.Damage = 10
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Recoil = 1
SWEP.Secondary.Cone = 0
SWEP.Secondary.Delay = 0.25
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Tracer = -1
SWEP.Secondary.Force = 5
SWEP.Secondary.TakeAmmoPerBullet = false
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.BarrelMustSmoke = false
SWEP.AimTime = 3
SWEP.BearTime = 3
SWEP.SprintPos = Vector(-4, 0, -10)
SWEP.SprintAng = Angle(80, 0, 0)
SWEP.AimPos = Vector(1.75, 0, 1.22)
SWEP.DeathDroppable = true
SWEP.CanAmmoShow = true
SWEP.CommandDroppable = true
SWEP.ENT = "ent_jack_hmcd_smallpistol"
SWEP.MuzzleSmoke = false
SWEP.Damage = 30
SWEP.EjectType = "auto"
SWEP.ShellType = "ShellEject"
SWEP.MuzzleEffect = "pcf_jack_mf_spistol"
SWEP.ReloadTime = 3
SWEP.ReloadRate = .6
SWEP.ReloadSound = "snd_jack_hmcd_smp_reload.wav"
SWEP.CloseFireSound = "snd_jack_hmcd_smp_close.wav"
SWEP.FarFireSound = "snd_jack_hmcd_smp_far.wav"
SWEP.HipHoldType = "pistol"
SWEP.AimHoldType = "revolver"
SWEP.DownHoldType = "normal"
SWEP.AmmoType = "Pistol"
SWEP.BarrelLength = 1
SWEP.HandlingPitch = 100
SWEP.TriggerDelay = .15
SWEP.CycleTime = .025
SWEP.Recoil = 1
SWEP.Supersonic = true
SWEP.Accuracy = .99
SWEP.Spread = 0
SWEP.NumProjectiles = 1
SWEP.ShotPitch = 100
SWEP.VReloadTime = 0
SWEP.HipFireInaccuracy = .18
SWEP.CycleType = "auto"
SWEP.ReloadType = "magazine"
SWEP.LastFire = 0
SWEP.FireAnim = "shoot1"
SWEP.DrawAnim = "draw"
SWEP.ReloadAnim = "reload"
SWEP.ReloadInterrupted = false
SWEP.HomicideSWEP = true
function SWEP:Initialize()
	self.NextFrontBlockCheckTime = CurTime()
	self:SetHoldType(self.HipHoldType)
	self:SetAiming(0)
	self:SetSprinting(0)
	self:SetReady(true)
	if self.CustomColor then self:SetColor(self.CustomColor) end
	self:SetReloading(false)
	local a = string.Explode("_", self:GetClass())
	self.PrintName = translate["weapon" .. a[4]]
	self.Instructions = translate["weapon" .. a[4] .. "Desc"]
end

function SWEP:PreDrawViewModel()
	if self.Scoped and (self:GetAiming() >= 99) then return true end
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Ready")
	self:NetworkVar("Int", 0, "Aiming")
	self:NetworkVar("Int", 1, "Sprinting")
	self:NetworkVar("Bool", 1, "Reloading")
end

function SWEP:BulletCallback(att, tr, dmg)
	return {
		effects = true,
		damage = true
	}
end

function SWEP:PrimaryAttack()
	self.ReloadInterrupted = true
	if not self:GetReady() then return end
	if self:GetSprinting() > 10 then return end
	if not IsFirstTimePredicted() then
		if (self:Clip1() == 1) and self.LastFireAnim then
			self:DoBFSAnimation(self.LastFireAnim)
		elseif self:Clip1() > 0 then
			self:DoBFSAnimation(self.FireAnim)
		end
		return
	end

	self.LastFire = CurTime()
	if not (self:Clip1() > 0) then
		self:EmitSound("snd_jack_hmcd_click.wav", 55, 100)
		if SERVER then
			net.Start("HMCD_AmmoShow")
			net.Send(self:GetOwner())
			net.Broadcast()
		end
		return
	end

	local WaterMul = 1
	if self:GetOwner():WaterLevel() >= 3 then WaterMul = .5 end
	local dmgAmt, InAcc = self.Damage * math.Rand(.9, 1.1) * WaterMul, 1 - self.Accuracy
	if not (self:GetAiming() > 99) then InAcc = InAcc + self.HipFireInaccuracy end
	local BulletTraj = (self:GetOwner():GetAimVector() + VectorRand() * InAcc):GetNormalized()
	local bullet = {}
	bullet.Num = self.NumProjectiles
	bullet.Src = self:GetOwner():GetShootPos()
	bullet.Dir = BulletTraj
	bullet.Spread = Vector(self.Spread, self.Spread, 0)
	bullet.Tracer = 0
	bullet.Force = dmgAmt / 10
	bullet.Damage = dmgAmt
	bullet.Callback = function(ply, tr) ply:GetActiveWeapon():BulletCallbackFunc(dmgAmt, ply, tr, dmg, false, true, false) end
	self:GetOwner():FireBullets(bullet)
	if self.Supersonic then self:BallisticSnap(BulletTraj) end
	if (self:Clip1() == 1) and self.LastFireAnim then
		self:DoBFSAnimation(self.LastFireAnim)
	elseif self:Clip1() > 0 then
		self:DoBFSAnimation(self.FireAnim)
		if self.FireAnimRate then self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimRate) end
	end

	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	local Pitch = self.ShotPitch * math.Rand(.9, 1.1)
	if SERVER then
		local Dist = 75
		if self.Suppressed then Dist = 55 end
		if self.Primary.Automatic == true then
			self:EmitSound(self.CloseFireSound, Dist, Pitch, 1, CHAN_AUTO)
			self:GetOwner():EmitSound(self.CloseFireSound, Dist, Pitch, 1, CHAN_AUTO)
		else
			sound.Play(self.CloseFireSound, self:GetOwner():GetShootPos() - vector_up, Dist, Pitch)
			sound.Play(self.CloseFireSound, self:GetOwner():GetShootPos(), Dist, Pitch)
			sound.Play(self.CloseFireSound, self:GetOwner():GetShootPos(), Dist + 1, Pitch)
		end

		sound.Play(self.FarFireSound, self:GetOwner():GetShootPos() + vector_up, Dist * 2, Pitch)
		if self.ExtraFireSound then
			if self.Primary.Automatic == true then
				self:EmitSound(self.ExtraFireSound, Dist - 5, Pitch, 1, CHAN_AUTO)
			else
				sound.Play(self.ExtraFireSound, self:GetOwner():GetShootPos() + VectorRand(), Dist - 5, Pitch)
			end
		end

		if self.CycleType == "manual" then timer.Simple(.1, function() if IsValid(self) and IsValid(self:GetOwner()) then self:EmitSound(self.CycleSound, 55, 100) end end) end
	end

	local Rightness, Upness = 4, 2
	if self:GetAiming() == 100 then
		Rightness = 0
		Upness = 0
	end

	ParticleEffect(self.MuzzleEffect, self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 20 + self:GetOwner():EyeAngles():Right() * Rightness - self:GetOwner():EyeAngles():Up() * Upness, self:GetOwner():EyeAngles(), self)
	self.BarrelMustSmoke = true
	if SERVER and (self.CycleType == "auto") then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 15 + self:GetOwner():EyeAngles():Right() * Rightness - self:GetOwner():EyeAngles():Up() * Upness)
		effectdata:SetAngles(self:GetOwner():GetRight():Angle())
		effectdata:SetEntity(self:GetOwner())
		util.Effect(self.ShellType, effectdata, true, true)
	elseif SERVER and (self.CycleType == "manual") then
		timer.Simple(.4, function()
			if IsValid(self) and IsValid(self:GetOwner()) then
				local effectdata = EffectData()
				effectdata:SetOrigin(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 15 + self:GetOwner():EyeAngles():Right() * Rightness - self:GetOwner():EyeAngles():Up() * Upness)
				effectdata:SetAngles(self:GetOwner():GetRight():Angle())
				effectdata:SetEntity(self:GetOwner())
				util.Effect(self.ShellType, effectdata, true, true)
			end
		end)
	end

	local Ang, Rec = self:GetOwner():EyeAngles(), self.Recoil
	if self:GetOwner().Murderer then Rec = .5 end
	local RecoilY = math.Rand(.015, .03) * Rec
	local RecoilX = math.Rand(-.03, .05) * Rec
	if (SERVER and game.SinglePlayer()) or CLIENT then self:GetOwner():SetEyeAngles((Ang:Forward() + RecoilY * Ang:Up() + Ang:Right() * RecoilX):Angle()) end
	if not self:GetOwner():OnGround() then self:GetOwner():SetVelocity(-self:GetOwner():GetAimVector() * 10) end
	self:GetOwner():ViewPunchReset()
	self:GetOwner():ViewPunch(Angle(RecoilY * -100 * self.Recoil, RecoilX * -100 * self.Recoil, 0))
	self:TakePrimaryAmmo(1)
	local Extra = 0
	if self:GetOwner():WaterLevel() >= 3 then Extra = 1 end
	self:SetNextPrimaryFire(CurTime() + self.TriggerDelay + self.CycleTime + Extra)
end

function SWEP:BarrelSmoke()
	if self:GetOwner():WaterLevel() >= 3 then return end
	if CLIENT then
		local ent = self:GetOwner():GetViewModel()
		if ent then ParticleEffectAttach("pcf_jack_mf_barrelsmoke", PATTACH_POINT_FOLLOW, ent, 2) end
	else
		for i = 0, math.random(1, 2) do
			timer.Simple(i / 2, function() if IsValid(self) and self:GetOwner() and self:GetOwner().Alive and self:GetOwner():Alive() then ParticleEffectAttach("pcf_jack_mf_barrelsmoke", PATTACH_POINT_FOLLOW, self:GetOwner(), self:GetOwner():LookupAttachment("anim_attachment_RH")) end end)
		end
	end
end

function SWEP:SecondaryAttack()
end

-- wat
function SWEP:Think()
	if self.BarrelMustSmoke then
		if math.random(1, 300) == 4 then
			self:BarrelSmoke()
			self.BarrelMustSmoke = false
		end
	end

	if SERVER then
		if (self.ReloadType == "individual") and self:GetReloading() then
			if self.VReloadTime < CurTime() then
				if (self:Clip1() < self.Primary.ClipSize) and (self:GetOwner():GetAmmoCount(self.AmmoType) > 0) and not self.ReloadInterrupted then
					self:SetClip1(self:Clip1() + 1)
					self:GetOwner():RemoveAmmo(1, self.AmmoType)
					self:StallAnimation("after_reload", .1)
					timer.Simple(.01, function() self:ReadyAfterAnim("insert") end)
					sound.Play(self.ReloadSound, self:GetOwner():GetShootPos(), 55, 100)
				else
					self:SetReloading(false)
					self:ReadyAfterAnim("after_reload")
					timer.Simple(.25, function() if IsValid(self) and IsValid(self:GetOwner()) then self:EmitSound(self.CycleSound, 55, 90) end end)
					timer.Simple(.5, function() if IsValid(self) and IsValid(self:GetOwner()) then self:SetReady(true) end end)
				end
			end
		end

		local Sprintin, Aimin, AimAmt, SprintAmt = self:GetOwner():IsSprinting(), self:GetOwner():KeyDown(IN_ATTACK2), self:GetAiming(), self:GetSprinting()
		if (Sprintin or self:FrontBlocked()) and self:GetReady() then
			self:SetSprinting(math.Clamp(SprintAmt + 40 * (1 / self.BearTime), 0, 100))
			self:SetAiming(math.Clamp(AimAmt - 40 * (1 / self.AimTime), 0, 100))
		elseif Aimin and self:GetOwner():OnGround() and not ((self.CycleType == "manual") and (self.LastFire + .75 > CurTime())) then
			self:SetAiming(math.Clamp(AimAmt + 20 * (1 / self.AimTime), 0, 100))
			self:SetSprinting(math.Clamp(SprintAmt - 20 * (1 / self.BearTime), 0, 100))
		else
			self:SetAiming(math.Clamp(AimAmt - 40 * (1 / self.AimTime), 0, 100))
			self:SetSprinting(math.Clamp(SprintAmt - 20 * (1 / self.BearTime), 0, 100))
		end

		local HoldType = self.HipHoldType
		if SprintAmt > 90 then
			HoldType = self.DownHoldType
		elseif Aimin and not self:GetOwner():Crouching() then
			HoldType = self.AimHoldType
		else
			HoldType = self.HipHoldType
		end

		self:SetHoldType(HoldType)
	end
end

function SWEP:Reload()
	self.ReloadInterrupted = false
	if not IsFirstTimePredicted() then return end
	if not (IsValid(self) and IsValid(self:GetOwner())) then return end
	if not self:GetReady() then return end
	if self:GetSprinting() > 0 then return end
	if SERVER then
		net.Start("HMCD_AmmoShow")
		net.Send(self:GetOwner())
		net.Broadcast()
	end

	if (self:Clip1() < self.Primary.ClipSize) and (self:GetOwner():GetAmmoCount(self.AmmoType) > 0) then
		local TacticalReload = self:Clip1() > 0
		self:SetReady(false)
		self:GetOwner():SetAnimation(PLAYER_RELOAD)
		if (self.ReloadType == "clip") or (self.ReloadType == "magazine") then
			if TacticalReload and self.TacticalReloadAnim then
				self:DoBFSAnimation(self.TacticalReloadAnim)
			else
				self:DoBFSAnimation(self.ReloadAnim)
			end

			self:GetOwner():GetViewModel():SetPlaybackRate(self.ReloadRate)
			self:EmitSound(self.ReloadSound, 65, 100)
			if SERVER then
				if self.CycleType == "revolving" then
					timer.Simple(self.ReloadTime / 3, function()
						if IsValid(self) and IsValid(self:GetOwner()) then
							for i = 1, self.Primary.ClipSize - self:Clip1() do
								local effectdata = EffectData()
								effectdata:SetOrigin(self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Forearm")))
								effectdata:SetAngles((-vector_up):Angle())
								effectdata:SetEntity(self:GetOwner())
								util.Effect(self.ShellType, effectdata, true, true)
							end
						end
					end)
				end

				local ReloadAdd = 0
				if not TacticalReload then ReloadAdd = .2 end
				timer.Simple(self.ReloadTime + ReloadAdd, function()
					if IsValid(self) and IsValid(self:GetOwner()) then
						self:SetReady(true)
						local Missing, Have = self.Primary.ClipSize - self:Clip1(), self:GetOwner():GetAmmoCount(self.AmmoType)
						if Missing <= Have then
							self:GetOwner():RemoveAmmo(Missing, self.AmmoType)
							self:SetClip1(self.Primary.ClipSize)
						elseif Missing > Have then
							self:SetClip1(self:Clip1() + Have)
							self:GetOwner():RemoveAmmo(Have, self.AmmoType)
							net.Start("HMCD_AmmoShow")
							net.Send(self:GetOwner())
							net.Broadcast()
						end
					end
				end)
			end
		elseif self.ReloadType == "individual" then
			self:SetReloading(true)
			self:ReadyAfterAnim("start_reload")
		end
	end
end

function SWEP:ReadyAfterAnim(anim)
	self:DoBFSAnimation(anim)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.ReloadRate)
	local Time = (self:GetOwner():GetViewModel():SequenceDuration() / self.ReloadRate) + .01
	self.VReloadTime = CurTime() + Time
end

function SWEP:Deploy()
	if IsValid(self) and IsValid(self:GetOwner()) then
		if not IsFirstTimePredicted() then
			self:DoBFSAnimation(self.DrawAnim)
			self:GetOwner():GetViewModel():SetPlaybackRate(.1)
			return
		end

		self:DoBFSAnimation(self.DrawAnim)
		self:GetOwner():GetViewModel():SetPlaybackRate(.5)
		self:SetReady(false)
		self:EmitSound("snd_jack_hmcd_pistoldraw.wav", 70, self.HandlingPitch)
		self:EnforceHolsterRules(self)
		timer.Simple(1.5, function() if IsValid(self) then self:SetReady(true) end end)
		return true
	end
end

function SWEP:EnforceHolsterRules(newWep)
	if CLIENT then return end
	if not (newWep == self) then -- only enforce rules for us
		return
	end

	for key, wep in ipairs(self:GetOwner():GetWeapons()) do
		-- conflict
		if wep.HolsterSlot and self.HolsterSlot and (wep.HolsterSlot == self.HolsterSlot) and not (wep == self) then self:GetOwner():DropWeapon(wep) end
	end
end

function SWEP:StallAnimation(anim, time)
	self:DoBFSAnimation(anim)
	self.VReloadTime = self.VReloadTime + .1
	self:GetOwner():GetViewModel():SetPlaybackRate(.1)
end

function SWEP:DoBFSAnimation(anim)
	if self:GetOwner() and self:GetOwner().GetViewModel then
		local vm = self:GetOwner():GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	end
end

function SWEP:UpdateNextIdle()
	local vm = self:GetOwner():GetViewModel()
	self:SetNextIdle(CurTime() + vm:SequenceDuration())
end

function SWEP:Holster(newWep)
	self:EnforceHolsterRules(newWep)
	self:SetReady(false)
	return true
end

function SWEP:OnRemove()
end

function SWEP:OnRestore()
end

function SWEP:Precache()
end

function SWEP:OwnerChanged()
end

function SWEP:FrontBlocked()
	local Time = CurTime()
	if self.NextFrontBlockCheckTime < Time then
		self.NextFrontBlockCheckTime = Time + .25
		local ShootVec, Ang, ShootPos = self:GetOwner():GetAimVector(), self:GetOwner():GetAngles(), self:GetOwner():GetShootPos()
		ShootPos = ShootPos + ShootVec * 15
		Ang.p = 0
		Ang.r = 0
		local Tr = util.TraceLine({
			start = ShootPos - Ang:Forward() * 5,
			endpos = ShootPos + (ShootVec * self.BarrelLength) + Ang:Forward() * 15,
			filter = {self:GetOwner()}
		})

		if Tr.Hit then
			if not Tr.Entity.JIBFS_NoBlock then self.FrontallyBlocked = true end
		else
			self.FrontallyBlocked = false
		end
	end
	return self.FrontallyBlocked
end

function SWEP:BulletCallbackFunc(dmgAmt, ply, tr, dmg, tracer, hard, multi)
	if self.NumProjectiles > 1 then return end
	if tr.HitSky then return end
	if tr.MatType == MAT_FLESH then
		util.Decal("Impact.Flesh", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		timer.Simple(.05, function()
			local Tr = util.QuickTrace(tr.HitPos + tr.HitNormal, -tr.HitNormal * 10)
			if Tr.Hit then util.Decal("Impact.Flesh", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal) end
		end)
	end

	if hard then self:RicochetOrPenetrate(tr) end
end

function SWEP:RicochetOrPenetrate(initialTrace)
	local AVec, IPos, TNorm, SMul = initialTrace.Normal, initialTrace.HitPos, initialTrace.HitNormal, HMCD_SurfaceHardness[initialTrace.MatType]
	if not SMul then SMul = .5 end
	local ApproachAngle = -math.deg(math.asin(TNorm:Dot(AVec)))
	local MaxRicAngle = 60 * SMul
	-- all the way through
	if ApproachAngle > (MaxRicAngle * 1.25) then
		local MaxDist, SearchPos, SearchDist, Penetrated = (self.Damage / SMul) * .15, IPos, 5, false
		while (not Penetrated) and (SearchDist < MaxDist) do
			SearchPos = IPos + AVec * SearchDist
			local PeneTrace = util.QuickTrace(SearchPos, -AVec * SearchDist)
			if (not PeneTrace.StartSolid) and PeneTrace.Hit then
				Penetrated = true
			else
				SearchDist = SearchDist + 5
			end
		end

		if Penetrated then
			self:FireBullets({
				Attacker = self:GetOwner(),
				Damage = 1,
				Force = 1,
				Num = 1,
				Tracer = 0,
				TracerName = "",
				Dir = -AVec,
				Spread = Vector(0, 0, 0),
				Src = SearchPos + AVec
			})

			self:FireBullets({
				Attacker = self:GetOwner(),
				Damage = self.Damage * .65,
				Force = self.Damage / 15,
				Num = 1,
				Tracer = 0,
				TracerName = "",
				Dir = AVec,
				Spread = Vector(0, 0, 0),
				Src = SearchPos + AVec
			})
		end
	elseif ApproachAngle < (MaxRicAngle * .75) then
		-- ping whiiiizzzz
		sound.Play("snd_jack_hmcd_ricochet_" .. math.random(1, 2) .. ".wav", IPos, 70, math.random(90, 100))
		local NewVec = AVec:Angle()
		NewVec:RotateAroundAxis(TNorm, 180)
		local AngDiffNormal = math.deg(math.acos(NewVec:Forward():Dot(TNorm))) - 90
		NewVec:RotateAroundAxis(NewVec:Right(), AngDiffNormal * .7) -- bullets actually don't ricochet elastically
		NewVec = NewVec:Forward()
		self:FireBullets({
			Attacker = self:GetOwner(),
			Damage = self.Damage * .5,
			Force = self.Damage / 15,
			Num = 1,
			Tracer = 0,
			TracerName = "",
			Dir = -NewVec,
			Spread = Vector(0, 0, 0),
			Src = IPos + TNorm
		})
	end
end

function SWEP:OnDrop()
	local Ent = ents.Create(self.ENT)
	Ent.HmcdSpawned = self.HmcdSpawned
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	Ent:Spawn()
	Ent:Activate()
	Ent.RoundsInMag = self:Clip1()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity() / 2)
	self:Remove()
end

function SWEP:BallisticSnap(traj)
	if CLIENT then return end
	if not self.Supersonic then return end
	if self.NumProjectiles > 1 then return end
	local Src = self:GetOwner():GetShootPos()
	local TrDat = {
		start = Src,
		endpos = Src + traj * 20000,
		filter = {self:GetOwner()}
	}

	local Tr, EndPos = util.TraceLine(TrDat), Src + traj * 20000
	if Tr.Hit or Tr.HitSky then EndPos = Tr.HitPos end
	local Dist = (EndPos - Src):Length()
	if Dist > 1000 then
		for i = 1, math.floor(Dist / 500) do
			local SoundSrc = Src + traj * i * 500
			for key, ply in player.Iterator() do
				if ply ~= self:GetOwner() then
					local PlyPos = ply:GetPos()
					if (PlyPos - SoundSrc):Length() < 500 then
						local Snd = "snd_jack_hmcd_bc_" .. math.random(1, 7) .. ".wav"
						local Pitch = math.random(90, 110)
						sound.Play(Snd, ply:GetShootPos(), 50, Pitch)
					end
				end
			end
		end
	end
end

if CLIENT then
	local Crouched = 0
	local LastSprintGotten = 0
	local LastAimGotten = 0
	local LastExtraAim = 0
	function SWEP:GetViewModelPosition(pos, ang)
		if not IsValid(self:GetOwner()) then return pos, ang end
		local FT = FrameTime()
		local SprintGotten = Lerp(.1, LastSprintGotten, self:GetSprinting())
		LastSprintGotten = SprintGotten
		local AimGotten = Lerp(.1, LastAimGotten, self:GetAiming())
		LastAimGotten = AimGotten
		local Aim, Sprint, Up, Forward, Right = AimGotten, SprintGotten / 100, ang:Up(), ang:Forward(), ang:Right()
		local ExtraAim = 0
		if self:GetOwner():KeyDown(IN_FORWARD) or self:GetOwner():KeyDown(IN_BACK) or self:GetOwner():KeyDown(IN_MOVELEFT) or self:GetOwner():KeyDown(IN_MOVERIGHT) then
			ExtraAim = Lerp(4 * FT, LastExtraAim, 1)
		else
			ExtraAim = Lerp(4 * FT, LastExtraAim, 0)
		end

		LastExtraAim = ExtraAim
		local Vec = self.AimPos * (Aim / 100)
		if self.CloseAimPos and (Aim > 0) then Vec = Vec + self.CloseAimPos * ExtraAim end
		if (Aim > 0) and self:GetReady() and self.AimAng then
			ang:RotateAroundAxis(ang:Right(), self.AimAng.p * Aim / 100)
			ang:RotateAroundAxis(ang:Up(), self.AimAng.y * Aim / 100)
			ang:RotateAroundAxis(ang:Forward(), self.AimAng.r * Aim / 100)
		end

		if (Sprint > 0) and self:GetReady() then
			pos = pos + Up * self.SprintPos.z * Sprint + Forward * self.SprintPos.y * Sprint + Right * self.SprintPos.x * Sprint
			ang:RotateAroundAxis(ang:Right(), self.SprintAng.p * Sprint)
			ang:RotateAroundAxis(ang:Up(), self.SprintAng.y * Sprint)
			ang:RotateAroundAxis(ang:Forward(), self.SprintAng.r * Sprint)
		end

		pos = pos + Vec.x * Right + Vec.y * Forward + Vec.z * Up
		if self:GetOwner():KeyDown(IN_DUCK) then
			Crouched = math.Clamp(Crouched + .01, 0, 1)
		else
			Crouched = math.Clamp(Crouched - .01, 0, 1)
		end

		Crouched = Crouched * (1 - (Aim / 100))
		pos = pos + Up * Crouched
		return pos, ang
	end

	function SWEP:ViewModelDrawn(vm)
		if self.Suppressed then
			if not self.VMSuppModel then
				self.VMSuppModel = ClientsideModel("models/mass_effect_3/weapons/misc/mods/pistols/barrela.mdl")
				self.VMSuppModel:SetPos(vm:GetPos())
				self.VMSuppModel:SetParent(vm)
				self.VMSuppModel:SetNoDraw(true)
				self.VMSuppModel:SetModelScale(.7, 0)
			elseif self.SuppressedLongGun then
				local matr = vm:GetBoneMatrix(vm:LookupBone("sights_K98"))
				local pos, ang = matr:GetTranslation(), matr:GetAngles()
				self.VMSuppModel:SetRenderOrigin(pos - ang:Up() * .6 - ang:Forward() * 14.5)
				self.VMSuppModel:SetRenderAngles(ang)
				self.VMSuppModel:DrawModel()
			else
				local matr = vm:GetBoneMatrix(vm:LookupBone("barrel"))
				local pos, ang = matr:GetTranslation(), matr:GetAngles()
				self.VMSuppModel:SetRenderOrigin(pos - ang:Right() * 2.2 + ang:Forward() * .25)
				ang:RotateAroundAxis(ang:Up(), -90)
				self.VMSuppModel:SetRenderAngles(ang)
				self.VMSuppModel:DrawModel()
			end
			--self.VMSuppModel=nil
		end
	end

	function SWEP:DrawWorldModel()
		if IsValid(self:GetOwner()) and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
			if self.FuckedWorldModel then
				if not self.WModel then
					self.WModel = ClientsideModel(self.WorldModel)
					self.WModel:SetPos(self:GetOwner():GetPos())
					self.WModel:SetParent(self:GetOwner())
					self.WModel:SetNoDraw(true)
				else
					local pos, ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
					if pos and ang then
						self.WModel:SetRenderOrigin(pos + ang:Right() + ang:Up())
						ang:RotateAroundAxis(ang:Forward(), 180)
						ang:RotateAroundAxis(ang:Right(), 10)
						self.WModel:SetRenderAngles(ang)
						self.WModel:DrawModel()
					end
				end
			else
				self:DrawModel()
			end

			if self.Suppressed then
				if not self.WMSuppModel then
					self.WMSuppModel = ClientsideModel("models/mass_effect_3/weapons/misc/mods/pistols/barrela.mdl")
					self.WMSuppModel:SetPos(self:GetOwner():GetPos())
					self.WMSuppModel:SetParent(self:GetOwner())
					self.WMSuppModel:SetNoDraw(true)
					self.WMSuppModel:SetModelScale(.9, 0)
				elseif self.SuppressedLongGun then
					local pos, ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
					if pos and ang then
						self.WMSuppModel:SetRenderOrigin(pos + ang:Forward() * 47 - ang:Up() * 10 + ang:Right() * 1)
						ang:RotateAroundAxis(ang:Right(), -10)
						self.WMSuppModel:SetRenderAngles(ang)
						self.WMSuppModel:DrawModel()
					end
				else
					local pos, ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
					if pos and ang then
						self.WMSuppModel:SetRenderOrigin(pos + ang:Forward() * 16 - ang:Up() * 4.5 + ang:Right() * 2)
						ang:RotateAroundAxis(ang:Right(), -5)
						self.WMSuppModel:SetRenderAngles(ang)
						self.WMSuppModel:DrawModel()
					end
				end
			end
		end
	end

	function SWEP:FireAnimationEvent(pos, ang, event, name)
		return true
	end
	-- I do all this, bitch
end
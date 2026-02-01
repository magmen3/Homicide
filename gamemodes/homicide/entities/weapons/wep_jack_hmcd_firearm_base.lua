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
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_smallpistol")
	SWEP.BounceWeaponIcon = false
end

SWEP.Base = "weapon_base_hmcd"
SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFlip = true
SWEP.ViewModelFOV = 75
SWEP.ViewModel = "models/weapons/homicide/c_px4.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/homicide/w_px4.mdl"
SWEP.HoldType = "pistol"
SWEP.BobScale = 0 -- 1.5
SWEP.SwayScale = 1
SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = "snd_jack_hmcd_smp_close.wav"
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Tracer = 1
SWEP.Primary.TakeAmmoPerBullet = false
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Pistol"
SWEP.Secondary.Sound = ""
SWEP.Secondary.NumShots = 1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Tracer = -1
SWEP.Secondary.TakeAmmoPerBullet = false
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.BarrelMustSmoke = false
SWEP.AimTime = 3
SWEP.BearTime = 3
SWEP.SprintPos = Vector(-4, 0, -10)
SWEP.SprintAng = Angle(80, 0, 0)
SWEP.AimPos = Vector(2.08, 0, 1.4)
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
SWEP.HipFireInaccuracy = .16
SWEP.CycleType = "auto"
SWEP.ReloadType = "magazine"
SWEP.LastFire = 0
SWEP.FireAnim = "shoot1"
SWEP.DrawAnim = "draw"
SWEP.ReloadAnim = "reload"
SWEP.ReloadInterrupted = false
SWEP.HomicideSWEP = true
SWEP.CanSuicide = true
SWEP.SuicidePos = Vector(-7, 4, -18)
SWEP.SuicideAng = Angle(100, -10, -30)
SWEP.PunchMul = 1.4
SWEP.DangerLevel = 80
SWEP.OneHanded = false

if SERVER then
	concommand.Add("suicide", function(ply, cmd, args)
		ply:SetNWBool("Suiciding", not ply:GetNWBool("Suiciding", false))

		if ply:GetVR() then
			ply:SetNWBool("Suiciding", false)
		end
	end)
end
function SWEP:Initialize()
	self.NextFrontBlockCheckTime = CurTime()
	self:SetHoldType(self.HipHoldType)
	self:SetAiming(0)
	self:SetSuiciding(0)
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
	self:NetworkVar("Int", 1, "Aiming")
	self:NetworkVar("Int", 2, "Sprinting")
	self:NetworkVar("Int", 3, "Suiciding")
	self:NetworkVar("Bool", 4, "Reloading")
end

function SWEP:BulletCallback(att, tr, dmg)
	return {
		effects = true,
		damage = true
	}
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
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
	if self:Clip1() <= 0 then
		if self.Primary.Automatic then self:SetNextPrimaryFire(CurTime() + 0.8) end
		self:EmitSound("snd_jack_hmcd_click.wav", 55, 100)
		if SERVER then
			net.Start("HMCD_AmmoShow")
			net.Send(owner)
			net.Broadcast()
		end
		return
	end

	--!! Fix for FuckedWorldModel in VR (not tested)
	local handpos, handang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
	if self:GetSuiciding() < 10 then
		local WaterMul = 1
		if owner:WaterLevel() >= 2 then WaterMul = .5 end
		local dmgAmt, InAcc = (GAMEMODE.Realism:GetBool() and self.Damage * 1.4 or self.Damage) * math.Rand(.9, 1.1) * WaterMul, 1 - self.Accuracy
		if self:GetAiming() <= 95 then InAcc = InAcc + self.HipFireInaccuracy end
		local BulletTraj = (owner:GetAimVector() + VectorRand() * (InAcc / (GAMEMODE.Realism:GetBool() and 1.9 or 1))):GetNormalized()
		local bullet = {}
		bullet.Num = self.NumProjectiles
		if owner:GetVR() then
			bullet.Src = self.FuckedWorldModel and handpos or owner:GetShootPos()
		else
			bullet.Src = owner:GetShootPos()
		end
		if owner:GetVR() then
			bullet.Dir = self.FuckedWorldModel and handang or owner:GetAimVector()
		else
			bullet.Dir = BulletTraj
		end
		if owner:GetVR() then
			bullet.Spread = vector_origin
		else
			bullet.Spread = Vector(self.Spread * (GAMEMODE.Realism:GetBool() and 0.4 or 1), self.Spread * (GAMEMODE.Realism:GetBool() and 0.4 or 1), 0)
		end
		bullet.Tracer = 0
		bullet.Force = dmgAmt / 10
		bullet.Damage = dmgAmt
		bullet.Callback = function(ply, tr) ply:GetActiveWeapon():BulletCallbackFunc(dmgAmt, ply, tr, dmg, false, true, false) end
		owner:FireBullets(bullet)
		if self.Supersonic then self:BallisticSnap(BulletTraj) end
	else
		if SERVER then
			local suicdmg = DamageInfo()
			suicdmg:SetDamage(self.Damage * 10)
			suicdmg:SetAttacker(owner)
			suicdmg:SetInflictor(self)
			suicdmg:SetDamageType(DMG_BULLET)
			suicdmg:SetAmmoType(game.GetAmmoID(self.AmmoType))
			owner:TakeDamageInfo(suicdmg)
		end
	end
	if (self:Clip1() == 1) and self.LastFireAnim then
		self:DoBFSAnimation(self.LastFireAnim)
	elseif self:Clip1() > 0 then
		self:DoBFSAnimation(self.FireAnim)
		if self.FireAnimRate then owner:GetViewModel():SetPlaybackRate(self.FireAnimRate) end
	end

	if owner:GetVR() and CLIENT then
		VRMOD_TriggerHaptic("vibration_right", 0, 0.3, 15, 20)
		VRMOD_TriggerHaptic("vibration_left", 0, 0.3, 15, 20)
	end

	owner:SetAnimation(PLAYER_ATTACK1)
	local Pitch = self.ShotPitch * math.Rand(.9, 1.1)
	if SERVER then
		local Dist = 75
		if self.Suppressed then Dist = 55 end
		if self.Primary.Automatic == true then
			self:EmitSound(self.CloseFireSound, Dist, Pitch, 1, CHAN_AUTO)
			owner:EmitSound(self.CloseFireSound, Dist, Pitch, 1, CHAN_AUTO)
		else
			sound.Play(self.CloseFireSound, owner:GetShootPos() - vector_up, Dist, Pitch)
			sound.Play(self.CloseFireSound, owner:GetShootPos(), Dist, Pitch)
			sound.Play(self.CloseFireSound, owner:GetShootPos(), Dist + 1, Pitch)
		end

		sound.Play(self.FarFireSound, owner:GetShootPos() + vector_up, Dist * 2, Pitch)
		if self.ExtraFireSound then
			if self.Primary.Automatic == true then
				self:EmitSound(self.ExtraFireSound, Dist - 5, Pitch, 1, CHAN_AUTO)
			else
				sound.Play(self.ExtraFireSound, owner:GetShootPos() + VectorRand(), Dist - 5, Pitch)
			end
		end

		if self.CycleType == "manual" then timer.Simple(.1, function() if IsValid(self) and IsValid(owner) then self:EmitSound(self.CycleSound, 55, 100) end end) end
	end

	local Rightness, Upness = 4, 2
	if self:GetAiming() == 100 then
		Rightness = 0
		Upness = 0
	end

	ParticleEffect(self.MuzzleEffect, owner:GetShootPos() + owner:GetAimVector() * 20 + owner:EyeAngles():Right() * Rightness - owner:EyeAngles():Up() * Upness, owner:EyeAngles(), self)
	self.BarrelMustSmoke = true
	if SERVER and (self.CycleType == "auto") then
		local effectdata = EffectData()
		effectdata:SetOrigin(owner:GetShootPos() + owner:GetAimVector() * 15 + owner:EyeAngles():Right() * Rightness - owner:EyeAngles():Up() * Upness)
		effectdata:SetAngles(owner:GetRight():Angle())
		effectdata:SetEntity(owner)
		util.Effect(self.ShellType, effectdata, true, true)
	elseif SERVER and (self.CycleType == "manual") then
		timer.Simple(.4, function()
			if IsValid(self) and IsValid(owner) then
				local effectdata = EffectData()
				effectdata:SetOrigin(owner:GetShootPos() + owner:GetAimVector() * 15 + owner:EyeAngles():Right() * Rightness - owner:EyeAngles():Up() * Upness)
				effectdata:SetAngles(owner:GetRight():Angle())
				effectdata:SetEntity(owner)
				util.Effect(self.ShellType, effectdata, true, true)
			end
		end)
	end

	local Ang, Rec = owner:EyeAngles(), self.Recoil
	if owner.Murderer or owner.Cop then Rec = .5 end
	local RecoilY = math.Rand(.015, .03) * Rec * (GAMEMODE.Realism:GetBool() and 1.15 or 1)
	local RecoilX = math.Rand(-.03, .05) * Rec * (GAMEMODE.Realism:GetBool() and 1.15 or 1)
	if (SERVER and game.SinglePlayer()) or CLIENT then owner:SetEyeAngles((Ang:Forward() + RecoilY * Ang:Up() + Ang:Right() * RecoilX):Angle()) end
	if not owner:OnGround() then owner:SetVelocity(-owner:GetAimVector() * 10) end
	--owner:ViewPunchReset()
	owner:ViewPunch(Angle(RecoilY * -100 * self.Recoil, RecoilX * -100 * self.Recoil, 0))
	self:TakePrimaryAmmo(1)
	local Extra = 0
	if owner:WaterLevel() >= 2 then Extra = 1 end
	self:SetNextPrimaryFire(CurTime() + self.TriggerDelay + self.CycleTime + Extra)
	--	if self:GetSprinting() > 10 and SERVER and IsValid(owner) then owner:Kill() end
end

function SWEP:BarrelSmoke()
	local owner = self:GetOwner()
	if owner:WaterLevel() >= 2 then return end
	if CLIENT then
		local ent = owner:GetViewModel()
		if ent then ParticleEffectAttach("pcf_jack_mf_barrelsmoke", PATTACH_POINT_FOLLOW, ent, 2) end
	else
		for i = 0, math.random(1, 2) do
			timer.Simple(i / 2, function() if IsValid(self) and owner and owner.Alive and owner:Alive() then ParticleEffectAttach("pcf_jack_mf_barrelsmoke", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("anim_attachment_RH")) end end)
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
	local owner = self:GetOwner()
	if self.BarrelMustSmoke and math.random(1, 300) == 4 then
		self:BarrelSmoke()
		self.BarrelMustSmoke = false
	end

	if owner:GetNWBool("Suiciding") and (owner:GetVR() or not self.CanSuicide) then
		owner:SetNWBool("Suiciding", false)
		owner:SetSuiciding(0)
	end

	if self:GetSuiciding() > 10 and CLIENT then
		for i = 0, owner:GetBoneCount() do
			if owner:GetBoneName(i) == "ValveBiped.Bip01_R_Forearm" then
				local matrix = owner:GetBoneMatrix(i)
				if matrix then
					matrix:SetAngles(Angle(0, 90, 0))
					owner:SetBoneMatrix(i, matrix)
				end
			end
		end
	end

	if SERVER then
		if (self.ReloadType == "individual") and self:GetReloading() then
			if self.VReloadTime < CurTime() then
				if (self:Clip1() < self.Primary.ClipSize) and (owner:GetAmmoCount(self.AmmoType) > 0) and not self.ReloadInterrupted then
					self:SetClip1(self:Clip1() + 1)
					owner:RemoveAmmo(1, self.AmmoType)
					self:StallAnimation("after_reload", .1)
					timer.Simple(.01, function() self:ReadyAfterAnim("insert") end)
					sound.Play(self.ReloadSound, owner:GetShootPos(), 55, 100)
				else
					self:SetReloading(false)
					self:ReadyAfterAnim("after_reload")
					timer.Simple(.25, function() if IsValid(self) and IsValid(owner) then self:EmitSound(self.CycleSound, 55, 90) end end)
					timer.Simple(.5, function() if IsValid(self) and IsValid(owner) then self:SetReady(true) end end)
				end
			end
		end

		local Sprintin, Aimin, AimAmt, SprintAmt = owner:IsSprinting(), owner:KeyDown(IN_ATTACK2), self:GetAiming(), self:GetSprinting()
		local SuicIn, SuicAmt = owner:GetNWBool("Suiciding"), self:GetSuiciding()
		if SuicAmt <= 0 and (Sprintin or self:FrontBlocked()) and self:GetReady() then
			self:SetSprinting(math.Clamp(SprintAmt + 40 * (1 / self.BearTime), 0, 100))
			self:SetAiming(math.Clamp(AimAmt - 40 * (1 / self.AimTime), 0, 100))
		elseif SuicAmt <= 0 and Aimin and owner:OnGround() and not ((self.CycleType == "manual") and (self.LastFire + .75 > CurTime())) then
			self:SetAiming(math.Clamp(AimAmt + 20 * (1 / self.AimTime), 0, 100))
			self:SetSprinting(math.Clamp(SprintAmt - 20 * (1 / self.BearTime), 0, 100))
		elseif SuicIn then
			self:SetReady(true)
			self:SetSuiciding(math.Clamp(SuicAmt + 20 * (1 / self.AimTime), 0, 100))
			self:SetAiming(math.Clamp(AimAmt - 40 * (1 / self.AimTime), 0, 100))
			self:SetSprinting(math.Clamp(SprintAmt - 20 * (1 / self.BearTime), 0, 100))
		else
			self:SetSuiciding(math.Clamp(SuicAmt - 20 * (1 / self.AimTime), 0, 100))
			self:SetAiming(math.Clamp(AimAmt - 40 * (1 / self.AimTime), 0, 100))
			self:SetSprinting(math.Clamp(SprintAmt - 20 * (1 / self.BearTime), 0, 100))
		end

		local HoldType = self.HipHoldType
		if not SuicIn and SprintAmt > 90 then
			HoldType = self.DownHoldType
		elseif not SuicIn and Aimin and not owner:Crouching() then
			HoldType = self.AimHoldType
		elseif SuicIn then
			HoldType = "normal"
		else
			HoldType = self.HipHoldType
		end

		self:SetHoldType(HoldType)
	end
end

function SWEP:Reload()
	local owner = self:GetOwner()
	self.ReloadInterrupted = false
	if not IsFirstTimePredicted() then return end
	if not (IsValid(self) and IsValid(owner)) then return end
	if not self:GetReady() then return end
	if self:GetSprinting() > 0 then return end
	if SERVER then
		net.Start("HMCD_AmmoShow")
		net.Send(owner)
		net.Broadcast()
	end

	if (self:Clip1() < self.Primary.ClipSize) and (owner:GetAmmoCount(self.AmmoType) > 0) then
		local TacticalReload = self:Clip1() > 0
		self:SetReady(false)
		owner:SetAnimation(PLAYER_RELOAD)
		if (self.ReloadType == "clip") or (self.ReloadType == "magazine") then
			if TacticalReload and self.TacticalReloadAnim then
				self:DoBFSAnimation(self.TacticalReloadAnim)
			else
				self:DoBFSAnimation(self.ReloadAnim)
			end

			owner:GetViewModel():SetPlaybackRate(self.ReloadRate)
			self:EmitSound(self.ReloadSound, 65, 100)
			if SERVER then
				if self.CycleType == "revolving" then
					timer.Simple(self.ReloadTime / 3, function()
						if IsValid(self) and IsValid(owner) then
							for i = 1, self.Primary.ClipSize - self:Clip1() do
								local effectdata = EffectData()
								effectdata:SetOrigin(owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Forearm")))
								effectdata:SetAngles((-vector_up):Angle())
								effectdata:SetEntity(owner)
								util.Effect(self.ShellType, effectdata, true, true)
							end
						end
					end)
				end

				local ReloadAdd = 0
				if not TacticalReload then ReloadAdd = .2 end
				timer.Simple(self.ReloadTime + ReloadAdd, function()
					if IsValid(self) and IsValid(owner) then
						self:SetReady(true)
						local Missing, Have = self.Primary.ClipSize - self:Clip1(), owner:GetAmmoCount(self.AmmoType)
						if Missing <= Have then
							owner:RemoveAmmo(Missing, self.AmmoType)
							self:SetClip1(self.Primary.ClipSize)
						elseif Missing > Have then
							self:SetClip1(self:Clip1() + Have)
							owner:RemoveAmmo(Have, self.AmmoType)
							net.Start("HMCD_AmmoShow")
							net.Send(owner)
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
	local owner = self:GetOwner()
	if IsValid(self) and IsValid(owner) then
		if not IsFirstTimePredicted() then
			self:DoBFSAnimation(self.DrawAnim)
			owner:GetViewModel():SetPlaybackRate(.1)
			return
		end

		self:DoBFSAnimation(self.DrawAnim)
		owner:GetViewModel():SetPlaybackRate(.5)
		if not owner:GetVR() then
			self:SetReady(false)
		end
		self:EmitSound("snd_jack_hmcd_pistoldraw.wav", 70, self.HandlingPitch)
		self:EnforceHolsterRules(self)
		owner:SetNWBool("Suiciding", false)
		timer.Simple(1.5, function() if IsValid(self) then self:SetReady(true) end end)

		return true
	end
end

function SWEP:EnforceHolsterRules(newWep)
	if CLIENT then return end
	if newWep ~= self then -- only enforce rules for us
		return
	end

	for key, wep in ipairs(self:GetOwner():GetWeapons()) do
		-- conflict
		if wep.HolsterSlot and self.HolsterSlot and (wep.HolsterSlot == self.HolsterSlot) and (wep ~= self) then self:GetOwner():DropWeapon(wep) end
	end
end

function SWEP:StallAnimation(anim, time)
	self:DoBFSAnimation(anim)
	self.VReloadTime = self.VReloadTime + .1
	self:GetOwner():GetViewModel():SetPlaybackRate(.1)
end

function SWEP:DoBFSAnimation(anim)
	local owner = self:GetOwner()
	if IsValid(owner) and owner.GetViewModel then
		local vm = owner:GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	end
end

function SWEP:UpdateNextIdle()
	local vm = self:GetOwner():GetViewModel()
	self:SetNextIdle(CurTime() + vm:SequenceDuration())
end

local vecfull = Vector(1, 1, 1)
function SWEP:Holster()
	local ply = self:GetOwner()
	self:EnforceHolsterRules(newWep)

	if IsValid(ply) then
		if not ply:GetVR() then
			self:SetReady(false)
		end
		ply:SetNWBool("Suiciding", false)

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

function SWEP:FrontBlocked()
	local Time = CurTime()
	local owner = self:GetOwner()
	if self.NextFrontBlockCheckTime < Time then
		self.NextFrontBlockCheckTime = Time + .25
		local ShootVec, Ang, ShootPos = owner:GetAimVector(), owner:GetAngles(), owner:GetShootPos()
		ShootPos = ShootPos + ShootVec * 15
		Ang.p = 0
		Ang.r = 0
		local Tr = util.TraceLine({
			start = ShootPos - Ang:Forward() * 5,
			endpos = ShootPos + (ShootVec * self.BarrelLength) + Ang:Forward() * 15,
			filter = {owner}
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
		local MaxDist, SearchPos, SearchDist, Penetrated = ((GAMEMODE.Realism:GetBool() and self.Damage * 1.4 or self.Damage) / SMul) * .15, IPos, 5, false
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
				Spread = vector_origin,
				Src = SearchPos + AVec
			})

			self:FireBullets({
				Attacker = self:GetOwner(),
				Damage = (GAMEMODE.Realism:GetBool() and self.Damage * 1.4 or self.Damage) * .65,
				Force = self.Damage / 15,
				Num = 1,
				Tracer = 0,
				TracerName = "",
				Dir = AVec,
				Spread = vector_origin,
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
			Damage = (GAMEMODE.Realism:GetBool() and self.Damage * 1.4 or self.Damage) * .5,
			Force = self.Damage / 15,
			Num = 1,
			Tracer = 0,
			TracerName = "",
			Dir = -NewVec,
			Spread = vector_origin,
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
	local c_oang, c_dang = Angle(0, 0, 0), Angle(0, 0, 0)
	local c_jump, c_look, c_move, c_sight = 0, 0, 0, 0
	local angdelta = Angle()

	function SWEP:Sway(pos, ang, ft)
		local owner = self:GetOwner()
		if not IsValid(self or owner) then return end
		local sway = 14 * (owner:OnGround() and 1 or 1.5)

		angdelta = LerpAngle(ft * 6, angdelta, owner:EyeAngles() - c_oang)
		if angdelta.y >= 180 then
			angdelta.y = angdelta.y - 360
		elseif angdelta.y <= -180 then
			angdelta.y = angdelta.y + 360
		end

		--print(angdelta)
		angdelta.p = math.Clamp(angdelta.p, -1, 1)
		angdelta.y = math.Clamp(angdelta.y, -1, 1)
		angdelta.r = math.Clamp(angdelta.r, -1, 1)
		if self.ViewModelFlip then
			angdelta = -angdelta
		end
		angdelta = angdelta * 0.5

		local newang = LerpAngle(ft * 4, c_dang, angdelta)
		c_dang = newang
		c_oang = owner:EyeAngles()

		ang:RotateAroundAxis(ang:Right(), -c_dang.p * sway * 3.5)
		ang:RotateAroundAxis(ang:Up(), c_dang.y * sway * 3.5)
		ang:RotateAroundAxis(ang:Forward(), c_dang.y * sway * 1.5)
		pos = pos + ang:Right() * c_dang.y * sway + ang:Up() * c_dang.p * sway
		return pos, ang
	end

	function SWEP:Movement(pos, ang, ct, ft)
		local owner = self:GetOwner()
		if not IsValid(self or owner) then return end
		local bob = 1.5 * (owner:OnGround() and 1 or 1.5)
		local idle = 2 * (owner:OnGround() and 1 or 1.5)

		if self:GetAiming() then
			local asd = math.Clamp(1 - (self:GetAiming() / 100), 0.5, 1)
			--print(asd)
			bob = bob * asd
		end

		local move = Vector(owner:GetVelocity().x, owner:GetVelocity().y, 0)
		local movement = move:LengthSqr()
		local movepercent = math.Clamp(movement / owner:GetRunSpeed() ^ 2, 0, 1)
		local vel = move:GetNormalized()
		local rd = owner:GetRight():Dot(vel)
		local fd = (owner:GetForward():Dot(vel) + 1) / 2
		local ft8 = ft * 4
		c_move = Lerp(ft8, c_move or 0, owner:OnGround() and movepercent or 0)
		c_sight = Lerp(ft8, c_sight or 0, self:GetAiming() and owner:OnGround() and 0.15 or 1)
		c_jump = Lerp(ft8, c_jump or 0, owner:GetMoveType() == MOVETYPE_NOCLIP and 0 or math.Clamp(owner:GetVelocity().z / 120, -1.5, 1))
		if rd > 0.5 then
			c_look = Lerp(math.Clamp(ft * 5, 0, 1), c_look, 5 * c_move)
		elseif rd < -0.5 then
			c_look = Lerp(math.Clamp(ft * 5, 0, 1), c_look, -5 * c_move)
		else
			c_look = Lerp(math.Clamp(ft * 5, 0, 1), c_look, 0)
		end

		pos = pos + ang:Up() * c_jump
		ang.p = ang.p + (c_jump or 0) * 2
		ang.r = ang.r + c_look
		if bob ~= 0 and c_move > 0 then
			local p = c_move * c_sight * bob
			pos = pos - ang:Forward() * c_move * c_sight * fd - ang:Up() * 0.75 * c_move * c_sight
			local viewmul = view and 5 or 1
			ang.y = ang.y + math.sin(ct * 8.4 * viewmul) * 3.2 * p
			ang.p = ang.p + math.sin(ct * 16 * viewmul) * 3.3 * p
			ang.r = ang.r + math.cos(ct * 8.4 * viewmul) * 8 * p
		end

		if idle ~= 0 then
			local p = (1 - c_move) * c_sight * idle
			ang.p = ang.p + math.sin(ct * 1.5) * 1.2 * p
			ang.y = ang.y + math.sin(ct * 1) * 0.7 * p
			ang.r = ang.r + math.sin(ct * 3) * 0.6 * p
		end
		return pos, ang
	end

	local Crouched = 0
	local SprintGotten = 0
	local SuicGotten = 0
	local AimGotten = 0
	local ExtraAim = 0
	function SWEP:GetViewModelPosition(pos, ang)
		local owner = self:GetOwner()
		local FT = FrameTime()
		pos, ang = self:Sway(pos, ang, FT)
		pos, ang = self:Movement(pos, ang, CurTime(), FT * 2)
		SprintGotten = Lerp(FT * 5, SprintGotten, self:GetSprinting())
		SuicGotten = Lerp(FT * 5, SuicGotten, self:GetSuiciding())
		AimGotten = Lerp(FT * 5, AimGotten, self:GetAiming())
		local Aim, Sprint, Up, Forward, Right = AimGotten, SprintGotten / 100, ang:Up(), ang:Forward(), ang:Right()
		local Suicid = SuicGotten / 100
		if owner:KeyDown(IN_FORWARD) or owner:KeyDown(IN_BACK) or owner:KeyDown(IN_MOVELEFT) or owner:KeyDown(IN_MOVERIGHT) then
			ExtraAim = Lerp(FT * 4, ExtraAim, 1)
		else
			ExtraAim = Lerp(FT * 4, ExtraAim, 0)
		end
	
		local Vec = self.AimPos * (Aim / 100)
		if self.CloseAimPos and (Aim > 0) then Vec = Vec + self.CloseAimPos * ExtraAim end

		if Aim > 0 and self:GetReady() and self.AimAng then
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

		if (Suicid > 0) and self:GetReady() and self.SuicidePos then
			pos = pos + Up * self.SuicidePos.z * Suicid + Forward * self.SuicidePos.y * Suicid + Right * self.SuicidePos.x * Suicid
			ang:RotateAroundAxis(ang:Right(), self.SuicideAng.p * Suicid)
			ang:RotateAroundAxis(ang:Up(), self.SuicideAng.y * Suicid)
			ang:RotateAroundAxis(ang:Forward(), self.SuicideAng.r * Suicid)
		end
		pos = pos + Vec.x * Right + Vec.y * Forward + Vec.z * Up
		Crouched = Lerp(FT * 1, Crouched, owner:KeyDown(IN_DUCK) and 1 or 0)

		Crouched = Crouched * (1 - (Aim / 100))

		local VPAimMul = math.Clamp(Aim / 50, 1, 2)
		ang = ang + ((owner:GetViewPunchAngles() / VPAimMul) * self.PunchMul)

		pos = pos + Up * Crouched + Forward * (1.5 * Crouched)

		return pos, ang
	end

	local RHIKBones = {
		"ValveBiped.Bip01_R_UpperArm",
		"ValveBiped.Bip01_R_Forearm",
		"ValveBiped.Bip01_R_Wrist",
		"ValveBiped.Bip01_R_Ulna",
		"ValveBiped.Bip01_R_Hand",
		"ValveBiped.Bip01_R_Finger4",
		"ValveBiped.Bip01_R_Finger41",
		"ValveBiped.Bip01_R_Finger42",
		"ValveBiped.Bip01_R_Finger3",
		"ValveBiped.Bip01_R_Finger31",
		"ValveBiped.Bip01_R_Finger32",
		"ValveBiped.Bip01_R_Finger2",
		"ValveBiped.Bip01_R_Finger21",
		"ValveBiped.Bip01_R_Finger22",
		"ValveBiped.Bip01_R_Finger1",
		"ValveBiped.Bip01_R_Finger11",
		"ValveBiped.Bip01_R_Finger12",
		"ValveBiped.Bip01_R_Finger0",
		"ValveBiped.Bip01_R_Finger01",
		"ValveBiped.Bip01_R_Finger02"
	}

	local LHIKBones = {
		"ValveBiped.Bip01_L_UpperArm",
		"ValveBiped.Bip01_L_Forearm",
		"ValveBiped.Bip01_L_Wrist",
		"ValveBiped.Bip01_L_Ulna",
		"ValveBiped.Bip01_L_Hand",
		"ValveBiped.Bip01_L_Finger4",
		"ValveBiped.Bip01_L_Finger41",
		"ValveBiped.Bip01_L_Finger42",
		"ValveBiped.Bip01_L_Finger3",
		"ValveBiped.Bip01_L_Finger31",
		"ValveBiped.Bip01_L_Finger32",
		"ValveBiped.Bip01_L_Finger2",
		"ValveBiped.Bip01_L_Finger21",
		"ValveBiped.Bip01_L_Finger22",
		"ValveBiped.Bip01_L_Finger1",
		"ValveBiped.Bip01_L_Finger11",
		"ValveBiped.Bip01_L_Finger12",
		"ValveBiped.Bip01_L_Finger0",
		"ValveBiped.Bip01_L_Finger01",
		"ValveBiped.Bip01_L_Finger02"
	}

	local delta = 1
	local vechands = Vector(0.75, 0.75, 0.75)
	local flipMatrix = Matrix({
		{ 1, 0, 0, 0 },
		{ 0, 1, 0, 0 },
		{ 0, 0, -1, 0 },
		{ 0, 0, 0, 1 }
	})
	function SWEP:ViewModelDrawn(vm)
		-- lhik stuff
		if GAMEMODE.Realism:GetBool() then
			local ea = EyeAngles()
			local onehand = self.OneHanded and self:GetAiming() <= 0 and self:GetReady() and not self:GetOwner():Crouching() or self:GetSuiciding() > 10
			delta = Lerp(FrameTime() * 4, delta, onehand and 1 or 0)

			for _, bone in ipairs(self.ViewModelFlip and RHIKBones or LHIKBones) do
				local vmbone = vm:LookupBone(bone)
				if !vmbone then continue end

				local vmtransform = vm:GetBoneMatrix(vmbone)
				if !vmtransform then continue end

				--[[
					{ x, 0, 0, 0 },
					{ 0, y, 0, 0 },
					{ 0, 0, z, 0 },
					{ 0, 0, 0, w }
				]]
				if self.ViewModelFlip then
					vmtransform = vmtransform * flipMatrix
				end

				local vm_pos = vmtransform:GetTranslation()
				local vm_ang = vmtransform:GetAngles()

				local newtransform = Matrix()

				newtransform:SetTranslation(LerpVector(delta, vm_pos, vm_pos - (ea:Up() * 6) - (ea:Forward() * 12) - (ea:Right() * 4)))
				newtransform:SetAngles(vm_ang)

				if self.ShitHands then
					newtransform:SetScale(vechands)
				end

				if self.ViewModelFlip then -- omg that's workin!!
					newtransform = newtransform * flipMatrix

					-- print(newtransform)
				end

				vm:SetBoneMatrix(vmbone, newtransform)
			end
		end

		if self.ShitHands then
			for i = 0, vm:GetBoneCount() do
				if vm:GetBoneName(i) == "__INVALIDBONE__" then
					continue
				end

				if string.find(vm:GetBoneName(i), "ValveBiped") then
					local matrix = vm:GetBoneMatrix(i)
					if matrix then
						matrix:SetScale(vechands)
						vm:SetBoneMatrix(i, matrix)
					end
				end
			end
		end

		if self.CustomVMDrawn then
			self:CustomVMDrawn(vm)
		end

		if self.Suppressed then
			if not self.VMSuppModel then
				self.VMSuppModel = ClientsideModel("models/mass_effect_3/weapons/misc/mods/pistols/barrela.mdl")
				self.VMSuppModel:SetPos(vm:GetPos())
				self.VMSuppModel:SetParent(vm)
				self.VMSuppModel:SetNoDraw(true)
				self.VMSuppModel:SetModelScale(.7, 0)
			elseif self.SuppressedLongGun then
				local bone = vm:LookupBone("sights_K98")
				if not bone then return end
				local matr = vm:GetBoneMatrix(bone)
				if not matr then return end
				local pos, ang = matr:GetTranslation(), matr:GetAngles()
				self.VMSuppModel:SetRenderOrigin(pos - ang:Up() * .6 - ang:Forward() * 14.5)
				self.VMSuppModel:SetRenderAngles(ang)
				self.VMSuppModel:DrawModel()
			else
				local bone = vm:LookupBone("barrel")
				if not bone then return end
				local matr = vm:GetBoneMatrix(bone)
				if not matr then return end
				local pos, ang = matr:GetTranslation(), matr:GetAngles()
				self.VMSuppModel:SetRenderOrigin(pos - ang:Right() * 2.2 + ang:Forward() * .25)
				ang:RotateAroundAxis(ang:Up(), -90)
				self.VMSuppModel:SetRenderAngles(ang)
				self.VMSuppModel:DrawModel()
			end
			--self.VMSuppModel=nil
		end
	end

	function SWEP:DrawWorldModel() --!! TODO: Refactor all this wm stuff
		local owner = self:GetOwner()
		if IsValid(owner) and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
			if self.FuckedWorldModel then
				if not self.WModel then
					self.WModel = ClientsideModel(self.WorldModel)
					self.WModel:SetPos(owner:GetPos())
					self.WModel:SetParent(owner)
					self.WModel:SetNoDraw(true)
				else
					local pos, ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
					if owner:GetVR() then
						pos, ang = g_VR.tracking.pose_righthand.pos, g_VR.tracking.pose_righthand.ang
					end
					if pos and ang then
						if not owner:GetVR() then
							self.WModel:SetRenderOrigin(pos + ang:Right() + ang:Up())
							ang:RotateAroundAxis(ang:Forward(), 180)
							ang:RotateAroundAxis(ang:Right(), 10)
							if owner:GetNWBool("Suiciding") then
								ang:RotateAroundAxis(ang:Forward(), -15)
								ang:RotateAroundAxis(ang:Right(), 140)
							end
						else
							self.WModel:SetRenderOrigin(pos + ang:Forward() * 1 + ang:Right() * -2 + ang:Up() * -2)
						end
						self.WModel:SetRenderAngles(ang)
						self.WModel:SetPos(pos)
						self.WModel:SetAngles(ang)
						self.WModel:DrawModel()
					end
				end
			else
				self:DrawModel()
			end

			if self.Suppressed then
				if not self.WMSuppModel then
					self.WMSuppModel = ClientsideModel("models/mass_effect_3/weapons/misc/mods/pistols/barrela.mdl")
					self.WMSuppModel:SetPos(owner:GetPos())
					self.WMSuppModel:SetParent(owner)
					self.WMSuppModel:SetNoDraw(true)
					self.WMSuppModel:SetModelScale(.9, 0)
				elseif self.SuppressedLongGun then
					local pos, ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
					if pos and ang then
						self.WMSuppModel:SetRenderOrigin(pos + ang:Forward() * 47 - ang:Up() * 10 + ang:Right() * 1)
						ang:RotateAroundAxis(ang:Right(), -10)
						self.WMSuppModel:SetRenderAngles(ang)
						self.WMSuppModel:DrawModel()
					end
				else
					local pos, ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
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
end
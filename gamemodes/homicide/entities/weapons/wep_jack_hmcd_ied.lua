if SERVER then
	AddCSLuaFile()
	util.AddNetworkString("hmcd_splodetype")
elseif CLIENT then
	SWEP.Slot = 4
	SWEP.SlotPos = 1
	local function drawTextShadow(t, f, x, y, c, px, py)
		color_black.a = c.a
		draw.SimpleText(t, f, x + 1, y + 1, color_black, px, py)
		draw.SimpleText(t, f, x, y, c, px, py)
		color_black.a = 255
	end

	net.Receive("hmcd_splodetype", function()
		local Ent = net.ReadEntity()
		Ent.SplodeType = net.ReadInt(32)
	end)

	function SWEP:DrawHUD()
		if not self:GetRigged() then
			local Ent, TrPos, TrNorm = HMCD_WhomILookinAt(self:GetOwner(), .2, 55)
			if IsValid(Ent) and ((Ent:GetClass() == "prop_physics") or (Ent:GetClass() == "prop_physics_multiplayer") or (Ent:GetClass() == "prop_ragdoll")) then
				local W, H = ScrW(), ScrH()
				drawTextShadow(translate.weaponIEDRig, "MersRadialSmall", W / 2, H / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				if Ent.SplodeType then
					if Ent.SplodeType == 2 then
						drawTextShadow(translate.weaponIEDFragments, "MersRadialSmall", W / 2, H / 2 + 25, Color(0, 255, 255, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					elseif Ent.SplodeType == 3 then
						drawTextShadow(translate.weaponIEDFire, "MersRadialSmall", W / 2, H / 2 + 25, Color(0, 255, 255, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				end
			end
		end
	end
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/props_junk/cardboard_jox004a.mdl"
SWEP.WorldModel = "models/props_junk/cardboard_jox004a.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_ied")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponIED
SWEP.Instructions = translate.weaponIEDDesc
SWEP.CarryWeight = 2000
SWEP.DownAmt = 16
SWEP.HoldType = "normal"

function SWEP:Initialize()
	self:SetRigged(false)
	self:SetHoldType(self.HoldType)
	self.PrintName = translate.weaponIED
	self.Instructions = translate.weaponIEDDesc
	self.DownAmt = 16
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Rigged")
end

function SWEP:UseActivate()
	if self:GetRigged() then self:GetOwner():SetAnimation(PLAYER_ATTACK1) end
	if CLIENT then return end
	if self:GetRigged() then
		self:SetNextPrimaryFire(CurTime() + 1)
		if self.Explosive and IsValid(self.Explosive) then
			sound.Play("snd_jack_hmcd_detonator.wav", self:GetOwner():GetShootPos(), 50, 110)
			sound.Play("snd_jack_hmcd_beep.wav", self.Explosive:GetPos(), 75, 100)
			local Splosive = self.Explosive
			timer.Simple(.5, function() if IsValid(Splosive) then Splosive:ExplodeIED() end end)
		end

		timer.Simple(.05, function()
			self:SetRigged(false)
			self:Remove()
		end)
		return
	end

	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + .25)
	self:DeployFront(true)
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end
	if self:GetOwner():IsSprinting() then return end
	self:SetNextSecondaryFire(CurTime() + 1)
	if self:GetRigged() then return end
	self:DeployFront(false)
end

function SWEP:Think()
	if SERVER then
		if not self:GetRigged() then
			local Ent, TrPos, TrNorm = HMCD_WhomILookinAt(self:GetOwner(), .2, 55)
			if Ent and IsValid(Ent) and ((Ent:GetClass() == "prop_physics") or (Ent:GetClass() == "prop_physics_multiplayer") or (Ent:GetClass() == "prop_ragdoll")) then
				local Type = HMCD_ExplosiveType(Ent)
				net.Start("hmcd_splodetype")
				net.WriteEntity(Ent)
				net.WriteInt(Type, 32)
				net.Send(self:GetOwner())
			end
		end
	end

	if self:GetRigged() then
		self:SetHoldType("normal")
	else
		self:SetHoldType("slam")
	end
end

function SWEP:DeployFront(proper)
	if CLIENT then return end
	self:GetOwner():LagCompensation(true)
	local Ent, HitPos, HitNorm = HMCD_WhomILookinAt(self:GetOwner(), .2, 55)
	local AimVec, Obvious, GoodToGo = self:GetOwner():GetAimVector(), nil, false
	if proper and (IsValid(Ent) and ((Ent:GetClass() == "prop_physics") or (Ent:GetClass() == "prop_physics_multiplayer") or (Ent:GetClass() == "prop_ragdoll"))) then
		Obvious = false
		GoodToGo = true
	elseif not proper then
		local Pos = HitPos or self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 30
		Ent = ents.Create("prop_physics")
		Ent.HmcdSpawned = self.HmcdSpawned
		Ent:SetModel("models/props_junk/cardboard_jox004a.mdl")
		Ent:SetPos(Pos)
		Ent:Spawn()
		Ent:SetModelScale(.5, .01)
		Ent:Activate()
		Ent:SetHealth(1)
		Ent:GetPhysicsObject():SetMass(20)
		Ent:GetPhysicsObject():SetVelocity(self:GetOwner():GetVelocity())
		Ent:GetPhysicsObject():SetDamping(3, 2)
		Obvious = true
		GoodToGo = true
	end

	if Ent and GoodToGo then
		if not HitPos then HitPos = Ent:GetPos() end
		self:GetOwner():ViewPunch(Angle(1, 0, 0))
		Ent.MurdererExplosive = true
		Ent.IEDAttacker = self:GetOwner()
		self.Explosive = Ent
		if Obvious then
			sound.Play("snd_jack_hmcd_bombrig.wav", HitPos, 50, 100)
		else
			sound.Play("snd_jack_hmcd_bombrig.wav", HitPos, 35, 100)
		end

		timer.Simple(.1, function()
			net.Start("hmcd_hudhalo")
			net.WriteEntity(Ent)
			net.WriteInt(4, 32)
			net.Send(self:GetOwner())
		end)

		self:SetRigged(true)
		self:SetNextPrimaryFire(CurTime() + 1)
	end

	self:GetOwner():LagCompensation(false)
end

if CLIENT then
	local Hidden = 0
	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 16 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 16 or 0)

		if self:GetRigged() then
			Hidden = 22
		else
			Hidden = 0
		end

		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		local NewPos = pos + ang:Forward() * 50 - ang:Up() * (20 + self.DownAmt + Hidden) + ang:Right() * 20
		return NewPos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self:GetRigged() then
			if self.DatDetModel then
				self.DatDetModel:SetRenderOrigin(Pos + Ang:Forward() * 4 + Ang:Right() * 1)
				Ang:RotateAroundAxis(Ang:Up(), 90)
				Ang:RotateAroundAxis(Ang:Right(), 180)
				self.DatDetModel:SetRenderAngles(Ang)
				self.DatDetModel:DrawModel()
			else
				self.DatDetModel = ClientsideModel("models/weapons/w_models/w_jda_engineer.mdl")
				self.DatDetModel:SetPos(self:GetPos())
				self.DatDetModel:SetParent(self)
				self.DatDetModel:SetNoDraw(true)
				self.DatDetModel:SetModelScale(.35, 0)
			end
		else
			if self.DatWorldModel then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 4 + Ang:Right() * 4)
				Ang:RotateAroundAxis(Ang:Up(), -30)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			else
				self.DatWorldModel = ClientsideModel("models/props_junk/cardboard_jox004a.mdl")
				self.DatWorldModel:SetPos(self:GetPos())
				self.DatWorldModel:SetParent(self)
				self.DatWorldModel:SetNoDraw(true)
				self.DatWorldModel:SetModelScale(.5, 0)
			end
		end
	end

	function SWEP:ViewModelDrawn(model)
		local Pos, Ang = model:GetPos(), model:GetAngles()
		if self:GetRigged() then
			if self.DatDetViewModel then
				if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
					self.DatDetViewModel:SetRenderOrigin(Pos + Ang:Up() * 20)
					Ang:RotateAroundAxis(Ang:Up(), 180)
					Ang:RotateAroundAxis(Ang:Right(), 30)
					self.DatDetViewModel:SetRenderAngles(Ang)
					self.DatDetViewModel:DrawModel()
				end
			else
				self.DatDetViewModel = ClientsideModel("models/weapons/w_models/w_jda_engineer.mdl")
				self.DatDetViewModel:SetPos(self:GetPos())
				self.DatDetViewModel:SetParent(self)
				self.DatDetViewModel:SetNoDraw(true)
				self.DatDetViewModel:SetModelScale(.5, 0)
			end
		end
	end
end
if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.Slot = 4
	SWEP.SlotPos = 5
	function SWEP:DrawHUD()
		local Go = self:FindObjects()
		if Go then
			local Rand = 150 --math.random(100, 200)
			surface.DrawCircle(ScrW() / 2, ScrH() / 2, 50, Color(Rand, Rand, Rand, 200))
			surface.DrawCircle(ScrW() / 2, ScrH() / 2, 49, Color(Rand, Rand, Rand, 200))
			surface.DrawCircle(ScrW() / 2, ScrH() / 2, 48, Color(Rand, Rand, Rand, 200))
		end
	end
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/props_phx/wheels/drugster_front.mdl"
SWEP.WorldModel = "models/props_phx/wheels/drugster_front.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_ducttape")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponDuctTape
SWEP.Instructions = translate.weaponDuctTapeDesc
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ENT = "ent_jack_hmcd_ducttape"
SWEP.UnTapeables = {MAT_SAND, MAT_SLOSH, MAT_SNOW}
SWEP.CarryWeight = 400
SWEP.HoldType = "slam"
SWEP.DownAmt = 20
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.DownAmt = 20
	self.PrintName = translate.weaponDuctTape
	self.Instructions = translate.weaponDuctTapeDesc
end

function SWEP:FindObjects()
	local Pos, Vec, GotOne, Tries, TrOne, TrTwo = self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector(), false, 0, nil, nil
	while not GotOne and (Tries < 100) do
		local Tr = util.QuickTrace(Pos, Vec * 60 + VectorRand() * 2, {self:GetOwner()})
		if Tr.Hit and not Tr.HitSky and not table.HasValue(self.UnTapeables, Tr.MatType) then
			GotOne = true
			TrOne = Tr
		end

		Tries = Tries + 1
	end

	if GotOne then
		GotOne = false
		Tries = 0
		while not GotOne and (Tries < 100) do
			local Tr = util.QuickTrace(Pos, Vec * 60 + VectorRand() * 2, {self:GetOwner()})
			if Tr.Hit and not Tr.HitSky and not table.HasValue(self.UnTapeables, Tr.MatType) and (Tr.Entity ~= TrOne.Entity) then
				GotOne = true
				TrTwo = Tr
			end

			Tries = Tries + 1
		end
	end

	if TrOne and TrTwo then
		return true, TrOne, TrTwo
	else
		return false, nil, nil
	end
end

function SWEP:UseActivate()
	if SERVER then
		local Go, TrOne, TrTwo = self:FindObjects()
		if Go then
			local DoorSealed = false
			if HMCD_IsDoor(TrOne.Entity) then
				DoorSealed = true
				TrOne.Entity:Fire("lock", "", 0)
			end

			if HMCD_IsDoor(TrTwo.Entity) then
				DoorSealed = true
				TrTwo.Entity:Fire("lock", "", 0)
			end

			if DoorSealed then
				if not self.TapeAmount then self.TapeAmount = 100 end
				self.TapeAmount = self.TapeAmount - 100
				sound.Play("snd_jack_hmcd_ducttape.wav", TrOne.HitPos, 65, math.random(80, 120))
				self:GetOwner():SetAnimation(PLAYER_ATTACK1)
				self:GetOwner():ViewPunch(Angle(3, 0, 0))
				self:SprayDecals()
				self:GetOwner():PrintMessage(HUD_PRINTCENTER, translate.weaponDoorSealed)
				timer.Simple(.1, function() if self.TapeAmount <= 0 then self:Remove() end end)
			else
				local Strength = HMCD_BindObjects(TrOne.Entity, TrOne.HitPos, TrTwo.Entity, TrTwo.HitPos, 8)
				if not self.TapeAmount then self.TapeAmount = 100 end
				self.TapeAmount = self.TapeAmount - 10
				sound.Play("snd_jack_hmcd_ducttape.wav", TrOne.HitPos, 65, math.random(80, 120))
				self:GetOwner():SetAnimation(PLAYER_ATTACK1)
				self:GetOwner():ViewPunch(Angle(3, 0, 0))
				util.Decal("hmcd_jackatape", TrOne.HitPos + TrOne.HitNormal, TrOne.HitPos - TrOne.HitNormal)
				util.Decal("hmcd_jackatape", TrTwo.HitPos + TrTwo.HitNormal, TrTwo.HitPos - TrTwo.HitNormal)
				self:GetOwner():PrintMessage(HUD_PRINTCENTER, "Strength: " .. tostring(Strength))
				timer.Simple(.1, function() if self.TapeAmount <= 0 then self:Remove() end end)
			end
		end
	end

	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + 2.5)
end

local util = util
function SWEP:SprayDecals()
	local Tr = util.QuickTrace(self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector() * 70, {self:GetOwner()})
	util.Decal("hmcd_jackatape", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
	local Tr2 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(0, 0, .15)) * 70, {self:GetOwner()})
	util.Decal("hmcd_jackatape", Tr2.HitPos + Tr2.HitNormal, Tr2.HitPos - Tr2.HitNormal)
	local Tr3 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(0, 0, -.15)) * 70, {self:GetOwner()})
	util.Decal("hmcd_jackatape", Tr3.HitPos + Tr3.HitNormal, Tr3.HitPos - Tr3.HitNormal)
	local Tr4 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(0, .15, 0)) * 70, {self:GetOwner()})
	util.Decal("hmcd_jackatape", Tr4.HitPos + Tr4.HitNormal, Tr4.HitPos - Tr4.HitNormal)
	local Tr5 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(0, -.15, 0)) * 70, {self:GetOwner()})
	util.Decal("hmcd_jackatape", Tr5.HitPos + Tr5.HitNormal, Tr5.HitPos - Tr5.HitNormal)
	local Tr6 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(.15, 0, 0)) * 70, {self:GetOwner()})
	util.Decal("hmcd_jackatape", Tr6.HitPos + Tr6.HitNormal, Tr6.HitPos - Tr6.HitNormal)
	local Tr7 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(-.15, 0, 0)) * 70, {self:GetOwner()})
	util.Decal("hmcd_jackatape", Tr7.HitPos + Tr7.HitNormal, Tr7.HitPos - Tr7.HitNormal)
end

function SWEP:Reload()
	if SERVER then
		self:GetOwner():PrintMessage(HUD_PRINTCENTER, tostring(self.TapeAmount or 100) .. translate.weaponDuctTapeRemaining)
	end
end

function SWEP:OnDrop()
	local Ent = ents.Create(self.ENT)
	Ent.HmcdSpawned = self.HmcdSpawned
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	if self.TapeAmount then Ent.TapeAmount = self.TapeAmount end
	Ent:Spawn()
	Ent:Activate()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity() / 2)
	self:Remove()
end

if CLIENT then
	local clr = Color(100, 100, 100, 255)
	function SWEP:PreDrawViewModel(vm, ply, wep)
		vm:SetMaterial("models/shiny")
		vm:SetColor(clr)
	end

	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 0 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 60 or 0)

		pos = pos - ang:Up() * (self.DownAmt + 30) + ang:Forward() * 100 + ang:Right() * 50
		--ang:RotateAroundAxis(ang:Up(),0)
		ang:RotateAroundAxis(ang:Right(), 90)
		ang:RotateAroundAxis(ang:Forward(), -90)
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return pos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 3.5 + Ang:Right() * 5 - Ang:Up() * -1)
				Ang:RotateAroundAxis(Ang:Right(), 180)
				--Ang:RotateAroundAxis(Ang:Right(),90)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel("models/props_phx/wheels/drugster_front.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(.2, 0)
			self.DatWorldModel:SetMaterial("models/shiny")
			self.DatWorldModel:SetColor(clr)
		end
	end
end
if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 2
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/foodnhouseholditems/mcdburgerbox.mdl"
SWEP.WorldModel = "models/foodnhouseholditems/mcdburgerbox.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_fooddrink")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponBigConsumable
SWEP.Instructions = translate.weaponConsumableDesc
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ENT = "ent_jack_hmcd_fooddrinkbig"
SWEP.DownAmt = 20
SWEP.HomicideSWEP = true
SWEP.CarryWeight = 1000
SWEP.HoldType = "slam"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.DownAmt = 20
	if SERVER and not self:GetRandomModel() then
		self:SetRandomModel("models/foodnhouseholditems/mcdburgerbox.mdl")
	end
	self.PrintName = translate.weaponBigConsumable
	self.Instructions = translate.weaponConsumableDesc
end

function SWEP:SetupDataTables()
	self:NetworkVar("String", 0, "RandomModel")
end

function SWEP:PrimaryAttack()
	if CLIENT then return end

	if self.Poisoned and self:GetOwner().Murderer then
		self:GetOwner():PrintMessage(HUD_PRINTCENTER, "This is poisoned!")
		self:SetNextPrimaryFire(CurTime() + 1)
		return
	end

	if self.Drink then
		sound.Play("snd_jack_hmcd_drink" .. math.random(1, 3) .. ".wav", self:GetOwner():GetShootPos(), 60, math.random(90, 100))
	else
		sound.Play("snd_jack_hmcd_eat" .. math.random(1, 4) .. ".wav", self:GetOwner():GetShootPos(), 60, math.random(90, 100))
	end

	local Boost = math.Clamp((self:GetOwner().FoodBoost or 0) - CurTime(), 0, 1000)
	Boost = Boost + 60
	self:GetOwner().FoodBoost = CurTime() + Boost
	net.Start("HMCD_FoodBoost")
	net.WriteFloat(Boost)
	net.Send(self:GetOwner())
	if self.Poisoned then HMCD_Poison(self:GetOwner(), self.Poisoner, true) end
	self:Remove()
end

function SWEP:OnDrop()
	local Ent = ents.Create(self.ENT)
	Ent.HmcdSpawned = self.HmcdSpawned
	Ent.RandomModel = self:GetRandomModel()
	Ent.Poisoned = self.Poisoned
	Ent.Poisoner = self.Poisoner
	if Ent.Poisoned then
		timer.Simple(.1, function()
			net.Start("hmcd_hudhalo")
			net.WriteEntity(Ent)
			net.WriteInt(3, 32)
			net.Send(player.GetAll())
		end)
	end

	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	Ent:Spawn()
	Ent:Activate()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity() / 2)
	self:Remove()
end

if CLIENT then
	function SWEP:PreDrawViewModel(vm, ply, wep)
		vm:SetModel(self:GetRandomModel())
	end

	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 0 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 20 or 0)

		pos = pos - ang:Up() * (self.DownAmt + 10) + ang:Forward() * 25 + ang:Right() * 7
		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Right(), -10)
		ang:RotateAroundAxis(ang:Forward(), -10)
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return pos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 4 - Ang:Up() * 3)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel(self:GetRandomModel())
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
		end
	end
end
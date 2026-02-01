if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.Slot = 4
	SWEP.SlotPos = 3
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/w_models/weapons/w_jj_pipebomb.mdl"
SWEP.WorldModel = "models/w_models/weapons/w_jj_pipebomb.mdl"
SWEP.ViewModelFlip = true
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_pipebomb")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponPipeBomb
SWEP.Instructions = translate.weaponPipeBombDesc
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.ENT = "ent_jack_hmcd_pipebomb"
SWEP.CarryWeight = 1200
SWEP.HoldType = "grenade"
SWEP.DownAmt = 10
SWEP.DontRemove = true

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.Thrown = false
	self.PrintName = translate.weaponPipeBomb
	self.Instructions = translate.weaponPipeBombDesc
	self.DownAmt = 10
end

function SWEP:UseActivate()
	self.DownAmt = 60
	self:EmitSound("snd_jack_hmcd_lighter.wav")
	timer.Simple(.5, function()
		if IsValid(self) then
			self:GetOwner():ViewPunch(Angle(-10, -5, 0))
			self:EmitSound("snd_jack_hmcd_throw.wav")
			self:GetOwner():SetAnimation(PLAYER_ATTACK1)
		end
	end)

	timer.Simple(.75, function()
		if IsValid(self) then
			self:GetOwner():ViewPunch(Angle(20, 10, 0))
			self:ThrowGrenade()
		end
	end)

	self:SetNextPrimaryFire(CurTime() + 1.5)
	self:SetNextSecondaryFire(CurTime() + 1.5)
end

function SWEP:ThrowGrenade()
	if CLIENT then return end
	self:GetOwner():SetLagCompensated(true)
	local Grenade = ents.Create("ent_jack_hmcd_pipebomb")
	Grenade.HmcdSpawned = self.HmcdSpawned
	Grenade:SetAngles(VectorRand():Angle())
	Grenade:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 20)
	Grenade:SetOwner(self:GetOwner())
	Grenade:Spawn()
	Grenade:Activate()
	Grenade:GetPhysicsObject():SetVelocity(self:GetOwner():GetVelocity() + self:GetOwner():GetAimVector() * 750)
	Grenade:Arm()
	self:GetOwner():SetLagCompensated(false)
	timer.Simple(.1, function()
		if IsValid(self) then
			self:Remove()
		end
	end)
end

if CLIENT then
	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 0 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 60 or 0)

		pos = pos - ang:Up() * (self.DownAmt + 7) + ang:Forward() * 20 - ang:Right() * 10
		ang:RotateAroundAxis(ang:Up(), -10)
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return pos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 3.5 + Ang:Right() * 2 - Ang:Up() * 1)
				Ang:RotateAroundAxis(Ang:Right(), 180)
				--Ang:RotateAroundAxis(Ang:Right(),90)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel("models/w_models/weapons/w_jj_pipebomb.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			--self.DatWorldModel:SetModelScale(1,0)
		end
	end
end
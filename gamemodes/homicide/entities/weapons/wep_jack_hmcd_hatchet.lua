if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 75
	SWEP.Slot = 2
	SWEP.SlotPos = 3
	killicon.AddFont("wep_jack_hmcd_hatchet", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))
	function SWEP:DrawViewModel()
		return false
	end

	function SWEP:DrawWorldModel()
		self:DrawModel()
	end
end

SWEP.Base = "weapon_base"
SWEP.ViewModel = "models/weapons/j_jnife_j.mdl"
SWEP.WorldModel = "models/props/cs_militia/axe.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_hatchet")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponHatchet
SWEP.Instructions = translate.weaponHatchetDesc
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
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Delay = 0.9
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.ENT = "ent_jack_hmcd_hatchet"
SWEP.NoHolster = true
SWEP.DeathDroppable = true
SWEP.HomicideSWEP = true
SWEP.Poisonable = true
SWEP.CarryWeight = 1500
function SWEP:Initialize()
	self:SetHoldType("melee")
	self:SetWindUp(0)
	self.NextWindThink = CurTime()
	self.PrintName = translate.weaponHatchet
	self.Instructions = translate.weaponHatchetDesc
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "WindUp")
end

function SWEP:PrimaryAttack()
	--for i=0,10 do PrintTable(self:GetOwner():GetViewModel():GetAnimInfo(i)) end
	if self:GetOwner().Stamina < 25 then return end
	if self:GetOwner():IsSprinting() then return end
	if not IsFirstTimePredicted() then
		timer.Simple(.1, function() if IsValid(self) then self:DoBFSAnimation("stab") end end)
		return
	end

	sound.Play("snd_jack_hmcd_tinyswish", self:GetOwner():GetShootPos(), 60, math.random(80, 90))
	self:SetWindUp(1)
	self:DoBFSAnimation("idle")
	self:SetNextPrimaryFire(CurTime() + 1.25)
	self:GetOwner():ViewPunch(Angle(-15, 0, 0))
	timer.Simple(.05, function()
		if IsValid(self) then
			self:GetOwner():SetAnimation(PLAYER_ATTACK1)
			self:DoBFSAnimation("stab")
			self:GetOwner():GetViewModel():SetPlaybackRate(1.5)
		end
	end)

	timer.Simple(.1, function() if IsValid(self) then timer.Simple(.1, function() if IsValid(self) then self:AttackFront() end end) end end)
end

function SWEP:Deploy()
	if not IsFirstTimePredicted() then
		self:DoBFSAnimation("draw")
		self:GetOwner():GetViewModel():SetPlaybackRate(.1)
		return
	end

	self:DoBFSAnimation("draw")
	self:GetOwner():GetViewModel():SetPlaybackRate(.5)
	self:SetNextPrimaryFire(CurTime() + .5)
	if SERVER then sound.Play("Wood_Plank.ImpactSoft", self:GetPos(), 65, math.random(90, 110)) end
	return true
end

function SWEP:SecondaryAttack()
end

--
function SWEP:Think()
	local Time = CurTime()
	if self.NextWindThink < Time then
		self.NextWindThink = Time + .05
		self:SetWindUp(math.Clamp(self:GetWindUp() - .2, 0, 1))
	end

	if self.FistCanAttack and self.FistCanAttack < CurTime() then
		self.FistCanAttack = nil
		--self:SendWeaponAnim( ACT_VM_IDLE )
		self.IdleTime = CurTime() + 0.1
	end

	if self.FistHit and self.FistHit < CurTime() then
		self.FistHit = nil
		--self:AttackTrace()
	end
end

function SWEP:AttackFront()
	if CLIENT then return end
	self:GetOwner():ViewPunch(Angle(15, 0, 0))
	self:GetOwner():LagCompensation(true)
	HMCD_StaminaPenalize(self:GetOwner(), 20)
	local Pos, AimVec = self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector()
	sound.Play("weapons/iceaxe/iceaxe_swing1.wav", self:GetOwner():GetShootPos(), 65, math.random(60, 70))
	local Ax = ents.Create(self.ENT)
	Ax.HmcdSpawned = self.HmcdSpawned
	Ax:SetPos(Pos + AimVec * 20)
	local Ang = AimVec:Angle()
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 180)
	Ax:SetAngles(Ang)
	Ax.Thrown = true
	Ax.Poisoned = self.Poisoned
	Ax:SetOwner(self:GetOwner())
	Ax:Spawn()
	Ax:Activate()
	Ax:GetPhysicsObject():SetVelocity(self:GetOwner():GetVelocity() + AimVec * 1000)
	Ax:GetPhysicsObject():AddAngleVelocity(Vector(0, 0, 2000))
	self:Remove()
	self:GetOwner():LagCompensation(false)
end

function SWEP:Reload()
end

--
function SWEP:DoBFSAnimation(anim)
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
end

function SWEP:IsEntSoft(ent)
	return ent:IsNPC() or ent:IsPlayer() or (ent:GetClass() == "prop_ragdoll")
end

function SWEP:Holster()
	return true
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
	local DownAmt = 0
	function SWEP:GetViewModelPosition(pos, ang)
		if self:GetOwner():IsSprinting() then
			DownAmt = math.Clamp(DownAmt + .6, 0, 50)
		else
			DownAmt = math.Clamp(DownAmt - .6, 0, 50)
		end

		ang:RotateAroundAxis(ang:Forward(), 10)
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return pos + ang:Up() * 0 - ang:Forward() * (DownAmt - 10) - ang:Up() * DownAmt + ang:Right() * (3 + self:GetWindUp() * 15), ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 4 + Ang:Right() - Ang:Up() * 5)
				Ang:RotateAroundAxis(Ang:Forward(), 90)
				self.DatWorldModel:SetRenderAngles(Ang)
				local Mat = Matrix()
				Mat:Scale(Vector(.9, .4, .9))
				self.DatWorldModel:EnableMatrix("RenderMultiply", Mat)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel("models/props/cs_militia/axe.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
		end
	end
end
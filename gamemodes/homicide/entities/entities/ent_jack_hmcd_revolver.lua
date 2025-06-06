AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName = "Revolver"
ENT.SWEP = "wep_jack_hmcd_revolver"
ENT.ImpactSound = "physics/metal/weapon_impact_soft3.wav"
if SERVER then
	function ENT:Initialize()
		self:SetModel("models/weapons/w_357.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(20)
			phys:Wake()
			phys:EnableMotion(true)
		end
	end

	function ENT:PickUp(ply)
		local SWEP = self.SWEP
		if not self.RoundsInMag then self.RoundsInMag = 6 end
		if ply:HasWeapon(self.SWEP) then
			if self.RoundsInMag > 0 then
				ply:GiveAmmo(self.RoundsInMag, "357", true)
				self.RoundsInMag = 0
				self:EmitSound("snd_jack_hmcd_ammotake.wav", 65, 100)
				ply:SelectWeapon(SWEP)
			else
				ply:PickupObject(self)
			end
		else
			ply:Give(self.SWEP)
			ply:GetWeapon(self.SWEP).HmcdSpawned = self.HmcdSpawned
			ply:GetWeapon(self.SWEP):SetClip1(self.RoundsInMag)
			self:Remove()
			ply:SelectWeapon(SWEP)
		end
	end
end
--
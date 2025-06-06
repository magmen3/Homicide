AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Door Wedge"
ENT.SWEP = "wep_jack_hmcd_jam"
ENT.MurdererInterest = true
if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_junk/wood_pallet001a_chunka1.mdl")
		self:SetModelScale(.5, 0)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(10)
		end

		if not self.Doors then self.Doors = {} end
		if not self.Blocking then self.Blocking = false end
		if not self.Constraint then self.Constraint = nil end
	end

	function ENT:Use(ply)
		if GAMEMODE.ZOMBIE and ply.Murderer then return end
		if self.ContactPoisoned then
			if ply.Murderer then
				ply:ChatPrint(translate.poisoned)
				return
			else
				self.ContactPoisoned = false
				HMCD_Poison(ply, self.Poisoner)
			end
		end

		if self.Blocking then
			if ply.Murderer or (math.random(1, 5) == 1) then
				self:UnBlock()
				self:EmitSound("Wood_Plank.ImpactHard")
			else
				self:EmitSound("Wood_Plank.ImpactSoft")
				self:EmitSound("Flesh.ImpactSoft")
			end
		elseif ply.Murderer then
			self:UnBlock()
			ply:Give(self.SWEP)
			ply:GetWeapon(self.SWEP).HmcdSpawned = self.HmcdSpawned
			ply:SelectWeapon(self.SWEP)
			self:Remove()
		end
	end

	function ENT:Think()
		if self.Blocking then
			for key, door in pairs(self.Doors) do
				if not IsValid(door) then
					self:UnBlock()
					break
				end

				door:Fire("lock", "", 0)
			end

			if not IsValid(self.Constraint) then
				self:UnBlock()
				self:EmitSound("Wood_Plank.ImpactSoft")
			end
		end

		self:NextThink(CurTime() + .1)
		return true
	end

	function ENT:UnBlock()
		if self.Blocking then
			self.Blocking = false
			for key, door in pairs(self.Doors) do
				if IsValid(door) then door:Fire("unlock", "", 0) end
			end

			self.Doors = {}
			self:EmitSound("Wood_Plank.ImpactSoft")
			self:EmitSound("Flesh.ImpactSoft")
			constraint.RemoveAll(self)
		end
	end

	function ENT:Block(doors)
		if not self.Blocking then
			self.Blocking = true
			self.Doors = doors
			self.Constraint = constraint.Weld(self.Doors[1], self, 0, 0, 3000, true, false)
			self:EmitSound("Wood_Plank.ImpactSoft")
			self:EmitSound("Flesh.ImpactSoft")
			self:EmitSound("Wood_Plank.ImpactSoft")
			self:Think()
		end
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > .1 then
			self:EmitSound("Wood_Plank.ImpactSoft")
			self:EmitSound("Flesh.ImpactSoft")
		end
	end

	function ENT:StartTouch(ply)
	end
	--
elseif CLIENT then
	function ENT:Initialize()
	end

	--
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Think()
	end

	--
	function ENT:OnRemove()
	end
end
--
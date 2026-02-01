if SERVER then AddCSLuaFile() end
DEFINE_BASECLASS("base_anim")
ENT.PrintName = "Chlorine Gas Particle"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.MinSize = 4
ENT.MaxSize = 128
ENT.HmcdGas = true
function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "ParticleSize", {
		KeyName = "ParticleSize",
		Edit = {
			type = "Float",
			min = self.MinSize,
			max = self.MaxSize,
			order = 1
		}
	})

	self:NetworkVarNotify("ParticleSize", self.OnParticleSizeChanged)
end

function ENT:Initialize()
	self.LifeTime = 150
	self.DieTime = CurTime() + self.LifeTime
	if CLIENT then return end
	self:SetParticleSize(.1)
	self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self:RebuildPhysics()
	self.Repulsion = .01
	self:DrawShadow(false)
end

function ENT:Think()
	if CLIENT then return end
	local Time, SelfPos = CurTime(), self:GetPos()
	if self.DieTime < Time then
		self:Remove()
		return
	end

	local Force = VectorRand() * 7 * self.Repulsion
	Force = Force - self:GetVelocity() / 2
	for key, obj in ipairs(ents.FindInSphere(SelfPos, 200 * self.Repulsion)) do
		if not (obj == self) and self:Visible(obj) then
			if obj.HmcdGas then
				local Vec = (obj:GetPos() - SelfPos):GetNormalized()
				Force = Force - Vec * self.Repulsion * 2
			elseif obj:IsPlayer() and (obj:Team() == 2) and obj:Alive() and (math.random(1, 300) == 42) then
				HMCD_Poison(obj, self:GetOwner(), true) --obj:TakeDamage(1,nil,nil)
			end
		end
	end

	self.Repulsion = math.Clamp(self.Repulsion + .03, 0, 1)
	self:GetPhysicsObject():ApplyForceCenter(Force)
	self:NextThink(Time + 1)
	return true
end

local physvec1, physvec2 = Vector(-.1, -.1, -.1), Vector(.1, .1, .1)
function ENT:RebuildPhysics(value)
	local size = math.Clamp(value or self:GetParticleSize(), self.MinSize, self.MaxSize) / 2.1
	self:PhysicsInitSphere(size, "metal_bouncy")
	self:SetCollisionBounds(physvec1, physvec2)
	self:PhysWake()
	self:GetPhysicsObject():SetMass(1)
	self:GetPhysicsObject():EnableGravity(false)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS) -- don't block traces
	self:SetCustomCollisionCheck(true) -- only collide with the World and doors
	self:GetPhysicsObject():SetMaterial("chainlink") -- pass-through for bullets
end

function ENT:OnParticleSizeChanged(varname, oldvalue, newvalue)
	-- Do not rebuild if the size wasn't changed
	if oldvalue == newvalue then return end
	self:RebuildPhysics(newvalue)
end

function ENT:PhysicsCollide(data, physobj)
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	physobj:SetVelocity(NewVelocity * 50 * self.Repulsion)
end

function ENT:OnTakeDamage(dmginfo)
	-- React physically when shot/getting blown
	self:TakePhysicsDamage(dmginfo)
end

function ENT:Use(activator, caller)
end

if CLIENT then
	local matBall, vec = Material("particle/smokestack"), Vector(0, 0, 1)
	function ENT:Draw()
		local Time = CurTime()
		render.SetMaterial(matBall)
		local pos = self:GetPos()
		local lcolor = Vector(0.95, 0.99, 0.59) - render.ComputeLighting(pos, vec)
		local a, size = math.Clamp(((self.DieTime - Time) / self.LifeTime) * 255, 0, 255), (1 - ((self.DieTime - Time) / self.LifeTime)) * 300
		render.DrawSprite(pos, size, size, Color(lcolor.x, lcolor.y, lcolor.z, a))
		size = math.Clamp(size + FrameTime() / 100, 0, 200)
	end
end
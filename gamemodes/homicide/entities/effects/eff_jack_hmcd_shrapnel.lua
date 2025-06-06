--[[---------------------------------------------------------
	EFFECT:Init(data)
---------------------------------------------------------]]
function EFFECT:Init(data)
	local vOffset = data:GetOrigin()
	local Scayul = data:GetScale()
	self.Scale = Scayul
	self.Position = vOffset
	self.Pos = vOffset
	self.Scayul = Scayul
	self.Siyuz = 1
	self.DieTime = CurTime() + .1
	self.Opacity = 1
	self.TimeToDie = CurTime() + 0.015 * self.Scale
	if self:WaterLevel() == 3 then return end
	local Emitter = ParticleEmitter(vOffset)
	for i = 0, 1000 * Scayul do
		local sprite = "sprites/mat_jack_nsmokethick"
		local particle = Emitter:Add(sprite, vOffset)
		if particle then
			particle:SetVelocity(20000 * VectorRand() * Scayul)
			particle:SetAirResistance(0)
			particle:SetGravity(VectorRand())
			particle:SetDieTime(.04 * Scayul)
			particle:SetStartAlpha(1)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(1, 20) * Scayul)
			particle:SetEndSize(math.Rand(20, 50) * Scayul)
			particle:SetRoll(math.Rand(-3, 3))
			particle:SetRollDelta(math.Rand(-2, 2))
			particle:SetLighting(true)
			local darg = math.Rand(150, 255)
			particle:SetColor(darg, darg, darg)
			particle:SetCollide(true)
			particle:SetBounce(0)
			particle:SetCollideCallback(function(part, hitpos, hitnormal)
				part:SetStartAlpha(math.Rand(50, 255))
				part:SetLifeTime(0)
				part:SetDieTime(math.Rand(.01, 1.5))
				part:SetVelocity(hitnormal * 10)
				util.Decal("ExplosiveGunshot", hitpos + hitnormal, hitpos - hitnormal)
			end)
		end
	end

	Emitter:Finish()
end

--[[---------------------------------------------------------
	EFFECT:Think()
---------------------------------------------------------]]
function EFFECT:Think()
	return false
end

--[[---------------------------------------------------------
	EFFECT:Render()
---------------------------------------------------------]]
function EFFECT:Render()
end
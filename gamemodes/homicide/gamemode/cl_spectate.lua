net.Receive("spectating_status", function(length)
	GAMEMODE.SpectateMode = net.ReadInt(8)
	GAMEMODE.Spectating = false
	GAMEMODE.Spectatee = nil
	if GAMEMODE.SpectateMode >= 0 then
		GAMEMODE.Spectating = true
		GAMEMODE.Spectatee = net.ReadEntity()
	end
end)

-- wow, inefficient much?
function GM:IsCSpectating()
	return self.Spectating
end

-- a whole function call, scope, application stack, etc, all to return a single value
-- a value that's already visible from the scope of the caller
-- good job, MechanicalMind
function GM:GetCSpectatee()
	return self.Spectatee
end

-- dumbass
function GM:ShouldDrawWeaponWorldModel(wep)
	if self.Spectating then
		local Dude = self.Spectatee
		if Dude and IsValid(Dude) and Dude:IsPlayer() and Dude:Alive() then if Dude == wep:GetOwner() then return false end end
	end
	return true
end

function GM:GetCSpectateMode()
	return self.SpectateMode
end

local function drawTextShadow(t, f, x, y, c, px, py)
	draw.SimpleText(t, f, x + 1, y + 1, Color(0, 0, 0, c.a), px, py)
	draw.SimpleText(t, f, x - 1, y - 1, Color(255, 255, 255, math.Clamp(c.a * .25, 0, 255)), px, py)
	draw.SimpleText(t, f, x, y, c, px, py)
end

local nextTipSwitch, tip = 0, ""
local clr1 = Color(20, 120, 255)
local clr2 = Color(190, 190, 190)
local clr3 = Color(128, 128, 128)
local clr4 = Color(0, 0, 0, 255)
local clr5 = Color(255, 20, 20)
function GM:RenderSpectate()
	if self:IsCSpectating() then
		local ply = self:GetCSpectatee()
		if IsValid(ply) and ply:IsPlayer() then
			drawTextShadow(translate.spectating, "MersRadial", ScrW() / 2, 50, clr1, 1)
			local h = draw.GetFontHeight("MersRadial")
			local name = ply:Nick() .. (ply:Nick() ~= ply:GetBystanderName() and (" | " .. ply:GetBystanderName()) or "")
			drawTextShadow(name, "MersRadialSmall", ScrW() / 2, 45 + h, clr2, 1)
			drawTextShadow(ply:Health() .. "/" .. ply:GetMaxHealth(), "MersRadialSmall", ScrW() / 2, 80 + h, clr2, 1)
			local clrt = not self.DEATHMATCH and (ply.Murderer and clr5 or clr1) or clr3
			--local txt = not self.DEATHMATCH and ((ply.Murderer and self.ZOMBIE and "Zombie" or ply.Murderer and "Traitor") or "Innocent") or "Fighter"
			drawTextShadow(self:GetRoleName(ply), "MersRadialSmall", ScrW() / 2, 110 + h, clrt, 1)
			local Time = CurTime()
			if nextTipSwitch < Time then
				nextTipSwitch = Time + 10
				tip = table.Random(HMCD_Tips)
			end

			draw.SimpleText(tip, "MersRadialSemiSuperS", ScrW() / 2, ScrH() - 75, clr3, 1)
			draw.SimpleText(tip, "MersRadialSemiSuperS", ScrW() / 2 + 1, ScrH() - 76, clr4, 1)
		end
	end
end

local color_red = Color(255, 0, 0)
hook.Add("VRMod_Start", "HMCD_VRStart", function(ply)
	if ply == LocalPlayer() then
		if not ply:Alive() then
			--ply:ConCommand("vrmod_exit")
			-- chat.AddText(color_red, "YOU MUST BE ALIVE TO ENTER VR!")
		end
	end
end)
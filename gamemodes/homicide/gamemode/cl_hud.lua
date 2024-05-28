surface.CreateFont("MersText1", {
	font = "Tahoma",
	size = 16,
	weight = 1000,
	antialias = true,
	italic = false
})

local ext = translate.nocoolvetica == "<nocoolvetica>"
surface.CreateFont("MersHead1", {
	font = "Coolvetica Rg",
	size = 26,
	weight = 500,
	antialias = true,
	italic = false,
	extended = ext
})

local basesize = ScrH() / 19.125 * 1.07829597918913 -- we have to multiply because coolvetica v1 is just bigger than coolvetica v5 for some reason
surface.CreateFont("MersRadial", {
	font = "Coolvetica Rg",
	size = math.ceil(basesize),
	weight = 500,
	antialias = true,
	italic = false,
	extended = ext
})

surface.CreateFont("MersRadial_QM", {
	font = "Coolvetica Rg",
	size = math.ceil(basesize * .89),
	weight = 500,
	antialias = true,
	italic = false,
	extended = ext
})

surface.CreateFont("MersRadialS", {
	font = "Coolvetica Rg",
	size = math.ceil(basesize * .76),
	weight = 400,
	antialias = true,
	italic = false,
	extended = ext
})

surface.CreateFont("MersRadialSemiSuperS", {
	font = "Coolvetica Rg",
	size = math.ceil(basesize * .62),
	weight = 125,
	antialias = true,
	italic = false,
	extended = ext
})

surface.CreateFont("MersRadialSuperS", {
	font = "Coolvetica Rg",
	size = math.ceil(basesize * .425),
	weight = 100,
	antialias = true,
	italic = false,
	extended = ext
})

surface.CreateFont("MersRadialBig", {
	font = "Coolvetica Rg",
	size = math.ceil(basesize * 1.42),
	weight = 500,
	antialias = true,
	italic = false,
	extended = ext
})

surface.CreateFont("MersRadialSmall", {
	font = "Coolvetica Rg",
	size = math.ceil(basesize * .57),
	weight = 100,
	antialias = true,
	italic = false,
	extended = ext
})

surface.CreateFont("MersRadialSmall_QM", {
	font = "Coolvetica Rg",
	size = math.ceil(basesize * .425),
	weight = 100,
	antialias = true,
	italic = false,
	extended = ext
})

surface.CreateFont("MersDeathBig", {
	font = "Coolvetica Rg",
	size = math.ceil(basesize * 1.89),
	weight = 500,
	antialias = true,
	italic = false,
	extended = ext
})

net.Receive("hmcd_noscopeaberration", function() LocalPlayer().JackaHMCDNoScopeAberration = true end)
net.Receive("hmcd_painvision", function() LocalPlayer().PainVision = 100 end)
net.Receive("hmcd_seizure", function() LocalPlayer().Seizuring = tobool(net.ReadBit()) end)
local function drawTextShadow(t, f, x, y, c, px, py)
	draw.SimpleText(t, f, x + 1, y + 1, Color(0, 0, 0, c.a), px, py)
	draw.SimpleText(t, f, x - 1, y - 1, Color(255, 255, 255, math.Clamp(c.a * .25, 0, 255)), px, py)
	draw.SimpleText(t, f, x, y, c, px, py)
end

function GM:HUDPaint()
	local round = self:GetRound()
	local client = LocalPlayer()
	if round == 0 then drawTextShadow(translate.minimumPlayers, "MersRadial", ScrW() / 2, ScrH() - 75, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP) end
	if client:Team() == 2 then
		if not client:Alive() then
			self:RenderRespawnText()
		else
			if round == 1 then
				if self.RoundStart and self.RoundStart + 10 > CurTime() then
					self:DrawStartRoundInformation()
				else
					self:DrawGameHUD(LocalPlayer())
				end
			elseif round == 2 then
				-- display who won
				self:DrawGameHUD(LocalPlayer())
			end
		end
	end

	self:RenderSpectate()
	self:DrawRadialMenu()
end

function GM:DrawStartRoundInformation()
	local client = LocalPlayer()
	local t1 = translate.startHelpBystanderTitle
	local t2 = nil
	local c = Color(20, 120, 255)
	local desc = translate.table.startHelpBystander
	local timeLeft = ((self.RoundStart + 10) - CurTime()) / 10
	if self.DEATHMATCH then
		t1 = translate.startHelpDMTitle
		desc = translate.table.startHelpDM
	elseif self.ZOMBIE then
		t1 = translate.startHelpSurvivorTitle
		desc = translate.table.startHelpSurvivor
	elseif self.SHTF then
		t1 = translate.startHelpInnocentTitle
		desc = translate.table.startHelpInnocent
	end

	if LocalPlayer().Murderer then
		t1 = translate.startHelpMurdererTitle
		desc = translate.table.startHelpMurderer
		if self.ZOMBIE then
			t1 = translate.startHelpZombieTitle
			desc = translate.table.startHelpZombie
		elseif self.SHTF then
			t1 = translate.startHelpTraitorTitle
			desc = translate.table.startHelpTraitor
		end

		c = Color(190, 20, 20)
	end

	local hasMagnum = false
	for k, wep in ipairs(client:GetWeapons()) do
		local Class = wep:GetClass()
		if (Class == "wep_jack_hmcd_smallpistol") or (Class == "wep_jack_hmcd_shotgun") or (Class == "wep_jack_hmcd_rifle") then
			hasMagnum = true
			break
		end
	end

	if hasMagnum then
		t1 = translate.startHelpGunTitle
		t2 = translate.startHelpGunSubtitle
		desc = translate.table.startHelpGun
		if self.ZOMBIE then
			t1 = translate.startHelpSurvivorTitle
			t2 = translate.startHelpBigGunSubtitle
			desc = translate.table.startHelpSurvgun
		elseif self.SHTF then
			t1 = translate.startHelpInnocentTitle
			t2 = translate.startHelpBigGunSubtitle
			desc = translate.table.startHelpIngun
		end
	end

	local Col = 255 * timeLeft ^ 2
	local Col1, Col2, Txt = Color(Col, Col, Col, 255), Color(Col, Col, Col, 128), "Homicide: "
	if self.SHTF then
		if self.DEATHMATCH then
			Txt = Txt .. translate.roundDM
			draw.SimpleText(translate.roundDMDesc, "MersRadialSmall", ScrW() / 2, ScrH() * .15, Col2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		elseif self.ZOMBIE then
			Txt = Txt .. translate.roundZS
			draw.SimpleText(translate.roundZSDesc, "MersRadialSmall", ScrW() / 2, ScrH() * .15, Col2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			Txt = Txt .. translate.roundSOE
			draw.SimpleText(translate.roundSOEDesc, "MersRadialSmall", ScrW() / 2, ScrH() * .15, Col2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	else
		if self.PUSSY then
			Txt = Txt .. translate.roundGFZ
			draw.SimpleText(translate.roundGFZDesc, "MersRadialSmall", ScrW() / 2, ScrH() * .15, Col2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		elseif self.EPIC then
			Txt = Txt .. translate.roundWW
			draw.SimpleText(translate.roundWWDesc, "MersRadialSmall", ScrW() / 2, ScrH() * .15, Col2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		elseif self.ISLAM then
			Txt = Txt .. translate.roundJM
			draw.SimpleText(translate.roundJMDesc, "MersRadialSmall", ScrW() / 2, ScrH() * .15, Col2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			Txt = Txt .. translate.roundSM
			draw.SimpleText(translate.roundSMDesc, "MersRadialSmall", ScrW() / 2, ScrH() * .15, Col2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	draw.SimpleText(Txt, "MersRadial", ScrW() / 2 - 20, ScrH() * .1, Col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(t1, "MersRadial", ScrW() / 2, ScrH() * 0.35, c, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	if t2 then
		local h = draw.GetFontHeight("MersRadial")
		draw.SimpleText(t2, "MersRadialSmall", ScrW() / 2, ScrH() * 0.35 + h * 0.7, Color(120, 70, 245), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	if desc then
		local fontHeight = draw.GetFontHeight("MersRadialSmall")
		for k, v in pairs(desc) do
			draw.SimpleText(v, "MersRadialSmall", ScrW() / 2, ScrH() * 0.8 + (k - 1) * fontHeight, c, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end

local function StatusEffect(data)
	LocalPlayer().StatusEffect = data:ReadString()
	LocalPlayer().StatusEffectShow = CurTime() + 1.5
end

usermessage.Hook("HMCD_StatusEffect", StatusEffect)
local function FoodBoost(data)
	LocalPlayer().FoodBoost = CurTime() + data:ReadShort()
end

usermessage.Hook("HMCD_FoodBoost", FoodBoost)
local function PainBoost(data)
	LocalPlayer().PainBoost = CurTime() + data:ReadShort()
end

usermessage.Hook("HMCD_PainBoost", PainBoost)
local function colorDif(col1, col2)
	local x = col1.x - col2.x
	local y = col1.y - col2.y
	local z = col1.z - col2.z
	x = x > 0 and x or -x
	y = y > 0 and y or -y
	z = z > 0 and z or -z
	return x + y + z
end

local Health, Stamina, PersonTex, StamTex, HelTex, BGTex = 0, 0, surface.GetTextureID("vgui/hud/hmcd_person"), surface.GetTextureID("vgui/hud/hmcd_stamina"), surface.GetTextureID("vgui/hud/hmcd_health"), surface.GetTextureID("vgui/hud/hmcd_background")
function GM:DrawGameHUD(ply)
	if not IsValid(ply) then return end
	if LocalPlayer() ~= ply then return end
	if self:GetVictor() then return end
	local W, H, Bleedout, Vary = ScrW(), ScrH(), ply.Bleedout, math.sin(CurTime() * 10) / 2 + .5
	Health = Lerp(.1, Health, ply:Health())
	Stamina = Lerp(.05, Stamina, ply.Stamina)
	if not Stamina then Stamina = 0 end
	if not Bleedout then Bleedout = 0 end
	local Bright = color_white
	if ply.FoodBoost and (ply.FoodBoost > CurTime()) then Bright = Color(175, 235, 255, 255) end
	local tr = ply:GetEyeTraceNoCursor()
	local shouldDraw = hook.Run("HUDShouldDraw", "MurderPlayerNames")
	if shouldDraw ~= false then
		-- draw names
		if IsValid(tr.Entity) and ((tr.Entity:IsPlayer() or tr.Entity:GetClass() == "prop_ragdoll") or tr.Entity:GetClass() == "npc_metropolice" or tr.Entity:GetClass() == "npc_citizen") and tr.HitPos:Distance(tr.StartPos) < 60 then
			self.LastLooked = tr.Entity
			self.LookedFade = CurTime()
		end

		if IsValid(self.LastLooked) and self.LookedFade + 1 > CurTime() then
			local name = self.LastLooked:GetBystanderName() or "error"
			local col = self.LastLooked:GetPlayerColor() or Vector()
			col = Color(col.x * 255, col.y * 255, col.z * 255)
			col.a = (1 - (CurTime() - self.LookedFade) / 1) * 255
			drawTextShadow(name, "MersRadial", ScrW() / 2, ScrH() / 2 + 80, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	local shouldDraw = hook.Run("HUDShouldDraw", "MurderDisguise")
	if GetViewEntity() == LocalPlayer() and shouldDraw ~= false then
		if IsValid(tr.Entity) and LocalPlayer().Murderer and tr.Entity:GetClass() == "prop_ragdoll" and tr.HitPos:Distance(tr.StartPos) < 60 and not self.ZOMBIE then
			if tr.Entity:GetBystanderName() ~= ply:GetBystanderName() or colorDif(tr.Entity:GetPlayerColor(), ply:GetPlayerColor()) > 0.1 then
				local h = draw.GetFontHeight("MersRadial")
				drawTextShadow(translate.pressEToDisguiseFor1Loot, "MersRadialSmall", ScrW() / 2, ScrH() / 2 + 80 + h * 0.7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		elseif IsValid(tr.Entity) and table.HasValue(HMCD_PersonContainers, string.lower(tr.Entity:GetModel())) and (tr.HitPos:Distance(tr.StartPos) < 60) then
			local h = draw.GetFontHeight("MersRadial")
			drawTextShadow(translate.hideInThing, "MersRadialSmall", ScrW() / 2, ScrH() / 2 + 80 + h * 0.7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	if IsValid(tr.Entity) and (ply.ArmedAtSpawn or self.DEATHMATCH or self.ZOMBIE) and not LocalPlayer().Murderer and tr.Entity:GetClass() == "prop_ragdoll" and tr.HitPos:Distance(tr.StartPos) < 60 then
		if tr.Entity:GetBystanderName() ~= ply:GetBystanderName() or colorDif(tr.Entity:GetPlayerColor(), ply:GetPlayerColor()) > 0.1 then
			local h = draw.GetFontHeight("MersRadial")
			drawTextShadow(translate.bodysearchPressE, "MersRadialSmall", ScrW() / 2, ScrH() / 2 + 80 + h * 0.7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	local shouldDraw = hook.Run("HUDShouldDraw", "MurderHealthBall")
	if shouldDraw ~= false and not self.Realism:GetBool() then
		local BarSize, BarLow, HFrac, SFrac = W * .75, H * .01 - 10, math.Clamp(Health / 100, .01, 1), math.Clamp(Stamina / 100, .01, 1)
		if SFrac < .99 then
			surface.SetTexture(StamTex)
			surface.SetDrawColor(Color(Bright.r * Vary, Bright.g * Vary, Bright.b * Vary, 255 * (1 - SFrac ^ 2)))
			surface.DrawTexturedRect(W / 2 - 500 * SFrac, BarLow, 1000 * SFrac, 40)
		end

		surface.SetTexture(BGTex)
		surface.SetDrawColor(color_black)
		surface.DrawTexturedRect(W / 2 - 500, BarLow, 1000, 40)
		surface.SetTexture(HelTex)
		if ply.PainBoost and (ply.PainBoost > CurTime()) then
			surface.SetDrawColor(Color(Bright.r * Vary, Bright.g * Vary, Bright.b * Vary, 255))
			surface.DrawTexturedRect(W / 2 - 500 * math.Clamp(HFrac, .99, 1), BarLow, 1000 * math.Clamp(HFrac, .9, 1), 40)
		end

		if Bleedout > 1 then
			surface.SetDrawColor(Color(Bright.r, Bright.g * Vary, Bright.b * Vary, 255))
		else
			surface.SetDrawColor(Bright)
		end

		surface.DrawTexturedRect(W / 2 - 500 * HFrac, BarLow, 1000 * HFrac, 40)
		if ply.StatusEffect and ply.StatusEffectShow and (ply.StatusEffectShow > CurTime()) then
			local Size, col = surface.GetTextSize(ply.StatusEffect), Color(128, 0, 0, 255)
			surface.SetDrawColor(col)
			surface.SetFont("MersRadialS")
			drawTextShadow(ply.StatusEffect, "MersRadialS", W / 2 - Size / 2, BarLow + 37, col, 0, TEXT_ALIGN_TOP)
		end
		--[[local col, Name = ply:GetPlayerColor(), ply:GetBystanderName()
		if (Name == translate.murderer) or (Name == translate.traitor) then
			col = Color(255 * Vary, 0, 0)
		else
			col = Color(col.x * 255, col.y * 255, col.z * 255)
		end

		surface.SetDrawColor(col)
		surface.SetFont("MersRadialS")
		local Size = surface.GetTextSize(Name)
		drawTextShadow(Name, "MersRadialS", W / 2 - 470 - Size, BarLow + 10, col, 0, TEXT_ALIGN_TOP)
		if ply.ChestArmor and (ply.ChestArmor ~= "") then
			local tca
			if ply.ChestArmor == "Level III" then
				tca = translate.armorLevelIII
			else
				tca = translate.armorLevelIIIA
			end

			local str = translate.chest .. tca
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetFont("MersRadialS")
			drawTextShadow(str, "MersRadialSuperS", W / 2 - 430, BarLow + 30, color_white, 0, TEXT_ALIGN_TOP)
		end

		if ply.HeadArmor and (ply.HeadArmor ~= "") then
			local str = translate.head .. ply.HeadArmor
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetFont("MersRadialS")
			local Size = surface.GetTextSize(str)
			drawTextShadow(str, "MersRadialSuperS", W / 2 + 470 - Size, BarLow + 30, color_white, 0, TEXT_ALIGN_TOP)
		end

		local shouldDraw = hook.Run("HUDShouldDraw", "MurderPlayerType")
		if shouldDraw ~= false then
			local Name = translate.bystander
			if self.SHTF then Name = translate.innocent end
			if self.DEATHMATCH then Name = translate.fighter end
			if self.ZOMBIE then Name = translate.survivor end
			if LocalPlayer() == ply and LocalPlayer().Murderer then
				if self.ZOMBIE then
					Name = translate.zombie
				elseif self.SHTF then
					Name = translate.traitor
				else
					Name = translate.murderer
				end
			end

			drawTextShadow(Name, "MersRadialS", W / 2 + 455, BarLow + 10, col, 0, TEXT_ALIGN_TOP)
		end]]
	end

	local RoundTextures = {
		["Pistol"] = surface.GetTextureID("vgui/hud/hmcd_round_9"),
		["357"] = surface.GetTextureID("vgui/hud/hmcd_round_38"),
		["AlyxGun"] = surface.GetTextureID("vgui/hud/hmcd_round_22"),
		["Buckshot"] = surface.GetTextureID("vgui/hud/hmcd_round_12"),
		["AR2"] = surface.GetTextureID("vgui/hud/hmcd_round_792"),
		["SMG1"] = surface.GetTextureID("vgui/hud/hmcd_round_556"),
		["XBowBolt"] = surface.GetTextureID("vgui/hud/hmcd_round_arrow"),
		["AirboatGun"] = surface.GetTextureID("vgui/hud/hmcd_nail")
	}

	local FlashTex = surface.GetTextureID("vgui/hud/hmcd_flash")
	local shouldDraw = hook.Run("HUDShouldDraw", "MurderFlashlightCharge")
	if shouldDraw ~= false then
		if LocalPlayer() == ply and ply:FlashlightIsOn() then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetTexture(FlashTex)
			surface.DrawTexturedRect(W * .3 - 150, H * .85, 128, 128)
			--drawTextShadow(math.Round(charge*100).."%","MersRadialSmall",W*.3-140,H*.85+50,col,0,TEXT_ALIGN_TOP)
		end
	end

	if ply.AmmoShow and (ply.AmmoShow > CurTime()) then
		local Wep, TimeLeft, Opacity = ply:GetActiveWeapon(), ply.AmmoShow - CurTime(), 255
		if Opacity <= 0 then return end
		Opacity = TimeLeft * 255
		if Wep.CanAmmoShow then
			surface.SetTexture(RoundTextures[Wep.AmmoType])
			surface.SetDrawColor(Color(255, 255, 255, Opacity))
			surface.DrawTexturedRect(W * .7 + 20, H * .825, 128, 128)
			local Mag, Message, Cnt = Wep:Clip1(), "", ply:GetAmmoCount(Wep.AmmoType)
			if Mag >= 0 then
				Message = tostring(Mag)
				if Cnt > 0 then Message = Message .. "+" .. tostring(Cnt) end
			else
				Message = tostring(Cnt)
			end

			drawTextShadow(Message, "MersRadialSmall", W * .7 + 30, H * .8 + 45, Color(255, 255, 255, Opacity), 0, TEXT_ALIGN_TOP)
		end
	end

	-- a simple grouping feature that will allows players to find eachother (and play) on large maps
	local Barycenter, Num = Vector(0, 0, 0), 0
	for key, playa in player.Iterator() do
		if playa:Alive() and playa ~= ply then
			Barycenter = Barycenter + playa:GetPos()
			Num = Num + 1
		end
	end

	Barycenter = Vector(Barycenter.x / Num, Barycenter.y / Num, Barycenter.z / Num)
	local Dist, MaxDist = (Barycenter - ply:GetPos()):Length(), 1000
	if self.SHTF then MaxDist = 2000 end
	if self.DEATHMATCH or self.ZOMBIE then MaxDist = 4000 end
	if self.ZOMBIE and LocalPlayer():HasWeapon("wep_jack_hmcd_zombhands") then MaxDist = 500 end
	local Wep = ply:GetActiveWeapon()
	if Dist > MaxDist then
		if not (Wep and IsValid(Wep) and Wep.GetAiming and (Wep:GetAiming() > 1)) then
			local ScreenPos = Barycenter:ToScreen()
			surface.SetTexture(PersonTex)
			surface.SetDrawColor(Color(255, 255, 255, math.Clamp((Dist - MaxDist) * .085, 0, 255)))
			surface.DrawTexturedRect(ScreenPos.x - 25 - 5 * Vary, ScreenPos.y - 25 - 5 * Vary, 45 + 10 * Vary, 45 + 10 * Vary)
		end
	end
end

local function ShowAmmo(len, ply)
	LocalPlayer().AmmoShow = CurTime() + 2
end

net.Receive("HMCD_AmmoShow", ShowAmmo)
local function Drugs(data)
	LocalPlayer().HighOnDrugs = data:ReadBool()
end

usermessage.Hook("HMCD_DrugsHigh", Drugs)
function GM:GUIMousePressed(code, vector)
end

local WHOTBackTab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -.05,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local RedVision = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local ScpMat, Helm, Narrow = surface.GetTextureID("sprites/mat_jack_hmcd_scope_diffuse"), "sprites/mat_jack_hmcd_helmover", "sprites/mat_jack_hmcd_narrow"
function GM:RenderScreenspaceEffects()
	local client, ViewEnt, SelfPos, Victor, FT = LocalPlayer(), GetViewEntity(), LocalPlayer():GetPos(), self:GetVictor(), FrameTime()
	if self:GetVictor() then return end
	if not client:Alive() then
		client.PainVision = false
		client.Seizuring = false
		self:RenderDeathOverlay()
	else
		if ViewEnt ~= client then
			DrawMaterialOverlay(Narrow, 1)
		elseif client.HeadArmor and (client.HeadArmor ~= "") then
			DrawMaterialOverlay(Helm, 1)
		end

		if self.ZOMBIE and client.Murderer and not Victor then
			local Close, Playa, Red = 100000, nil, 0
			for key, ply in pairs(team.GetPlayers(2)) do
				if not (ply == client) and ply:Alive() then
					local Dist = ply:GetPos():Distance(SelfPos)
					if Dist < Close then
						Close = Dist
						Playa = ply
					end
				end
			end

			if Playa then
				local Dot = client:GetAimVector():Dot((Playa:GetPos() - SelfPos):GetNormalized())
				local ApproachAngle = -math.deg(math.asin(Dot)) + 90
				local AngFrac = 1 - (ApproachAngle / 180)
				Red = Red + (AngFrac ^ 5)
				local DistFrac = math.Clamp(1 - (Close / 2000), 0, 1)
				Red = Red + DistFrac * 2
				WHOTBackTab["$pp_colour_mulr"] = Red / 2
				WHOTBackTab["$pp_colour_addr"] = Red / 15
			end

			DrawColorModify(WHOTBackTab)
			DrawToyTown(1, ScrH())
		elseif not Victor and client.PainVision and (client.PainVision > 0) then
			RedVision["$pp_colour_addr"] = client.PainVision / 100
			DrawColorModify(RedVision)
			client.PainVision = client.PainVision - FT * 100
		end

		local Wep = client:GetActiveWeapon()
		if IsValid(Wep) then
			if Wep.GetAiming and (Wep:GetAiming() > 5) then
				if Wep.Scoped then
					if Wep:GetAiming() >= 99 then
						local W, H = ScrW(), ScrH()
						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetTexture(ScpMat)
						surface.DrawTexturedRect(-1, -1, W + 1, H + 1)
						surface.SetDrawColor(0, 0, 0, 255)
						surface.DrawRect(-1, H / 2, W + 1, 2)
						surface.DrawRect((W / 2) + 5, -1, 2, H + 1)
					end
				else
					DrawToyTown(2, Wep:GetAiming() * ScrH() / 200)
				end
			end
		end

		if client.HighOnDrugs then DrawSharpen(2, 1.2) end
	end

	local ply = client
	if self:IsCSpectating() and IsValid(self:GetCSpectatee()) then ply = self:GetCSpectatee() end
	local Health = ply:Health()
	if (ply:IsPlayer() and ply:Alive() or (GAMEMODE.SpectateTime > CurTime())) and not (self.ZOMBIE and ply.Murderer) then
		if Health < 50 then
			local Frac = math.Clamp(Health / 50, .01, 1)
			DrawColorModify({
				["$pp_colour_addr"] = 0,
				["$pp_colour_addg"] = 0,
				["$pp_colour_addb"] = 0,
				["$pp_colour_brightness"] = -(1 - Frac) * .1,
				["$pp_colour_contrast"] = 1 + (1 - Frac) * .5,
				["$pp_colour_colour"] = Frac,
				["$pp_colour_mulr"] = 0,
				["$pp_colour_mulg"] = 0,
				["$pp_colour_mulb"] = 0
			})
		end

		if Health < 10 then DrawToyTown(1, ScrH()) end
	end

	if not self.RoundStart then self.RoundStart = CurTime() end
	if self:GetRound() == 1 and self.RoundStart and self.RoundStart + 10 > CurTime() then
		local sw, sh = ScrW(), ScrH()
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(-1, -1, sw + 2, sh + 2)
	end
end

net.Receive("hmcd_innocence", function() net.ReadEntity().InnocenceLost = CurTime() + 1.5 end)
function GM:PostDrawHUD()
	if self:GetRound() == 1 then
		local AlreadyDrawn = false
		if self.TKerPentalty ~= 0 then
			if self.TKerUnShowTime > CurTime() then
				if self.TKerPenalty == 1 then
					surface.SetDrawColor(10, 10, 10, 50)
					if self.SHTF then
						drawTextShadow(translate.ywbaInnocent, "MersRadial", ScrW() * 0.5, ScrH() / 2, Color(90, 20, 20), 1, TEXT_ALIGN_CENTER)
					else
						drawTextShadow(translate.ywbaBystander, "MersRadial", ScrW() * 0.5, ScrH() / 2, Color(90, 20, 20), 1, TEXT_ALIGN_CENTER)
					end

					AlreadyDrawn = true
				elseif self.TKerPenalty == 2 then
					surface.SetDrawColor(10, 10, 10, 50)
					drawTextShadow(translate.ywbaSpectator, "MersRadial", ScrW() * 0.5, ScrH() / 2, Color(90, 20, 20), 1, TEXT_ALIGN_CENTER)
					AlreadyDrawn = true
				end
			end
		end

		if not AlreadyDrawn then
			local Ply = LocalPlayer()
			if Ply.InnocenceLost and (Ply.InnocenceLost > CurTime()) then
				surface.SetDrawColor(10, 10, 10, 50)
				drawTextShadow(translate.noInnocence, "MersRadial", ScrW() * .5, ScrH() * .85, Color(90, 20, 20), 1, TEXT_ALIGN_CENTER)
			end
		end
	end
end

local hidechud = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudCrosshair"] = true,
	["CHudGeiger"] = true,
	["CHudPoisonDamageIndicator"] = true,
	["CHudSquadStatus"] = true,
	["CHudZoom"] = true
}

function GM:HUDShouldDraw(name)
	if hidechud[name] then return false end
	return true
end

function GM:GUIMousePressed(code, vector)
	return self:RadialMousePressed(code, vector)
end

--[[--------------------------------------------------------------
	I hate desiging derma UIs so damn much
---------------------------------------------------------------]]
net.Receive("hmcd_openammomenu", function() GAMEMODE:OpenAmmoDropMenu() end)
function GM:OpenAmmoDropMenu()
	local Ply, AmmoType, AmmoAmt, Ammos = LocalPlayer(), "Pistol", 1, {}
	for key, name in pairs(HMCD_AmmoNames) do
		local Amownt = Ply:GetAmmoCount(key)
		if Amownt > 0 then Ammos[key] = Amownt end
	end

	if #table.GetKeys(Ammos) <= 0 then
		Ply:ChatPrint(translate.ammoNo)
		return
	end

	AmmoType = table.GetKeys(Ammos)[1]
	AmmoAmt = Ammos[AmmoType]
	local DermaPanel = vgui.Create("DFrame")
	DermaPanel:SetPos(40, 80)
	DermaPanel:SetSize(300, 300)
	DermaPanel:SetTitle(translate.ammoDrop)
	DermaPanel:SetVisible(true)
	DermaPanel:SetDraggable(true)
	DermaPanel:ShowCloseButton(true)
	DermaPanel:MakePopup()
	DermaPanel:Center()
	local MainPanel = vgui.Create("DPanel", DermaPanel)
	MainPanel:SetPos(5, 25)
	MainPanel:SetSize(290, 270)
	MainPanel.Paint = function()
		surface.SetDrawColor(0, 20, 40, 255)
		surface.DrawRect(0, 0, MainPanel:GetWide(), MainPanel:GetTall() + 3)
	end

	local SecondPanel = vgui.Create("DPanel", MainPanel)
	SecondPanel:SetPos(100, 177)
	SecondPanel:SetSize(180, 20)
	SecondPanel.Paint = function()
		surface.SetDrawColor(100, 100, 100, 255)
		surface.DrawRect(0, 0, SecondPanel:GetWide(), SecondPanel:GetTall() + 3)
	end

	local amtselect = vgui.Create("DNumSlider", MainPanel)
	amtselect:SetPos(10, 170)
	amtselect:SetWide(290)
	amtselect:SetText(translate.ammoAmount)
	amtselect:SetMin(1)
	amtselect:SetMax(AmmoAmt)
	amtselect:SetDecimals(0)
	amtselect:SetValue(AmmoAmt)
	amtselect.OnValueChanged = function(panel, val) AmmoAmt = math.Round(val) end
	local AmmoList = vgui.Create("DListView", MainPanel)
	AmmoList:SetMultiSelect(false)
	AmmoList:AddColumn(translate.ammoType)
	for key, amm in pairs(Ammos) do
		AmmoList:AddLine(HMCD_AmmoNames[key]).Type = key
	end

	AmmoList:SetPos(5, 5)
	AmmoList:SetSize(280, 150)
	AmmoList.OnRowSelected = function(panel, ind, row)
		AmmoType = row.Type
		AmmoAmt = Ammos[AmmoType]
		amtselect:SetMax(AmmoAmt)
		amtselect:SetValue(AmmoAmt)
	end

	AmmoList:SelectFirstItem()
	local gobutton = vgui.Create("Button", MainPanel)
	gobutton:SetSize(270, 40)
	gobutton:SetPos(10, 220)
	gobutton:SetText(translate.ammoDropShort)
	gobutton:SetVisible(true)
	gobutton.DoClick = function()
		DermaPanel:Close()
		RunConsoleCommand("hmcd_droprequest_ammo", AmmoType, tostring(AmmoAmt))
	end
end
local ments
local radialOpen = false
local prevSelected, prevSelectedVertex
function GM:OpenRadialMenu(elements)
	if not LocalPlayer():Alive() then return end
	radialOpen = true
	gui.EnableScreenClicker(true)
	ments = elements or {}
	prevSelected = nil
end

function GM:CloseRadialMenu()
	radialOpen = false
	gui.EnableScreenClicker(false)
end

local function getSelected()
	local mx, my = gui.MousePos()
	local sw, sh = ScrW(), ScrH()
	local total = #ments
	local w = math.min(sw * 0.45, sh * 0.45)
	local sx, sy = sw / 2, sh / 2
	local x2, y2 = mx - sx, my - sy
	local ang = 0
	local dis = math.sqrt(x2 ^ 2 + y2 ^ 2)
	if dis / w <= 1 then
		if y2 <= 0 and x2 <= 0 then
			ang = math.acos(x2 / dis)
		elseif x2 > 0 and y2 <= 0 then
			ang = -math.asin(y2 / dis)
		elseif x2 <= 0 and y2 > 0 then
			ang = math.asin(y2 / dis) + math.pi
		else
			ang = math.pi * 2 - math.acos(x2 / dis)
		end
		return math.floor((1 - (ang - math.pi / 2 - math.pi / total) / (math.pi * 2) % 1) * total) + 1
	end
end

function GM:RadialMousePressed(code, vec)
	if radialOpen then
		local selected = getSelected()
		if selected and selected > 0 and code == MOUSE_LEFT then
			if selected and ments[selected] then
				if ments[selected].Code == "drop_item" then
					RunConsoleCommand("hmcd_dropwep")
				elseif ments[selected].Code == "drop_equipment" then
					RunConsoleCommand("hmcd_dropequipment")
				elseif ments[selected].Code == "drop_ammo" then
					RunConsoleCommand("hmcd_dropammo")
				else
					RunConsoleCommand("hmcd_taunt", ments[selected].Code)
				end
			end
		end

		self:CloseRadialMenu()
	end
end

local elements
local function addElement(transCode, code)
	local t = {}
	t.TransCode = transCode
	t.Code = code
	table.insert(elements, t)
end

concommand.Add("+menu", function(client, com, args, full)
	if client:Alive() and client:Team() == 2 then
		if not client.HMCD_Merit then client.HMCD_Merit = 0 end
		if not client.HMCD_Demerit then client.HMCD_Demerit = 1 end
		if not client.HMCD_Experience then client.HMCD_Experience = 0 end
		elements = {}
		addElement("Help", "help")
		addElement("Random", "random")
		addElement("Happy", "happy")
		addElement("Morose", "morose")
		addElement("Response", "response")
		if (client.HeadArmor and (client.HeadArmor ~= "")) or (client.ChestArmor and (client.ChestArmor ~= "")) or client.HasFlashlight then addElement("DropEquipment", "drop_equipment") end
		local Wep = client:GetActiveWeapon()
		if IsValid(Wep) then
			if Wep.CommandDroppable and not (GAMEMODE.SHTF and Wep.SHTF_NoDrop) then addElement("Drop", "drop_item") end
			local Num = 0
			for amm, fuck in ipairs(HMCD_AmmoWeights) do
				local Amt = client:GetAmmoCount(amm) or 0
				Num = Num + Amt
			end

			if Num > 0 then addElement("DropAmmo", "drop_ammo") end
			if LocalPlayer().Murderer then
				addElement("Villain", "villain")
			elseif Wep.ClassName == "wep_jack_hmcd_smallpistol" then
				addElement("Hero", "hero")
			end
		end

		GAMEMODE:OpenRadialMenu(elements)
	end
end)

concommand.Add("-menu", function(client, com, args, full) GAMEMODE:RadialMousePressed(MOUSE_LEFT) end)
local tex = surface.GetTextureID("VGUI/white.vmt")
local function drawShadow(n, f, x, y, color, pos)
	draw.DrawText(n, f, x + 1, y + 1, color_black, pos)
	draw.DrawText(n, f, x, y, color, pos)
end

local function drawTextShadow(t, f, x, y, c, px, py)
	draw.SimpleText(t, f, x + 1, y + 1, Color(0, 0, 0, c.a), px, py)
	draw.SimpleText(t, f, x - 1, y - 1, Color(255, 255, 255, math.Clamp(c.a * .25, 0, 255)), px, py)
	draw.SimpleText(t, f, x, y, c, px, py)
end

local circleVertex
local fontHeight = draw.GetFontHeight("MersRadial")
function GM:DrawRadialMenu()
	if radialOpen then
		local sw, sh = ScrW(), ScrH()
		local total = #ments
		local w = math.min(sw * 0.45, sh * 0.45)
		local h = w
		local sx, sy = sw / 2, sh / 2
		local selected = getSelected() or -1
		if not circleVertex then
			circleVertex = {}
			local max = 50
			for i = 0, max do
				local vx, vy = math.cos((math.pi * 2) * i / max), math.sin((math.pi * 2) * i / max)
				table.insert(circleVertex, {
					x = sx + w * 1 * vx,
					y = sy + h * 1 * vy
				})
			end
		end

		surface.SetTexture(tex)
		local defaultTextCol = color_white
		if selected <= 0 or selected ~= selected then
			surface.SetDrawColor(20, 20, 20, 180)
		else
			surface.SetDrawColor(20, 20, 20, 120)
			defaultTextCol = Color(150, 150, 150)
		end

		surface.DrawPoly(circleVertex)
		local add = math.pi * 1.5 + math.pi / total
		local add2 = math.pi * 1.5 - math.pi / total
		for k, ment in pairs(ments) do
			local x, y = math.cos((k - 1) / total * math.pi * 2 + math.pi * 1.5), math.sin((k - 1) / total * math.pi * 2 + math.pi * 1.5)
			local lx, ly = math.cos((k - 1) / total * math.pi * 2 + add), math.sin((k - 1) / total * math.pi * 2 + add)
			local textCol = defaultTextCol
			if ment.Code == "villain" then
				textCol = Color(200, 10, 10, 150)
			elseif ment.Code == "hero" then
				textCol = Color(20, 200, 255, 150)
			end

			if selected == k then
				local vertexes = prevSelectedVertex -- uhh, you mean VERTICES? Dumbass.
				if prevSelected ~= selected then
					prevSelected = selected
					vertexes = {}
					prevSelectedVertex = vertexes
					local lx2, ly2 = math.cos((k - 1) / total * math.pi * 2 + add2), math.sin((k - 1) / total * math.pi * 2 + add2)
					table.insert(vertexes, {
						x = sx,
						y = sy
					})

					table.insert(vertexes, {
						x = sx + w * 1 * lx2,
						y = sy + h * 1 * ly2
					})

					local max = math.floor(50 / total)
					for i = 0, max do
						local addv = (add - add2) * i / max + add2
						local vx, vy = math.cos((k - 1) / total * math.pi * 2 + addv), math.sin((k - 1) / total * math.pi * 2 + addv)
						table.insert(vertexes, {
							x = sx + w * 1 * vx,
							y = sy + h * 1 * vy
						})
					end

					table.insert(vertexes, {
						x = sx + w * 1 * lx,
						y = sy + h * 1 * ly
					})
				end

				surface.SetTexture(tex)
				surface.SetDrawColor(20, 120, 255, 120)
				if ment.Code == "happy" then
					surface.SetDrawColor(255, 20, 20, 120)
				elseif (ment.Code == "drop_item") or (ment.Code == "drop_armor") or (ment.Code == "drop_ammo") then
					surface.SetDrawColor(50, 50, 50, 120)
				end

				surface.DrawPoly(vertexes)
				textCol = color_white
				if ment.Code == "villain" then
					textCol = Color(255, 50, 50, 255)
				elseif ment.Code == "hero" then
					textCol = Color(100, 225, 255, 255)
				end
			end

			local Main, Sub = translate["voice" .. ment.TransCode], translate["voice" .. ment.TransCode .. "Description"]
			drawShadow(Main, "MersRadial_QM", sx + w * 0.6 * x, sy + h * 0.6 * y - fontHeight / 3, textCol, 1)
			drawShadow(Sub, "MersRadialSmall_QM", sx + w * 0.6 * x, sy + h * 0.6 * y + fontHeight / 2, textCol, 1)
			local ply = LocalPlayer()
			local H, W = ScrH(), ScrW()
			local BarSize, BarLow = W * .75, H * .01 - 10
			local col, Name = ply:GetPlayerColor(), ply:GetBystanderName()
			if (Name == translate.murderer) or (Name == translate.traitor) then
				col = Color(255 * Vary, 0, 0)
			else
				col = Color(col.x * 255, col.y * 255, col.z * 255)
			end

			surface.SetDrawColor(col)
			surface.SetFont("MersRadialS")
			local Size = surface.GetTextSize(Name)
			drawTextShadow(Name, "MersRadialS", W / 2.9 - 470 - Size, BarLow + 10, col, 0, TEXT_ALIGN_RIGHT)
			if not self.Realism:GetBool() then
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
			end

			local shouldDraw = hook.Run("HUDShouldDraw", "MurderPlayerType")
			if shouldDraw ~= false then
				--[[local Name = translate.bystander
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
				end]]
				drawTextShadow(self:GetRoleName(ply), "MersRadialS", W / 9.9 - Size, BarLow + 55, col, 0, TEXT_ALIGN_RIGHT)
			end
		end
	end
end
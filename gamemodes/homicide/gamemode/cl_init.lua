include("sh_translate.lua")
include("shared.lua")
include("cl_hud.lua")
include("cl_scoreboard.lua")
include("cl_footsteps.lua")
include("cl_respawn.lua")
include("cl_murderer.lua")
include("cl_player.lua")
include("cl_ragdoll.lua")
include("cl_chattext.lua")
include("cl_voicepanels.lua")
include("cl_rounds.lua")
include("cl_endroundboard.lua")
include("cl_qmenu.lua")
include("cl_spectate.lua")
include("cl_flashlight.lua")
include("cl_outline.lua")
GM.Debug = CreateClientConVar("hmcd_debug", 0, true, true)
GM.HeroPlayer = nil
GM.VillainPlayer = nil
GM.PlayerAwardStats = {}
GM.WinCondition = nil
GM.TKerUnShowTime = 0
function GM:Initialize()
	self:FootStepsInit()
end

net.Receive("hmcd_mode", function(len)
	GAMEMODE.SHTF = tobool(net.ReadBit())
	GAMEMODE.PUSSY = tobool(net.ReadBit())
	GAMEMODE.ISLAM = tobool(net.ReadBit())
	GAMEMODE.EPIC = tobool(net.ReadBit())
	GAMEMODE.DEATHMATCH = tobool(net.ReadBit())
	GAMEMODE.ZOMBIE = tobool(net.ReadBit())
end)

GM.FogEmitters = {}
if GAMEMODE then GM.FogEmitters = GAMEMODE.FogEmitters end
local lply = LocalPlayer()
function GM:Think()
	if not lply.TempSpeedMul then lply.TempSpeedMul = 1 end
end

local function SendIdentity(len, ply)
	if not lply.ConCommand then return end
	if file.Exists("homicide_identity.txt", "DATA") then
		local RawData = string.Split(file.Read("homicide_identity.txt", "DATA"), "\n")
		if #RawData == 10 then
			local DatName, DatAccessory = string.Replace(RawData[1], " ", "_"), string.Replace(RawData[10], " ", "_")
			lply:ConCommand("homicide_identity " .. DatName .. " " .. RawData[2] .. " " .. RawData[3] .. " " .. RawData[4] .. " " .. RawData[5] .. " " .. RawData[6] .. " " .. RawData[7] .. " " .. RawData[8] .. " " .. RawData[9] .. " " .. DatAccessory)
		else
			lply:ChatPrint(translate.identityIncorrectLines)
		end
	end
end

net.Receive("HMCD_Identity", SendIdentity)
local function Act(len, ply)
	print(231123) -- принтится
	local str = net.ReadString()
	if not IsValid(lply) then return end
	print(str)
	lply:ConCommand("act " .. str)
end

net.Receive("HMCD_PlayerAct", Act)
-- i hate you, garry
local function FixGlitch(data)
	if not lply.ConCommand then return end
	lply:ConCommand("gm_demo_icon 0")
	print(translate.miscExplanation)
	lply:ConCommand("record HOMICIDE_FIXGLITCH_DELETEME")
	timer.Simple(.01, function() lply:ConCommand("stop") end)
	timer.Simple(5, function() if lply and lply.ConCommand then lply:ConCommand("stop") end end)
end

usermessage.Hook("HMCD_FixViewModelGlitch", FixGlitch)
-- self:FootStepsRenderScene(origin, angles, fov)
function GM:PostDrawTranslucentRenderables()
	self:DrawFootprints()
end

-- 1 loot 2 interest 3 poison 4 explosive
net.Receive("hmcd_hudhalo", function(length)
	local Ent, Type = net.ReadEntity(), net.ReadInt(32)
	--print(Ent,Type)
	if Type == 1 then
		Ent.MurdererLoot = true
	elseif Type == 2 then
		Ent.MurdererInterest = true
	elseif Type == 3 then
		Ent.MurdererPoison = true
	elseif Type == 4 then
		Ent.MurdererExplosive = true
	end
end)

local StopThatShit = 0
local tabcolor = Color(0, 200, 200)
local tab2color = Color(200, 0, 0)
function GM:PreDrawHalos()
	if self.ZOMBIE and lply.Murderer or not system.HasFocus() then return end
	-- fucking losers
	if (1 / FrameTime()) < 30 then
		StopThatShit = 100
	else
		StopThatShit = math.Clamp(StopThatShit - 1, 0, 100)
	end

	if StopThatShit > 0 then return end
	local client, murd = lply, lply.Murderer
	local Vary, Modulus = 0, CurTime() % 5
	if Modulus < 1 then Vary = 1 - (math.sin(CurTime() * math.pi * 2 - (math.pi / 2)) + 1) / 2 end
	if IsValid(client) and client:Alive() then
		local tab, tab2 = {}, {}
		for k, v in pairs(ents.GetAll()) do
			if v.IsLoot and not v:GetDTBool(0) and not v.MurdererLoot then
				table.insert(tab, v)
			elseif murd then
				if v.MurdererLoot or v.MurdererInterest or v.MurdererPoison or v.MurdererExplosive then table.insert(tab2, v) end
			end
		end

		if Vary > 0 then
			outline.Add(tab, tabcolor, OUTLINE_MODE_VISIBLE)
			-- halo.Add(tab, Color(0, 220, 220, 255), 10 * Vary, 10 * Vary, 1, true, false)
		end

		if #tab2 > 0 then
			outline.Add(tab2, tab2color, OUTLINE_MODE_VISIBLE)
			-- halo.Add(tab2, Color(220, 0, 0, 255), 3, 3, 1, true, false)
		end
	end
end

function GM:RenderAccessories(ply)
	local Mod = ply:GetModel()
	if (Mod == "models/player/mkx_jajon.mdl") or (Mod == "models/player/zombie_classic.mdl") then return end
	if ply.Accessory and not (ply.Accessory == "none") and not (ply.HeadArmor and (ply.HeadArmor == "ACH") and HMCD_Accessories[ply.Accessory][5]) then
		local AccInfo = HMCD_Accessories[ply.Accessory]
		if ply.AccessoryModel then
			local PosInfo = nil
			if ply.ModelSex == "male" then
				PosInfo = AccInfo[3]
			elseif ply.ModelSex == "female" then
				PosInfo = AccInfo[4]
			end

			local Pos, Ang = ply:GetBonePosition(ply:LookupBone(AccInfo[2]))
			if Pos and Ang then
				Pos = Pos + Ang:Right() * PosInfo[1].x + Ang:Forward() * PosInfo[1].y + Ang:Up() * PosInfo[1].z
				Ang:RotateAroundAxis(Ang:Right(), PosInfo[2].p)
				Ang:RotateAroundAxis(Ang:Up(), PosInfo[2].y)
				Ang:RotateAroundAxis(Ang:Forward(), PosInfo[2].r)
				ply.AccessoryModel:SetRenderOrigin(Pos)
				ply.AccessoryModel:SetRenderAngles(Ang)
				local Scale, Matr = nil, Matrix()
				if ply.ModelSex == "male" then
					Scale = AccInfo[3][3]
				elseif ply.ModelSex == "female" then
					Scale = AccInfo[4][3]
				end

				Matr:Scale(Vector(Scale, Scale, Scale))
				ply.AccessoryModel:EnableMatrix("RenderMultiply", Matr)
				ply.AccessoryModel:DrawModel()
			end
		else
			ply.AccessoryModel = ClientsideModel(AccInfo[1])
			ply.AccessoryModel:SetPos(ply:GetPos())
			ply.AccessoryModel:SetParent(ply)
			ply.AccessoryModel:SetSkin(AccInfo[6])
			local Mats = ply.AccessoryModel:GetMaterials() -- garry, fuck you
			-- robotboy, fuck you too
			for key, mat in pairs(Mats) do
				ply.AccessoryModel:SetSubMaterial(key - 1, mat) -- i shouldn't have to do this
			end

			-- you stupid bastards
			ply.AccessoryModel:SetNoDraw(true)
		end
	end

	if ply:IsPlayer() then
		local Weps, DrawWep = ply:GetWeapons(), nil
		for key, wep in pairs(Weps) do
			if wep.HolsterSlot and (wep.HolsterSlot == 1) then
				DrawWep = wep
				break
			end
		end

		if DrawWep and not (DrawWep == ply:GetActiveWeapon()) then
			if ply.HolsterWep and (ply.HolsterWepModelName == DrawWep.WorldModel) then
				local Pos, Ang = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Spine4"))
				if Pos and Ang then
					local Dist = 0
					if ply.ChestArmor and ((ply.ChestArmor == "Level III") or (ply.ChestArmor == "Level IIIA")) then Dist = 2 end
					Pos = Pos + Ang:Right() * (DrawWep.HolsterPos.x + Dist) + Ang:Forward() * DrawWep.HolsterPos.y + Ang:Up() * DrawWep.HolsterPos.z
					Ang:RotateAroundAxis(Ang:Right(), DrawWep.HolsterAng.p)
					Ang:RotateAroundAxis(Ang:Up(), DrawWep.HolsterAng.y)
					Ang:RotateAroundAxis(Ang:Forward(), DrawWep.HolsterAng.r)
					ply.HolsterWep:SetRenderOrigin(Pos)
					ply.HolsterWep:SetRenderAngles(Ang)
					ply.HolsterWep:DrawModel()
				end
			else
				ply.HolsterWep = ClientsideModel(DrawWep.WorldModel)
				ply.HolsterWepModelName = DrawWep.WorldModel
				ply.HolsterWep:SetPos(ply:GetPos())
				ply.HolsterWep:SetParent(ply)
				local Mats = ply.HolsterWep:GetMaterials() -- garry, fuck you
				-- robotboy, fuck you too
				for key, mat in pairs(Mats) do
					ply.HolsterWep:SetSubMaterial(key - 1, mat) -- i shouldn't have to do this
				end

				-- you stupid bastards
				ply.HolsterWep:SetNoDraw(true)
			end
		end
	end

	if ply.ChestArmor and ((ply.ChestArmor == "Level III") or (ply.ChestArmor == "Level IIIA")) then
		if ply.ArmorModel then
			local Pos, Ang = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Spine4"))
			if Pos and Ang then
				local Dist, Down = 10, 46
				if ply.ModelSex == "male" then
					Dist = 12.5
					Down = 50
				end

				Pos = Pos - Ang:Forward() * Down - Ang:Right() * Dist + Ang:Up() * 0
				ply.ArmorModel:SetRenderOrigin(Pos)
				Ang:RotateAroundAxis(Ang:Up(), 80)
				Ang:RotateAroundAxis(Ang:Forward(), 90)
				ply.ArmorModel:SetRenderAngles(Ang)
				local R, G, B = render.GetColorModulation()
				if ply.ChestArmor == "Level III" then render.SetColorModulation(.3, .3, .3) end
				ply.ArmorModel:DrawModel()
				render.SetColorModulation(R, G, B)
			end
		else
			ply.ArmorModel = ClientsideModel("models/sal/acc/armor01.mdl")
			--ply.ArmorModel:SetMaterial("models/mat_jack_hmcd_armor")
			ply.ArmorModel:SetPos(ply:GetPos())
			ply.ArmorModel:SetParent(ply)
			ply.ArmorModel:SetNoDraw(true)
			local Scale = 1
			if ply.ModelSex == "female" then
				Scale = Scale * .8
			else
				Scale = Scale * .9
			end

			ply.ArmorModel:SetModelScale(Scale, 0)
		end
	else
		ply.ArmorModel = nil
	end

	if ply.HeadArmor and (ply.HeadArmor == "ACH") then
		if ply.HelmetModel then
			local Pos, Ang = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
			if Pos and Ang then
				local Dist = 4.5
				if ply.ModelSex == "male" then Dist = 6 end
				Pos = Pos + Ang:Forward() * 1 + Ang:Right()
				ply.HelmetModel:SetRenderOrigin(Pos)
				Ang:RotateAroundAxis(Ang:Up(), -80)
				Ang:RotateAroundAxis(Ang:Forward(), -90)
				ply.HelmetModel:SetRenderAngles(Ang)
				local R, G, B = render.GetColorModulation()
				render.SetColorModulation(.7, .7, .7)
				ply.HelmetModel:DrawModel()
				render.SetColorModulation(R, G, B)
			end
		else
			ply.HelmetModel = ClientsideModel("models/barney_helmet.mdl")
			ply.HelmetModel:SetMaterial("models/mat_jack_hmcd_armor")
			ply.HelmetModel:SetPos(ply:GetPos())
			ply.HelmetModel:SetParent(ply)
			ply.HelmetModel:SetNoDraw(true)
			local Scale = 1
			if ply.ModelSex == "female" then Scale = Scale * .9 end
			ply.HelmetModel:SetModelScale(Scale, 0)
		end
	else
		ply.HelmetModel = nil
	end
end

--[[---------------------------------------
--     Super Special Secret w00tzorz     --
---------------------------------------]]
local Shine = Material("models/debug/debugwhite")
function GM:PostDrawOpaqueRenderables(drawingDepth, drawingSkybox)
	for key, ply in pairs(ents.FindByClass("prop_ragdoll")) do
		self:RenderAccessories(ply)
	end

	if self.ZOMBIE and lply.Murderer and not self:GetVictor() then
		local Vary = math.sin(CurTime() * 3)
		if Vary > .5 then
			Vary = (Vary - .5) / .5
			for key, targ in pairs(ents.GetAll()) do
				local Ja = targ:IsPlayer() and targ:Alive()
				if Ja then
					if Ja and targ:IsEffectActive(EF_NODRAW) then
					else --nope
						render.SetBlend(Vary)
						render.ModelMaterialOverride(Shine)
						render.SuppressEngineLighting(true)
						render.SetColorModulation(1 * Vary, 1 * Vary ^ 2, 1 * Vary ^ 2)
						targ:DrawModel()
						render.SetColorModulation(1, 1, 1)
						render.SuppressEngineLighting(false)
						render.ModelMaterialOverride(nil)
						render.SetBlend(1)
					end
				end
			end
		elseif Vary < -.5 then
			Vary = (math.abs(Vary) - .5) / .5
			local dlight = DynamicLight(lply:EntIndex())
			if dlight then
				dlight.Pos = EyePos() + EyeAngles():Forward() * 10
				dlight.r = 20 * Vary
				dlight.g = 20 * Vary ^ 2
				dlight.b = 20 * Vary ^ 2
				dlight.Brightness = .1 * Vary
				dlight.Size = 2000 * Vary
				dlight.Decay = 1000
				dlight.DieTime = CurTime() + .2
				dlight.Style = 0
			end
		end
	end
end

function GM:PlayerBindPress(ply, bind, pressed)
	if self.PlayerAttackTime and (self.PlayerAttackTime > CurTime()) and (bind == "+attack") then return true end
	if not (GetViewEntity() == lply) then RunConsoleCommand("hmcd_lockedcontrols", bind) end
end

net.Receive("hmcd_tker", function(len)
	GAMEMODE.TKerPenalty = net.ReadFloat()
	GAMEMODE.TKerUnShowTime = CurTime() + 5
end)

local function ExplosiveReceive(data)
	lply.RecognizedExplosive = data:ReadEntity()
end

usermessage.Hook("HMCD_ExplosiveRecognition", ExplosiveReceive)
local function SurfaceSound(data)
	surface.PlaySound(data:ReadString())
end

usermessage.Hook("HMCD_SurfaceSound", SurfaceSound)
function GM:GetVictor()
	--if(true)then return player.GetAll()[1] end
	if self.RoundStage == 2 then
		if ((self.WinCondition == 2) or (self.WinCondition == 5)) and self.HeroPlayer then
			if self.HeroPlayer.IsPlayer and self.HeroPlayer:IsPlayer() then return self.HeroPlayer end
		elseif (self.WinCondition == 1) and self.VillainPlayer then
			if self.VillainPlayer.IsPlayer and self.VillainPlayer:IsPlayer() then return self.VillainPlayer end
		end
	end
	return nil
end

function GM:ShouldDrawLocalPlayer(ply)
	if ply:IsPlayingTaunt() or self:GetVictor() then return true end
	return false
end

function GM:CalcView(ply, pos, ang, efovee, nearZ, farZ)
	local Dude, Ent = self:GetVictor(), GetViewEntity()
	if IsValid(Dude) and Dude.GetShootPos then
		local Origin, Offset, ViewPos, ViewAng = Dude:GetShootPos(), Vector(60 * math.cos(CurTime()), 60 * math.sin(CurTime()), 0), pos, ang
		local Lowness = (math.sin(CurTime() * .65) / 2 + .5) ^ 3
		Offset = Offset + Vector(0, 0, -20 * Lowness)
		local Tr = util.QuickTrace(Origin, Offset, {Dude})
		if Tr.Hit then
			ViewPos = Tr.HitPos + Tr.HitNormal
		else
			ViewPos = Origin + Offset
		end

		ViewAng = (-Offset):Angle()
		ViewAng:Normalize()
		ViewAng:RotateAroundAxis(ViewAng:Up(), -28)
		ViewAng:RotateAroundAxis(ViewAng:Right(), -17)
		ViewAng:RotateAroundAxis(ViewAng:Forward(), -5 + (-5 * Lowness))
		local CamData = {
			origin = ViewPos,
			angles = ViewAng,
			fov = efovee,
			znear = nearZ,
			zfar = farZ
		}
		return CamData
	end

	if not ply:Alive() then
		if GAMEMODE.SpectateTime > CurTime() then
			local Rag = ply:GetRagdollEntity()
			if IsValid(Rag) then
				local PosAng = Rag:GetAttachment(Rag:LookupAttachment("eyes"))
				local CamData = {
					origin = PosAng.Pos,
					angles = PosAng.Ang,
					fov = efovee,
					znear = nearZ,
					zfar = farZ
				}
				return CamData
			end
		end
	elseif ply:IsPlayingTaunt() then
		local ViewPos = pos - ang:Forward() * 75
		local Tr = util.QuickTrace(pos, ViewPos - pos, {ply})
		if Tr.Hit then ViewPos = Tr.HitPos end
		local CamData = {
			origin = ViewPos,
			angles = ang,
			fov = efovee,
			znear = nearZ,
			zfar = farZ
		}
		return CamData
	elseif ply:InVehicle() then
		local Mdl, Vec = ply:GetVehicle():GetModel(), Vector(0, 0, 0)
		if not ((Mdl == "models/airboat.mdl") or (Mdl == "models/buggy.mdl") or (Mdl == "models/vehicle.mdl")) then Vec = Vector(0, 0, 5) end
		local CamData = {
			origin = pos + Vec,
			angles = ang,
			fov = efovee,
			znear = nearZ,
			zfar = farZ
		}
		return CamData
	elseif Ent ~= LocalPlayer() then
		local Pos = Ent:LocalToWorld(Ent:OBBCenter())
		local CamData = {
			origin = Pos,
			angles = ang,
			fov = efovee,
			znear = nearZ,
			zfar = farZ
		}
		return CamData
	end
end

local PUNCH_DAMPING = 9
local PUNCH_SPRING_CONSTANT = 65
local vp_is_calc = false
local vp_punch_angle = Angle()
local vp_punch_angle_velocity = Angle()
local vp_punch_angle_last = vp_punch_angle
hook.Add("Think", "viewpunch_think", function()
	if not vp_punch_angle:IsZero() or not vp_punch_angle_velocity:IsZero() then
		vp_punch_angle = vp_punch_angle + vp_punch_angle_velocity * FrameTime()
		local damping = 1 - (PUNCH_DAMPING * FrameTime())
		if damping < 0 then damping = 0 end
		vp_punch_angle_velocity = vp_punch_angle_velocity * damping
		local spring_force_magnitude = math.Clamp(PUNCH_SPRING_CONSTANT * FrameTime(), 0, 0.2 / FrameTime())
		vp_punch_angle_velocity = vp_punch_angle_velocity - vp_punch_angle * spring_force_magnitude
		local x, y, z = vp_punch_angle:Unpack()
		vp_punch_angle = Angle(math.Clamp(x, -89, 89), math.Clamp(y, -179, 179), math.Clamp(z, -89, 89))
	else
		vp_punch_angle = Angle()
		vp_punch_angle_velocity = Angle()
	end

	if vp_punch_angle:IsZero() and vp_punch_angle_velocity:IsZero() then return end
	if LocalPlayer():InVehicle() then return end
	LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles() + vp_punch_angle - vp_punch_angle_last)
	vp_punch_angle_last = vp_punch_angle
end)

function SetViewPunchAngles(angle)
	if not angle then
		print("[Local Viewpunch] SetViewPunchAngles called without an angle. wtf?")
		return
	end

	vp_punch_angle = angle
end

function SetViewPunchVelocity(angle)
	if not angle then
		print("[Local Viewpunch] SetViewPunchVelocity called without an angle. wtf?")
		return
	end

	vp_punch_angle_velocity = angle * 20
end

function Viewpunch(angle)
	if not angle then
		print("[Local Viewpunch] Viewpunch called without an angle. wtf?")
		return
	end

	vp_punch_angle_velocity = vp_punch_angle_velocity + angle * 20
end

function ViewPunch(angle)
	Viewpunch(angle)
end

function GetViewPunchAngles()
	return vp_punch_angle
end

function GetViewPunchVelocity()
	return vp_punch_angle_velocity
end
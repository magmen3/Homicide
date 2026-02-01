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

function GM:Think()
	local lply = LocalPlayer()
	if not lply.TempSpeedMul then lply.TempSpeedMul = 1 end
end

CreateClientConVar("homicide_fov", 0, true, true, "Change weapon FOV (set 0 to use defaults)", 0, 90)

cvars.AddChangeCallback("homicide_fov", function(newValue)
	local fov = newValue
	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) and wep ~= NULL then
		if not wep.OldFoV then wep.OldFoV = wep.ViewModelFOV end
		if fov == 0 then fov = wep.OldFoV end
		wep.ViewModelFOV = fov
	end
end)

local homicide_fov = GetConVar("homicide_fov")
hook.Add("OnViewModelChanged", "HMCD_OnViewModelChanged", function(viewmodel, oldModel, newModel)
	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) and wep ~= NULL then
		if not wep.OldFoV then wep.OldFoV = wep.ViewModelFOV end
		local fov = homicide_fov:GetInt()
		if fov == 0 then fov = wep.OldFoV end
		wep.ViewModelFOV = fov
	end
end)

hook.Add("OnEntityCreated", "FixFoV", function(ent)
	if IsValid(ent) and ent:IsWeapon() then
		timer.Simple(0, function()
			if not ent.OldFoV then ent.OldFoV = ent.ViewModelFOV end
			local fov = homicide_fov:GetInt()
			if fov == 0 then fov = ent.OldFoV end
			ent.ViewModelFOV = fov
		end)
	end
end)

local function SendIdentity(len, ply)
	local lply = LocalPlayer()
	if not lply.ConCommand then return end
	if file.Exists("homicide_identity.txt", "DATA") then
		local RawData = string.Split(file.Read("homicide_identity.txt", "DATA"), "\n")
		PrintTable(RawData)
		if #RawData >= 11 then
			local DatName, DatAccessory = string.Replace(RawData[1], " ", "_"), string.Replace(RawData[10], " ", "_")
			lply:ConCommand("homicide_identity " .. DatName .. " " .. RawData[2] .. " " .. RawData[3] .. " " .. RawData[4] .. " " .. RawData[5] .. " " .. RawData[6] .. " " .. RawData[7] .. " " .. RawData[8] .. " " .. RawData[9] .. " " .. DatAccessory .. " " .. RawData[11])
		else
			lply:ChatPrint(translate.identityIncorrectLines)
		end
	end
end

net.Receive("HMCD_Identity", SendIdentity)
local function Act(len, ply)
	local str = net.ReadString()
	local ply = net.ReadPlayer()
	if not IsValid(ply) then return end

	ply:ConCommand("act " .. str)
end

net.Receive("HMCD_PlayerAct", Act)

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
	local lply = LocalPlayer()

	--[[for k, v in ents.Iterator() do
		outline.Add(v, tabcolor, OUTLINE_MODE_VISIBLE)
	end]]

	if self.ZOMBIE and lply.Murderer or not system.HasFocus() then return end
	-- заботливый
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
		for k, v in ents.Iterator() do
			if v.IsLoot and not v:GetDTBool(0) and not v.MurdererLoot then
				table.insert(tab, v)
			elseif murd then
				if v.MurdererLoot or v.MurdererInterest or v.MurdererPoison or v.MurdererExplosive then
					table.insert(tab2, v)
				end
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
	if (Mod == "models/player/homicide_jason.mdl") or string.find(Mod, "zombie") then return end
	if IsValid(ply) and ply:IsPlayer() and ply:GetVR() then return end
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
			local Mats = ply.AccessoryModel:GetMaterials()
			for key, mat in pairs(Mats) do
				ply.AccessoryModel:SetSubMaterial(key - 1, mat)
			end

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
				local Mats = ply.HolsterWep:GetMaterials()
				for key, mat in pairs(Mats) do
					ply.HolsterWep:SetSubMaterial(key - 1, mat)
				end

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
	for key, ply in ipairs(ents.FindByClass("prop_ragdoll")) do
		self:RenderAccessories(ply)
	end

	local lply = LocalPlayer()
	if self.ZOMBIE and lply.Murderer and not self:GetVictor() then
		local Vary = math.sin(CurTime() * 3)
		if Vary > .5 then
			Vary = (Vary - .5) / .5
			for key, targ in ents.Iterator() do
				local Ja = targ:IsPlayer() and targ:Alive()
				if Ja and not targ:IsEffectActive(EF_NODRAW) then
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
	if not (GetViewEntity() == LocalPlayer()) then RunConsoleCommand("hmcd_lockedcontrols", bind) end
end

net.Receive("hmcd_tker", function(len)
	GAMEMODE.TKerPenalty = net.ReadFloat()
	GAMEMODE.TKerUnShowTime = CurTime() + 5
end)

local function ExplosiveReceive(data)
	LocalPlayer().RecognizedExplosive = data:ReadEntity()
end

usermessage.Hook("HMCD_ExplosiveRecognition", ExplosiveReceive)
local function SurfaceSound(len, ply)
	local snd = net.ReadString()
	surface.PlaySound(snd)
end
net.Receive("HMCD_SurfaceSound", SurfaceSound)

function GM:GetVictor()
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

-- replacing global CalculateFoV that manually changes fov with this func that just returns fov value
local function CalculateFoV(ply)
	local FoV = 88
	if ply:IsSprinting() and ply:GetVelocity():LengthSqr() >= 10000 or not ply:IsOnGround() then
		FoV = 95
	else
		local Wep = ply:GetActiveWeapon()
		if Wep and IsValid(Wep) and Wep.GetAiming then
			local Aim = Wep:GetAiming()
			if Aim > 99 then
				if Wep.Scoped then
					FoV = Wep.ScopeFoV
				else
					FoV = 87
				end
			end
		end
	end

	if ply.HighOnDrugs then FoV = 105 end
	if GAMEMODE:GetRound() == 2 then FoV = 90 end
	if ply:InVehicle() then FoV = 90 end

	return FoV
end

local finalfov = 88
local vec5up = Vector(0, 0, 5)
local Aim = 0
function GM:CalcView(ply, pos, ang, efovee, nearZ, farZ)
	if ply:GetVR() then
		nearZ = 500
		farZ = 500
	end

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
		if not ((Mdl == "models/airboat.mdl") or (Mdl == "models/buggy.mdl") or (Mdl == "models/vehicle.mdl")) then
			Vec = vec5up
		end
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

	local FT, fovneed = FrameTime(), CalculateFoV(ply)
	finalfov = Lerp(FT * 5, finalfov, fovneed)

	local Wep = ply:GetActiveWeapon()
	if Wep and IsValid(Wep) and Wep.GetAiming and Wep.AimHoldType == "ar2" and not Wep.Scoped and self.Realism:GetBool() then
		Aim = Lerp(FT * 10, Aim, Wep:GetAiming())
		if Aim > 0 then
			ang:RotateAroundAxis(ang:Forward(), Aim / 20)
			pos = pos + ang:Forward() * -(Aim / 100)
		end
	end

	local CamData = {
		origin = pos,
		angles = ang,
		fov = finalfov,
		znear = nearZ,
		zfar = farZ
	}
	return CamData
end

function PrintPosParameters(ent)
	for i = 0, ent:GetNumPoseParameters() - 1 do
		local min, max = ent:GetPoseParameterRange( i )
		print( ent:GetPoseParameterName( i ) .. ' ' .. min .. " / " .. max )
	end
end

function PrintBones( entity )
	for i = 0, entity:GetBoneCount() - 1 do
		print( i, entity:GetBoneName( i ) )
	end
end

function PrintBodygroups( entity )
	PrintTable(entity:GetBodyGroups())
end

function PrintAnims( entity )
	PrintTable(entity:GetSequenceList())
end

concommand.Add("printanims", function(ply)
	PrintAnims(ply)
end)

concommand.Add("printbones", function(ply)
	PrintBones(ply)
end)

concommand.Add("printbodygroups", function(ply)
	PrintBodygroups(ply)
end)

concommand.Add("printanimsvm", function(ply)
	PrintAnims(ply:GetViewModel())
end)

concommand.Add("printbonesvm", function(ply)
	PrintBones(ply:GetViewModel())
end)

concommand.Add("printbodygroupsvm", function(ply)
	PrintBodygroups(ply:GetViewModel())
end)
if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 4
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/Items/Flare.mdl"
SWEP.WorldModel = "models/Items/Flare.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_poisongoo")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponPoisonGoo
SWEP.Instructions = translate.weaponPoisonGooDesc
SWEP.NoHolsterForce = true
SWEP.LastMenuOpen = 0
SWEP.DownAmt = 8
SWEP.HoldType = "normal"
SWEP.CommandDroppable = false

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.PrintName = translate.weaponPoisonGoo
	self.Instructions = translate.weaponPoisonGooDesc
	self.DownAmt = 8
end

function SWEP:UseActivate()
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + 1)
	if not IsFirstTimePredicted() then return end
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	if CLIENT and self.LastMenuOpen + 1 < CurTime() then
		self.LastMenuOpen = CurTime()
		self:OpenTheMenu()
	end
end

if CLIENT then
	function SWEP:OpenTheMenu()
		if not self:GetOwner():Alive() then return end
		local DermaPanel, Ply, W, H, Weps, Poisonables = vgui.Create("DFrame"), LocalPlayer(), ScrW(), ScrH(), self:GetOwner():GetWeapons(), {}
		for key, wep in pairs(Weps) do
			if wep.Poisonable or (wep.AmmoPoisonable and (self:GetOwner():GetAmmoCount(wep.AmmoType) > 0)) then table.insert(Poisonables, wep) end
		end

		DermaPanel:SetPos(0, 0)
		DermaPanel:SetSize(210, 35 + #Poisonables * 55)
		DermaPanel:SetTitle(translate.weaponPoisonGooMenuTitle)
		DermaPanel:SetVisible(true)
		DermaPanel:SetDraggable(true)
		DermaPanel:ShowCloseButton(true)
		DermaPanel:MakePopup()
		DermaPanel:Center()
		local MainPanel = vgui.Create("DPanel", DermaPanel)
		MainPanel:SetPos(5, 25)
		MainPanel:SetSize(200, 5 + #Poisonables * 55)
		MainPanel:SetVisible(true)
		MainPanel.Paint = function()
			surface.SetDrawColor(0, 20, 40, 255)
			surface.DrawRect(0, 0, MainPanel:GetWide(), MainPanel:GetTall())
		end

		for key, wep in pairs(Poisonables) do
			local PButton = vgui.Create("Button", MainPanel)
			PButton:SetSize(190, 50)
			PButton:SetPos(5, -50 + key * 55)
			if wep.Poisonable then
				PButton:SetText(translate.weaponPoisonGooPoison .. wep:GetPrintName())
			elseif wep.AmmoPoisonable then
				PButton:SetText(translate.weaponPoisonGooPoison .. wep.AmmoName)
			end

			PButton:SetVisible(true)
			PButton.DoClick = function()
				self:GetOwner():ConCommand("hmcd_apply_poison " .. wep:GetClass())
				DermaPanel:Close()
			end
		end
	end

	function SWEP:PreDrawViewModel(vm, ply, wep)
		vm:SetMaterial("debug/env_cubemap_model")
	end

	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 8 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 8 or 0)

		local NewPos = pos + ang:Forward() * 40 - ang:Up() * (18 + self.DownAmt) + ang:Right() * 15
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return NewPos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatWorldModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatWorldModel:SetRenderOrigin(Pos + Ang:Forward() * 4 - Ang:Up() * 0 + Ang:Right() * 1.5)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel("models/Items/Flare.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetMaterial("debug/env_cubemap_model")
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(.5, 0)
		end
	end
elseif SERVER then
	local function Poison(ply, cmd, args)
		if not ply:Alive() then return end
		local wep = args[1]
		if ply:HasWeapon(wep) and ply:HasWeapon("wep_jack_hmcd_poisongoo") then
			wep = ply:GetWeapon(wep)
			if not wep.Poisoned then
				if wep.Poisonable then
					wep.Poisoned = true
					ply:StripWeapon("wep_jack_hmcd_poisongoo")
					ply:SelectWeapon(wep:GetClass())
					ply:EmitSound("snd_jack_hmcd_drink1.wav", 55, 120)
				elseif wep.AmmoPoisonable and (ply:GetAmmoCount(wep.AmmoType) > 0) then
					ply.HMCD_AmmoPoisoned = true
					ply:StripWeapon("wep_jack_hmcd_poisongoo")
					ply:SelectWeapon(wep:GetClass())
					ply:EmitSound("snd_jack_hmcd_drink1.wav", 55, 120)
				end
			end
		end
	end

	concommand.Add("hmcd_apply_poison", Poison)
end
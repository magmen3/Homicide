if SERVER then
	AddCSLuaFile()
	util.AddNetworkString("hmcd_splodetype")
elseif CLIENT then
	SWEP.Slot = 4
	SWEP.SlotPos = 1

	net.Receive("hmcd_splodetype", function()
		local Ent = net.ReadEntity()
		Ent.SplodeType = net.ReadInt(32)
	end)
end

SWEP.Base = "wep_jack_hmcd_item_base"
SWEP.ViewModel = "models/props_junk/cardboard_jox004a.mdl"
SWEP.WorldModel = "models/props_junk/cardboard_jox004a.mdl"
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_jihad")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName = translate.weaponJihad
SWEP.Instructions = translate.weaponJihadDesc
SWEP.HomicideSWEP = true
SWEP.CarryWeight = 3500
SWEP.HoldType = "normal"
SWEP.DownAmt = 16

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.PrintName = translate.weaponJihad
	self.Instructions = translate.weaponJihadDesc
	self.DownAmt = 16
end

function SWEP:UseActivate()
	self:SetNextPrimaryFire(CurTime() + 2)
	if CLIENT then
		LocalPlayer():ConCommand("act zombie")
		return
	end

	sound.Play("snd_jack_hmcd_jihad" .. math.random(1, 3) .. ".wav", self:GetOwner():GetShootPos(), 75, math.random(95, 105))
	timer.Simple(math.Rand(.9, 1.1), function()
		if IsValid(self and self:GetOwner()) and self:GetOwner():Alive() then
			self:GetOwner():ExplodeIED()
		end
	end)
end

if CLIENT then
	local Hidden = 0
	function SWEP:GetVMPos2(pos, ang)
		if not self.DownAmt then self.DownAmt = 16 end
		self.DownAmt = Lerp(FrameTime() * 2, self.DownAmt, self:GetOwner():IsSprinting() and 16 or 0)

		Hidden = 22
		local NewPos = pos + ang:Forward() * 50 - ang:Up() * (20 + self.DownAmt + Hidden) + ang:Right() * 20
		ang = ang + (self:GetOwner():GetViewPunchAngles() * 1.5)
		return NewPos, ang
	end

	function SWEP:DrawWorldModel()
		local Pos, Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
		if self.DatDetModel then
			self.DatDetModel:SetRenderOrigin(Pos + Ang:Forward() * 4 + Ang:Right() * 1)
			Ang:RotateAroundAxis(Ang:Up(), 90)
			Ang:RotateAroundAxis(Ang:Right(), 180)
			self.DatDetModel:SetRenderAngles(Ang)
			self.DatDetModel:DrawModel()
		else
			self.DatDetModel = ClientsideModel("models/weapons/w_models/w_jda_engineer.mdl")
			self.DatDetModel:SetPos(self:GetPos())
			self.DatDetModel:SetParent(self)
			self.DatDetModel:SetNoDraw(true)
			self.DatDetModel:SetModelScale(.35, 0)
		end
	end

	function SWEP:ViewModelDrawn(model)
		local Pos, Ang = model:GetPos(), model:GetAngles()
		if self.DatDetViewModel then
			if Pos and Ang and GAMEMODE:ShouldDrawWeaponWorldModel(self) then
				self.DatDetViewModel:SetRenderOrigin(Pos + Ang:Up() * 20)
				Ang:RotateAroundAxis(Ang:Up(), 180)
				Ang:RotateAroundAxis(Ang:Right(), 30)
				self.DatDetViewModel:SetRenderAngles(Ang)
				self.DatDetViewModel:DrawModel()
			end
		else
			self.DatDetViewModel = ClientsideModel("models/weapons/w_models/w_jda_engineer.mdl")
			self.DatDetViewModel:SetPos(self:GetPos())
			self.DatDetViewModel:SetParent(self)
			self.DatDetViewModel:SetNoDraw(true)
			self.DatDetViewModel:SetModelScale(.5, 0)
		end
	end
end
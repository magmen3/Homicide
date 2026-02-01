if SERVER then
	AddCSLuaFile()
else
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_autorifle")
end

SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName = translate.weaponautorifle
SWEP.Instructions = translate.weaponautorifleDesc
SWEP.Primary.ClipSize = 30
SWEP.ViewModel = "models/weapons/homicide/c_rif_ar15.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_rif_m4a1_silencer.mdl"
SWEP.ViewModelFlip = false
SWEP.Damage = 65
SWEP.SprintPos = Vector(9, -1, -3)
SWEP.SprintAng = Angle(-20, 60, -40)
SWEP.AimPos = Vector(-1.902, -4.2, .13)
SWEP.CloseAimPos = Vector(.45, 0, 0)
SWEP.ReloadTime = 4.4
SWEP.ReloadRate = .6
SWEP.ReloadSound = "snd_jack_hmcd_arreload.wav"
SWEP.AmmoType = "SMG1"
SWEP.TriggerDelay = .065
SWEP.CycleTime = .05
SWEP.Recoil = .6
SWEP.Supersonic = false
SWEP.Primary.Automatic = true
SWEP.Accuracy = .995
SWEP.ShotPitch = 80
SWEP.ENT = "ent_jack_hmcd_autorifle"
SWEP.DeathDroppable = true
SWEP.CommandDroppable = true
SWEP.CycleType = "auto"
SWEP.ReloadType = "magazine"
SWEP.DrawAnim = "draw"
SWEP.FireAnim = "fire-1"
SWEP.ReloadAnim = "reload"
SWEP.CloseFireSound = "snd_jack_hmcd_supppistol.wav"
SWEP.ExtraFireSound = "snd_jack_hmcd_supppistol.wav"
SWEP.FarFireSound = ""
SWEP.ShellType = "RifleShellEject"
SWEP.BarrelLength = 18
SWEP.FireAnimRate = 2
SWEP.AimTime = 6.5
SWEP.BearTime = 7.5
SWEP.HipHoldType = "shotgun"
SWEP.AimHoldType = "ar2"
SWEP.DownHoldType = "passive"
SWEP.MuzzleEffect = "pcf_jack_mf_suppressed"
SWEP.HipFireInaccuracy = .16
SWEP.HolsterSlot = 1
SWEP.HolsterPos = Vector(3, -12, -4)
SWEP.HolsterAng = Angle(160, 5, 180)
SWEP.CarryWeight = 5100
SWEP.SuicidePos = Vector(3, 6.75, -22)
SWEP.SuicideAng = Angle(110, 2, 90)
SWEP.ShitHands = true

if CLIENT then
	local vechands, vecfull = Vector(0.75, 0.75, 0.75), Vector(1, 1, 1)
	function SWEP:PreDrawViewModel(vm, ply, wep)
		if IsValid(vm) and IsValid(ply) then
			for i = 0, vm:GetBoneCount() do
				if vm:GetBoneName(i) == "__INVALIDBONE__" then
					continue
				end

				if vm:GetBoneName(i) == "Carry_Handle:Mesh" then
					local matrix = vm:GetBoneMatrix(i)
					if matrix then
						matrix:Zero()
						vm:SetBoneMatrix(i, matrix)
					end
				end
			end
			vm:SetSubMaterial(11, "models/weapons/v_models/jellyhead's_ar-15/fore")
		end
	end
end
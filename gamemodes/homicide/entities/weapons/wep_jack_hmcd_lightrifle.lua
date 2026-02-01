if SERVER then
	AddCSLuaFile()
else
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_lightrifle")
end

SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName = translate.weaponlightrifle
SWEP.Instructions = translate.weaponlightrifleDesc
SWEP.Primary.ClipSize = 32
SWEP.ViewModel = "models/weapons/homicide/c_rif_ar15.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.ViewModelFlip = false
SWEP.Damage = 30
SWEP.SprintPos = Vector(9, -1, -3)
SWEP.SprintAng = Angle(-20, 60, -40)
SWEP.AimPos = Vector(-1.902, -4.2, .13)
SWEP.CloseAimPos = Vector(.45, 0, 0)
SWEP.ReloadTime = 3
SWEP.ReloadRate = .7
SWEP.ReloadSound = "snd_jack_hmcd_arreload.wav"
SWEP.AmmoType = "Pistol"
SWEP.TriggerDelay = .075
SWEP.CycleTime = .05
SWEP.Recoil = .3
SWEP.Supersonic = true
SWEP.Accuracy = .997
SWEP.ShotPitch = 95
SWEP.ENT = "ent_jack_hmcd_lightrifle"
SWEP.DeathDroppable = true
SWEP.CommandDroppable = true
SWEP.CycleType = "auto"
SWEP.ReloadType = "magazine"
SWEP.DrawAnim = "draw_unsil"
SWEP.FireAnim = "fire-1-unsil"
SWEP.ReloadAnim = "reload_unsil"
SWEP.CloseFireSound = "snd_jack_hmcd_smp_close.wav"
SWEP.ExtraFireSound = "snd_jack_hmcd_shotimpulse.wav"
SWEP.FarFireSound = "snd_jack_hmcd_smp_far.wav"
SWEP.ShellType = "ShellEject"
SWEP.BarrelLength = 18
SWEP.FireAnimRate = 2.8
SWEP.AimTime = 4
SWEP.BearTime = 5
SWEP.HipHoldType = "shotgun"
SWEP.AimHoldType = "ar2"
SWEP.DownHoldType = "passive"
SWEP.MuzzleEffect = "pcf_jack_mf_mrifle2"
SWEP.HipFireInaccuracy = .14
SWEP.HolsterSlot = 1
SWEP.HolsterPos = Vector(3, -12, -4)
SWEP.HolsterAng = Angle(160, 5, 180)
SWEP.CarryWeight = 2500
SWEP.SuicidePos = Vector(3, 6.75, -22)
SWEP.SuicideAng = Angle(110, 2, 90)
SWEP.ShitHands = true

if CLIENT then
	local vecmag = Vector(0.45, 1, 1)
	function SWEP:PreDrawViewModel(vm, ply, wep)
		if IsValid(vm) and IsValid(ply) then
			for i = 0, vm:GetBoneCount() do
				if vm:GetBoneName(i) == "__INVALIDBONE__" then
					continue
				end

				if vm:GetBoneName(i) == "Emag:Mesh" then
					local matrix = vm:GetBoneMatrix(i)
					if matrix then
						matrix:SetScale(vecmag)
						vm:SetBoneMatrix(i, matrix)
					end
				end
			end
		end
	end
end
if SERVER then
	AddCSLuaFile()
else
	killicon.AddFont("wep_jack_hmcd_assaultrifle", "HL2MPTypeDeath", "1", Color(255, 0, 0))
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_assaultrifle")
end

SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName = translate.weaponautorifle
SWEP.Instructions = translate.weaponautorifleDesc
SWEP.Primary.ClipSize = 30
SWEP.ViewModel = "models/weapons/v_rif_j4a1.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.ViewModelFlip = false
SWEP.Damage = 70
SWEP.SprintPos = Vector(9, -1, -3)
SWEP.SprintAng = Angle(-20, 60, -40)
SWEP.AimPos = Vector(-1.902, -4.2, .13)
SWEP.CloseAimPos = Vector(.45, 0, 0)
SWEP.ReloadTime = 4.4
SWEP.ReloadRate = .6
SWEP.ReloadSound = "snd_jack_hmcd_arreload.wav"
SWEP.AmmoType = "SMG1"
SWEP.TriggerDelay = .078
SWEP.CycleTime = .05
SWEP.Recoil = 0.8
SWEP.Supersonic = true
SWEP.Primary.Automatic = true
SWEP.Accuracy = .999
SWEP.ShotPitch = 105
SWEP.ENT = "ent_jack_hmcd_autorifle"
SWEP.DeathDroppable = true
SWEP.CommandDroppable = true
SWEP.CycleType = "auto"
SWEP.ReloadType = "magazine"
SWEP.DrawAnim = "draw_unsil"
SWEP.FireAnim = "fire-1-unsil"
SWEP.ReloadAnim = "reload_unsil"
SWEP.CloseFireSound = "snd_jack_hmcd_ar_close.wav"
SWEP.FarFireSound = "snd_jack_hmcd_ar_far.wav"
SWEP.ShellType = "RifleShellEject"
SWEP.BarrelLength = 18
SWEP.FireAnimRate = 2
SWEP.AimTime = 6.5
SWEP.BearTime = 7.5
SWEP.HipHoldType = "shotgun"
SWEP.AimHoldType = "ar2"
SWEP.DownHoldType = "passive"
SWEP.MuzzleEffect = "pcf_jack_mf_mrifle2"
SWEP.HipFireInaccuracy = .2
SWEP.HolsterSlot = 1
SWEP.HolsterPos = Vector(3, -12, -4)
SWEP.HolsterAng = Angle(160, 5, 180)
SWEP.CarryWeight = 5100
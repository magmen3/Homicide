if SERVER then
	AddCSLuaFile()
else
	killicon.AddFont("wep_jack_hmcd_lightrifle", "HL2MPTypeDeath", "1", color_white)
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_lightrifle")
end

SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName = translate.weaponlightrifle
SWEP.Instructions = translate.weaponlightrifleDesc
SWEP.Primary.ClipSize = 30
SWEP.ViewModel = "models/weapons/v_rif_j4a1.mdl"
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
SWEP.TriggerDelay = .1
SWEP.CycleTime = .05
SWEP.Recoil = .3
SWEP.Supersonic = true
SWEP.Accuracy = .999
SWEP.ShotPitch = 100
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
SWEP.ShellType = "RifleShellEject"
SWEP.BarrelLength = 18
SWEP.FireAnimRate = 2.8
SWEP.AimTime = 4.5
SWEP.BearTime = 5.5
SWEP.HipHoldType = "shotgun"
SWEP.AimHoldType = "ar2"
SWEP.DownHoldType = "passive"
SWEP.MuzzleEffect = "pcf_jack_mf_mrifle2"
SWEP.HipFireInaccuracy = .17
SWEP.HolsterSlot = 1
SWEP.HolsterPos = Vector(3, -12, -4)
SWEP.HolsterAng = Angle(160, 5, 180)
SWEP.CarryWeight = 2500
SWEP.SuicidePos = Vector(3, 6.75, -22)
SWEP.SuicideAng = Angle(110, 2, 90)
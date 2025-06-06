if SERVER then
	AddCSLuaFile()
else
	killicon.AddFont("wep_jack_hmcd_rifle", "HL2MPTypeDeath", "1", color_white)
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_jack_hmcd_suppressedrifle")
end

SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName = translate.weaponsuppressedrifle
SWEP.Instructions = translate.weaponsuppressedrifleDesc
SWEP.Primary.ClipSize = 5
SWEP.ViewModel = "models/weapons/v_snip_jwp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_jwp.mdl"
SWEP.ViewModelFlip = true
SWEP.Damage = 115
SWEP.SprintPos = Vector(-9, 0, -2)
SWEP.SprintAng = Angle(-20, -60, 40)
SWEP.AimPos = Vector(1.95, -3, .5)
SWEP.ReloadTime = 6
SWEP.ReloadRate = .75
SWEP.ReloadSound = "snd_jack_hmcd_boltreload.wav"
SWEP.CycleSound = "snd_jack_hmcd_boltcycle.wav"
SWEP.AmmoType = "AR2"
SWEP.TriggerDelay = .2
SWEP.CycleTime = 1.2
SWEP.Recoil = 1
SWEP.Supersonic = true
SWEP.Accuracy = .9999
SWEP.ShotPitch = 90
SWEP.ENT = "ent_jack_hmcd_suppressedrifle"
SWEP.DeathDroppable = true
SWEP.CommandDroppable = true
SWEP.CycleType = "manual"
SWEP.ReloadType = "magazine"
SWEP.DrawAnim = "awm_draw"
SWEP.FireAnim = "awm_fire"
SWEP.ReloadAnim = "awm_reload"
SWEP.CloseFireSound = "snd_jack_hmcd_supppistol.wav"
SWEP.ExtraFireSound = "snd_jack_hmcd_supppistol.wav"
SWEP.FarFireSound = ""
SWEP.ShellType = "RifleShellEject"
SWEP.Scoped = true
SWEP.Suppressed = true
SWEP.SuppressedLongGun = true
SWEP.ScopeFoV = 25
SWEP.ScopedSensitivity = .1
SWEP.BarrelLength = 25
SWEP.AimTime = 10
SWEP.BearTime = 12
SWEP.FuckedWorldModel = true
SWEP.HipHoldType = "shotgun"
SWEP.AimHoldType = "ar2"
SWEP.DownHoldType = "passive"
SWEP.MuzzleEffect = "pcf_jack_mf_suppressed"
SWEP.HipFireInaccuracy = .16
SWEP.HolsterSlot = 1
SWEP.HolsterPos = Vector(3.5, 2, -4)
SWEP.HolsterAng = Angle(160, 5, 180)
SWEP.CarryWeight = 5500
SWEP.SuicidePos = Vector(-2, 12.5, -45)
SWEP.SuicideAng = Angle(110, 2, -90)
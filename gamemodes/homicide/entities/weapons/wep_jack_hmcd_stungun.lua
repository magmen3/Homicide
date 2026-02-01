do return end --!! TODO: make the stungun

AddCSLuaFile()
SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName = translate.weaponstungun
SWEP.Instructions = translate.weaponstungunDesc
SWEP.ViewModel = "models/realistic_police/taser/c_taser.mdl"
SWEP.WorldModel = "models/realistic_police/taser/w_taser.mdl"
SWEP.FuckedWorldModel = true
SWEP.Primary.ClipSize = 1
SWEP.CustomColor = Color(170, 170, 170)
SWEP.AmmoType = "Battery"
SWEP.CloseFireSound = "stungun/active_stun.mp3"
SWEP.ExtraFireSound = "stungun/taser_shoot.mp3"
SWEP.FarFireSound = "stungun/taser_shoot.mp3"
SWEP.ReloadSound = "stungun/taser_reload.mp3"
SWEP.DrawAnim = "draw_unsil"
SWEP.FireAnim = "fire-1-unsil"
SWEP.ReloadAnim = "reload_unsil"
SWEP.CarryWeight = 850
SWEP.SuicidePos = Vector(-7, 4, -18)
SWEP.SuicideAng = Angle(100, -10, -90)
SWEP.CanSuicide = false
SWEP.CanAmmoShow = false
SWEP.ENT = "ent_jack_hmcd_stungun"
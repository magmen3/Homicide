if SERVER then
	AddCSLuaFile()
end

SWEP.Base = "wep_jack_hmcd_smallpistol"
SWEP.PrintName = translate.weaponpistol
SWEP.Instructions = translate.weaponpistolDesc
SWEP.FuckedWorldModel = true
SWEP.Primary.ClipSize = 13
SWEP.ENT = "ent_jack_hmcd_pistol"
SWEP.CustomColor = Color(100, 100, 100, 255)
SWEP.HolsterSlot = 2
SWEP.DeathDroppable = true
SWEP.CloseFireSound = "snd_jack_hmcd_smp_close.wav"
SWEP.FarFireSound = "snd_jack_hmcd_smp_far.wav"
SWEP.CarryWeight = 1200
SWEP.SuicidePos = Vector(-7, 4, -18)
SWEP.SuicideAng = Angle(100, -10, -90)
SWEP.DangerLevel = 70
SWEP.OneHanded = true
local PlayerMeta = FindMetaTable("Player")
util.AddNetworkString("you_are_a_murderer")
function PlayerMeta:SetMurderer(bool)
	self.Murderer = bool
	net.Start("you_are_a_murderer")
	net.WriteEntity(self)
	net.WriteBit(bool)
	net.Broadcast()
end

util.AddNetworkString("you_are_a_gunman")
function PlayerMeta:SetGunman(bool)
	self.ArmedAtSpawn = bool
	net.Start("you_are_a_gunman")
	net.WriteEntity(self)
	net.WriteBit(bool)
	net.Broadcast()
end

function GM:MurdererThink()
	local players = team.GetPlayers(2)
	local murderer
	for k, ply in pairs(players) do
		if ply.Murderer then
			murderer = ply
			break
		end
	end

	-- regenerate shuriken if on ground
	if IsValid(murderer) and murderer:Alive() and (not self.SHTF) and murderer.InfiniShuriken then
		if murderer:HasWeapon("wep_jack_hmcd_shuriken") then
			murderer.LastHadShuriken = CurTime()
		else
			if murderer.LastHadShuriken and (murderer.LastHadShuriken or 0) + 30 < CurTime() then
				for k, ent in ipairs(ents.FindByClass("ent_jack_hmcd_shuriken")) do
					ent:Remove()
				end

				for k, ent in ipairs(ents.FindByClass("wep_jack_hmcd_shuriken")) do
					ent:Remove()
				end

				murderer:Give("wep_jack_hmcd_shuriken")
				murderer:GetWeapon("wep_jack_hmcd_shuriken").HmcdSpawned = true
			end
		end
	end
end
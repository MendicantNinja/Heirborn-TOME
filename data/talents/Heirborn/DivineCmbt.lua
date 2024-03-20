local ActorTalents = require "engine.interface.ActorTalents"
damDesc = ActorTalents.main_env.damDesc
newTalentType{ type="Heirborn/DivineCmbt", name = _t("DivineCmbt", "talent type"), description = _t"The various racial bonuses a Shadowmeld can have." }
local techs_req1 = function(self, t) local stat = "str"; return {
	stat = { [stat]=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
} end
local techs_req2 = function(self, t) local stat = "str"; return {
	stat = { [stat]=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
} end
local techs_req3 = function(self, t) local stat = "str"; return {
	stat = { [stat]=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
} end
local techs_req4 = function(self, t) local stat = "str"; return {
	stat = { [stat]=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
} end


newTalent{
	name = "Enduring Power", short_name = "MANARGNCONPOWER", image = "talents/blackguard10.png",
	type = {"Heirborn/DivineCmbt", 1},
	require = techs_req3,
	points = 5,
	mode = "passive",
	--~ See Arcane Cunning
	--Gain a bonus to spellpower = to % of your Con
	--Generate Mana on Melee Hit (Main mana sustain for class)
		info = function(self, t)
		return ([[Placeholder]])
	end,
}

newTalent{
	name = "Dawnstrike", short_name = "HEIRSPELLBLADE", image = "talents/blackguard13.png",
	type = {"Heirborn/DivineCmbt", 2},
	require = techs_req2,
	points = 5,
	mode = "sustained",
	--See Arcane Combat
	--Use spells "Sun Ray, Mark of light, spell/fire talent tree, spell/wildfire talent tree
	--chance to cast increases with con
		info = function(self, t)
		return ([[Placeholder]])
	end,
	}

newTalent{
	name = "Mana Focus", short_name = "MANAEXCHANGEPOSITIVE", image = "talents/blackguard10.png",
	type = {"Heirborn/DivineCmbt", 3},
	require = techs_req3,
	points = 5,
	mode = "activated",
	--Instant
	--Exchange 100% (90%, 80%, 70%, 60%) positive energy (calculated from max not current) to gain 50% total Mana
		info = function(self, t)
		return ([[Placeholder]])
	end,
}	

	newTalent{
	name = "Overwhelming Vitality", short_name = "SPLPWRTOHP", image = nil,
	type = {"Heirborn/DivineCmbt", 4},
	mode = "passive",
	points = 5,
	require = techs_req4,
	--Increase Max HP scaling with spell power
		info = function(self, t)
		return ([[Placeholder]])
	end,
}

local ActorTalents = require "engine.interface.ActorTalents"
damDesc = ActorTalents.main_env.damDesc
newTalentType{ type="Heirborn/Inheritor", name = _t("Inheritor", "talent type"), description = _t"The various racial bonuses a Shadowmeld can have." }
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
	name = "Dark Contract1", short_name = "CONTRACTSIGN1", image = "talents/blackguard5.png",
	type = {"Heirborn/Inheritor", 1},
	require = techs_req1,
	points = 5,
	cooldown = 25,
	mode = "sustained",
	--Knight with shield --image = "npc/Shieldpaladin.png"
	--Soldier with Sword --image = "npc/flamedead.png"
	--Wizard with Fireball --image = "npc/Flamelich.png"

	--Many times things that are apparent to us are not obvious to others. When making ANY note. Write the following things:
	--1) What's the name of the talent this note is in regards to/what is it affecting? If it's not a talent, then what is it?
	--2) Is the talent a class talent or generic talent?
	
	--Permanent Companion 
	--Can equip items based on talent level 
	--Re-use skill to resurrect 
	--Is Undead 
	--First talent include no dmg to allies for pet and player
	--See Worm that walks talent tree for reference

	--Note: Playing TOME again for a little bit is the quickest way to become familiar with this. I plan on doing so.
	
	info = function(self, t)
		return ([[Placeholder]])
	
	end,
}

newTalent{
	name = "For Glory", short_name = "BANNERSUMMON1", image = "talents/blackguard13.png",
	type = {"Heirborn/Inheritor", 2},
	require = techs_req2,
	points = 5,
	mode = "activated",
	--Banner --image = "npc/Banner.png"
	--Summon a Banner at a location to reduce incoming damage within range for a duration.
	--Give allies in range a max life % increase.
	--Use again (only once) while active to teleport back to your banner.
	--Cool down 15, lasts 15 turns (15 turn duration + 15 turn cool down = 30 turns between uses)
	--Start cooldown after duration expires
		info = function(self, t)
		return ([[Placeholder]])
		end,
	}

newTalent{
	name = "Heartfire", short_name = "GROUPHEALBURN", image = "talents/blackguard10.png",
	type = {"Heirborn/Inheritor", 3},
	require = techs_req3,
	points = 5,
	cooldown = 25,
	mode = "activated",
	--Healing skill
	--Heal player and Minion to 100% health
	--both player and minion take 10% total health per turn as fire damage over time (6turns)
	--Apply taunt to minion for 6 turns.
	--Apply fire retaliation damage to player and minion for 6 turns, scaling on player's con.
		info = function(self, t)
		return ([[Placeholder]])
		end,
}	

	newTalent{
	name = "Flames of War", short_name = "DAMAGETOFIREHEAL", image = nil,
	type = {"Heirborn/Inheritor", 4},
	mode = "passive",
	points = 5,
	require = techs_req4,
	--turn x% of incoming damage to fire + fire affinity for player and minion
		info = function(self, t)
		return ([[Placeholder]])
	end,
}
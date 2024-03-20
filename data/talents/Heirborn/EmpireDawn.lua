local ActorTalents = require "engine.interface.ActorTalents"
damDesc = ActorTalents.main_env.damDesc
newTalentType{ type="Heirborn/EmpireDawn", name = _t("EmpireDawn", "talent type"), description = _t"The various racial bonuses a Shadowmeld can have." }
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

--Name for skill tree: Dawnguard Technique?, Imperial Arts?
newTalent{
	name = "Smoldering Assault", short_name = "CONTRACTSIGN2", image = "talents/blackguard5.png",
	type = {"Heirborn/EmpireDawn", 1},
	require = techs_req1,
	points = 5,
	cooldown = 10,
	sustain_positive = 10,
	tactical = { BUFF = 2 },
	range = 10,
	mode = "sustained",
	--Deal x fire damage on hit. Gain y max life per hit, lasting for 3 turns. Duration Refreshes on each new hit. Stacks
	--Bonus to damage and max life increase with Con and talent level.
		info = function(self, t)
		return ([[Placeholder]])
	end,
}

newTalent{
	name = "Conquerer's Charge", short_name = "REAVER2CRIT2", image = "talents/blackguard13.png",
	type = {"Heirborn/EmpireDawn", 2},
	require = techs_req2,
	points = 5,
	--Rush towards the enemy and deal a weapon attack. On hit reduce their damage by 10% for 6 turns.
		info = function(self, t)
		return ([[Placeholder]])
	end,
	}


newTalent{
	name = "Eternal Vigor", short_name = "HPREGENPERCENT", image = "talents/blackguard10.png",
	type = {"Heirborn/EmpireDawn", 3},
	require = techs_req3,
	mode = "passive",
	points = 5,
	no_npc_use = true,
	--Regain 1(2, 3, 4, 5)% of max hp per turn.
	getHealValues = function(self, t) return self:combatTalentLimit(t, 0.1, 0.01, 0.05)
	end,
	getRegen = function(self, t) return self.max_life * t.getHealValues(self, t) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "life_regen", t.getRegen(self, t))
	end,
	info = function(self, t)
		return ([[Your combat focus allows you to regenerate life faster (+%0.1f life/turn).]]):tformat(t.getRegen(self, t))
	end,
}

	newTalent{
	name = "Immortal's Strike", short_name = "CONNUKE", image = nil,
	type = {"Heirborn/EmpireDawn", 4},
	points = 5,
	require = techs_req4,
	--Strike an opponent for a  melee weapon attack dealing additional fire damage based on your Max HP
	--See Weapon of Wrath
	
		info = function(self, t)
		return ([[Placeholder]])
	end,
}


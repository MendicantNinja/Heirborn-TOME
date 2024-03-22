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

--Returns whether the player's Guardian is currently summoned or not as a boolean value called "self.guardian". 
function getGuardian(self)
	if self.guardian and game.level and game.level:hasEntity(self.guardian) then
		return self.guardian
	end
end

local function learnGuardianTalents(self)
	if not self.guardian or not self.player then return end
	-- Do stuff for NPC talents here
end

--Make the guardian.
local function makeGuardian(self)
	self:attr("summoned_times",11)
	local g = require("mod.class.NPC").new{
		--Anything that doesn't fall into the below categories goes here.
		type = "Undead", subtype = "skeleton",
		name = "guardian",
		desc = _t[[A skeletal knight carrying a large shield and wearing plate mail.]],
		display = 'h', image = "npc/Shieldpaladin.png",
		is_guardian = 1,

		difficulty_boosted = 1,  -- Avoid difficulty boosting, adding to party probably also works but I'm positive this always does
		save_hotkeys = true,
		never_anger = true,

		moddable_tile = "orc_male",
		moddable_tile_nude = 1,
		moddable_tile_base = "worm_that_walks_base.png",



		--Anything to do with stats that are not resistances and affinities goes here. 
		level_range = {1, self.max_level}, exp_worth=0,
		stats = { str=15, dex=12, mag=15, con=12 },

		unused_stats = 0,
		unused_talents = 0,
		unused_generics = 0,
		unused_talents_types = 0,

		no_points_on_levelup = function(self)
			self.unused_stats = self.unused_stats + 2
			if self.level >= 2 and self.level % 2 == 0 then self.unused_talents = self.unused_talents + 1 end
			if self.level >= 2 and self.level % 4 == 0 then self.unused_generics = self.unused_generics + 1 end
		end,

		life_rating = 10,
		life_regen = 1,
		healing_factor = 0.5,
		infravision = 10,

		combat = { dam=10, atk=10, apr=0, dammod={str=0.5, mag=0.5} },
		combat_atk = resolvers.levelup(1, 1, 2),
		combat_spellpower = resolvers.levelup(1, 1, 2),
		combat_spellspeed = 0.8,
		combat_physspeed = 0.8,


		--Anything to do with resistances and affinities is here. 
		inc_damage = { all = -60, },
		resists = { [DamageType.ACID] = 50, [DamageType.BLIGHT] = 100, [DamageType.FIRE] = 10},
		stun_immune = 1,
		blind_immune = 1,
		disease_immune = 1,
		see_invisible = 30,
		--damage_affinity = { [DamageType.BLIGHT] = 10 }

		--Anything to do with starting equipment goes here.
		body = { INVEN = 1000, QS_MAINHAND = 1, QS_OFFHAND = 1, MAINHAND = 1, OFFHAND = 1, BODY=1, },
		equipdoll = "guardian",
		
		rank = 3,
		size_category = 3,
		
		--Equip this with your custom imperial items. see base_list parameter on the 3rd item
		resolvers.equip{ id=true,
			{type="weapon", subtype="longsword", ego_chance = -1000, id=true, forbid_power_source={antimagic=true}, autoreq=true, not_properties = {"unique"}},
			{type="weapon", subtype="shield", ego_chance = -1000, id=true, forbid_power_source={antimagic=true}, autoreq=true, not_properties = {"unique"}},
			{type="armor", subtype="steel", name="Imperial Armor", base_list="mod.class.Object:/data-cults/general/objects/special-misc.lua", ego_chance = -1000, id=true, autoreq=true}
		},
		


		--Anything to do with talents and inscriptions goes here. You can add custom imperial talents using the format below.
		--Fill this with custom imperial talent trees.
		talents_types = {
			["corruption/reaving-combat"] = true,
			["corruption/rot"] = true,
			["corruption/plague"] = true,
			["corruption/scourge"] = true,
			["technique/combat-training"] = true,
		},
		--What talents does the Guardian start with points already invested into?
		resolvers.talents{
			[Talents.T_ARMOUR_TRAINING]=1,
			[Talents.T_WEAPON_COMBAT]=1,
			[Talents.T_GUARDIAN_CONNECTION]=1,
			[Talents.T_GUARDIAN_DESTRUCT]=1,

		},

		

		power_source = {arcane = true},

		--Should skele boy have a regeneration infusion? They'll need it to heal normally, unless you want the player to keep resurrecting them again and again.
		resolvers.inscription("INFUSION:_REGENERATION", {cooldown=10, dur=5, heal=60}),
		max_inscriptions = 1,

		hotkey = {},
		hotkey_page = 1,
		move_others = true,

		ai = "tactical",
		-- We want a high emphasis on closing range (for Reaving Combat proc) survival via healing/defense (inscriptions) and the rest of the weighting doesn't matter much
		ai_state = { talent_in=1, ai_move="move_astar", ally_compassion=10 },
		ai_tactic = {type="guardian", attack=2, buff=6, attackarea=2, disable=2, escape=0, closein=3, defend=2, heal=4, go_melee=1},
		hate_regen = 2, vim_regen = 2,
		

		-- No natural exp gain
		gainExp = function() end,
		forceLevelup = function(self) if self.summoner then return mod.class.Actor.forceLevelup(self, self.summoner.level) end end,

		--[[CHECK ME 
		-- Break control when losing LOS
		on_act = function(self)
			self.movement_speed = self.summoner.movement_speed  -- Quality of life
			if not self:isTalentActive(self.T_WORM_THAT_WALKS_LINK) then self:forceUseTalent(self.T_WORM_THAT_WALKS_LINK, {ignore_cooldown=true, ignore_energy=true}) end
			if game.player ~= self then return end
			if not self.summoner.dead and not self:hasLOS(self.summoner.x, self.summoner.y) then
				if not self:hasEffect(self.EFF_WTW_OFS) then
					self:setEffect(self.EFF_WTW_OFS, 4, {})
				end
			else
				if self:hasEffect(self.EFF_WTW_OFS) then
					self:removeEffect(self.EFF_WTW_OFS)
				end
			end
		end,
		
		on_can_control = function(self, vocal)
			if not self:hasLOS(self.summoner.x, self.summoner.y) then
				if vocal then game.logPlayer(game.player, "Your worm that walks is out of sight; you cannot establish direct control.") end
				return false
			end
			return true
		end,
		]]--
		keep_inven_on_death = true,
		no_auto_resists = true,
		open_door = true,
		can_change_level = true,
	}

	return g
end

newTalent{
	name = "Guardian Connection", image = "talents/blackguard5.png",
	type = {"corruption/other", 1},
	require = techs_req1,
	points = 1,
	cooldown = 25,
	mode = "sustained",

	requires_target = true,
	range = 10,
	tactical = { BUFF=100 },
	activate = function(self, t) return {} end,
	deactivate = function(self, t, p) return true end,
	info = function(self, t) return (_t[[Connection to your Guardian]]) end,
	--Knight with shield --image = "npc/Shieldpaladin.png"
	--Soldier with Sword --image = "npc/flamedead.png"
	--Wizard with Fireball --image = "npc/Flamelich.png"

	--Permanent Companion 
	--Can equip items based on talent level 
	--Re-use skill to resurrect 
	--Is Undead 
	--First talent include no dmg to allies for pet and player
	--See Worm that walks talent tree for reference
}

newTalent{
	name = "Ancestral Guardian",
	type = {"Heirborn/inheritor", 1},
	require = techs_req1,
	points = 5,
	cooldown = 15,
	cant_steal = true,
	no_unlearn_last = true,
	unlearn_on_clone = true,
	tactical = { BUFF = 5, ATTACK = 5 },
	on_unlearn = function(self, t)
		if self:getTalentLevelRaw(t) == 0 and self.guardian then
			-- There have been multiple issues with this triggering when it wasn't really unlearned, all I know of are fixed but keep an eye out
			-- self.worm = nil This is used as a flag for healing in WTW, not useful for us.
			if game.party:hasMember(self) and game.party:hasMember(self.guardian) then game.party:removeMember(self.guardian) end
			self.guardian:disappear()
			self.guardian = nil
			self.initialized_guardian= nil --initialized_guardian is a bool (flag) that checks if the guardian is present.
		end
	end,
	on_levelup_close = function(self, t)
		-- self.worm = 1  Flag for healing from Infestation blight pools, we do this here instead of in passives so updateTalentTypeMastery doesn't cause issues with pet deletion
		if self.guardian then 
			t.update_guardian(self, t)
			return
		end
		if self.initialized_guardian then return end  -- We can't rely on the first check because it may not happen immediately

		self.initialized_guardian = true

		if not game.level:hasEntity(self) then
			-- We aren't on the level yet so delay the spawn
			-- This should only be possible at birth. I think.
			self.on_added_old = self.on_added
			self.on_added = function(self)
				local t = self:getTalentFromId(self.T_ANCESTRAL_GUARDIAN)
				if self.on_added_old then
					self.on_added_old(self) 
				end
				self.on_added_old = nil
				t.invoke_guardian(self, t)
				t.update_guardian(self, t)
			end
		else
			-- Create the pet immediately when the talent is learned if we already exist
			t.invoke_guardian(self, t)
			t.update_guardian(self, t)
		end
	end,
	--function that spawns the pet after we created it with makeGuardian. 
	invoke_guardian = function(self, t)
		if self.guardian then return end  -- Avoid any odd bugs causing regeneration of the pet
		if game.zone.wilderness then return end

		self.guardian = game.zone:finishEntity(game.level, "actor", makeGuardian(self))
		if game.party:hasMember(self) then
			game.party:addMember(self.guardian, {
				control="full", type="guardian", title=_t"guardian", important=true,
				orders = {target=true, leash=true, anchor=true, talents=true, behavior=true, rename=function(self, name) return ("%s (servant of %s)"):tformat(name, self.summoner and self.summoner:getName() or "???") end},
			})
		end
		if not self.guardian then return end
		self.guardian.faction = self.faction
		self.guardian.name = ("Ancestral guardian of %s"):tformat(self:getName())
		self.guardian.summoner = self
		self.guardian.summoner_gain_exp = true

		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to invoke!")
			return
		end
		game.zone:addEntity(game.level, self.guardian, "actor", x, y)
	end,
	update_guardian = function(self, t)
		local guardian = self.guardian
		if not guardian or guardian.dead or not guardian.x then return end  -- Don't update if the pet is dead just in case something weird happens

		if guardian.level < self.level then
			guardian.max_level = self.max_level
			guardian:forceLevelup(self.level)
		end

		--[[ CHECK ME 
		if self:knowTalent(self.T_SHARED_INSANITY) then
			guardian.max_inscriptions = 1 + self:callTalent(self.T_SHARED_INSANITY, "getInscriptions")
		end

		if self:knowTalent(self.T_WORM_THAT_STABS) then
			guardian.talent_cd_reduction = {[Talents.T_BLINDSIDE] = (1 + self:callTalent(self.T_WORM_THAT_STABS, "getBlindside"))}
		end
		
		-- Create some starting gear so players aren't forced to start micromanaging immediately and so NPCs don't suck
		-- Charms are a bit different though so lets not give them that
		local level = self:getTalentLevelRaw(t)
		if level >= 2 then
			if not guardian.init_body then
				local no = game.zone:makeEntity(game.level, "object", {name="iron mail armour", ignore_material_restriction=true, no_tome_drops=true, ego_filter={keep_egos=true}}, nil, true)
				local o, item, inven_id = guardian:findInAllWornInventoriesBy(true, "define_as", "IMPERIAL_ARMOR")
				if o then
					o.wtw_can_takeoff = true
					if no then
						wtw:takeoffObject(inven_id, item)
						game:addEntity(game.level, no, "object")
						no:identify(true)
						no.name = _t"Robe of the Worm (Improved)"
						no.short_name = "worm"
						no.cosmetic=true
						no.image = "object/robe_of_the_worm.png"
						no.moddable_tile = "cults/robe_of_the_worm"
						no.special = 1
						wtw:wearObject(no)
					end
				end
			end
			wtw.init_body = true
		end
		if level >= 3 then
			if not wtw.init_belt then
				wtw.body = {BELT = 1}
				wtw:initBody()
				local o = game.zone:makeEntity(game.level, "object", {name="rough leather belt", ignore_material_restriction=true, no_tome_drops=true, ego_filter={keep_egos=true}}, nil, true)
				game:addEntity(game.level, o, "object")
				o:identify(true)
				wtw:wearObject(o)
			end
			wtw.init_belt = true
		end
		if level >= 4 then
			if not wtw.init_ring1 then
				wtw.body = {FINGER = 2}
				wtw:initBody()
				for i = 1,2 do
					local o = game.zone:makeEntity(game.level, "object", {name="copper ring", ignore_material_restriction=true, no_tome_drops=true, ego_filter={keep_egos=true}}, nil, true)
					game:addEntity(game.level, o, "object")
					o:identify(true)
					wtw:wearObject(o)
				end
			end
			wtw.init_ring1 = true
		end
		if level >= 5 then
			if not wtw.init_ring2 then
				local ring1, ring2

				if wtw:getInven("FINGER")[1] then ring1 = wtw:takeoffObject(wtw:getInven("FINGER"), 1) end
				if wtw:getInven("FINGER")[1] then ring2 = wtw:takeoffObject(wtw:getInven("FINGER"), 1) end

				wtw.body = {FINGER = 4, TOOL = 1}
				wtw:initBody()

				if ring1 then wtw:wearObject(ring1) end
				if ring2 then wtw:wearObject(ring2) end

				for i = 1,2 do
					local o = game.zone:makeEntity(game.level, "object", {name="copper ring", ignore_material_restriction=true, no_tome_drops=true, ego_filter={keep_egos=true}}, nil, true)
					game:addEntity(game.level, o, "object")
					o:identify(true)
					wtw:wearObject(o)
				end
			end
			wtw.init_ring2 = true
		end ]]--
	end,
	
	on_pre_use = function(self, t, silent) if self.guardian and not self.guardian:attr("dead") then if not silent then game.logPlayer(self, "Your ancestral guardian is not dead.") end return false end return true end,
	getPower = function(self, t) return (60 + self:combatTalentSpellDamage(t, 15, 450)) / 7, 7, self:combatTalentLimit(t, 100, 27, 55) end, --Limit life gain < 100%
	action = function(self, t)
		-- Initialize pet if we somehow haven't, such as the case of a player learning the talent in the wilderness (on_added does not run for players)
		if not self.guardian then
			t.invoke_guardian(self, t)
			t.update_guardian(self, t)
			return true
		end

		if self.guardian:attr("dead") then game.level:removeEntity(self.guardian, true) end

		if not game.level:hasEntity(self.guardian) then
			self.guardian.dead = nil
			self.guardian.life = self.guardian.max_life / 100 * t.getPower(self, t)

			-- Find space
			local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to invoke!")
				return
			end
			game.zone:addEntity(game.level, self.guardian, "actor", x, y)
			self.guardian:setTarget(nil)
			self.guardian.ai_state.tactic_leash_anchor = self
			self.guardian:removeAllEffects()
			self.guardian.talents_cd = {}  -- Make sure defensive inscriptions can be used right away
		end
		t.update_guardian(self, t)

		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	-- This is an all-catch talent, and it is auto-learned on anything involving guardian, so this is a good place to stick that onto
	callbackOnLevelup = function(self, t, new_level)
		local guardian = getGuardian(self)
		if not guardian then return end
		t.update_guardian(self, t)
	end,
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, state)
		local guardian = self.guardian
		if not guardian or guardian.dead or not guardian.x then return end
		if (guardian.ai_target and guardian.ai_target.actor) then return end
		if core.fov.distance(self.x, self.y, x, y) >= 5 then return end  -- Avoid aggroing anything distant this way since it easily leads to pet suicide
		if not src:isClassName("mod.class.Actor") then return end
		guardian:setTarget(src)
	end,
	callbackOnCombat = function(self, t, state)
		if state == false and not game.zone.wilderness then
			if self.guardian and self.guardian.dead and not game.level:hasEntity(self.guardian) then
				self.guardian.dead = nil
				self.guardian.life = self.guardian.max_life  -- Full life since were out of combat

				-- Find space
				local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
				if not x then
					game.logPlayer(self, "Not enough space to invoke!")
					return
				end
				game.zone:addEntity(game.level, self.guardian, "actor", x, y)
				self.guardian:setTarget(nil)
				self.guardian.ai_state.tactic_leash_anchor = self
				self.guardian:removeAllEffects()
				self.guardian.talents_cd = {}  -- Make sure defensive inscriptions can be used right away
			
				t.update_guardian(self, t)
			
				game:playSoundNear(self, "talents/arcane")
			end
			-- Recall pet and make sure it isn't chasing anything
			if self.guardian then
				local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
				if not x then return end
				self.guardian:move(x, y, true)
				self.guardian:setTarget(nil)
			end
		end	
	end,
	info = function(self, t)
		return ([[You summon the ancestral guardian associated with your noble imperial lineage
		You can fully control, level, and equip it.
		Using this spell will ressurect your friendly guardian if it died, giving it back %d%% life.
		Higher raw talent levels will give your horror more equipment slots:

		Level 1:  Mainhand, Offhand
		Level 2:  Body
		Level 3:  Belt
		Level 4:  Ring, Ring
		Level 5:  Ring, Ring, Trinket

		To change your guardian's equipment and talents first transfer the equipment from your inventory then take control of it.]]):
		tformat(t.getPower(self, t))
	end,
}

newTalent{
	name = "For Glory", short_name = "BANNERSUMMON1", image = "talents/blackguard13.png",
	type = {"Heirborn/Inheritor", 2},
	require = techs_req2,
	points = 5,
	mode = "activated",
	cooldown = 15,
	requires_target = true,
	range = 7,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), nolock=true, can_autoaccept=true} end,
	--Banner --image = "npc/Banner.png"
	--Summon a Banner at a location to reduce incoming damage within range for a duration. (Does the range increase per talent level?)
	--Give allies in range a max life % increase. (What attribute does this scale off of)?
	--Use again (only once) while active to teleport back to your banner.
	--Cool down 15, lasts 15 turns (15 turn duration + 15 turn cool down = 30 turns between uses) 
	--Start cooldown after duration expires
		info = function(self, t)
		return ([[Summon a banner within %d tiles to reduce incoming damage for a duration. Gives allies within %d tiles a %d% max life increase. You can use this ability once
		while active to teleport back to your banner.]])
		:tformat(7, 7, 10)
		end,
	}

newTalent{
	name = "Heartfire", short_name = "GROUPHEALBURN", image = "talents/blackguard10.png",
	type = {"Heirborn/Inheritor", 3},
	require = techs_req3,
	points = 5,
	cooldown = 25,
	mode = "activated",
	action = function(self, t)
		game:playSoundNear(self, "talents/heal")
		self:heal(self.max_life, self)


	end,
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
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, state)
			
	end,


	--turn x% of incoming damage to fire + fire affinity for player and minion
	info = function(self, t)
		return ([[Placeholder]])
	end,
}

newBirthDescriptor{
	type = "subclass",
	name = "Heirborn",
	desc = {
		"Blackguards are nefarious warriors who have been tainted by the shadows",
		"Bruisers, Rogues, Brutes, a blackguard goes by all these names and more.",
		"Their most important stats are: Strength and Cunning",
		"#GOLD#Stat modifiers:",
		"#LIGHT_BLUE# * +2 Strength, +0 Dexterity, +5 Constitution",
		"#LIGHT_BLUE# * +2 Magic, +0 Willpower, +0 Cunning",
		"#GOLD#Life per level:#LIGHT_BLUE# +6",
	},
	power_source = {technique=true},
	stats = { str=2, con=5, mag=2 },
	getStatDesc = function(stat, actor)
	end,
	talents_types = {
		--class talents
		
		["Heirborn/Inheritor"]={true, 0.3},
		["Heirborn/EmpireDawn"]={true, 0.3},		
		["Heirborn/DivineCmbt"]={true, 0.3},		
		["spell/fire"]={true, 0.3},
		["celestial/sun"]={true, 0.3},
		--unlockable
		["spell/wildfire"]={false, 0.3},
		["celestial/crusader"]={false, 0.3},
		["celestial/radiance"]={false, 0.3},		
		--generic talents
		["technique/combat-training"]={true, 0.3},
		["celestial/chants"]={true, 0.3},    
		["spell/aegis"]={true, 0.3},    
		["technique/conditioning"]={true, 0.3},  
		-- unlockable
		["spell/spectre"]={false, 0.3},
		
	},
	talents = {
		--class talents
		[ActorTalents.T_WEAPONS_MASTERY] = 1,
		[ActorTalents.T_WEAPON_COMBAT] = 1,
		[ActorTalents.T_ARMOUR_TRAINING] = 2,
		--generic talents
		
	},
	copy = {
		max_life = 120,
		mage_equip_filters,
		resolvers.equipbirth{ id=true,
			{type="weapon", subtype="battleaxe", name="iron battleaxe", autoreq=true, ignore_material_restriction=true, ego_chance=-1000},
			{type="armor", subtype="heavy", name="iron mail armour", autoreq=true, ego_chance=-1000},
		},
	},
	copy_add = {
		life_rating = 6,
	},
}

getBirthDescriptor("class", "Warrior").descriptor_choices.subclass.Heirborn = "allow"
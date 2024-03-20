local Birther = require "engine.Birther"
local ActorTalents = require "engine.interface.ActorTalents"
local Map = require "engine.Map"
local ActorTalents = require "engine.interface.ActorTalents" 
	
class:bindHook("ToME:load", function(self, data)
	ActorTalents:loadDefinition("/data-Heirborn/talents/Heirborn/Inheritor.lua")
	ActorTalents:loadDefinition("/data-Heirborn/talents/Heirborn/EmpireDawn.lua")
	ActorTalents:loadDefinition("/data-Heirborn/talents/Heirborn/DivineCmbt.lua")
	Birther:loadDefinition("/data-Heirborn/birth/classes/warrior.lua")

end)
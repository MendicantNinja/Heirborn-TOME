newTalent{
	name = "Self-destruction", short_name = "GUARDIAN_DESTRUCT", image = "talents/golem_destruct.png",
	type = {"heirborn/other", 1},
	points = 1,
	range = 0,
	radius = 4,
	no_unlearn_last = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t)}
	end,
	no_npc_use = true,
	on_pre_use = function(self, t)
		return self.summoner and self.summoner.dead
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.FIRE, 50 + 10 * self.level)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_fire", {radius=tg.radius})
		game:playSoundNear(self, "talents/fireflash")
		self:die(self)
		return true
	end,
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[Self destruct in a glorious explosion of fire dealing %0.2f fire damage to all enemies in %d radius.  Your summoner must be dead to use this talent.]])
			:tformat(damDesc(self, DamageType.FIRE, 50 + 10 * self.level), rad)
	end,
}
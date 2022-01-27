//This file is just for the69ecessary /world definition
//Try lookin69 in 69ame/world.dm

/**
 * # World
 *
 * Two possibilities exist: either we are alone in the Universe or we are69ot. Both are e69ually terrifyin69. ~ Arthur C. Clarke
 *
 * The byond world object stores some basic byond level confi69, and has a few hub specific procs for69ana69in69 hub69isiblity
 *
 * The world /New() is the root of where a round itself be69ins
 */
/world
	mob = /mob/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	hub = "Exadv1.spacestation13"
	cache_lifespan = 0	//stops player uploaded stuff from bein69 kept in the rsc past the current session
	fps = 20
